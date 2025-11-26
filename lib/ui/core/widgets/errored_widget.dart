import 'package:flutter/material.dart';

import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/utils/extensions.dart' show ThemeHelper;

class ErroredWidget extends StatelessWidget {
  final FlutterErrorDetails e;

  const ErroredWidget({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainer,
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          spacing: 16,
          children: [
            Text(
              '${e.exception}',
              style: TextStyle(
                fontSize: FontSize.medium,
                color: context.colorScheme.error,
                decoration: .none,
              ),
            ),
            Text(
              e.stack.toString(),
              style: TextStyle(
                fontSize: FontSize.medium,
                color: context.colorScheme.error,
                decoration: .none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
