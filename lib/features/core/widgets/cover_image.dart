import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CoverImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  const CoverImage({super.key, required this.imageUrl, this.height, this.width});

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
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        placeholder: (context, url) {
          return Skeletonizer(
            child: Container(
              height: height,
              width: width,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
