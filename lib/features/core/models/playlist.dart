import 'package:playlist_annotator/features/core/models/song.dart';
import 'package:playlist_annotator/features/core/models/user.dart';
import 'package:pocketbase/pocketbase.dart';

class Playlist {
  final String id;
  final String spotifyId;
  final String name;
  final String description;
  final String imageUrl;
  final List<User> annotators;
  final String ownerSpotifyNames;
  final List<Song> songs;

  Playlist({
    required this.id,
    required this.spotifyId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.annotators,
    required this.ownerSpotifyNames,
    required this.songs,
  });

  Playlist.fromPocketbaseRecord(RecordModel record)
      : id = record.id,
        spotifyId = record.data['spotifyId'],
        name = record.data['name'],
        description = record.data['description'],
        imageUrl = record.data['imageUrl'],
        annotators = [], // TODO: Implement multiple annotators
        ownerSpotifyNames = record.data['ownerSpotifyNames'],
        songs = []; // TODO: Implement songs

  Playlist.fromSpotify(Map<String, dynamic> data)
      : id = "PLAYLIST_NOT_UPLOADED_YET", // ? What about pocketbase id ?
        spotifyId = data['id'],
        name = data['name'],
        description = data['description'],
        imageUrl = data['images'][0]['url'],
        annotators = [], // TODO: Implement multiple annotators
        ownerSpotifyNames = data['owner']['display_name'],
        songs = (data["tracks"]["items"] as List<dynamic>).map((item) {
          return Song.fromSpotify(item["track"]);
        }).toList(); // TODO: Implement songs
}
