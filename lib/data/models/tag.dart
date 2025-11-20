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

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'colorHex': colorHex};

  @override
  String toString() {
    return 'Tag{\n'
        '\tid: $id,\n'
        '\tname: $name,\n'
        '\tcolorHex: $colorHex\n'
        '}';
  }
}
