// import 'package:fetch_client/fetch_client.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:log/log.dart';
import 'package:playlist_annotator/constants/links.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/models/user.dart';
import 'package:playlist_annotator/features/core/services/local_storage_service.dart';
import 'package:playlist_annotator/features/core/services/user_service.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

class PocketbaseService extends GetxService {
  late String? initialAuthStoreData;
  late AsyncAuthStore store;
  late PocketBase pocketbase;

  Future<PocketbaseService> init() async {
    store = await _loadAsyncAuthStore();
    if (store.isValid) {
      _updateCurrentUser(store);
    }
    pocketbase = PocketBase(
      Links.pocketbaseUrl,
      authStore: store,
      // httpClientFactory: kIsWeb ? () => FetchClient(mode: RequestMode.cors) : null,
    );
    return this;
  }

  Future<void> signOut() async {
    store.clear();
    pocketbase.authStore.clear();
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
    RecordAuth? authData = await pocketbase.collection('users').authWithOAuth2('spotify', (uri) async {
      await launchUrl(uri);
    }).then((RecordAuth? response) async {
      if (response == null) return null;
      await _updateRecordIfNecessary(response);
      return response;
    }).catchError((e) {
      Log.error(e);
      return null;
    });

    return authData;
  }

  Future<void> _updateRecordIfNecessary(RecordAuth response) async {
    if (response.record == null) return;

    Log.debug("_updateRecordIfNecessary");
    final user = await pocketbase.collection("users").getOne(response.record!.id);
    Log.debug("user: $user");

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

  Future<Function()> subscribePlaylistPreviews() async {
    final UserService userService = Get.find();
    String? userId = userService.currentUser.value?.id;
    // TODO: Add filter
    final subscription = await pocketbase.collection('playlistPreviews').subscribe("*", filter: "\"$userId\" ?= annotators.id", (event) {
      Log.debug("event: ${event.record}");
    });
    return subscription;
  }

  Future<List<PlaylistPreview>> getPlaylistPreviews() async {
    final UserService userService = Get.find();
    String? userId = userService.currentUser.value?.id;
    // TODO: Replace getFullList(..) with getList(..)
    final playlistPreviews = await pocketbase.collection('playlistPreviews').getFullList(filter: "\"$userId\" ?= annotators.id");
    return playlistPreviews.map((record) => PlaylistPreview.fromPocketbaseRecord(record)).toList();
  }

  Future<RecordModel> addPlaylistPreview(PlaylistPreview playlistPreview) async {
    return await pocketbase.collection('playlistPreviews').create(body: playlistPreview.toPocketbaseRecord());
  }

  Future<void> removePlaylistPreviewById(String id) async {
    await pocketbase.collection('playlistPreviews').delete(id);
  }

  Future<List<Annotation>> getLocalAnnotationsByPlaylistPreview(PlaylistPreview playlistPreview) async {
    final String playlistFilter = "playlistSpotifyId = \"${playlistPreview.spotifyId}\"";
    final String annotatorFilter = "(${playlistPreview.annotatorIds.map((id) => "\"$id\"= user").join("||")})";

    final List<RecordModel> records = await pocketbase.collection('localAnnotations').getFullList(
          filter: "$playlistFilter && $annotatorFilter",
        );

    return records.map((record) => Annotation.fromPocketbaseRecord(record)).toList();
  }

  Future<RecordModel> saveLocalAnnotation(Annotation annotation) async {
    try {
      return await pocketbase.collection('localAnnotations').update(annotation.id, body: annotation.toPocketbaseRecord());
    } catch (e) {
      Log.error(e);
      return await pocketbase.collection('localAnnotations').create(body: annotation.toPocketbaseRecord());
    }
  }

  Future<void> removeLocalAnnotationById(String id) async {
    await pocketbase.collection('localAnnotations').delete(id);
  }
}
