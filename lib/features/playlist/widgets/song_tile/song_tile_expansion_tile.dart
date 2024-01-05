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
    final List<String> annotationUserIds = localAnnotations.map((e) => e.userId).toList();
    final bool userHasAnnotation = annotationUserIds.contains(currentUser?.id);

    SelectedSongController selectedSongController = Get.find<SelectedSongController>();
    PlaylistPreview? currentPlaylistPreview = Get.find<PlaylistController>().currentPlaylistPreview.value;

    return Obx(
      () {
        final bool isExpanded = selectedSongController.selectedSongIds.contains(song.spotifyId);

        void toggleExpansion() {
          if (isExpanded) {
            selectedSongController.deselectSongId(song.spotifyId);
          } else {
            selectedSongController.selectSongId(song.spotifyId);
          }
        }

        Future<void> annotate() async {
          if (currentPlaylistPreview == null) return;
          if (currentUser == null) return;
          int? rating;
          String? comment;
          (rating, comment) = await showDialog(context: context, builder: (_) => AnnotationDialog(song: song)) ?? (null, null);
          if (rating == null && (comment == null || comment.isEmpty)) return;
          Log.debug("rating: $rating, comment: $comment");
          Log.debug("currentPlaylistPreview.id: ${currentPlaylistPreview.id}");
          Annotation annotation = Annotation(
            id: "",
            userId: currentUser.id,
            userName: currentUser.name,
            songSpotifyId: song.spotifyId,
            playlistId: currentPlaylistPreview.id,
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
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
                child: Image.network(song.imageUrl, height: 50, width: 50),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isExpanded)
                    IconButton(
                      onPressed: () => annotate(),
                      icon: Icon(
                        userHasAnnotation ? Icons.edit_rounded : Icons.add_comment_rounded,
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
