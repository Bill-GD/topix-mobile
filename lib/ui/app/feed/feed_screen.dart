import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart' show LoginViewModel;
import 'package:topix/utils/services/token_service.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: IconButton(
            onPressed: () async {
              await GetIt.I<TokenService>().deleteTokens();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen(viewModel: LoginViewModel());
                    },
                  ),
                );
              }
            },
            icon: Icon(Icons.power_settings_new_rounded),
          ),
        ),
      ),
    );
  }
}
