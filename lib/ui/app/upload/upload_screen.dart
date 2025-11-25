import 'package:flutter/material.dart';

import 'package:topix/ui/app/upload/upload_view_model.dart';
import 'package:topix/ui/core/theme/colors.dart';
import 'package:topix/ui/core/widgets/button.dart';
import 'package:topix/ui/core/widgets/input.dart';
import 'package:topix/ui/core/widgets/post/file_picker.dart';
import 'package:topix/ui/core/widgets/toast.dart';

class UploadScreen extends StatelessWidget {
  final UploadViewModel viewModel;
  final contentController = TextEditingController();

  UploadScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) => child!,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(viewModel.isReply ? 'Reply' : 'New post'),
            actions: [
              ValueListenableBuilder(
                valueListenable: contentController,
                builder: (context, value, child) {
                  return Button(
                    tooltip: 'Post',
                    icon: Icon(Icons.check_rounded, color: ThemeColors.successLight),
                    disabled: value.text.trim().isEmpty,
                    onPressed: () async {
                      final res = await viewModel.uploadPost(contentController.text.trim());
                      if (res) {
                        if (context.mounted) {
                          context.showToast('Post uploaded successfully');
                          Navigator.of(context).pop();
                        }
                      }
                    },
                  );
                }
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const .symmetric(horizontal: 16),
              child: Column(
                spacing: 8,
                children: [
                  Input(
                    controller: contentController,
                    hintText: "What's happening?",
                    maxLines: 8,
                  ),

                  Row(
                    children: [
                      if (viewModel.allowVisiblity)
                        Button(type: .base, text: 'Public', onPressed: () async {}),
                      const Spacer(),
                      Button(
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          context.showToast('Feature is not yet implemented.');
                          return;
                          if (viewModel.hasVideo) return;
                          final path = await FilePicker.image(context: context);
                          if (path != null) viewModel.addImage(path);
                        },
                      ),
                      Button(
                        icon: Icon(Icons.videocam_rounded),
                        onPressed: () async {
                          context.showToast('Feature is not yet implemented.');
                          return;
                          if (viewModel.hasImage) return;
                          final path = await FilePicker.video(context: context);
                          if (path != null) viewModel.updateVideo(path);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
