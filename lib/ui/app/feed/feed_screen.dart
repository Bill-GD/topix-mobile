import 'package:flutter/material.dart';

import 'package:topix/ui/app/feed/feed_view_model.dart';
import 'package:topix/ui/app/layout.dart';

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
    return AppLayout(
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.loading) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent * 0.8) {
                widget.viewModel.load();
              }
              return false;
            },
            child: ListView.separated(
              key: PageStorageKey('feed_posts_key'),
              controller: widget.viewModel.scroll,
              itemCount: widget.viewModel.posts.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
              itemBuilder: (context, index) {
                final post = widget.viewModel.posts.elementAt(index);
                return ListTile(
                  leading: SizedBox.square(
                    dimension: 40,
                    child: ClipRRect(
                      borderRadius: .circular(50),
                      child: post.owner.profilePicture != null
                          ? Image.network(post.owner.profilePicture!)
                          : Image.asset('assets/images/default-picture.jpg'),
                    ),
                  ),
                  title: Text(post.owner.displayName),
                  subtitle: Text(post.content),
                  onTap: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
