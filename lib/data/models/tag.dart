import 'dart:ui' show Color;

class TagModel {
  final int? id;
  final String name;
  final String colorHex;

  TagModel({this.id, required this.name, required this.colorHex});

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
    id: json['id'] as int?,
    name: json['name'] as String,
    colorHex: json['color'] as String,
  );

  Color get color => Color(int.parse(colorHex, radix: 16) | 0xFF000000);
}
