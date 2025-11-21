import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'package:topix/data/services/auth_service.dart';
import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart' show LoginViewModel;
import 'package:topix/ui/core/theme/colors.dart';
import 'package:topix/ui/core/widgets/button.dart' show Button;
import 'package:topix/data/models/user.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: DrawerButton(),
          title: FittedBox(child: Image.asset('assets/images/icon.png', height: 32)),
        ),
        drawerEnableOpenDragGesture: true,
        drawer: Drawer(
          child: Column(
            mainAxisSize: .min,
            children: [
              Padding(
                padding: const .all(16),
                child: ListTile(
                  title: Text(context.read<User>().username),
                  tileColor: ThemeProvider.themeOf(context).id.contains('dark')
                      ? ThemeColors.darkFaint
                      : ThemeColors.lightFaint,
                  shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                ),
              ),
              Padding(
                padding: const .all(16),
                child: SwitchListTile.adaptive(
                  title: Text('Dark mode'),
                  value: ThemeProvider.themeOf(context).id.contains('dark'),
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(12),
                    side: BorderSide(
                      color: ThemeProvider.themeOf(context).id.contains('dark')
                          ? ThemeColors.darkFaint
                          : ThemeColors.lightFaint,
                    ),
                  ),
                  onChanged: (_) => ThemeProvider.controllerOf(context).nextTheme(),
                ),
              ),
              ListTile(
                title: Button(
                  type: .base,
                  text: 'Log out',
                  onPressed: () async {
                    await GetIt.I<AuthService>().logout();
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
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(child: Column(children: [child])),
      ),
    );
  }
}
