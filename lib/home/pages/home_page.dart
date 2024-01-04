import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/core/services/spotify_service.dart';
import 'package:playlist_annotator/core/models/playlist.dart';
import 'package:playlist_annotator/core/models/spotify_playlist_item.dart';
import 'package:playlist_annotator/home/pages/spotify_playlist_chooser_page.dart';
import 'package:playlist_annotator/playlist/pages/playlist_page.dart';

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
      body: ListView.builder(
        itemCount: playlists.length + 1,
        itemBuilder: (context, index) {
          if (index == playlists.length) {
            return ListTile(
              title: Text("add_playlist_label".tr),
              leading: const Icon(Icons.add),
              onTap: addPlaylist,
            );
          }
          return ListTile(
            title: Text(playlists.elementAt(index).name),
            subtitle: Text(playlists.elementAt(index).description),
            leading: Image.network(playlists.elementAt(index).imageUrl, height: 50, width: 50),
            onTap: () => openPlaylist(playlists.elementAt(index)),
          );
        },
      ),
    );
  }
}
