import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:log/log.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/models/song.dart';
import 'package:playlist_annotator/features/core/models/user.dart';
import 'package:playlist_annotator/features/core/services/pocketbase_service.dart';
import 'package:playlist_annotator/features/core/services/user_service.dart';
import 'package:playlist_annotator/features/core/widgets/cover_image.dart';
import 'package:playlist_annotator/features/playlist/controller/local_annotation_controller.dart';
import 'package:playlist_annotator/features/playlist/controller/playlist_controller.dart';
import 'package:playlist_annotator/features/playlist/controller/selected_song_controller.dart';
import 'package:playlist_annotator/features/playlist/widgets/annotation_dialog.dart';
import 'package:playlist_annotator/features/playlist/widgets/song_tile/annotation_row.dart';

class SongTileExpansionTile extends StatelessWidget {
  final Song song;
  final List<Annotation> localAnnotations;
  const SongTileExpansionTile({super.key, required this.song, this.localAnnotations = const []});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = Get.find<UserService>().currentUser.value;
    Annotation? userAnnotation = localAnnotations.firstWhereOrNull((e) => e.userId == currentUser?.id);

    late SelectedSongController? selectedSongController;
    late PlaylistPreview? currentPlaylistPreview;
    try {
      selectedSongController = Get.find<SelectedSongController>();
      currentPlaylistPreview = Get.find<PlaylistController>().currentPlaylistPreview.value;
    } catch (e) {
      Log.error("Could not find SelectedSongController or PlaylistController: $e");
    }

    if (selectedSongController == null || currentPlaylistPreview == null) {
      return Center(child: Text("error_label".tr));
    }
    return Obx(
      () {
        final bool isExpanded = selectedSongController!.selectedSongIds.contains(song.spotifyId);

        void toggleExpansion() {
          if (isExpanded) {
            selectedSongController!.deselectSongId(song.spotifyId);
          } else {
            selectedSongController!.selectSongId(song.spotifyId);
          }
        }

        Future<void> annotate() async {
          if (currentPlaylistPreview == null) return;
          if (currentUser == null) return;

          int? rating;
          String? comment;
          final (int?, String?)? result = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AnnotationDialog(previousAnnotation: userAnnotation, song: song),
          );

          if (result == null) return;

          if (result == (null, null) && userAnnotation != null) {
            Log.debug("userAnnotation.id: ${userAnnotation.id}");
            await Get.find<PocketbaseService>().removeLocalAnnotationById(userAnnotation.id);
            Get.find<LocalAnnotationController>().annotations.removeWhere((e) => e.id == userAnnotation.id);
            return;
          }

          (rating, comment) = result;

          Annotation annotation = Annotation(
            id: userAnnotation?.id ?? "",
            userSpotifyId: userAnnotation?.userSpotifyId ?? currentUser.spotifyId,
            userId: userAnnotation?.userId ?? currentUser.id,
            userName: userAnnotation?.userName ?? currentUser.name,
            songSpotifyId: userAnnotation?.songSpotifyId ?? song.spotifyId,
            playlistSpotifyId: userAnnotation?.playlistSpotifyId ?? currentPlaylistPreview.spotifyId,
            rating: rating,
            comment: comment,
          );

          Get.find<PocketbaseService>().saveLocalAnnotation(annotation);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(song.name),
              onTap: toggleExpansion,
              subtitle: Text(
                song.artist,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: isExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(Measurements.defaultBorderRadius))
                    : BorderRadius.circular(Measurements.defaultBorderRadius),
              ),
              tileColor: isExpanded ? Theme.of(context).colorScheme.surfaceVariant : null,
              leading: CoverImage(imageUrl: song.imageUrl),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isExpanded)
                    IconButton(
                      onPressed: () => annotate(),
                      icon: Icon(
                        userAnnotation == null ? Icons.add_comment_rounded : Icons.edit_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  Measurements.normalPadding,
                  Measurements.minimalPadding,
                  Measurements.normalPadding,
                  Measurements.normalPadding,
                ),
                height: isExpanded ? null : 0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Measurements.defaultBorderRadius)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var annotation in localAnnotations) AnnotationRow(annotation: annotation),
                    if (localAnnotations.isEmpty)
                      Text(
                        "no_annotations_label".tr,
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
