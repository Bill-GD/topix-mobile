import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import 'package:topix/data/models/enums.dart' show ReactionType;
import 'package:topix/data/models/post.dart';
import 'package:topix/data/models/user.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/image_carousel.dart';
import 'package:topix/utils/extensions.dart' show ThemeHelper, TimeAgo;

class PostWidget extends StatefulWidget {
  final User self;
  final Post post;
  final bool isDetailed;
  final bool showReplyMarker;
  final bool showReaction;
  final bool showOptions;
  final bool showThreadAndGroup;
  final bool allowEditVisibility;

  const PostWidget({
    super.key,
    required this.self,
    required this.post,
    this.isDetailed = false,
    this.showReplyMarker = true,
    this.showReaction = true,
    this.showOptions = true,
    this.showThreadAndGroup = true,
    this.allowEditVisibility = false,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
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

  late ReactionType? currentReaction = widget.post.reaction;
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
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainer,
      child: InkWell(
        onTap: widget.isDetailed ? null : () {},
        overlayColor: WidgetStatePropertyAll(context.colorScheme.surfaceContainerHighest),
        child: Padding(
          padding: const .only(top: 12, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              // post metadata & options
              Row(
                crossAxisAlignment: .center,
                spacing: 8,
                children: [
                  SizedBox.square(
                    dimension: 40,
                    child: ClipOval(
                      child: widget.post.owner.profilePicture != null
                          ? Image.network(widget.post.owner.profilePicture!)
                          : Image.asset('assets/images/default-picture.jpg'),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          spacing: 4,
                          children: [
                            if (!widget.isDetailed &&
                                isReply &&
                                widget.showReplyMarker) ...[
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
                                  onTap: () {},
                                  child: Text(
                                    widget.post.threadTitle ??
                                        widget.post.threadTitle ??
                                        '',
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
                              onTap: () {},
                              child: Text(
                                widget.post.owner.displayName,
                                style: TextStyle(fontWeight: .w700),
                              ),
                            ),
                            if (showExtraInfo) ...[
                              Text('•'),
                              Text(widget.post.dateCreated.getTimeAgo()),

                              if (widget.post.dateUpdated != null)
                                Text(
                                  '• edited ${widget.post.dateUpdated!.getTimeAgo()}'
                                  '${widget.showThreadAndGroup && (widget.post.threadTitle != null || widget.post.groupName != null) ? '|' : ''}',
                                ),
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
                      (widget.self.id == widget.post.owner.id ||
                          widget.self.role == .admin))
                    Button(icon: Icon(Icons.more_horiz_rounded), onPressed: () {}),
                ],
              ),
              // post content
              Padding(
                padding: const .only(top: 8),
                child:
                    widget.post.visibility != .public &&
                        widget.self.id != widget.post.owner.id
                    ? Text('Post is privated or hidden.')
                    : Column(
                        crossAxisAlignment: .start,
                        spacing: 4,
                        children: [
                          if (widget.post.content.isNotEmpty) Text(widget.post.content),
                          if (widget.post.mediaPaths.isNotEmpty)
                            if (isImages)
                              ImageCarousel(post: widget.post)
                            else if (isVideo &&
                                vidController?.value.isInitialized == true)
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
              ),
              // post interaction
              Row(
                spacing: 4,
                children: [
                  TextButton.icon(
                    label: Text('${widget.post.reactionCount}'),
                    icon: Icon(Icons.thumb_up_off_alt_outlined),
                    style: ButtonStyle(),
                    onPressed: () {},
                  ),
                  TextButton.icon(
                    label: Text('${widget.post.replyCount}'),
                    icon: Icon(Icons.reply_rounded),
                    style: ButtonStyle(),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
