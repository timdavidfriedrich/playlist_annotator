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
}
