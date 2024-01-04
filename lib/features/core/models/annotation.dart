import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/core/models/song.dart';
import 'package:playlist_annotator/features/core/models/user.dart';

class Annotation {
  final String id;
  final Song song;
  final User user;
  final int rating;
  final String comment;
  final Playlist? playlist;

  Annotation({
    required this.id,
    required this.song,
    required this.user,
    required this.rating,
    required this.comment,
    this.playlist,
  });

  Annotation.global({
    required this.id,
    required this.song,
    required this.user,
    required this.rating,
    required this.comment,
  }) : playlist = null;
}
