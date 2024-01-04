import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:log/log.dart';
import 'package:playlist_annotator/constants/links.dart';
import 'package:playlist_annotator/features/core/models/user.dart';
import 'package:playlist_annotator/features/core/services/local_storage_services.dart';
import 'package:playlist_annotator/features/core/services/user_service.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseService extends GetxService {
  late String? initialAuthStoreData;
  late AsyncAuthStore store;
  late PocketBase pocketbase;

  Future<PocketbaseService> init() async {
    store = await _loadAsyncAuthStore();
    if (store.isValid) {
      _updateCurrentUser(store);
    }
    pocketbase = PocketBase(Links.pocketbaseUrl, authStore: store);
    return this;
  }

  Future<AsyncAuthStore> _loadAsyncAuthStore() async {
    initialAuthStoreData = await Get.find<LocalStorageService>().loadAuthStore();
    return AsyncAuthStore(
      save: (String data) async => await Get.find<LocalStorageService>().saveAuthStore(data),
      initial: initialAuthStoreData,
    );
  }

  void _updateCurrentUser(AuthStore store) {
    Get.find<UserService>().updateCurrentUser(User.fromPocketbaseRecord(store.model));
  }

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
    final UserService userService = Get.find();
    String? userId = userService.currentUser.value?.id;
    // TODO: Add filter
    final subscription = await pocketbase.collection('playlists').subscribe("*", filter: "owners~\"$userId\"", (event) {
      Log.debug("event: ${event.record}");
    });
    return subscription;
  }

  Future<List<RecordModel>> getPlaylists() async {
    final UserService userService = Get.find();
    String? userId = userService.currentUser.value?.id;
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
