import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:topix/ui/auth/layout.dart';
import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart' show LoginViewModel;
import 'package:topix/ui/auth/register/register_view_model.dart';
import 'package:topix/ui/core/button.dart';
import 'package:topix/ui/core/input.dart';
import 'package:topix/utils/constants.dart' show FontSize;

class RegisterScreen extends StatelessWidget {
  final RegisterViewModel viewModel;

  const RegisterScreen({super.key, required this.viewModel});

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
                                    return LoginScreen(
                                      viewModel: LoginViewModel(dio: context.read()),
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
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_rounded),
                    textInputType: .emailAddress,
                    textInputAction: .next,
                  ),
                  Input(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: Icon(Icons.person_rounded),
                    textInputType: TextInputType.name,
                    textInputAction: .next,
                  ),
                  Input(
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
                  Button(type: .success, onPressed: () {}, text: 'Register'),
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
