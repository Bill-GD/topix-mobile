import 'package:flutter/material.dart';

import 'package:topix/ui/core/theme/colors.dart';
import 'package:topix/ui/core/theme/font.dart';
import 'package:topix/utils/extensions.dart' show ThemeHelper;

enum ButtonType { base, primary, danger, success }

class Button extends StatelessWidget {
  final ButtonType type;
  final bool outline;
  final void Function()? onPressed;
  final bool disabled;

  final String? text;

  final Widget? icon;
  final EdgeInsetsGeometry? padding;

  const Button({
    super.key,
    required this.type,
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

    final isDark = context.isDarkMode;

    Color? outlineColor;
    Color hoverColor;
    Color textColor;
    Color bgColor;

    switch (type) {
      case .base:
        if (outline) {
          outlineColor = isDark ? ThemeColors.darkFaint : ThemeColors.lightFaint;
          hoverColor = outlineColor;
          textColor = isDark ? ThemeColors.lightFaint : ThemeColors.darkDim;
          bgColor = Colors.transparent;
        } else {
          bgColor = isDark ? ThemeColors.lightDim : ThemeColors.darkDim;
          hoverColor = isDark ? ThemeColors.lightFaint : ThemeColors.darkFaint;
          textColor = isDark ? ThemeColors.darkSubtle : ThemeColors.lightSubtle;
          outlineColor = null;
        }
      case .primary:
        if (outline) {
          outlineColor = ThemeColors.primary;
          hoverColor = ThemeColors.primaryLight;
          textColor = ThemeColors.primaryLight;
          bgColor = Colors.transparent;
        } else {
          bgColor = ThemeColors.primary;
          hoverColor = ThemeColors.primaryLight;
          textColor = ThemeColors.lightDim;
          outlineColor = null;
        }
      case .danger:
        if (outline) {
          outlineColor = ThemeColors.danger;
          hoverColor = ThemeColors.dangerLight;
          textColor = ThemeColors.dangerLight;
          bgColor = Colors.transparent;
        } else {
          bgColor = ThemeColors.danger;
          hoverColor = ThemeColors.dangerLight;
          textColor = ThemeColors.lightDim;
          outlineColor = null;
        }
      case .success:
        if (outline) {
          outlineColor = ThemeColors.success;
          hoverColor = ThemeColors.successLight;
          textColor = ThemeColors.successLight;
          bgColor = Colors.transparent;
        } else {
          bgColor = ThemeColors.success;
          hoverColor = ThemeColors.successLight;
          textColor = ThemeColors.lightDim;
          outlineColor = null;
        }
    }

    final colors = {
      'bg': bgColor,
      'outline': outlineColor,
      'hover': hoverColor,
      'text': textColor,
    };

    return icon == null
        ? ElevatedButton(
            onPressed: disabled ? null : onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(colors['bg']),
              overlayColor: WidgetStatePropertyAll(colors['hover']),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: .circular(8)),
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
            style: ButtonStyle(
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(colors['bg']),
              overlayColor: WidgetStatePropertyAll(colors['hover']),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: .circular(10),
                  side: outline ? BorderSide(color: colors['outline']!) : .none,
                ),
              ),
            ),
            icon: icon!,
          );
  }
}
