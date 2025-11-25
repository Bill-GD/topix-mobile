import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:topix/data/models/user.dart';
import 'package:topix/ui/app/layout.dart';
import 'package:topix/ui/app/post/post_view_model.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/post/post.dart';
import 'package:topix/utils/extensions.dart';

class PostScreen extends StatefulWidget {
  final PostViewModel viewModel;

  const PostScreen({super.key, required this.viewModel});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 3, vsync: this);
  int profileTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabController.addListener(() {
        if (tabController.index != tabController.previousIndex) {
          profileTabIndex = tabController.index;
        }
      });
      widget.viewModel.loadReplies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    final self = context.read<UserModel>();
    final isReply = vm.post.parentPost != null;

    return AppLayout(
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              final pixels = notification.metrics.pixels,
                  maxScrollExtent = notification.metrics.maxScrollExtent;
              if (maxScrollExtent - pixels <= 50) vm.loadReplies();
              return true;
            },
            child: ListView(
              controller: vm.scroll,
              children: [
                if (isReply) ...[
                  Post(
                    self: self,
                    post: vm.post.parentPost!,
                    showReaction: false,
                    showOptions: false,
                    reactPost: vm.reactPost,
                    deletePost: vm.removePost,
                  ),

                  Container(
                    height: 16,
                    width: 2,
                    decoration: BoxDecoration(
                      border: .symmetric(
                        vertical: .new(color: context.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                ],

                Post(
                  self: self,
                  post: vm.post,
                  isDetailed: true,
                  showThreadAndGroup: !isReply,
                  reactPost: vm.reactPost,
                  deletePost: vm.removePost,
                ),

                Padding(padding: const .all(12), child: Text('Replies')),

                for (final reply in vm.replies)
                  Post(
                    self: self,
                    post: reply,
                    showReplyMarker: false,
                    reactPost: vm.reactPost,
                    deletePost: vm.removePost,
                  ),

                if (vm.loading) Center(child: CircularProgressIndicator.adaptive()),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Button(
        type: .primary,
        tooltip: 'Reply',
        icon: Icon(Icons.add_rounded),
        onPressed: () {},
      ),
    );
  }
}
