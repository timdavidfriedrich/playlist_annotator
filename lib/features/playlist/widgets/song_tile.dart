import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/song.dart';
import 'package:playlist_annotator/features/playlist/widgets/song_tile/song_tile_annotation_indicator.dart';
import 'package:playlist_annotator/features/playlist/widgets/song_tile/song_tile_expansion_tile.dart';

class SongTile extends StatefulWidget {
  final Song song;
  final List<Annotation> localAnnotations;
  const SongTile({super.key, required this.song, this.localAnnotations = const []});

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
    List<Annotation> localAnnotations = widget.localAnnotations.where((annotation) {
      return annotation.songSpotifyId == widget.song.spotifyId;
    }).toList();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Measurements.minimalPadding + Measurements.smallPadding),
          child: SongTileExpansionTile(
            song: widget.song,
            localAnnotations: localAnnotations,
          ),
        ),
        const SizedBox(
          width: Measurements.minimalPadding,
          height: Measurements.minimalPadding,
        ),
        if (localAnnotations.isNotEmpty)
          const Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: Measurements.minimalPadding,
            child: SongTileAnnotationIndicator(),
          ),
      ],
    );
  }
}
