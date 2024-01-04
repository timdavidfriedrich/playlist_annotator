import 'package:pocketbase/pocketbase.dart';

class Annotation {
  final String id;
  final String songSpotifyId;
  final String userId;
  final String userName;
  final int? rating;
  final String? comment;
  final String? playlistId;

  Annotation({
    required this.id,
    required this.songSpotifyId,
    required this.userId,
    required this.userName,
    this.rating,
    this.comment,
    required this.playlistId,
  });

  Annotation.global({
    required this.id,
    required this.songSpotifyId,
    required this.userId,
    required this.userName,
    this.rating,
    this.comment,
  }) : playlistId = null;

  Map<String, dynamic> toPocketbaseRecord() {
    return {
      "songSpotifyId": songSpotifyId,
      "userId": userId,
      "userName": userName,
      "rating": rating,
      "comment": comment,
      ...playlistId != null ? {"playlist": playlistId} : {},
    };
  }

  factory Annotation.fromPocketbaseRecord(RecordModel model) {
    if (model.collectionName == "globalAnnotations") {
      return Annotation.global(
        id: model.id,
        songSpotifyId: model.data["songSpotifyId"],
        userId: model.data["userId"],
        userName: model.data["userName"],
        rating: model.data["rating"],
        comment: model.data["comment"],
      );
    }
    return Annotation(
      id: model.id,
      playlistId: model.data["playlist"],
      songSpotifyId: model.data["songSpotifyId"],
      userId: model.data["userId"],
      userName: model.data["userName"],
      rating: model.data["rating"],
      comment: model.data["comment"],
    );
  }
}
