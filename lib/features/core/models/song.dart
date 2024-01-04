class Song {
  final String id;
  final String name;
  final String artist;
  final String imageUrl;

  Song({
    required this.id,
    required this.name,
    required this.artist,
    required this.imageUrl,
  });

  Song.fromSpotify(Map<String, dynamic> track)
      : id = track['id'],
        name = track['name'],
        artist = track['artists'].map((artist) => artist['name']).join(', '),
        imageUrl = track['album']['images'][0]['url'];
}
