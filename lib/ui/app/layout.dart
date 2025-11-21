import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'package:topix/data/models/user.dart';
import 'package:topix/data/services/auth_service.dart';
import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart' show LoginViewModel;
import 'package:topix/ui/core/theme/colors.dart';
import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/ui/core/widgets/button.dart' show Button;
import 'package:topix/utils/extensions.dart' show ThemeHelper;

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final self = context.read<User>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: DrawerButton(),
          title: FittedBox(child: Image.asset('assets/images/icon.png', height: 32)),
        ),
        drawerEnableOpenDragGesture: true,
        drawer: Drawer(
          backgroundColor: context.isDarkMode ? ThemeColors.darkDim : ThemeColors.light,
          child: Padding(
            padding: const .all(16),
            child: Column(
              mainAxisSize: .min,
              spacing: 8,
              children: [
                ListTile(
                  leading: SizedBox.square(
                    dimension: 40,
                    child: ClipRRect(
                      borderRadius: .circular(50),
                      child: self.profilePicture != null
                          ? Image.network(self.profilePicture!)
                          : Image.asset('assets/images/default-picture.jpg'),
                    ),
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: self.displayName,
                      style: TextStyle(
                          color: context.isDarkMode ? ThemeColors.light : ThemeColors.darkDim,
                          fontSize: FontSize.mediumSmall),
                      children: [
                        TextSpan(
                          text: ' @${self.username}',
                          style: TextStyle(
                            color: context.isDarkMode ? ThemeColors.lightFaint : ThemeColors.darkFaint,
                            fontSize: FontSize.small,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text('View profile'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  tileColor: context.isDarkMode
                      ? ThemeColors.darkSubtle
                      : ThemeColors.lightDim,
                  shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                  onTap: () {
                    print('to profile page');
                  },
                ),
                SwitchListTile.adaptive(
                  title: Text('Dark mode'),
                  value: context.isDarkMode,
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(12),
                    side: BorderSide(
                      color: context.isDarkMode
                          ? ThemeColors.darkFaint
                          : ThemeColors.lightFaint,
                    ),
                  ),
                  onChanged: (_) => ThemeProvider.controllerOf(context).nextTheme(),
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
        ),
        body: SingleChildScrollView(child: Column(children: [child])),
      ),
    );
  }
}
