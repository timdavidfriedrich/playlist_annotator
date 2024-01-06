import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_preview_delete_confirmation_dialog.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_preview_tile.dart';

class PlaylistPreviewMoreOptionsSheet extends StatelessWidget {
  final PlaylistPreview playlistPreview;
  const PlaylistPreviewMoreOptionsSheet({super.key, required this.playlistPreview});

  @override
  Widget build(BuildContext context) {
    void openDeleteConfirmationDialog() {
      Get.back();
      Get.dialog(
        PlaylistPreviewDeleteConfirmationDialog(playlistPreview: playlistPreview),
        barrierDismissible: false,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: Measurements.smallPadding),
        PlaylistPreviewTile(playlistPreview: playlistPreview),
        Divider(color: Theme.of(context).colorScheme.surfaceTint),
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
          children: [
            ListTile(
              title: Text("remove_playlist_label".tr),
              leading: const Icon(Icons.delete),
              onTap: openDeleteConfirmationDialog,
            ),
          ],
        ),
        const SizedBox(height: Measurements.mediumPadding),
      ],
    );
  }
}
