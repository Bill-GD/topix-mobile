import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class Input extends StatefulWidget {
  final TextStyle? style;
  final TextEditingController? controller;
  final bool? readOnly;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextStyle? labelStyle;
  final InputBorder? border;
  final BoxConstraints? constraints;
  final int? maxLines;
  final int? minLines;
  final void Function(String)? onChanged;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const Input({
    super.key,
    this.style,
    this.controller,
    this.readOnly,
    this.labelText,
    this.hintText,
    this.errorText,
    this.labelStyle,
    this.border = const OutlineInputBorder(borderRadius: .all(.circular(8))),
    this.constraints,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.obscureText = false,
    this.textInputType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        style: widget.style ?? const TextStyle(fontSize: FontSize.small),
        controller: widget.controller,
        readOnly: widget.readOnly ?? false,
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          errorText: widget.errorText,
          labelStyle:
              widget.labelStyle ??
              TextStyle(
                fontWeight: .w600, //
                color: Theme.of(context).colorScheme.primary,
              ),
          border: widget.border,
          constraints: widget.constraints,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        ),
        textInputAction: widget.textInputAction,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        onChanged: widget.onChanged,
      ),
    );
  }
}
