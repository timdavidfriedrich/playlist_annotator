import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/playlist/controller/selected_song_controller.dart';

class PlaylistInfoRow extends StatelessWidget {
  final Playlist playlist;
  const PlaylistInfoRow({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    SelectedSongController selectedSongController = Get.put(SelectedSongController());

    List<String> songIds = playlist.songs.map((e) => e.spotifyId).toList();

    return Obx(
      () => Row(
        children: [
          Text(playlist.ownerSpotifyNames),
          const Text(" • "),
          Text("song_count_label".trParams({"count": "${playlist.songs.length}"})),
          const Spacer(),
          TextButton(
            onPressed: selectedSongController.hasNoSelectedSong
                ? () => selectedSongController.replaceSongIds(songIds)
                : selectedSongController.deselectAllSongIds,
            child: Text(
              selectedSongController.selectedSongIds.any(songIds.contains) ? "collapse_all_label".tr : "expand_all_label".tr,
            ),
          )
        ],
      ),
    );
  }
}
