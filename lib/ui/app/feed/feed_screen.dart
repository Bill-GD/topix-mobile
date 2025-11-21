import 'package:flutter/material.dart';

import 'package:topix/ui/app/feed/feed_view_model.dart';
import 'package:topix/ui/app/layout.dart';

class FeedScreen extends StatelessWidget {
  final FeedViewModel viewModel;

  const FeedScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Center(child: Text('hey'));
        },
      ),
    );
  }
}
