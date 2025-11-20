import 'package:topix/data/models/enums.dart' show Visibility;
import 'package:topix/data/models/tag.dart';
import 'package:topix/data/models/user.dart';

class Post {
  final int id;
  final User owner;
  final String content;
  final String? reaction;
  final int reactionCount;
  final int replyCount;
  final List<String> mediaPaths;
  final Visibility visibility;
  final DateTime dateCreated;
  final DateTime? dateUpdated;

  final int? threadId;
  final String? threadTitle;
  final int? threadOwnerId;
  final Visibility? threadVisibility;

  final int? groupId;
  final String? groupName;
  final Visibility? groupVisibility;
  final bool? joinedGroup;
  final bool groupApproved;
  final Tag? tag;

  Post({
    required this.id,
    required this.owner,
    required this.content,
    this.reaction,
    required this.reactionCount,
    required this.replyCount,
    required this.mediaPaths,
    required this.visibility,
    required this.dateCreated,
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

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'] as int,
    owner: User.fromJson(json['owner'] as Map<String, dynamic>),
    content: json['content'] as String,
    reaction: json['reaction'] as String?,
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
    tag: json['tag'] != null ? Tag.fromJson(json['tag'] as Map<String, dynamic>) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'owner': owner.toJson(),
    'content': content,
    'reaction': reaction,
    'reactionCount': reactionCount,
    'replyCount': replyCount,
    'mediaPaths': mediaPaths,
    'visibility': visibility.name,
    'dateCreated': dateCreated.toIso8601String(),
    'dateUpdated': dateUpdated?.toIso8601String(),
    'threadId': threadId,
    'threadTitle': threadTitle,
    'threadOwnerId': threadOwnerId,
    'threadVisibility': threadVisibility?.name,
    'groupId': groupId,
    'groupName': groupName,
    'groupVisibility': groupVisibility?.name,
    'joinedGroup': joinedGroup,
    'groupApproved': groupApproved,
    'tag': tag?.toJson(),
  };

  @override
  String toString() {
    final ownerStr = owner.toString().replaceAll('\n', '\n\t');
    return 'Post{\n'
        '\tid: $id,\n'
        '\towner: $ownerStr,\n'
        '\tcontent: $content,\n'
        '\treaction: $reaction,\n'
        '\treactionCount: $reactionCount,\n'
        '\treplyCount: $replyCount,\n'
        '\tmediaPaths: $mediaPaths,\n'
        '\tvisibility: ${visibility.name},\n'
        '\tdateCreated: $dateCreated,\n'
        '\tdateUpdated: $dateUpdated,\n'
        '\tthreadId: $threadId,\n'
        '\tthreadTitle: $threadTitle,\n'
        '\tthreadOwnerId: $threadOwnerId,\n'
        '\tthreadVisibility: ${threadVisibility?.name},\n'
        '\tgroupId: $groupId,\n'
        '\tgroupName: $groupName,\n'
        '\tgroupVisibility: ${groupVisibility?.name},\n'
        '\tjoinedGroup: $joinedGroup,\n'
        '\tgroupApproved: $groupApproved,\n'
        '\ttag: ${tag?.name}\n'
        '}';
  }
}
