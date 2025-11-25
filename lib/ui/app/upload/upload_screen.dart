import 'package:flutter/material.dart';

import 'package:topix/ui/app/upload/upload_view_model.dart';

class UploadScreen extends StatelessWidget {
  final UploadViewModel viewModel;

  const UploadScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(viewModel.isReply ? 'Reply' : 'New post'),
        ),
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return child!;
          },
          child: Center(child: Text('upload')),
        ),
      ),
    );
  }
}
