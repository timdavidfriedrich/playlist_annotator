import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/core/services/local_annotation_controller.dart';
import 'package:playlist_annotator/features/playlist/widgets/playlist_cover.dart';
import 'package:playlist_annotator/features/playlist/widgets/playlist_info_row.dart';
import 'package:playlist_annotator/features/playlist/widgets/song_tile.dart';

class PlaylistPage extends StatelessWidget {
  final Playlist playlist;
  const PlaylistPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<LocalAnnotationController>(
          future: Get.put(LocalAnnotationController()).init(playlist.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text("${"error_label".tr}: ${snapshot.error}"));
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            List<Annotation> localAnnotations = snapshot.data!.annotations;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 4),
                    child: PlaylistCover(playlist: playlist),
                  ),
                  const SizedBox(height: Measurements.mediumPadding),
                  Text(
                    playlist.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: Measurements.normalPadding),
                  Text(playlist.description),
                  const SizedBox(height: Measurements.normalPadding),
                  PlaylistInfoRow(playlist: playlist),
                  const SizedBox(height: Measurements.normalPadding),
                  for (int index = 0; index < playlist.songs.length; index++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Measurements.smallPadding),
                      child: SongTile(
                        song: playlist.songs.elementAt(index),
                        localAnnotations: localAnnotations,
                      ),
                    )
                ],
              ),
            );
          }),
    );
  }
}
