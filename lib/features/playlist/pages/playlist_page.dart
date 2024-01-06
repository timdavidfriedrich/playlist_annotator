import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/playlist/controller/local_annotation_controller.dart';
import 'package:playlist_annotator/features/core/services/spotify_service.dart';
import 'package:playlist_annotator/features/playlist/controller/playlist_controller.dart';
import 'package:playlist_annotator/features/playlist/widgets/playlist_cover.dart';
import 'package:playlist_annotator/features/playlist/widgets/playlist_info_row.dart';
import 'package:playlist_annotator/features/playlist/widgets/skeletons/skeleton_playlist_info_row.dart';
import 'package:playlist_annotator/features/playlist/widgets/skeletons/skeleton_song_tile.dart';
import 'package:playlist_annotator/features/playlist/widgets/song_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlaylistPage extends StatelessWidget {
  final PlaylistPreview playlistPreview;
  const PlaylistPage({super.key, required this.playlistPreview});

  @override
  Widget build(BuildContext context) {
    Future<Playlist?> getPlaylistFromPreview(PlaylistPreview playlistPreview) async {
      SpotifyService spotifyService = Get.find<SpotifyService>();
      final token = await spotifyService.getAccessToken();
      if (token == null) return null;
      return await spotifyService.getPlaylistByPlaylistPreview(playlistPreview: playlistPreview, token: token);
    }

    Future<List<Annotation>> getLocalAnnotations() async {
      LocalAnnotationController localAnnotationController = await Get.put(LocalAnnotationController()).init(playlistPreview.spotifyId);
      return localAnnotationController.annotations;
    }

    Future<(Playlist?, List<Annotation>)> getData() async {
      return (await getPlaylistFromPreview(playlistPreview), await getLocalAnnotations());
    }

    Get.put(PlaylistController()).setCurrentPlaylistPreview(playlistPreview);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 4),
              child: PlaylistCover(playlistPreview: playlistPreview),
            ),
            const SizedBox(height: Measurements.mediumPadding),
            Text(
              playlistPreview.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            if (playlistPreview.description != null && playlistPreview.description!.isNotEmpty) ...[
              const SizedBox(height: Measurements.normalPadding),
              Text(playlistPreview.description!),
              const SizedBox(height: Measurements.normalPadding),
            ],
            FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text("${"error_label".tr}: ${snapshot.error}"));
                if (!snapshot.hasData) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SkeletonPlaylistInfoRow(),
                        const SizedBox(height: Measurements.normalPadding),
                        ...List.generate(4, (index) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: Measurements.smallPadding),
                            child: SkeletonSongTile(),
                          );
                        }),
                      ],
                    ),
                  );
                }

                Playlist? playlist;
                List<Annotation> localAnnotations;
                (playlist, localAnnotations) = snapshot.data!;

                if (playlist == null) return Center(child: Text("${"error_label".tr}: ${snapshot.error}"));
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlaylistInfoRow(playlist: playlist),
                    const SizedBox(height: Measurements.normalPadding),
                    for (int index = 0; index < playlist.songs.length; index++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Measurements.smallPadding),
                        child: SongTile(
                          song: playlist.songs.elementAt(index),
                          localAnnotations: localAnnotations,
                        ),
                      ),
                    const SizedBox(height: Measurements.largePadding),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
