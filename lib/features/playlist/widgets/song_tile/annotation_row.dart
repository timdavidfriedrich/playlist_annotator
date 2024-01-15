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
    if (!hasRating && !hasComment) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Measurements.minimalPadding),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: annotation.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (![null, 0].contains(annotation.rating)) ...[
              const WidgetSpan(child: SizedBox(width: Measurements.minimalPadding)),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: RatingIcon.fromInt(
                  annotation.rating!,
                  size: Theme.of(context).textTheme.labelMedium?.fontSize,
                ).icon,
              ),
            ],
            if (annotation.comment != null && annotation.comment!.isNotEmpty) ...[
              const WidgetSpan(child: SizedBox(width: Measurements.smallPadding)),
              TextSpan(
                text: annotation.comment!,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
