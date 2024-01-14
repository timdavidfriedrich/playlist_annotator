import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/services/user_service.dart';
import 'package:playlist_annotator/features/core/utils/rating_icon.dart';

class AnnotationRow extends StatelessWidget {
  final Annotation annotation;
  const AnnotationRow({super.key, required this.annotation});

  @override
  Widget build(BuildContext context) {
    final bool hasRating = ![null, 0].contains(annotation.rating);
    final bool hasComment = annotation.comment != null && annotation.comment!.isNotEmpty;
    if (!hasRating && !hasComment) return const SizedBox();
    final bool isCurrentUser = Get.find<UserService>().currentUser.value?.spotifyId == annotation.userSpotifyId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Measurements.minimalPadding),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: annotation.userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCurrentUser ? null : Theme.of(context).hintColor,
              ),
            ),
            const WidgetSpan(child: SizedBox(width: Measurements.minimalPadding)),
            if (![null, 0].contains(annotation.rating))
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: RatingIcon.fromInt(
                  annotation.rating!,
                  size: Theme.of(context).textTheme.labelMedium?.fontSize,
                  color: isCurrentUser ? null : Theme.of(context).hintColor,
                ).icon,
              ),
            const WidgetSpan(child: SizedBox(width: Measurements.smallPadding)),
            // const TextSpan(text: "\n"),
            if (annotation.comment != null && annotation.comment!.isNotEmpty)
              TextSpan(
                text: annotation.comment!,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
          ],
        ),
      ),
    );
  }
}
