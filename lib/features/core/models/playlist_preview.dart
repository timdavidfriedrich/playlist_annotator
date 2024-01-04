import 'package:get/instance_manager.dart';
import 'package:playlist_annotator/features/core/services/user_service.dart';
import 'package:pocketbase/pocketbase.dart';

class PlaylistPreview {
  final String id;
  final String spotifyId;
  final String name;
  final List<String> annotatorIds;
  final String ownerSpotifyNames;
  final String imageUrl;

  PlaylistPreview({
    required this.id,
    required this.spotifyId,
    required this.name,
    required this.annotatorIds,
    required this.ownerSpotifyNames,
    required this.imageUrl,
  });

  factory PlaylistPreview.fromPocketbaseRecord(RecordModel model) {
    return PlaylistPreview(
      id: model.id,
      spotifyId: model.data['spotifyId'],
      name: model.data['name'],
      annotatorIds: (model.data['annotators'] as List<dynamic>).map((e) => e.toString()).toList(),
      ownerSpotifyNames: model.data['ownerSpotifyNames'],
      imageUrl: model.data['imageUrl'],
    );
  }

  Map<String, dynamic> toPocketbaseRecord() {
    return {
      'spotifyId': spotifyId,
      'name': name,
      'annotators': annotatorIds,
      'ownerSpotifyNames': ownerSpotifyNames,
      'imageUrl': imageUrl,
    };
  }

  factory PlaylistPreview.fromSpotify(Map<String, dynamic> map) {
    final userId = Get.find<UserService>().currentUser.value?.id;
    return PlaylistPreview(
      id: "PLAYLIST_PREVIEW_NOT_UPLOADED_YET",
      spotifyId: map['id'],
      name: map['name'],
      annotatorIds: userId != null ? [userId] : [],
      ownerSpotifyNames: map['owner']['display_name'],
      imageUrl: map['images'][0]['url'],
    );
  }
}
