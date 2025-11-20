import 'package:topix/data/models/enums.dart' show UserRole;

class User {
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

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'displayName': displayName,
    'description': description,
    'profilePicture': profilePicture,
    'followerCount': followerCount,
    'followingCount': followingCount,
    'followed': followed,
    'chatChannelId': chatChannelId,
    'role': role.name,
  };

  @override
  String toString() {
    return 'User{\n'
        '\tid: $id,\n'
        '\tusername: $username,\n'
        '\tdisplayName: $displayName,\n'
        '\tdescription: $description,\n'
        '\tprofilePicture: $profilePicture,\n'
        '\tfollowerCount: $followerCount,\n'
        '\tfollowingCount: $followingCount,\n'
        '\tfollowed: $followed,\n'
        '\tchatChannelId: $chatChannelId,\n'
        '\trole: ${role.name}\n'
        '}';
  }
}
