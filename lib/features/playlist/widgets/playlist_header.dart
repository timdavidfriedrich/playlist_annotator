import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/links.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/widgets/cover_image.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaylistHeader extends StatelessWidget {
  final PlaylistPreview playlistPreview;
  const PlaylistHeader({super.key, required this.playlistPreview});

  void openInSpotify() {
    launchUrl(
      Uri.parse("${Links.spotifyPlaylistUrl}/${playlistPreview.spotifyId}"),
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surfaceTint,
            Theme.of(context).colorScheme.background,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 4),
            child: CoverImage(imageUrl: playlistPreview.imageUrl, width: MediaQuery.of(context).size.width / 2),
          ),
          const SizedBox(height: Measurements.mediumPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Measurements.mediumPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  playlistPreview.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: Measurements.smallPadding),
                if (playlistPreview.description != null && playlistPreview.description!.isNotEmpty) ...[
                  Text(
                    playlistPreview.description!,
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ],
                const SizedBox(height: Measurements.normalPadding),
                FilledButton(
                  onPressed: openInSpotify,
                  child: Text("open_in_spotify".tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
