import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/song.dart';
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
  bool isExpanded = false;

  void setExpansion(bool value) {
    setState(() => isExpanded = value);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) => setExpansion(value),
      controller: widget.controller,
      title: Text(widget.song.name),
      subtitle: Text(widget.song.artist),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius)),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
        child: Image.network(widget.song.imageUrl, height: 50, width: 50),
      ),
      initiallyExpanded: isExpanded,
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
