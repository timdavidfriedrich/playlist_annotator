import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/services/spotify_service.dart';
import 'package:playlist_annotator/features/core/models/spotify_playlist_item.dart';
import 'package:playlist_annotator/features/home/widgets/spotify_playlist_tile.dart';

class SpotifyPlaylistChooserPage extends StatelessWidget {
  const SpotifyPlaylistChooserPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController uriController = TextEditingController();

    Future<List<SpotifyPlaylistItem>> getPlaylists() async {
      SpotifyService spotifyService = Get.find();
      final token = await spotifyService.getAccessToken();
      if (token == null) return [];
      return await spotifyService.getUserSpotifyPlaylists(token);
    }

    void returnPlaylist(SpotifyPlaylistItem playlist) {
      Get.back(result: playlist);
    }

    void returnPlaylistFromUri() {
      Get.back(result: uriController.text);
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
            TextField(
              controller: uriController,
              decoration: InputDecoration(
                labelText: "playlist_uri_label".tr,
              ),
            ),
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
                  final playlists = snapshot.data as List<SpotifyPlaylistItem>;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists.elementAt(index);
                      return SpotifyPlaylistTile(
                        spotifyPlaylistItem: playlists.elementAt(index),
                        onTap: () => returnPlaylist(playlist),
                      );
                    },
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
