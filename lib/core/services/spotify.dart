import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:log/log.dart';
import 'package:playlist_annotator/core/models/playlist.dart';
import 'package:playlist_annotator/core/models/spotify_playlist_item.dart';
import 'package:playlist_annotator/core/models/user.dart';

class Spotify extends GetxController {
  final clientId = '81ae522634cb431daed4230728ed0a76';
  final clientSecret = '25524e4e3a1b4e2bba98fe17bfea97da';

  final String baseUrl = "https://api.spotify.com/v1";

  Future<String?> getAccessToken() async {
    final url = Uri.parse('https://accounts.spotify.com/api/token');
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    const body = 'grant_type=client_credentials';

    final response = await http.post(url, headers: headers, body: body).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['access_token'];
    } else {
      Log.error("Error ${response.statusCode}: ${response.reasonPhrase}");
      return null;
    }
  }

  Future<List<SpotifyPlaylistItem>> getUserSpotifyPlaylists(String token) async {
    final userId = Get.put(UserController()).current.value?.username;
    Log.debug("userId: $userId");
    final url = Uri.parse('$baseUrl/users/$userId/playlists');
    Log.debug("url: $url");
    final headers = {
      'Authorization': 'Bearer $token',
    };

    List<SpotifyPlaylistItem> playlists = [];

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['items'] != null) {
        for (var data in body['items']) {
          playlists.add(SpotifyPlaylistItem(data));
        }
      }
    } else {
      Log.error("Error ${response.statusCode}: ${response.reasonPhrase}");
    }

    return playlists;
  }

  Future<Playlist?> getPlaylistById({required String id, required String token}) async {
    final url = Uri.parse('$baseUrl/playlists/$id');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return Playlist.fromSpotify(body);
    } else {
      Log.error("Failed to get playlist by ID with error ${response.statusCode}: ${response.reasonPhrase}. Returning null.");
      return null;
    }
  }
}
