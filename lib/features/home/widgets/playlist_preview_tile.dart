import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';

class PlaylistPreviewTile extends StatelessWidget {
  final PlaylistPreview playlistPreview;
  final Function()? onTap;
  final Function()? onActionTap;
  const PlaylistPreviewTile({super.key, required this.playlistPreview, this.onTap, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: Measurements.normalPadding, right: onActionTap == null ? Measurements.normalPadding : 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(playlistPreview.name),
        subtitle: Text(playlistPreview.ownerSpotifyNames),
        trailing: onActionTap == null
            ? null
            : IconButton(
                icon: const Icon(Icons.more_vert),
                color: Theme.of(context).hintColor,
                onPressed: onActionTap,
              ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
          child: Image.network(playlistPreview.imageUrl, height: 50, width: 50),
        ),
        onTap: onTap,
      ),
    );
  }
}
