import 'package:flutter/material.dart';

import 'package:topix/ui/core/theme/font.dart';

class WidgetErrorScreen extends StatelessWidget {
  final FlutterErrorDetails e;
  final textStyle = const TextStyle(
    fontSize: FontSize.medium,
    color: Colors.red,
    decoration: .none,
  );

  const WidgetErrorScreen({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              Text('${e.exception}', style: textStyle),
              Text(e.stack.toString(), style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
