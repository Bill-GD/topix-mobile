import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';

import 'package:topix/data/services/user_service.dart';
import 'package:topix/ui/app/feed/feed_screen.dart';
import 'package:topix/ui/app/feed/feed_view_model.dart';

class LoggedInRoute extends StatefulWidget {
  const LoggedInRoute({super.key});

  @override
  State<LoggedInRoute> createState() => _LoggedInRouteState();
}

class _LoggedInRouteState extends State<LoggedInRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I<UserService>().getSelf(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
        }

        return MultiProvider(
          providers: [
            Provider.value(value: snapshot.data),
            ChangeNotifierProvider(create: (_) => FeedViewModel()),
          ],
          builder: (context, _) => Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => FeedScreen(viewModel: context.read()),
              );
            },
          ),
        );
      },
    );
  }
}
