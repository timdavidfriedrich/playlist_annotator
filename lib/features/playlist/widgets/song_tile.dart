import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/song.dart';

class SongTile extends StatefulWidget {
  final Song song;
  final ExpansionTileController controller;
  const SongTile({super.key, required this.song, required this.controller});

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
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
      children: [
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
