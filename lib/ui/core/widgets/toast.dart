import 'package:flutter/material.dart';

extension ToastMessage on BuildContext {
  void showToast(String msg) {
    ScaffoldMessenger.of(this)
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
}
