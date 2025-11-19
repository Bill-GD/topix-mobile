import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:topix/ui/auth/layout.dart';
import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart' show LoginViewModel;
import 'package:topix/ui/auth/register/register_view_model.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/input.dart';
import 'package:topix/ui/core/widgets/toast.dart';
import 'package:topix/utils/constants.dart' show FontSize;
import 'package:topix/utils/services/auth_service.dart';
import 'package:topix/utils/services/logger_service.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterViewModel viewModel;
  final emailController = TextEditingController(),
      usernameController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController();

  RegisterScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Center(
            child: Padding(
              padding: const .all(16),
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
                      style: TextStyle(fontSize: FontSize.small, color: Colors.grey[500]),
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
                  Input(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_rounded),
                    textInputType: .emailAddress,
                    textInputAction: .next,
                  ),
                  Input(
                    controller: usernameController,
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: Icon(Icons.person_rounded),
                    textInputType: TextInputType.name,
                    textInputAction: .next,
                  ),
                  Input(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    obscureText: viewModel.hidePassword,
                    textInputType: .visiblePassword,
                    textInputAction: .next,
                    prefixIcon: Icon(Icons.password_rounded),
                    suffixIcon: ExcludeFocus(
                      child: IconButton(
                        onPressed: () => viewModel.togglePasswordVisibility(.normal),
                        icon: Icon(
                          viewModel.hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                    ),
                  ),
                  Input(
                    controller: confirmPasswordController,
                    labelText: 'Confirm password',
                    hintText: 'Repeat your password',
                    obscureText: viewModel.hideConfirmPassword,
                    textInputType: .visiblePassword,
                    textInputAction: .done,
                    prefixIcon: Icon(Icons.password_rounded),
                    suffixIcon: ExcludeFocus(
                      child: IconButton(
                        onPressed: () => viewModel.togglePasswordVisibility(.confirm),
                        icon: Icon(
                          viewModel.hideConfirmPassword
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
                        return showToast(context, 'All fields must not be empty.');
                      }

                      final emailRegex =
                          '^[a-zA-Z0-9]+([._-][0-9a-zA-Z]+)*@[a-zA-Z0-9]+([.-][0-9a-zA-Z]+)*.[a-zA-Z]{2,}\$';

                      if (!RegExp(emailRegex).hasMatch(email)) {
                        return showToast(context, 'Email format is invalid.');
                      }

                      if (password != confirmPassword) {
                        return showToast(context, 'Passwords do not match.');
                      }

                      final res = await context.read<AuthService>().register(
                        email,
                        username,
                        password,
                      );

                      if (context.mounted) {
                        showToast(context, res.$2);
                        if (res.$1) {
                          LoggerService.log(res.$2);
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (_) {
                          //       return FeedScreen();
                          //     },
                          //   ),
                          // );
                        }
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: .center,
                    children: const [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: .symmetric(horizontal: 15),
                        child: Text(
                          'Or sign up with',
                          style: TextStyle(fontSize: 16, fontWeight: .w600),
                        ),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  Button(
                    type: .base,
                    outline: true,
                    padding: const .all(12),
                    icon: Image.asset('assets/images/google_icon.png', scale: 1.75),
                    onPressed: () async {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
