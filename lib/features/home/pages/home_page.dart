import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/services/spotify_service.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/core/models/spotify_playlist_item.dart';
import 'package:playlist_annotator/features/home/pages/spotify_playlist_chooser_page.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_tile.dart';
import 'package:playlist_annotator/features/playlist/pages/playlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Playlist> playlists = [];

  addPlaylist() async {
    // final uri = await showDialog(context: context, builder: (context) => const AddPlaylistDialog());
    SpotifyPlaylistItem? spotifyPlaylistItem = await Get.to(() => const SpotifyPlaylistChooserPage());
    if (spotifyPlaylistItem == null) return;
    final token = await Get.find<SpotifyService>().getAccessToken();
    Playlist? playlist = await Get.find<SpotifyService>().getPlaylistById(id: spotifyPlaylistItem.id, token: token ?? "");
    if (playlist == null) return;
    setState(() {
      playlists.add(playlist);
    });
  }

  openPlaylist(Playlist playlist) {
    Get.to(() => PlaylistPage(playlist: playlist));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app_title".tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
        child: ListView.builder(
          itemCount: playlists.length + 1,
          itemBuilder: (context, index) {
            if (index == playlists.length) {
              return ListTile(
                title: Text("add_playlist_label".tr),
                leading: const Icon(Icons.add),
                onTap: addPlaylist,
              );
            }
            return PlaylistTile(
              playlist: playlists.elementAt(index),
              onTap: () => openPlaylist(playlists.elementAt(index)),
            );
          },
        ),
      ),
    );
  }
}
