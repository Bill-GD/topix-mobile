import 'dart:ui';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icon, Icons, Colors;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:topix/data/models/enums.dart' show Visibility, ReactionType;
import 'package:topix/data/models/tag.dart';
import 'package:topix/data/models/user.dart';
import 'package:topix/ui/core/theme/colors.dart';
import 'package:topix/utils/extensions.dart' show WhereOrNull;

class PostModel {
  final int id;
  final UserModel owner;
  final String content;
  ReactionType? reaction;
  int reactionCount;
  int replyCount;
  final List<String> mediaPaths;
  final Visibility visibility;
  final DateTime dateCreated;
  final DateTime? dateUpdated;

  final PostModel? parentPost;

  final int? threadId;
  final String? threadTitle;
  final int? threadOwnerId;
  final Visibility? threadVisibility;

  final int? groupId;
  final String? groupName;
  final Visibility? groupVisibility;
  final bool? joinedGroup;
  final bool groupApproved;
  final TagModel? tag;

  PostModel({
    required this.id,
    required this.owner,
    required this.content,
    this.reaction,
    required this.reactionCount,
    required this.replyCount,
    required this.mediaPaths,
    required this.visibility,
    required this.dateCreated,
    this.parentPost,
    this.dateUpdated,
    this.threadId,
    this.threadTitle,
    this.threadOwnerId,
    this.threadVisibility,
    this.groupId,
    this.groupName,
    this.groupVisibility,
    this.joinedGroup,
    required this.groupApproved,
    this.tag,
  });

  static Icon reactionIcon(ReactionType? reaction, [double size = 20]) {
    return switch (reaction) {
      .like => Icon(Icons.thumb_up_rounded, color: ThemeColors.primary, size: size),
      .heart => Icon(CupertinoIcons.heart_fill, color: Colors.redAccent, size: size),
      .laugh => FaIcon(FontAwesomeIcons.solidFaceLaugh, color: Colors.yellow[700], size: size),
      .sad => FaIcon(
        FontAwesomeIcons.solidFaceFrownOpen,
        color: Colors.yellow[700],
        shadows: [Shadow(color: Colors.black26)],
        size: size,
      ),
      .angry => FaIcon(
        FontAwesomeIcons.solidFaceAngry,
        color: Colors.redAccent,
        size: size,
      ),
      null => Icon(Icons.thumb_up_off_alt_outlined, size: size),
    };
  }

  void updateReaction(ReactionType newReaction) {
    if (newReaction == reaction) {
      reaction = null;
      reactionCount--;
    } else {
      if (reaction == null) reactionCount++;
      reaction = newReaction;
    }
  }

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'] as int,
    owner: UserModel.fromJson(json['owner'] as Map<String, dynamic>),
    content: json['content'] as String,
    reaction: .values.firstWhereOrNull((v) => v.name == json['reaction'] as String?),
    reactionCount: json['reactionCount'] as int? ?? 0,
    replyCount: json['replyCount'] as int? ?? 0,
    mediaPaths:
        (json['mediaPaths'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        const [],
    visibility: .values.firstWhere(
      (v) => v.name == (json['visibility'] as String?),
      orElse: () => .public,
    ),
    dateCreated: DateTime.parse(json['dateCreated'] as String),
    dateUpdated: json['dateUpdated'] != null
        ? DateTime.parse(json['dateUpdated'] as String)
        : null,
    parentPost: json['parentPost'] != null
        ? PostModel.fromJson(json['parentPost'])
        : null,
    threadId: json['threadId'] as int?,
    threadTitle: json['threadTitle'] as String?,
    threadOwnerId: json['threadOwnerId'] as int?,
    threadVisibility: json['threadVisibility'] != null
        ? .values.firstWhere(
            (v) => v.name == (json['threadVisibility'] as String?),
            orElse: () => .public,
          )
        : null,
    groupId: json['groupId'] as int?,
    groupName: json['groupName'] as String?,
    groupVisibility: json['groupVisibility'] != null
        ? .values.firstWhere(
            (v) => v.name == (json['groupVisibility'] as String?),
            orElse: () => .public,
          )
        : null,
    joinedGroup: json['joinedGroup'] as bool?,
    groupApproved: json['groupApproved'] as bool,
    tag: json['tag'] != null
        ? TagModel.fromJson(json['tag'] as Map<String, dynamic>)
        : null,
  );
}
