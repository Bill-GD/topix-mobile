import 'package:flutter/material.dart';

void showToast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: .floating,
        margin: const .only(bottom: 10, left: 15, right: 15),
        shape: RoundedRectangleBorder(borderRadius: .circular(10)),
        showCloseIcon: true,
        persist: false,
      ),
    );
}
