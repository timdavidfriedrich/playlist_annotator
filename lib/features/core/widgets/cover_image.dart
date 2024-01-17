import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CoverImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  const CoverImage({super.key, this.imageUrl, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final double? height;
    final double? width;

    if (this.height != null || this.width != null) {
      height = this.height;
      width = this.width;
    } else {
      height = 50;
      width = 50;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
      child: imageUrl == null
          ? SizedBox(
              height: height,
              width: width,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Theme.of(context).hintColor),
              ),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl!,
              height: height,
              width: width,
              filterQuality: FilterQuality.none,
              placeholder: (context, url) {
                return Skeletonizer(
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Theme.of(context).hintColor),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
