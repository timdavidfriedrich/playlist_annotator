class SpotifyPlaylistItem {
  final String id;
  final String spotifyUri;
  final String name;
  final String description;
  final String imageUrl;
  final String ownerId;

  SpotifyPlaylistItem(data)
      : id = data['id'],
        spotifyUri = data['uri'],
        name = data['name'],
        description = data['description'],
        imageUrl = data['images'][0]['url'],
        ownerId = data['owner']['id'];
}
