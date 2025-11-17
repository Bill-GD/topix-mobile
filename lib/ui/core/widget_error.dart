import 'package:flutter/material.dart';
import 'package:topix/utils/constants.dart';

class WidgetError extends StatelessWidget {
  final FlutterErrorDetails e;
  final textStyle = TextStyle(
    fontSize: FontSize.medium(),
    color: Colors.red,
    decoration: .none,
  );

  WidgetError({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Text('${e.exception}', style: textStyle),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(e.stack.toString(), style: textStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
