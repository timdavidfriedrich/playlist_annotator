import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:playlist_annotator/features/core/models/user.dart';
import 'package:playlist_annotator/features/core/services/pocketbase_service.dart';
import 'package:playlist_annotator/features/playlist/widgets/skeletons/skeleton_annotator_list_tile.dart';

class AnnotatorListTile extends StatelessWidget {
  final String annotatorId;
  const AnnotatorListTile({super.key, required this.annotatorId});

  Future<User?> getAnnotator() {
    return Get.find<PocketbaseService>().getUserFromId(annotatorId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAnnotator(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox();
        }

        if (!snapshot.hasData) {
          return const SkeletonAnnotatorListTile();
        }

        User? annotator = snapshot.data;

        if (annotator == null) {
          return const SkeletonAnnotatorListTile();
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).hintColor,
            backgroundImage: annotator.avatarUrl == null ? null : CachedNetworkImageProvider(annotator.avatarUrl!),
          ),
          title: Text(annotator.name),
          subtitle: Text(annotator.spotifyId),
        );
      },
    );
  }
}
