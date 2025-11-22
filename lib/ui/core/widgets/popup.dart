import 'package:flutter/material.dart';

import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/utils/extensions.dart';
import 'package:topix/utils/helpers.dart';

Future<void> showPopupMessage(
  BuildContext context, {
  required String title,
  required String content,
  Duration time = const Duration(milliseconds: 200),
  bool centerContent = true,
  bool enableButton = true,
  bool barrierDismissible = true,
}) async {
  await dialogWithActions<void>(
    context,
    title: title,
    content: content,
    centerContent: centerContent,
    time: time,
    actions: [
      TextButton(
        onPressed: enableButton ? () => Navigator.of(context).pop() : null,
        child: const Text('OK'),
      ),
    ],
    barrierDismissible: barrierDismissible,
  );
}

Future<T?> dialogWithActions<T>(
  BuildContext context, {
  Icon? icon,
  required String title,
  required String content,
  bool centerContent = true,
  required Duration time,
  List<Widget> actions = const [],
  bool barrierDismissible = true,
}) async {
  return await showGeneralDialog<T>(
    context: context,
    transitionDuration: time,
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    transitionBuilder: (_, anim1, _, child) {
      return ScaleTransition(
        scale: anim1.drive(CurveTween(curve: Curves.easeOutQuart)),
        alignment: .center,
        child: child,
      );
    },
    pageBuilder: (_, _, _) {
      return SafeArea(
        child: AlertDialog(
          scrollable: true,
          icon: icon,
          title: Text(title, textAlign: .center),
          titleTextStyle: TextStyle(
            fontSize: FontSize.mediumSmall,
            color: context.colorScheme.onSurface,
          ),
          content: Text(
            dedent(content),
            textAlign: centerContent ? .center : null,
            style: const TextStyle(fontSize: FontSize.small),
          ),
          contentPadding: const .symmetric(horizontal: 20, vertical: 15),
          actionsAlignment: .spaceEvenly,
          actions: actions,
          shape: const RoundedRectangleBorder(borderRadius: .all(.circular(10))),
          insetPadding: const .all(24),
        ),
      );
    },
  );
}
