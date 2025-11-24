import 'package:flutter/material.dart';

import 'package:topix/ui/core/theme/colors.dart';
import 'package:topix/ui/core/theme/font.dart';

class DeleteOption extends StatelessWidget {
  final void Function() onTap;

  const DeleteOption({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: .circular(30)),
      leading: Icon(Icons.delete_rounded, color: ThemeColors.dangerLight),
      title: const Text(
        'Delete',
        style: TextStyle(fontSize: FontSize.small, color: ThemeColors.dangerLight),
      ),
      onTap: onTap,
    );
  }
}
