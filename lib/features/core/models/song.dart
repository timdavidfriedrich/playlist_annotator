class Song {
  final String id;
  final String spotifyId;
  final String name;
  final String artist;
  final String? imageUrl;

  Song({
    required this.id,
    required this.spotifyId,
    required this.name,
    required this.artist,
    required this.imageUrl,
  });

  Song.fromSpotify(Map<String, dynamic> track)
      : id = "SONG_NOT_UPLOADED_YET",
        spotifyId = track['id'] ?? "NO_SPOTIFY_ID",
        name = track['name'],
        artist = track['artists'].map((artist) => artist['name']).join(', '),
        imageUrl = (track['album']['images'] as List).isNotEmpty ? track['album']['images'][0]['url'] : null;
}
