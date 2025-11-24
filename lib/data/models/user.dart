import 'package:topix/data/models/enums.dart' show UserRole;

class UserModel {
  final int id;
  final String username;
  final String displayName;
  final String? description;
  final String? profilePicture;
  final int? followerCount;
  final int? followingCount;
  final bool? followed;
  final int? chatChannelId;
  final UserRole role;

  UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    this.description,
    this.profilePicture,
    this.followerCount,
    this.followingCount,
    this.followed,
    this.chatChannelId,
    this.role = .user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int,
    username: json['username'] as String,
    displayName: json['displayName'] as String,
    description: json['description'] as String?,
    profilePicture: json['profilePicture'] as String?,
    followerCount: json['followerCount'] as int?,
    followingCount: json['followingCount'] as int?,
    followed: json['followed'] as bool?,
    chatChannelId: json['chatChannelId'] as int?,
    role: (json['role'] as String?) == 'admin' ? .admin : .user,
  );
}
