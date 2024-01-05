import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/services/data_service.dart';
import 'package:playlist_annotator/features/home/pages/spotify_playlist_chooser_page.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_preview_tile.dart';
import 'package:playlist_annotator/features/playlist/pages/playlist_page.dart';
import 'package:playlist_annotator/features/settings/pages/settings_page.dart';

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
    Get.to(() => PlaylistPage(playlistPreview: playlistPreview));
  }

  void goToSettings() {
    Get.to(() => const SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    final playlistPreviews = Get.find<DataService>().playlistPreviews;
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text("app_title".tr),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: goToSettings,
            ),
            const SizedBox(width: Measurements.smallPadding),
          ],
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
