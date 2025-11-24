import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import 'package:topix/data/models/enums.dart';
import 'package:topix/data/models/post.dart';
import 'package:topix/data/models/user.dart';
import 'package:topix/ui/app/post/post_screen.dart';
import 'package:topix/ui/app/post/post_view_model.dart';
import 'package:topix/ui/app/user/user_profile_screen.dart';
import 'package:topix/ui/app/user/user_profile_view_model.dart';
import 'package:topix/ui/core/theme/colors.dart';
import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/ui/core/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:topix/ui/core/widgets/bottom_sheet/delete_option.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/image_carousel.dart';
import 'package:topix/ui/core/widgets/popup.dart';
import 'package:topix/ui/core/widgets/post/reaction_button.dart';
import 'package:topix/ui/core/widgets/tag.dart';
import 'package:topix/ui/core/widgets/toast.dart';
import 'package:topix/utils/extensions.dart' show ThemeHelper, TimeAgo;

class Post extends StatefulWidget {
  final UserModel self;
  final PostModel post;
  final bool isDetailed;
  final bool showReplyMarker;
  final bool showReaction;
  final bool showOptions;
  final bool showThreadAndGroup;
  final bool allowEditVisibility;
  final Future<void> Function(int, ReactionType?) reactPost;
  final Future<void> Function(int) deletePost;

