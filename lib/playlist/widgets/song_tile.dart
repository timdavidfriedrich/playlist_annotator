import 'package:flutter/material.dart';
import 'package:playlist_annotator/core/models/song.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(widget.song.imageUrl, height: 50, width: 50),
      ),
      initiallyExpanded: false,
      childrenPadding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.surfaceTint,
                  labelText: 'Add a comment',
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
