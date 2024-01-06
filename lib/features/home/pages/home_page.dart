import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/services/data_service.dart';
import 'package:playlist_annotator/features/home/pages/spotify_playlist_chooser_page.dart';
import 'package:playlist_annotator/features/home/widgets/empty_home_body.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_preview_more_options_sheet.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_preview_tile.dart';
import 'package:playlist_annotator/features/playlist/pages/playlist_page.dart';
import 'package:playlist_annotator/features/settings/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _addPlaylist() async {
    PlaylistPreview? playlistPreview = await Get.to(() => const SpotifyPlaylistChooserPage());
    if (playlistPreview == null) return;
    Get.find<DataService>().addAndSavePlaylistPreview(playlistPreview);
  }

  Future<void> _openPlaylist(PlaylistPreview playlistPreview) async {
    Get.to(() => PlaylistPage(playlistPreview: playlistPreview));
  }

  void _openMoreOptions(PlaylistPreview playlistPreview) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PlaylistPreviewMoreOptionsSheet(playlistPreview: playlistPreview);
      },
    );
  }

  void _goToSettings() {
    Get.to(() => const SettingsPage());
  }

  @override
  void initState() {
    super.initState();

    // TODO: Move this to a FutureBuilder
    Get.find<DataService>().init();
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
              onPressed: _goToSettings,
            ),
            const SizedBox(width: Measurements.smallPadding),
          ],
        ),
        body: playlistPreviews.isEmpty
            ? EmptyHomeBody(onAddPlaylist: _addPlaylist)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
                child: ListView(
                  children: [
                    ...List.generate(
                      playlistPreviews.length,
                      (index) {
                        PlaylistPreview playlistPreview = playlistPreviews.elementAt(index);
                        return PlaylistPreviewTile(
                          playlistPreview: playlistPreview,
                          onTap: () => _openPlaylist(playlistPreview),
                          onActionTap: () => _openMoreOptions(playlistPreview),
                        );
                      },
                    ),
                    ListTile(
                      title: Text("add_playlist_label".tr),
                      leading: const Icon(Icons.add),
                      onTap: _addPlaylist,
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
