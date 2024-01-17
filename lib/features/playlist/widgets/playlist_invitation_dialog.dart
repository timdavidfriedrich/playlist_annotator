import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PlaylistInvitationDialog extends StatelessWidget {
  final PlaylistPreview playlistPreview;
  const PlaylistInvitationDialog({super.key, required this.playlistPreview});

  @override
  Widget build(BuildContext context) {
    void copyPlaylistPreviewId() async {
      await Clipboard.setData(ClipboardData(text: playlistPreview.id));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("playlist_id_has_been_copied_label".tr),
          duration: const Duration(seconds: 5),
        ),
      );
    }

    void close() {
      Get.back();
    }

    return AlertDialog.adaptive(
      title: Text("share_label".tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Measurements.smallPadding),
          Flexible(
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: QrImageView(
                padding: EdgeInsets.zero,
                data: playlistPreview.id,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
          const SizedBox(height: Measurements.smallPadding),
          Row(
            children: [
              Text("${"share_code_label".tr}:"),
              const SizedBox(width: Measurements.smallPadding),
              Flexible(
                fit: FlexFit.tight,
                child: SelectableText(
                  playlistPreview.id,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: Measurements.smallPadding),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: copyPlaylistPreviewId,
              ),
            ],
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: close,
          child: Text("close_label".tr),
        ),
      ],
    );
  }
}
