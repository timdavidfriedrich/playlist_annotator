import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/playlist/controller/local_annotation_controller.dart';
import 'package:playlist_annotator/features/core/services/spotify_service.dart';
import 'package:playlist_annotator/features/playlist/controller/playlist_controller.dart';
import 'package:playlist_annotator/features/playlist/pages/playlist_options_page.dart';
import 'package:playlist_annotator/features/playlist/widgets/playlist_header.dart';
import 'package:playlist_annotator/features/playlist/widgets/playlist_song_list.dart';
import 'package:playlist_annotator/features/playlist/widgets/skeletons/skeleton_playlist_song_list.dart';

class PlaylistPage extends StatelessWidget {
  final PlaylistPreview playlistPreview;
  const PlaylistPage({super.key, required this.playlistPreview});

  Future<Playlist?> getPlaylistFromPreview(PlaylistPreview playlistPreview) async {
    SpotifyService spotifyService = Get.find<SpotifyService>();
    final token = await spotifyService.getAccessToken();
    if (token == null) return null;
    return await spotifyService.getPlaylistByPlaylistPreview(playlistPreview: playlistPreview, token: token);
  }

  Future<List<Annotation>> getLocalAnnotations() async {
    LocalAnnotationController localAnnotationController = await Get.put(LocalAnnotationController()).init(playlistPreview);
    return localAnnotationController.annotations;
  }

  Future<(Playlist?, List<Annotation>)> getData() async {
    return (await getPlaylistFromPreview(playlistPreview), await getLocalAnnotations());
  }

  void goToPlaylistOptions() {
    Get.to(PlaylistOptionsPage(playlistPreview: playlistPreview));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PlaylistController()).setCurrentPlaylistPreview(playlistPreview);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
        actions: [
          IconButton(
            onPressed: goToPlaylistOptions,
            icon: const Icon(Icons.group),
          ),
          const SizedBox(width: Measurements.normalPadding),
        ],
      ),
      body: ListView(
        children: [
          PlaylistHeader(playlistPreview: playlistPreview),
          const SizedBox(height: Measurements.smallPadding),
          FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("${"error_label".tr}: ${snapshot.error}"));
              }
              if (!snapshot.hasData) {
                return const SkeletonPlaylistSongList();
              }

              Playlist? playlist;
              List<Annotation> localAnnotations;
              (playlist, localAnnotations) = snapshot.data!;

              if (playlist == null) {
                return Center(child: Text("${"error_label".tr}: ${snapshot.error}"));
              }

              return PlaylistSongList(
                playlist: playlist,
                localAnnotations: localAnnotations,
              );
            },
          ),
          const SizedBox(height: Measurements.largePadding),
        ],
      ),
    );
  }
}
