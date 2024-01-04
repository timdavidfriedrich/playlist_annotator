import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/utils/rating_icon.dart';

class AnnotationRow extends StatelessWidget {
  final Annotation annotation;
  const AnnotationRow({super.key, required this.annotation});

  @override
  Widget build(BuildContext context) {
    final bool hasRating = ![null, 0].contains(annotation.rating);
    final bool hasComment = annotation.comment != null && annotation.comment!.isNotEmpty;
    if (!hasRating && !hasComment) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Measurements.minimalPadding),
      child: Row(
        children: [
          Text(annotation.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: Measurements.minimalPadding),
          // TODO: Replace icon size with a constant or something
          if (![null, 0].contains(annotation.rating)) RatingIcon.fromInt(annotation.rating!, size: 12).icon,
          const SizedBox(width: Measurements.smallPadding),
          if (annotation.comment != null) Text(annotation.comment!),
        ],
      ),
    );
  }
}
