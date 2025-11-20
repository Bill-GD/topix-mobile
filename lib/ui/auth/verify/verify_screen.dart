import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:topix/data/services/auth_service.dart';
import 'package:topix/ui/auth/layout.dart';
import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart' show LoginViewModel;
import 'package:topix/ui/auth/verify/verify_view_model.dart';
import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/input.dart';
import 'package:topix/ui/core/widgets/toast.dart';

class VerifyScreen extends StatefulWidget {
  final VerifyViewModel viewModel;

  const VerifyScreen({super.key, required this.viewModel});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
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
                      'We sent the code to the email you specified.',
                      style: TextStyle(fontSize: FontSize.mediumSmall),
                      textAlign: .center,
                    ),
                    Input(
                      controller: otpController,
                      labelText: 'Code',
                      hintText: 'Enter the OTP code',
                      prefixIcon: Icon(Icons.password_rounded),
                      textInputAction: .done,
                    ),
                    Button(
                      type: .success,
                      text: 'Verify',
                      onPressed: () async {
                        final otp = otpController.text.trim();

                        if (otp.isEmpty) {
                          return showToast(context, 'You must enter the code.');
                        }

                        final res = await GetIt.I<AuthService>().verify(
                          widget.viewModel.userId,
                          otp,
                        );

                        if (context.mounted) {
                          showToast(context, 'Email verified.');
                          if (res.$1) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen(viewModel: LoginViewModel());
                                },
                              ),
                            );
                          }
                        }
                      },
                    ),
                    Button(
                      type: .base,
                      text: 'Resend',
                      onPressed: () async {
                        final res = await GetIt.I<AuthService>().resend(
                          widget.viewModel.userId,
                        );
                        if (context.mounted) showToast(context, res.$2);
                      },
                    ),
                    const Divider(),
                    RichText(
                      textAlign: .center,
                      text: TextSpan(
                        text: 'Back to ',
                        style: TextStyle(
                          fontSize: FontSize.small,
                          color: Colors.grey[500],
                        ),
                        children: [
                          TextSpan(
                            text: 'login',
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
