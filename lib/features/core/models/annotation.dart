import 'package:pocketbase/pocketbase.dart';

class Annotation {
  final String id;
  final String songSpotifyId;
  final String userSpotifyId;
  final String userId;
  final String userName;
  final int? rating;
  final String? comment;
  final String? playlistSpotifyId;

  Annotation({
    required this.id,
    required this.songSpotifyId,
    required this.userSpotifyId,
    required this.userId,
    required this.userName,
    this.rating,
    this.comment,
    required this.playlistSpotifyId,
  });

  Annotation.global({
    required this.id,
    required this.songSpotifyId,
    required this.userSpotifyId,
    required this.userId,
    required this.userName,
    this.rating,
    this.comment,
  }) : playlistSpotifyId = null;

  Map<String, dynamic> toPocketbaseRecord() {
    return {
      "songSpotifyId": songSpotifyId,
      "userSpotifyId": userSpotifyId,
      "user": userId,
      "userName": userName,
      "rating": rating,
      "comment": comment,
      ...playlistSpotifyId != null ? {"playlistSpotifyId": playlistSpotifyId} : {},
    };
  }

  factory Annotation.fromPocketbaseRecord(RecordModel model) {
    if (model.collectionName == "globalAnnotations") {
      return Annotation.global(
        id: model.id,
        songSpotifyId: model.data["songSpotifyId"],
        userSpotifyId: model.data["userSpotifyId"],
        userId: model.data["user"],
        userName: model.data["userName"],
        rating: model.data["rating"],
        comment: model.data["comment"],
      );
    }
    return Annotation(
      id: model.id,
      playlistSpotifyId: model.data["playlistSpotifyId"],
      songSpotifyId: model.data["songSpotifyId"],
      userSpotifyId: model.data["userSpotifyId"],
      userId: model.data["user"],
      userName: model.data["userName"],
      rating: model.data["rating"],
      comment: model.data["comment"],
    );
  }
}
