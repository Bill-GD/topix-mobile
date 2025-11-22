import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:topix/data/models/user.dart';
import 'package:topix/ui/app/feed/feed_view_model.dart';
import 'package:topix/ui/app/layout.dart';
import 'package:topix/ui/core/widgets/post.dart';

class FeedScreen extends StatefulWidget {
  final FeedViewModel viewModel;

  const FeedScreen({super.key, required this.viewModel});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return AppLayout(
      child: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              final pixels = notification.metrics.pixels,
                  maxScrollExtent = notification.metrics.maxScrollExtent;
              if (maxScrollExtent - pixels <= 50) {
                vm.load();
              }
              return false;
            },
            child: Scrollbar(
              controller: vm.scroll,
              thumbVisibility: true,
              radius: const Radius.circular(16),
              child: ListView.separated(
                key: PageStorageKey('feed_posts_key'),
                controller: vm.scroll,
                itemCount: vm.posts.length + (vm.loading ? 1 : 0),
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  if (vm.loading && index == vm.posts.length) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                  final post = vm.posts.elementAt(index);
                  return PostWidget(self: context.read<User>(), post: post);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
