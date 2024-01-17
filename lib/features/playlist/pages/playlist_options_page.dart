import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/playlist/widgets/annotator_list_tile.dart';
import 'package:playlist_annotator/features/playlist/widgets/playlist_invitation_dialog.dart';

class PlaylistOptionsPage extends StatelessWidget {
  final PlaylistPreview playlistPreview;
  const PlaylistOptionsPage({super.key, required this.playlistPreview});

  @override
  Widget build(BuildContext context) {
    void sharePlaylist() {
      Get.dialog(PlaylistInvitationDialog(playlistPreview: playlistPreview));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(playlistPreview.name),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: Measurements.mediumPadding),
        children: [
          const SizedBox(height: Measurements.normalPadding),
          Text("annotator_list_label".tr, style: Theme.of(context).textTheme.headlineSmall),
          for (String annotatorId in playlistPreview.annotatorIds)
            AnnotatorListTile(
              annotatorId: annotatorId,
            ),
          ListTile(
            onTap: sharePlaylist,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surfaceTint,
              child: Icon(Icons.adaptive.share),
            ),
            title: Text("share_playlist_label".tr),
          ),
        ],
      ),
    );
  }
}
