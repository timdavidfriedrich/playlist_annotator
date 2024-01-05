import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/song.dart';
import 'package:playlist_annotator/features/core/models/user.dart';
import 'package:playlist_annotator/features/core/services/user_service.dart';
import 'package:playlist_annotator/features/playlist/widgets/annotation_row.dart';

class SongTileExpansionTile extends StatefulWidget {
  final Song song;
  final List<Annotation> localAnnotations;
  final ExpansionTileController controller;
  const SongTileExpansionTile({
    super.key,
    required this.song,
    this.localAnnotations = const [],
    required this.controller,
  });

  @override
  State<SongTileExpansionTile> createState() => _SongTileExpansionTileState();
}

class _SongTileExpansionTileState extends State<SongTileExpansionTile> {
  bool _isExpanded = false;

  void _setExpansion(bool value) {
    setState(() => _isExpanded = value);
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = Get.find<UserService>().currentUser.value;
    final List<String> annotationUserIds = widget.localAnnotations.map((e) => e.userId).toList();
    final bool userHasAnnotation = annotationUserIds.contains(currentUser?.id);
    return ExpansionTile(
      onExpansionChanged: (value) => _setExpansion(value),
      controller: widget.controller,
      tilePadding: const EdgeInsets.symmetric(horizontal: Measurements.smallPadding),
      title: Text(widget.song.name),
      subtitle: Text(
        widget.song.artist,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius)),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
        child: Image.network(widget.song.imageUrl, height: 50, width: 50),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isExpanded)
            IconButton(
              onPressed: () {},
              icon: Icon(
                userHasAnnotation ? Icons.edit_rounded : Icons.add_comment_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          Icon(
            _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
      initiallyExpanded: _isExpanded,
      childrenPadding: const EdgeInsets.all(Measurements.normalPadding),
      expandedAlignment: Alignment.topLeft,
      children: [
        for (var annotation in widget.localAnnotations) AnnotationRow(annotation: annotation),
        if (widget.localAnnotations.isEmpty)
          Text(
            "no_annotations_label".tr,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
      ],
    );
  }
}
