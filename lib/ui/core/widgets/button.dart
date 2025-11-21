import 'package:flutter/material.dart';

import 'package:topix/ui/core/theme/colors.dart';
import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/utils/extensions.dart' show ThemeHelper;

enum ButtonType { base, primary, danger, success }

class Button extends StatelessWidget {
  final ButtonType? type;
  final bool outline;
  final void Function()? onPressed;
  final bool disabled;

  final String? text;

  final Widget? icon;
  final EdgeInsetsGeometry? padding;

  const Button({
    super.key,
    this.type,
    this.outline = false,
    this.onPressed,
    this.disabled = false,
    this.text,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    assert(icon != null || text != null);

    final colorScheme = context.colorScheme;

    Color? bgColor = outline ? Colors.transparent : null;
    Color? outlineColor;
    Color? hoverColor;
    Color? textColor;

    switch (type) {
      case .base:
        if (outline) {
          outlineColor = colorScheme.outline;
          textColor = colorScheme.onSurface;
        } else {
          bgColor = colorScheme.onSurface;
          textColor = colorScheme.onInverseSurface;
        }
      case .primary:
        if (outline) {
          outlineColor = ThemeColors.primary;
          textColor = ThemeColors.primary;
        } else {
          bgColor = ThemeColors.primary;
          textColor = ThemeColors.lightDim;
          hoverColor = ThemeColors.primaryLight;
        }
      case .danger:
        if (outline) {
          outlineColor = ThemeColors.danger;
          textColor = ThemeColors.danger;
        } else {
          bgColor = ThemeColors.danger;
          textColor = ThemeColors.lightDim;
          hoverColor = ThemeColors.dangerLight;
        }
      case .success:
        if (outline) {
          outlineColor = ThemeColors.success;
          textColor = ThemeColors.success;
        } else {
          bgColor = ThemeColors.success;
          textColor = ThemeColors.lightDim;
          hoverColor = ThemeColors.successLight;
        }
      case null:
    }

    final colors = {
      'bg': ?bgColor,
      'outline': ?outlineColor,
      'hover': ?hoverColor,
      'text': ?textColor,
    };

    return icon == null
        ? ElevatedButton(
            onPressed: disabled
                ? null
                : () {
                    onPressed?.call();
                    colors['text'] = Colors.white;
                  },
            style: ButtonStyle(
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(colors['bg']),
              overlayColor: WidgetStatePropertyAll(colors['hover']),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: .circular(8),
                  side: outline && colors['outline'] != null
                      ? BorderSide(color: colors['outline']!)
                      : .none,
                ),
              ),
            ),
            child: Text(
              text!,
              style: TextStyle(
                color: colors['text'],
                fontSize: FontSize.small,
                fontWeight: .w700,
              ),
            ),
          )
        : IconButton(
            onPressed: disabled ? null : onPressed,
            padding: padding,
            hoverColor: colors['hover'],
            style: ButtonStyle(
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(colors['bg']),
              overlayColor: WidgetStatePropertyAll(colors['hover']),
              foregroundColor: WidgetStatePropertyAll(colors['text']),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: .circular(10),
                  side: outline && colors['outline'] != null
                      ? BorderSide(color: colors['outline']!)
                      : .none,
                ),
              ),
            ),
            icon: icon!,
          );
  }
}
