import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart';

import 'package:topix/utils/extensions.dart' show ThemeHelper;

extension BottomSheet on BuildContext {
  Future<void> showBottomSheet(Widget title, List<Widget> content) async {
    await showCupertinoModalPopup(
      context: this,
      builder: (context) {
        return Material(
          borderRadius: .circular(30),
          child: Container(
            constraints: .loose(.fromWidth(MediaQuery.of(context).size.width * 0.90)),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: .circular(30),
            ),
            child: Padding(
              padding: const .only(left: 10, right: 10, top: 30),
              child: Column(
                mainAxisSize: .min,
                children: [
                  Padding(padding: const .symmetric(horizontal: 20), child: title),
                  Padding(
                    padding: const .symmetric(vertical: 15),
                    child: Column(mainAxisSize: .min, children: content),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
