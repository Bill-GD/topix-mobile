import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:topix/data/models/user.dart';
import 'package:topix/ui/app/feed/feed_view_model.dart';
import 'package:topix/ui/app/layout.dart';
import 'package:topix/ui/core/widgets/post/post.dart';
import 'package:topix/utils/extensions.dart' show ThemeHelper;

class FeedScreen extends StatefulWidget {
  final FeedViewModel viewModel;

  const FeedScreen({super.key, required this.viewModel});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 2, vsync: this);
  int feedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabController.addListener(() {
        if (tabController.index != tabController.previousIndex) {
          feedIndex = tabController.index;
        }
      });
      widget.viewModel.loadNew();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return AppLayout(
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            enableFeedback: false,
            splashFactory: NoSplash.splashFactory,
            indicatorSize: .label,
            indicator: UnderlineTabIndicator(
              borderRadius: .circular(10),
              insets: const .symmetric(vertical: 6),
              borderSide: BorderSide(width: 3, color: context.colorScheme.primary),
            ),
            labelStyle: const TextStyle(fontWeight: .bold),
            unselectedLabelStyle: const TextStyle(fontWeight: .w500),
            tabs: [
              Tab(text: 'New'),
              Tab(text: 'Following'),
            ],
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: vm,
              builder: (context, _) {
                return NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    final pixels = notification.metrics.pixels,
                        maxScrollExtent = notification.metrics.maxScrollExtent;
                    if (maxScrollExtent - pixels <= 50) {
                      switch (FeedType.values[feedIndex]) {
                        case .all:
                          vm.loadNew();
                        case .following:
                          vm.loadFollowing();
                      }
                    }
                    return true;
                  },
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ListView.separated(
                        key: PageStorageKey('new_feed_posts_key'),
                        controller: vm.newScroll,
                        itemCount: vm.posts(.all).length + (vm.loading ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          if (vm.loading && index == vm.posts(.all).length) {
                            return Center(child: CircularProgressIndicator.adaptive());
                          }
                          final post = vm.posts(.all).elementAt(index);
                          return Post(
                            self: context.read<UserModel>(),
                            post: post,
                            reactPost: vm.reactPost,
                            deletePost: (id) async {
                              await vm.removePost(id, .all);
                            },
                          );
                        },
                      ),
                      ListView.separated(
                        key: PageStorageKey('follow_feed_posts_key'),
                        controller: vm.followingScroll,
                        itemCount: vm.posts(.following).length + (vm.loading ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          if (vm.loading && index == vm.posts(.following).length) {
                            return Center(child: CircularProgressIndicator.adaptive());
                          }
                          final post = vm.posts(.following).elementAt(index);
                          return Post(
                            self: context.read<UserModel>(),
                            post: post,
                            reactPost: vm.reactPost,
                            deletePost: (id) async {
                              await vm.removePost(id, .following);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
