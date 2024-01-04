import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:log/log.dart';
import 'package:playlist_annotator/core/services/user_service.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseService extends GetxService {
  Future<PocketbaseService> init() async {
    return this;
  }

  PocketBase pocketbase = PocketBase('http://192.168.1.221:8090');

  Future<RecordAuth?> signInWithSpotify() async {
    final authData = await pocketbase.collection('users').authWithOAuth2('spotify', (uri) async {
      await launch(uri.toString());
    }).then((response) async {
      await _updateRecordIfNecessary(response);
      return response;
    });

    return authData;
  }

  Future<void> _updateRecordIfNecessary(response) async {
    if (response.record == null) return;

    final user = await pocketbase.collection("users").getOne(response.record!.id);

    final String username = response.meta["id"];
    final String name = response.meta["name"];
    final String avatarUrl = response.meta["avatarUrl"];
    final String email = response.meta["email"];
    final bool isPremium = response.meta["rawUser"]["product"] == "premium" ? true : false;

    final Map<String, dynamic> body = {
      ...user.data["username"] != username ? {"username": username} : {},
      ...user.data["name"] != name ? {"name": name} : {},
      ...user.data["avatarUrl"] != avatarUrl ? {"avatarUrl": avatarUrl} : {},
      ...user.data["email"] != email ? {"email": email} : {},
      ...user.data["isPremium"] != isPremium ? {"isPremium": isPremium} : {},
    };

    if (body.isNotEmpty) {
      pocketbase.collection("users").update(response.record!.id, body: body);
    }
  }

  Future<Function()> subscribe() async {
    final UserService user = Get.find();
    String? userId = user.current.value?.id;
    // TODO: Add filter
    final subscription = await pocketbase.collection('playlists').subscribe("*", filter: "owners~\"$userId\"", (event) {
      Log.debug("event: ${event.record}");
    });
    return subscription;
  }

  Future<List<RecordModel>> getPlaylists() async {
    final UserService user = Get.find();
    String? userId = user.current.value?.id;
    // TODO: Replace getFullList(..) with getList(..)
    // TODO: Add filter
    final playlists = await pocketbase.collection('playlists').getFullList(filter: "owners~\"$userId\"");
    return playlists;
  }

  Future<RecordModel?> getPlaylistById(String id) async {
    final playlist = await pocketbase.collection('playlists').getOne(id);
    return playlist;
  }

  Future<RecordModel> addPlaylist({
    required String spotifyUri,
    required String name,
    required String description,
    required imageUrl,
    List<String> owners = const [],
    List<String> annotators = const [],
    List<String> songs = const [],
  }) async {
    final playlist = await pocketbase.collection('playlists').create(
      body: {
        "spotifyUri": spotifyUri,
        "name": name,
        "description": description,
        "imageUrl": imageUrl,
        "owners": owners,
        "annotators": annotators,
        "songs": songs,
      },
    );
    return playlist;
  }
}
