import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/services/data_service.dart';
import 'package:playlist_annotator/features/core/services/spotify_service.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/home/pages/spotify_playlist_chooser_page.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_preview_tile.dart';
import 'package:playlist_annotator/features/playlist/pages/playlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  addPlaylist() async {
    PlaylistPreview? playlistPreview = await Get.to(() => const SpotifyPlaylistChooserPage());
    if (playlistPreview == null) return;
    Get.find<DataService>().addAndSavePlaylistPreview(playlistPreview);
  }

  Future<void> openPlaylist(PlaylistPreview playlistPreview) async {
    Playlist? playlist = await _getPlaylistFromPreview(playlistPreview);
    if (playlist == null) return;
    Get.to(() => PlaylistPage(playlist: playlist));
  }

  Future<Playlist?> _getPlaylistFromPreview(PlaylistPreview playlistPreview) async {
    SpotifyService spotifyService = Get.find<SpotifyService>();
    final token = await spotifyService.getAccessToken();
    if (token == null) return null;
    return await spotifyService.getPlaylistById(id: playlistPreview.spotifyId, token: token);
  }

  @override
  Widget build(BuildContext context) {
    final playlistPreviews = Get.find<DataService>().playlistPreviews;
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text("app_title".tr),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
          child: ListView.builder(
            itemCount: playlistPreviews.length + 1,
            itemBuilder: (context, index) {
              if (index == playlistPreviews.length) {
                return ListTile(
                  title: Text("add_playlist_label".tr),
                  leading: const Icon(Icons.add),
                  onTap: addPlaylist,
                );
              }
              return PlaylistPreviewTile(
                playlistPreview: playlistPreviews.elementAt(index),
                onTap: () => openPlaylist(playlistPreviews.elementAt(index)),
              );
            },
          ),
        ),
      );
    });
  }
}
