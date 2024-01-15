import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/services/data_service.dart';
import 'package:playlist_annotator/features/core/services/pocketbase_service.dart';
import 'package:playlist_annotator/features/home/widgets/playlist_preview_tile.dart';

class PlaylistPreviewDeleteConfirmationDialog extends StatefulWidget {
  final PlaylistPreview playlistPreview;
  const PlaylistPreviewDeleteConfirmationDialog({super.key, required this.playlistPreview});

  @override
  State<PlaylistPreviewDeleteConfirmationDialog> createState() => _PlaylistPreviewDeleteConfirmationDialogState();
}

class _PlaylistPreviewDeleteConfirmationDialogState extends State<PlaylistPreviewDeleteConfirmationDialog> {
  bool _keepAnnotationsAfterDeletion = true;
  bool _isRemoving = false;

  void _setKeepAnnotationsAfterDeletion(value) {
    setState(() => _keepAnnotationsAfterDeletion = value);
  }

  Future<void> _removePlaylistPreview(PlaylistPreview playlistPreview) async {
    setState(() => _isRemoving = true);

    if (!_keepAnnotationsAfterDeletion) {
      await _removeAllLocalAnnotationsByPlaylistSpotifyId(playlistPreview);
    }

    await Get.find<PocketbaseService>().removePlaylistPreviewById(playlistPreview.id);
    await Get.find<DataService>().removePlaylistPreviewById(playlistPreview.id);

    Get.back();
  }

  Future<void> _removeAllLocalAnnotationsByPlaylistSpotifyId(PlaylistPreview playlistPreview) async {
    final PocketbaseService pocketbaseService = Get.find<PocketbaseService>();
    final List<Annotation> localAnnotations = await pocketbaseService.getLocalAnnotationsByPlaylistPreview(playlistPreview);

    for (var annotation in localAnnotations) {
      await pocketbaseService.removeLocalAnnotationById(annotation.id);
    }
  }

  void _cancel() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      insetPadding: const EdgeInsets.all(Measurements.normalPadding),
      title: Text("remove_playlist_label".tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlaylistPreviewTile(playlistPreview: widget.playlistPreview),
          const SizedBox(height: Measurements.smallPadding),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("keep_annotations_after_deletion_label".tr),
            subtitle: Text("keep_annotations_after_deletion_description".tr),
            trailing: Switch.adaptive(
              value: _keepAnnotationsAfterDeletion,
              onChanged: _setKeepAnnotationsAfterDeletion,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface),
          ),
          onPressed: _cancel,
          child: Text("cancel_label".tr),
        ),
        FilledButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.error),
            foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onError),
          ),
          onPressed: () => _removePlaylistPreview(widget.playlistPreview),
          child: _isRemoving
              ? CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onError))
              : Text("remove_label".tr),
        ),
      ],
    );
  }
}
