import 'package:flutter/material.dart';

import 'package:topix/ui/app/layout.dart';
import 'package:topix/ui/core/widgets/button.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Padding(
        padding: const .symmetric(horizontal: 8),
        child: Wrap(
          direction: .horizontal,
          spacing: 4,
          children: [
            // text
            Button(text: 'Default', onPressed: () {}),
            Button(type: .base, text: 'Base', onPressed: () {}),
            Button(type: .base, outline: true, text: 'Base outline', onPressed: () {}),
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
            Button(type: .danger, outline: true, text: 'Danger outline', onPressed: () {}),
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
      ),
    );
  }
}
