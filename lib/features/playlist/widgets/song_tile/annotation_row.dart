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
    if (!hasRating && !hasComment) return Container();
    final bool isCurrentUser = Get.find<UserService>().currentUser.value?.name == annotation.userName;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Measurements.minimalPadding),
      child: Row(
        children: [
          Text(
            annotation.userName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCurrentUser ? null : Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(width: Measurements.minimalPadding),
          // TODO: Replace icon size with a constant or something
          if (![null, 0].contains(annotation.rating))
            RatingIcon.fromInt(
              annotation.rating!,
              size: 12,
              color: isCurrentUser ? null : Theme.of(context).hintColor,
            ).icon,
          const SizedBox(width: Measurements.smallPadding),
          if (annotation.comment != null)
            Text(
              annotation.comment!,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
        ],
      ),
    );
  }
}