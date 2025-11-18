import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../core/input.dart';
import '../layout.dart';
import 'register_view_model.dart';

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
                      style: TextStyle(fontSize: FontSize.small, color: Colors.grey[700]),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: FontSize.small,
                            color: Colors.blueAccent,
                            fontWeight: .w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
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
                    suffixIcon: IconButton(
                      onPressed: () => viewModel.togglePasswordVisibility(.normal),
                      icon: Icon(
                        viewModel.hidePassword
                            ? Icons.visibility
                            : Icons.visibility_off_rounded,
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
                    suffixIcon: IconButton(
                      onPressed: () => viewModel.togglePasswordVisibility(.confirm),
                      icon: Icon(
                        viewModel.hideConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green[800]),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: .circular(8)),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: FontSize.small,
                        fontWeight: .w700,
                      ),
                    ),
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
                  IconButton(
                    onPressed: () async {},
                    padding: const .all(12),
                    style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: .circular(10)),
                      ),
                    ),
                    icon: Image.asset('assets/images/google_icon.png', scale: 1.75),
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
