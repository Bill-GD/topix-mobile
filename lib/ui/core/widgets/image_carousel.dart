import 'package:flutter/material.dart';

import 'package:topix/data/models/post.dart';
import 'package:topix/utils/extensions.dart';

class ImageCarousel extends StatefulWidget {
  final Post post;

  const ImageCarousel({super.key, required this.post});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  bool loading = true;
  int loadedImageCount = 0;
  (int, int) maxHeightSize = (16, 9);
  List<Image> images = [];
  final controller = CarouselController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final m in widget.post.mediaPaths) {
        final image = Image.network(m, fit: .contain);
        images.add(image);
        image.image
            .resolve(ImageConfiguration())
            .addListener(
              ImageStreamListener((image, synchronousCall) {
                if (image.image.height > maxHeightSize.$2) {
                  maxHeightSize = (image.image.width, image.image.height);
                }
                loadedImageCount++;
                if (loadedImageCount == widget.post.mediaPaths.length) {
                  if (mounted) {
                    setState(() => loading = false);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.animateToItem(0, duration: 1.ms);
                    });
                  }
                }
              }),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SizedBox(
          width: constraint.maxWidth,
          child: AspectRatio(
            aspectRatio: maxHeightSize.$1 / maxHeightSize.$2,
            child: loading
                ? Container(
                    alignment: .center,
                    decoration: BoxDecoration(
                      borderRadius: .circular(8),
                      color: context.colorScheme.surfaceContainerHigh,
                    ),
                    child: CircularProgressIndicator.adaptive(),
                  )
                : CarouselView(
                    controller: controller,
                    padding: const .all(0),
                    backgroundColor: context.colorScheme.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                    itemSnapping: true,
                    itemExtent: constraint.maxWidth,
                    children: images,
                  ),
          ),
        );
      },
    );
  }
}
