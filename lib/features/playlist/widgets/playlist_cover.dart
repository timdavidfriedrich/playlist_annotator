import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';

class PlaylistCover extends StatelessWidget {
  final PlaylistPreview playlistPreview;
  const PlaylistCover({super.key, required this.playlistPreview});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Measurements.normalPadding),
        child: Image.network(
          playlistPreview.imageUrl,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 2,
        ),
      ),
    );
  }
}
