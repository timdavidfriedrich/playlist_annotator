import 'package:playlist_annotator/core/models/song.dart';
import 'package:playlist_annotator/core/models/user.dart';
import 'package:pocketbase/pocketbase.dart';

class Playlist {
  final String id;
  final String spotifyUri;
  final String name;
  final String description;
  final String imageUrl;
  final List<User> owners;
  final List<User> annotators;
  final List<Song> songs;

  Playlist({
    required this.id,
    required this.spotifyUri,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.owners,
    required this.annotators,
    required this.songs,
  });

  Playlist.fromPocketbaseRecord(RecordModel record)
      : id = record.id,
        spotifyUri = record.data['spotifyUri'],
        name = record.data['name'],
        description = record.data['description'],
        imageUrl = record.data['imageUrl'],
        owners = [], // TODO: Implement multiple owners
        annotators = [], // TODO: Implement annotators
        songs = []; // TODO: Implement songs

  Playlist.fromSpotify(Map<String, dynamic> data)
      : id = data['id'], // ? What about pocketbase id ?
        spotifyUri = data['uri'],
        name = data['name'],
        description = data['description'],
        imageUrl = data['images'][0]['url'],
        owners = [], // TODO: Implement multiple owners
        annotators = [], // TODO: Implement annotators
        songs = (data["tracks"]["items"] as List<dynamic>).map((item) {
          return Song.fromSpotify(item["track"]);
        }).toList(); // TODO: Implement songs
}
