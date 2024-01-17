import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/services/data_service.dart';
import 'package:playlist_annotator/features/core/services/spotify_service.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_preview_add_by_code_row.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_preview_tile.dart';

class SpotifyPlaylistChooserPage extends StatelessWidget {
  const SpotifyPlaylistChooserPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<PlaylistPreview>> getPlaylists() async {
      SpotifyService spotifyService = Get.find();
      final token = await spotifyService.getAccessToken();
      if (token == null) return [];
      return await spotifyService.getUserSpotifyPlaylistPreviews(token);
    }

    void returnPlaylistPreview(PlaylistPreview playlist) {
      Get.back(result: playlist);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("add_playlist_label".tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
        child: Column(
          children: [
            const SizedBox(height: Measurements.normalPadding),
            const PlaylistPreviewAddByCodeRow(),
            const SizedBox(height: Measurements.normalPadding),
            Expanded(
              child: FutureBuilder(
                future: getPlaylists(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  final playlistPreviews = snapshot.data as List<PlaylistPreview>;
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      ...List.generate(playlistPreviews.length, (index) {
                        final playlistPreview = playlistPreviews.elementAt(index);
                        final currentPlaylistPreviews = Get.find<DataService>().playlistPreviews;

                        final bool alreadyInCurrent = currentPlaylistPreviews.any((e) => e.spotifyId == playlistPreview.spotifyId);
                        if (alreadyInCurrent) return const SizedBox();

                        return PlaylistPreviewTile(
                          playlistPreview: playlistPreviews.elementAt(index),
                          onTap: () => returnPlaylistPreview(playlistPreview),
                        );
                      }),
                      const SizedBox(height: Measurements.largePadding),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
