import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';

class PlaylistCover extends StatelessWidget {
  final Playlist playlist;
  const PlaylistCover({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Measurements.normalPadding),
        child: Image.network(
          playlist.imageUrl,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 2,
        ),
      ),
    );
  }
}
