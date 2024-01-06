import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/song.dart';
import 'package:playlist_annotator/features/core/models/user.dart';
import 'package:playlist_annotator/features/core/services/user_service.dart';
import 'package:playlist_annotator/features/playlist/widgets/annotation_dialog/rating_button.dart';

class AnnotationDialog extends StatefulWidget {
  final Annotation? previousAnnotation;
  final Song song;
  const AnnotationDialog({super.key, required this.song, this.previousAnnotation});

  @override
  State<AnnotationDialog> createState() => _AnnotationDialogState();
}

class _AnnotationDialogState extends State<AnnotationDialog> {
  final TextEditingController _commentController = TextEditingController();

  bool _isRemoving = false;

  int _rating = 0;
  final int _maxLines = 5;
  final int _maxLength = 100;

  bool _isValid = false;

  void _validate() {
    final commentIsNotEmpty = _commentController.text.isNotEmpty;
    final commentHasCorrectLength = _commentController.text.length <= _maxLength;
    final ratingIsSet = _rating != 0;
    setState(() {
      _isValid = (commentHasCorrectLength && commentIsNotEmpty) || ratingIsSet;
    });
  }

  void _returnAnnotation() {
    User? currentUser = Get.find<UserService>().currentUser.value;
    if (currentUser == null) return;
    final comment = _commentController.text.isEmpty ? null : _commentController.text;
    Get.back<(int?, String?)>(result: (_rating, comment));
  }

  void _cancel() {
    Get.back();
  }

  Future<void> _delete() async {
    if (widget.previousAnnotation == null) return;
    Get.back<(int?, String?)?>(result: (null, null));
  }

  void _setRating(int newRating) {
    setState(() => _rating = newRating);
    _validate();
  }

  void _initPreviousAnnotation() {
    if (widget.previousAnnotation == null) return;
    _commentController.text = widget.previousAnnotation!.comment ?? "";
    _rating = widget.previousAnnotation!.rating ?? 0;
    _validate();
  }

  @override
  void initState() {
    super.initState();
    _initPreviousAnnotation();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      insetPadding: const EdgeInsets.all(Measurements.normalPadding),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
            child: Image.network(widget.song.imageUrl, height: 48, width: 48),
          ),
          const SizedBox(width: Measurements.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.song.name, style: Theme.of(context).textTheme.labelMedium),
                Text(
                  widget.song.artist,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: Measurements.smallPadding),
          RatingButton(onRatingChanged: _setRating),
        ],
      ),
      content: TextField(
        controller: _commentController,
        maxLines: _maxLines,
        maxLength: _maxLength,
        decoration: InputDecoration(
          hintText: "add_comment_label".tr,
        ),
        maxLengthEnforcement: MaxLengthEnforcement.none,
        onSubmitted: (_) => _returnAnnotation(),
        onChanged: (_) => _validate(),
      ),
      actionsAlignment: widget.previousAnnotation == null ? null : MainAxisAlignment.spaceBetween,
      actions: [
        if (widget.previousAnnotation != null) ...[
          IconButton(
            onPressed: _delete,
            icon: _isRemoving
                ? CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.error))
                : Icon(Icons.delete_rounded, color: Theme.of(context).colorScheme.error),
          ),
        ],
        TextButton(
          onPressed: _cancel,
          child: Text("cancel_label".tr),
        ),
        FilledButton(
          onPressed: _isValid ? _returnAnnotation : null,
          child: Text("save_label".tr),
        ),
      ],
    );
  }
}
