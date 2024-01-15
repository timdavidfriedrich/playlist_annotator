import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/playlist/widgets/skeletons/skeleton_playlist_info_row.dart';
import 'package:playlist_annotator/features/playlist/widgets/skeletons/skeleton_song_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonPlaylistSongList extends StatelessWidget {
  const SkeletonPlaylistSongList({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
            child: SkeletonPlaylistInfoRow(),
          ),
          const SizedBox(height: Measurements.normalPadding),
          ...List.generate(4, (index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: Measurements.smallPadding),
              child: SkeletonSongTile(),
            );
          }),
        ],
      ),
    );
  }
}
