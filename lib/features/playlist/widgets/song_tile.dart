import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/song.dart';
import 'package:playlist_annotator/features/playlist/widgets/annotation_row.dart';

class SongTile extends StatefulWidget {
  final Song song;
  final List<Annotation> localAnnotations;
  final ExpansionTileController controller;
  const SongTile({super.key, required this.song, this.localAnnotations = const [], required this.controller});

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
    List<Annotation> localAnnotations = widget.localAnnotations.where((annotation) {
      return annotation.songSpotifyId == widget.song.spotifyId;
    }).toList();

    return ExpansionTile(
      maintainState: true,
      controller: widget.controller,
      title: Text(widget.song.name),
      subtitle: Text(widget.song.artist),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius)),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
        child: Image.network(widget.song.imageUrl, height: 50, width: 50),
      ),
      initiallyExpanded: false,
      childrenPadding: const EdgeInsets.all(Measurements.normalPadding),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var annotation in localAnnotations) AnnotationRow(annotation: annotation),
        const SizedBox(height: Measurements.smallPadding),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  // TODO: Replace "0 + 1" with the number of annotations + 1
                  labelText: "add_first_comment_label".trPlural("add_comment_label".tr, 0 + 1),
                ),
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.thumbs_up_down_rounded))
          ],
        )
      ],
    );
  }
}
