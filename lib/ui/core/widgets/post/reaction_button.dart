import 'package:flutter/material.dart';

import 'package:topix/data/models/enums.dart' show ReactionType;
import 'package:topix/data/models/post.dart';
import 'package:topix/utils/extensions.dart';

class ReactionButton extends StatefulWidget {
  final Icon reactionIcon;
  final int reactionCount;
  final void Function(ReactionType) onReact;

  const ReactionButton({
    super.key,
    required this.reactionIcon,
    required this.reactionCount,
    required this.onReact,
  });

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton>
    with SingleTickerProviderStateMixin {
  final layerLink = LayerLink();
  late final AnimationController controller;

  OverlayEntry? overlay;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: 150.ms,
      reverseDuration: 150.ms,
    );
  }

  void showReactionsMenu() {
    overlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 1,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, -35),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: controller,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: Container(
              padding: const .symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: .circular(8),
                boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black26)],
              ),
              child: Row(
                spacing: 16,
                children: [
                  for (final t in ReactionType.values)
                    GestureDetector(
                      onTap: () {
                        widget.onReact(t);
                        overlay?.remove();
                        overlay = null;
                      },
                      child: PostModel.reactionIcon(t, 32),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay!);
    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: TextButton.icon(
        label: Text('${widget.reactionCount}'),
        icon: widget.reactionIcon,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            context.colorScheme.surfaceContainerHighest,
          ),
        ),
        onPressed: () {
          if (overlay != null) {
            controller.reverse(from: 1).then((_) {
              overlay?.remove();
              overlay = null;
            });
          } else {
            showReactionsMenu();
          }
        },
      ),
    );
  }
}
