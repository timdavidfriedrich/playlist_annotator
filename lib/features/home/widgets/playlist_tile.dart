import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';

class PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final Function()? onTap;
  final Function()? onActionTap;
  const PlaylistTile({super.key, required this.playlist, this.onTap, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(playlist.name),
        subtitle: Text(playlist.owners.firstOrNull?.name ?? "unknown_author_label".tr),
        trailing: onActionTap == null
            ? null
            : IconButton(
                icon: const Icon(Icons.more_vert),
                color: Theme.of(context).hintColor,
                onPressed: onActionTap,
              ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(playlist.imageUrl, height: 50, width: 50),
        ),
        onTap: onTap,
      ),
    );
  }
}
