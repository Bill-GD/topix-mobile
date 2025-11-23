import 'package:flutter/material.dart';

import 'package:topix/data/models/tag.dart';

class TagWidget extends StatelessWidget {
  final Tag tag;

  const TagWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 4),
      decoration: BoxDecoration(borderRadius: const .all(.circular(4)), color: tag.color),
      child: Text(tag.name, style: TextStyle(fontWeight: .w600)),
    );
  }
}
