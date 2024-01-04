import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/core/api/spotify.dart';
import 'package:playlist_annotator/core/models/spotify_playlist_item.dart';
import 'package:playlist_annotator/home/widgets/spotify_playlist_tile.dart';

class SpotifyPlaylistChooserPage extends StatelessWidget {
  const SpotifyPlaylistChooserPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController uriController = TextEditingController();

    Future<List<SpotifyPlaylistItem>> getPlaylists() async {
      final spotify = Get.put(Spotify());
      final token = await spotify.getAccessToken();
      if (token == null) return [];
      return await spotify.getUserSpotifyPlaylists(token);
    }

    void returnPlaylist(SpotifyPlaylistItem playlist) {
      Get.back(result: playlist);
    }

    void returnPlaylistFromUri() {
      Get.back(result: uriController.text);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add playlist"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: uriController,
              decoration: const InputDecoration(
                labelText: "Playlist URI",
              ),
            ),
            const SizedBox(height: 32),
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