  const Post({
    super.key,
    required this.self,
    required this.post,
    this.isDetailed = false,
    this.showReplyMarker = true,
    this.showReaction = true,
    this.showOptions = true,
    this.showThreadAndGroup = true,
    this.allowEditVisibility = false,
    required this.reactPost,
    required this.deletePost,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late final isImages =
          widget.post.mediaPaths.isNotEmpty &&
          widget.post.mediaPaths.every((m) => m.contains('image')),
      isVideo =
          widget.post.mediaPaths.isNotEmpty &&
          widget.post.mediaPaths.every((m) => m.contains('video')),
      canClickPost =
          !widget.isDetailed &&
          (widget.post.visibility == .public ||
              (widget.post.visibility == .private &&
                  widget.self.id == widget.post.owner.id)),
      isReply = widget.post.parentPost != null,
      showExtraInfo =
          isReply ||
          (widget.showThreadAndGroup &&
              (widget.post.groupName != null || widget.post.threadTitle != null));

  VideoPlayerController? vidController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isVideo) {
        vidController = VideoPlayerController.networkUrl(
          Uri.parse(widget.post.mediaPaths.first),
        )..initialize().then((_) => setState(() {}));
      }
    });
  }

  @override
  void dispose() {
    vidController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postContent = Container(
      color: context.colorScheme.surfaceContainer,
      padding: .only(top: 12, left: 12, right: 12, bottom: widget.showReaction ? 6 : 12),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 8,
        children: [
          // post metadata & options
          Row(
            crossAxisAlignment: .center,
            spacing: 8,
            children: [
              SizedBox.square(
                dimension: 40,
                child: ClipOval(child: widget.post.owner.profileImage),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        if (!widget.isDetailed && isReply && widget.showReplyMarker) ...[
                          Flexible(
                            child: Text(
                              'replied to ${widget.post.parentPost?.owner.displayName}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.showThreadAndGroup &&
                              (widget.post.threadTitle != null ||
                                  widget.post.groupName != null))
                            Text('|'),
                        ],
                        if (widget.showThreadAndGroup &&
                            (widget.post.threadTitle != null ||
                                widget.post.groupName != null))
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.showToast('Thread/group not yet implemented.');
                              },
                              child: Text(
                                widget.post.threadTitle ?? widget.post.groupName ?? '',
                                style: TextStyle(fontWeight: .w700),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return UserProfileScreen(
                                    viewModel: UserProfileViewModel(
                                      username: widget.post.owner.username,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            widget.post.owner.displayName,
                            style: TextStyle(fontWeight: .w700),
                          ),
                        ),
                        if (showExtraInfo) ...[
                          Text('•'),
                          Text(widget.post.dateCreated.getTimeAgo()),
                          if (widget.post.dateUpdated != null) ...[
                            Text('•'),
                            Text('edited ${widget.post.dateUpdated!.getTimeAgo()}'),
                          ],
                          switch (widget.post.visibility) {
                            .private => Icon(Icons.lock_rounded, size: 16),
                            .hidden => Icon(Icons.visibility_off_rounded, size: 16),
                            .public => Icon(Icons.public_rounded, size: 16),
                          },
                        ],
                      ],
                    ),

                    if (!showExtraInfo)
                      Row(
                        spacing: 8,
                        children: [
                          Text(widget.post.dateCreated.getTimeAgo()),
                          if (widget.post.dateUpdated != null)
                            Text('• edited ${widget.post.dateUpdated!.getTimeAgo()}'),
                          switch (widget.post.visibility) {
                            .private => Icon(Icons.lock_rounded, size: 16),
                            .hidden => Icon(Icons.visibility_off_rounded, size: 16),
                            .public => Icon(Icons.public_rounded, size: 16),
                          },
                        ],
                      ),
                  ],
                ),
              ),
              // options
              if (widget.showOptions &&
                  (widget.self.id == widget.post.owner.id || widget.self.role == .admin))
                Button(
                  icon: Icon(Icons.more_horiz_rounded),
                  onPressed: () {
                    context.showBottomSheet(
                      Text('Post options', style: TextStyle(fontSize: FontSize.medium)),
                      [
                        DeleteOption(
                          onTap: () async {
                            final confirm = await context.showActionDialog<bool>(
                              title: 'Delete post',
                              content:
                                  'Are you sure you want to delete this post? '
                                  'This is irreversible.',
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop(true),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: ThemeColors.dangerLight,
                                      fontSize: FontSize.small,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop(false),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: FontSize.small),
                                  ),
                                ),
                              ],
                            );

                            if (confirm == true) {
                              await widget.deletePost(widget.post.id);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
          // post content
          if (widget.post.visibility != .public && widget.self.id != widget.post.owner.id)
            Text('Post is privated or hidden.')
          else
            Column(
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                if (widget.post.tag != null) Tag(tag: widget.post.tag!),
                if (widget.post.content.isNotEmpty) Text(widget.post.content),
                if (widget.post.mediaPaths.isNotEmpty)
                  if (isImages)
                    ImageCarousel(post: widget.post)
                  else if (isVideo && vidController?.value.isInitialized == true)
                    ClipRRect(
                      borderRadius: .circular(8),
                      child: AspectRatio(
                        aspectRatio: vidController!.value.aspectRatio,
                        child: VideoPlayer(vidController!),
                      ),
                    )
                  else
                    Container(
                      alignment: .center,
                      width: .infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: .circular(8),
                        color: context.colorScheme.surfaceContainerHigh,
                      ),
                      child: CircularProgressIndicator.adaptive(),
                    ),
              ],
            ),
          // post interaction
          if (widget.showReaction)
            Row(
              spacing: 8,
              children: [
                ReactionButton(
                  reactionIcon: PostModel.reactionIcon(widget.post.reaction),
                  reactionCount: widget.post.reactionCount,
                  onReact: (newReaction) async {
                    widget.post.updateReaction(newReaction);
                    await widget.reactPost(widget.post.id, widget.post.reaction);
                    setState(() {});
                  },
                ),
                TextButton.icon(
                  label: Text('${widget.post.replyCount}'),
                  icon: Icon(Icons.reply_rounded),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      context.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  onPressed: () {
                    if (widget.isDetailed) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return PostScreen(viewModel: PostViewModel(post: widget.post));
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );

    return widget.showReaction || widget.isDetailed
        ? postContent
        : InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return PostScreen(viewModel: PostViewModel(post: widget.post));
                  },
                ),
              );
            },
            child: postContent,
          );
  }
}
