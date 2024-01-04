import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/spotify_playlist_item.dart';

class SpotifyPlaylistTile extends StatelessWidget {
  final SpotifyPlaylistItem spotifyPlaylistItem;
  final Function()? onTap;
  const SpotifyPlaylistTile({super.key, required this.spotifyPlaylistItem, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius)),
        title: Text(spotifyPlaylistItem.name),
        subtitle: Text(spotifyPlaylistItem.ownerId),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
          child: Image.network(spotifyPlaylistItem.imageUrl, height: 50, width: 50),
        ),
        onTap: onTap,
      ),
    );
  }
}
