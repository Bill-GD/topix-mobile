import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:topix/data/models/post.dart';
import 'package:topix/data/models/user.dart';
import 'package:topix/ui/app/layout.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/post.dart';
import 'package:topix/utils/extensions.dart' show NumDurationExtensions;

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Padding(
        padding: const .symmetric(horizontal: 8),
        child: ListView(
          children: [
            Wrap(
              direction: .horizontal,
              spacing: 8,
              children: [
                // text
                Button(text: 'Default', onPressed: () {}),
                Button(type: .base, text: 'Base', onPressed: () {}),
                Button(
                  type: .base,
                  outline: true,
                  text: 'Base outline',
                  onPressed: () {},
                ),
                Button(type: .primary, text: 'Primary', onPressed: () {}),
                Button(
                  type: .primary,
                  outline: true,
                  text: 'Primary outline',
                  onPressed: () {},
                ),
                Button(type: .success, text: 'Success', onPressed: () {}),
                Button(
                  type: .success,
                  outline: true,
                  text: 'Success outline',
                  onPressed: () {},
                ),
                Button(type: .danger, text: 'Danger', onPressed: () {}),
                Button(
                  type: .danger,
                  outline: true,
                  text: 'Danger outline',
                  onPressed: () {},
                ),
                // icon
                Button(icon: Icon(Icons.add_rounded), onPressed: () {}),
                Button(type: .base, icon: Icon(Icons.add_rounded), onPressed: () {}),
                Button(
                  type: .base,
                  outline: true,
                  icon: Icon(Icons.add_rounded),
                  onPressed: () {},
                ),
                Button(type: .primary, icon: Icon(Icons.add_rounded), onPressed: () {}),
                Button(
                  type: .primary,
                  outline: true,
                  icon: Icon(Icons.add_rounded),
                  onPressed: () {},
                ),
                Button(type: .success, icon: Icon(Icons.add_rounded), onPressed: () {}),
                Button(
                  type: .success,
                  outline: true,
                  icon: Icon(Icons.add_rounded),
                  onPressed: () {},
                ),
                Button(type: .danger, icon: Icon(Icons.add_rounded), onPressed: () {}),
                Button(
                  type: .danger,
                  outline: true,
                  icon: Icon(Icons.add_rounded),
                  onPressed: () {},
                ),
              ],
            ),

            PostWidget(
              self: context.read(),
              post: Post(
                id: 0,
                owner: User(id: 1, username: 'owner', displayName: 'Owner'),
                content: 'example content',
                reactionCount: 1,
                replyCount: 1,
                mediaPaths: [],
                visibility: .public,
                dateCreated: DateTime.now().subtract(30.minutes),
                groupApproved: true,
              ),
            ),
            PostWidget(
              self: context.read(),
              post: Post(
                id: 0,
                owner: User(id: 1, username: 'owner', displayName: 'Owner'),
                content: 'example content',
                reactionCount: 1,
                replyCount: 1,
                mediaPaths: [],
                visibility: .public,
                dateCreated: DateTime.now().subtract(30.minutes),
                threadId: 0,
                threadOwnerId: 0,
                threadTitle: 'Thread title',
                threadVisibility: .public,
                groupApproved: true,
              ),
            ),
            PostWidget(
              self: context.read(),
              post: Post(
                id: 0,
                owner: User(id: 1, username: 'owner', displayName: 'Owner'),
                content: 'example content',
                reactionCount: 1,
                replyCount: 0,
                mediaPaths: [],
                visibility: .public,
                dateCreated: DateTime.now().subtract(30.minutes),
                parentPost: Post(
                  id: 0,
                  owner: User(
                    id: 0,
                    username: 'owner',
                    displayName: 'Owner really long name',
                  ),
                  content: 'example content',
                  reactionCount: 1,
                  replyCount: 1,
                  mediaPaths: [],
                  visibility: .public,
                  dateCreated: DateTime.now().subtract(50.minutes),
                  groupApproved: true,
                ),
                threadId: 0,
                threadOwnerId: 0,
                threadTitle: 'A very very long and extra long thread title',
                threadVisibility: .public,
                groupApproved: true,
              ),
            ),
            PostWidget(
              self: context.read(),
              post: Post(
                id: 0,
                owner: User(id: 1, username: 'owner', displayName: 'Owner'),
                content: 'example content',
                reactionCount: 1,
                replyCount: 1,
                mediaPaths: [
                  'https://res.cloudinary.com/djqtcdphf/image/upload/v1760779019/jgqxueci3zyuifcd1euj.jpg',
                  'https://res.cloudinary.com/djqtcdphf/image/upload/v1760779018/xgbghehrjst0brtofrhk.jpg',
                ],
                visibility: .public,
                dateCreated: DateTime.now().subtract(30.minutes),
                groupApproved: true,
              ),
            ),
            PostWidget(
              self: context.read(),
              post: Post(
                id: 0,
                owner: User(id: 1, username: 'owner', displayName: 'Owner'),
                content: 'example content',
                reactionCount: 1,
                replyCount: 1,
                mediaPaths: [
                  'https://res.cloudinary.com/djqtcdphf/video/upload/v1757936272/cwqcetmilgpca92egj4d.mp4',
                ],
                visibility: .public,
                dateCreated: DateTime.now().subtract(30.minutes),
                groupApproved: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
