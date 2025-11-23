import 'dart:ui' show Color;

class Tag {
  final int? id;
  final String name;
  final String colorHex;

  Tag({this.id, required this.name, required this.colorHex});

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json['id'] as int?,
    name: json['name'] as String,
    colorHex: json['color'] as String,
  );

  Color get color => Color(int.parse(colorHex, radix: 16) | 0xFF000000);
}
