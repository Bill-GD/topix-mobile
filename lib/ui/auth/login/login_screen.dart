import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../core/button.dart';
import '../../core/input.dart';
import '../layout.dart';
import '../register/register_screen.dart';
import '../register/register_view_model.dart' show RegisterViewModel;
import 'login_view_model.dart';

class LoginScreen extends StatelessWidget {
  final LoginViewModel viewModel;

  const LoginScreen({super.key, required this.viewModel});

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
                  Button(type: .success, onPressed: () {}, text: 'Login'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
