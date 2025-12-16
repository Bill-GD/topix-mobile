import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:topix/data/services/auth_service.dart';
import 'package:topix/ui/auth/layout.dart';
import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart' show LoginViewModel;
import 'package:topix/ui/auth/register/register_view_model.dart';
import 'package:topix/ui/auth/verify/verify_screen.dart';
import 'package:topix/ui/auth/verify/verify_view_model.dart';
import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/input.dart';
import 'package:topix/ui/core/widgets/toast.dart';
import 'package:topix/utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  final RegisterViewModel viewModel;

  const RegisterScreen({super.key, required this.viewModel});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final vm = widget.viewModel;

  final emailController = TextEditingController(),
      usernameController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = vm.googleAccount?.email ?? '';
    usernameController.text = vm.accountUsername.toLowerCase().replaceAll(' ', '_');
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Center(
            child: Padding(
              padding: const .all(16),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      'Sign up for topix',
                      style: TextStyle(fontSize: FontSize.large, fontWeight: .w700),
                      textAlign: .center,
                    ),
                    RichText(
                      textAlign: .center,
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontSize: FontSize.small,
                          color: Colors.grey[500],
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontSize: FontSize.small,
                              color: Colors.blueAccent,
                              fontWeight: .w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return LoginScreen(viewModel: LoginViewModel());
                                    },
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    if (!Constants.emailVerificationEnabled.value)
                      Text(
                        'Normal account registration is currently disabled. '
                        'Please sign up using Google.',
                        style: TextStyle(
                          fontSize: FontSize.small,
                          color: Colors.grey[500],
                        ),
                        textAlign: .center,
                      ),
                    Input(
                      controller: emailController,
                      readOnly:
                          vm.isGoogleOAuth ||
                          (!vm.isGoogleOAuth &&
                              !Constants.emailVerificationEnabled.value),
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_rounded),
                      textInputType: .emailAddress,
                      textInputAction: .next,
                    ),
                    Input(
                      controller: usernameController,
                      readOnly:
                          vm.isGoogleOAuth ||
                          (!vm.isGoogleOAuth &&
                              !Constants.emailVerificationEnabled.value),
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person_rounded),
                      textInputType: TextInputType.name,
                      textInputAction: .next,
                    ),
                    Input(
                      controller: passwordController,
                      readOnly:
                          !vm.isGoogleOAuth && !Constants.emailVerificationEnabled.value,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: vm.hidePassword,
                      textInputType: .visiblePassword,
                      textInputAction: .next,
                      prefixIcon: Icon(Icons.password_rounded),
                      suffixIcon: ExcludeFocus(
                        child: IconButton(
                          onPressed: () => vm.togglePasswordVisibility(.normal),
                          icon: Icon(
                            vm.hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off_rounded,
                          ),
                        ),
                      ),
                    ),
                    Input(
                      controller: confirmPasswordController,
                      readOnly:
                          !vm.isGoogleOAuth && !Constants.emailVerificationEnabled.value,
                      labelText: 'Confirm password',
                      hintText: 'Repeat your password',
                      obscureText: vm.hideConfirmPassword,
                      textInputType: .visiblePassword,
                      textInputAction: .done,
                      prefixIcon: Icon(Icons.password_rounded),
                      suffixIcon: ExcludeFocus(
                        child: IconButton(
                          onPressed: () => vm.togglePasswordVisibility(.confirm),
                          icon: Icon(
                            vm.hideConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off_rounded,
                          ),
                        ),
                      ),
                    ),
                    Button(
                      type: .success,
                      text: 'Register',
                      onPressed: () async {
                        final email = emailController.text.trim(),
                            username = usernameController.text.trim(),
                            password = passwordController.text.trim(),
                            confirmPassword = confirmPasswordController.text.trim();

                        if (email.isEmpty ||
                            username.isEmpty ||
                            password.isEmpty ||
                            confirmPassword.isEmpty) {
                          return context.showToast('All fields must not be empty.');
                        }

                        final emailRegex =
                            '^[a-zA-Z0-9]+([._-][0-9a-zA-Z]+)*@[a-zA-Z0-9]+([.-][0-9a-zA-Z]+)*.[a-zA-Z]{2,}\$';

                        if (!RegExp(emailRegex).hasMatch(email)) {
                          return context.showToast('Email format is invalid.');
                        }

                        if (password != confirmPassword) {
                          return context.showToast('Passwords do not match.');
                        }

                        final res = await GetIt.I<AuthService>().register(
                          email,
                          username,
                          password,
                          verified: vm.isGoogleOAuth ? true : null,
                          picture: vm.googleAccount?.photoUrl,
                        );

                        if (context.mounted) {
                          if (!res.$1) {
                            context.showToast(res.$2);
                            return;
                          }
                          if (vm.isGoogleOAuth) {
                            context.showToast('Account registered.');
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen(viewModel: LoginViewModel());
                                },
                              ),
                            );
                          } else {
                            context.showToast('Verification code sent.');
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => VerifyScreen(
                                  viewModel: VerifyViewModel(userId: int.parse(res.$2)),
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: .center,
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: .symmetric(horizontal: 15),
                          child: Text(
                            'Or sign up with',
                            style: TextStyle(fontSize: 16, fontWeight: .w600),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    Button(
                      type: .base,
                      outline: true,
                      disabled: !GetIt.I<GoogleSignIn>().supportsAuthenticate(),
                      padding: const .all(12),
                      icon: Image.asset('assets/images/google_icon.png', scale: 1.75),
                      onPressed: vm.requestGoogleSignIn,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
