import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/playlist/widgets/playlist_song_list_actions.dart';
import 'package:playlist_annotator/features/playlist/widgets/song_tile.dart';

class PlaylistSongList extends StatelessWidget {
  final Playlist playlist;
  final List<Annotation> localAnnotations;
  const PlaylistSongList({super.key, required this.playlist, this.localAnnotations = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlist.songs.length + 1,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(
              left: Measurements.normalPadding + Measurements.minimalPadding,
              right: Measurements.smallPadding,
            ),
            child: PlaylistSongListActions(playlist: playlist),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: Measurements.minimalPadding),
          child: SongTile(
            song: playlist.songs.elementAt(index - 1),
            localAnnotations: localAnnotations,
          ),
        );
      },
    );
  }
}
