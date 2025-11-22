import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:topix/data/models/user.dart';
import 'package:topix/data/services/auth_service.dart';
import 'package:topix/ui/app/dev/dev_screen.dart';
import 'package:topix/ui/app/feed/feed_screen.dart';
import 'package:topix/ui/auth/login/login_screen.dart';
import 'package:topix/ui/auth/login/login_view_model.dart' show LoginViewModel;
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
        drawer: Drawer(
          backgroundColor: context.colorScheme.surface,
          child: Padding(
            padding: const .all(16),
            child: Column(
              crossAxisAlignment: .stretch,
              mainAxisSize: .min,
              spacing: 8,
              children: [
                ListTile(
                  leading: SizedBox.square(
                    dimension: 40,
                    child: ClipOval(
                      child: self.profilePicture != null
                          ? Image.network(self.profilePicture!)
                          : Image.asset('assets/images/default-picture.jpg'),
                    ),
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: self.displayName,
                      style: TextStyle(
                        color: context.colorScheme.onSurface,
                        fontSize: FontSize.mediumSmall,
                      ),
                      children: [
                        TextSpan(
                          text: ' @${self.username}',
                          style: TextStyle(
                            color: context.colorScheme.onSurfaceVariant,
                            fontSize: FontSize.small,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text('View profile'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  tileColor: context.colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                  onTap: () {
                    print('to profile page');
                  },
                ),
                ListTile(
                  title: Text('Settings'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(12),
                    side: BorderSide(color: context.colorScheme.surfaceContainerHighest),
                  ),
                  dense: true,
                  onTap: () {},
                ),
                if (self.role == .admin)
                  ListTile(
                    title: Text('Dev'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    shape: RoundedRectangleBorder(
                      borderRadius: .circular(12),
                      side: BorderSide(
                        color: context.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    dense: true,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => DevScreen()),
                      );
                    },
                  ),
                SwitchListTile.adaptive(
                  title: Text('Dark mode'),
                  value: context.isDarkMode,
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(12),
                    side: BorderSide(color: context.colorScheme.surfaceContainerHighest),
                  ),
                  dense: true,
                  onChanged: (_) => context.nextTheme(),
                ),
                Button(
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
              ],
            ),
          ),
        ),
        body: child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: context.colorScheme.surfaceContainerLow),
          padding: const .all(8),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Button(
                icon: Icon(Icons.home_rounded, size: 32),
                tooltip: 'Home',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => FeedScreen(viewModel: context.read()),
                    ),
                  );
                },
              ),
              Button(
                icon: Icon(Icons.search_rounded, size: 32),
                tooltip: 'Search',
                onPressed: () {},
              ),
              Button(
                icon: Icon(Icons.chat_bubble_rounded, size: 32),
                tooltip: 'Chat',
                onPressed: () {},
              ),
              Button(
                icon: Icon(Icons.group_rounded, size: 32),
                tooltip: 'Group',
                onPressed: () {},
              ),
              Button(
                icon: Icon(Icons.person_rounded, size: 32),
                tooltip: 'Users',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
