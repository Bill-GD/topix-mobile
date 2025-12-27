import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:topix/data/services/auth_service.dart';
import 'package:topix/data/services/logger_service.dart';
import 'package:topix/ui/app/logged_in_route.dart';
import 'package:topix/ui/auth/layout.dart';
import 'package:topix/ui/auth/login/login_view_model.dart';
import 'package:topix/ui/auth/register/register_screen.dart';
import 'package:topix/ui/auth/register/register_view_model.dart' show RegisterViewModel;
import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/input.dart';
import 'package:topix/ui/core/widgets/toast.dart';

class LoginScreen extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginScreen({super.key, required this.viewModel});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController(),
      passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
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
                      'Log in to your account',
                      style: TextStyle(fontSize: FontSize.large, fontWeight: .w700),
                      textAlign: .center,
                    ),
                    RichText(
                      textAlign: .center,
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: FontSize.small,
                          color: Colors.grey[500],
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign up',
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
                                      return RegisterScreen(
                                        viewModel: RegisterViewModel(),
                                      );
                                    },
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
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
                      obscureText: widget.viewModel.hidePassword,
                      textInputType: .visiblePassword,
                      textInputAction: .done,
                      prefixIcon: Icon(Icons.password_rounded),
                      suffixIcon: ExcludeFocus(
                        child: IconButton(
                          onPressed: widget.viewModel.togglePasswordVisibility,
                          icon: Icon(
                            widget.viewModel.hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off_rounded,
                          ),
                        ),
                      ),
                    ),
                    Button(
                      type: .success,
                      text: 'Login',
                      onPressed: () async {
                        final username = usernameController.text.trim(),
                            password = passwordController.text.trim();

                        if (username.isEmpty || password.isEmpty) {
                          return context.showToast('All fields must not be empty.');
                        }

                        final res = await GetIt.I<AuthService>().login(
                          username,
                          password,
                        );

                        if (context.mounted) {
                          context.showToast(res.$2);
                          if (res.$1) {
                            LoggerService.log(res.$2);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoggedInRoute();
                                  // return FeedScreen(viewModel: context.read());
                                },
                              ),
                            );
                          }
                        }
                      },
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
