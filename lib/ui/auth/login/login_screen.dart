import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:topix/ui/app/feed/feed_screen.dart';
import 'package:topix/ui/auth/layout.dart';
import 'package:topix/ui/auth/login/login_view_model.dart';
import 'package:topix/ui/auth/register/register_screen.dart';
import 'package:topix/ui/auth/register/register_view_model.dart' show RegisterViewModel;
import 'package:topix/ui/core/button.dart';
import 'package:topix/ui/core/input.dart';
import 'package:topix/ui/core/toast.dart';
import 'package:topix/utils/constants.dart' show FontSize;
import 'package:topix/utils/services/auth_service.dart';
import 'package:topix/utils/services/logger_service.dart';

class LoginScreen extends StatelessWidget {
  final LoginViewModel viewModel;
  final usernameController = TextEditingController(),
      passwordController = TextEditingController();

  LoginScreen({super.key, required this.viewModel});

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
                    'Log in to your account',
                    style: TextStyle(fontSize: FontSize.large, fontWeight: .w700),
                    textAlign: .center,
                  ),
                  RichText(
                    textAlign: .center,
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(fontSize: FontSize.small, color: Colors.grey[500]),
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
                                    return RegisterScreen(viewModel: RegisterViewModel());
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
                    obscureText: viewModel.hidePassword,
                    textInputType: .visiblePassword,
                    textInputAction: .done,
                    prefixIcon: Icon(Icons.password_rounded),
                    suffixIcon: ExcludeFocus(
                      child: IconButton(
                        onPressed: viewModel.togglePasswordVisibility,
                        icon: Icon(
                          viewModel.hidePassword
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
                        return showToast(context, 'All fields must not be empty.');
                      }

                      final res = await context.read<AuthService>().login(
                        username,
                        password,
                      );

                      if (context.mounted) {
                        showToast(context, res.$2);
                        if (res.$1) {
                          LoggerService.log(res.$2);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) {
                                return FeedScreen();
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
          );
        },
      ),
    );
  }
}
