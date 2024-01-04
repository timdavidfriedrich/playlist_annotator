import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:log/log.dart';
import 'package:playlist_annotator/constants/links.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
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
    }).then((RecordAuth response) async {
      await _updateRecordIfNecessary(response);
      return response;
    });

    return authData;
  }

  Future<void> _updateRecordIfNecessary(RecordAuth response) async {
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

  Future<Function()> subscribePlaylistPreviews() async {
    final UserService userService = Get.find();
    String? userId = userService.currentUser.value?.id;
    // TODO: Add filter
    final subscription = await pocketbase.collection('playlistPreviews').subscribe("*", filter: "annotators ~ \"$userId\"", (event) {
      Log.debug("event: ${event.record}");
    });
    return subscription;
  }

  Future<List<PlaylistPreview>> getPlaylistPreviews() async {
    final UserService userService = Get.find();
    String? userId = userService.currentUser.value?.id;
    // TODO: Replace getFullList(..) with getList(..)
    final playlistPreviews = await pocketbase.collection('playlistPreviews').getFullList(filter: "annotators ~\"$userId\"");
    return playlistPreviews.map((record) => PlaylistPreview.fromPocketbaseRecord(record)).toList();
  }

  Future<RecordModel> addPlaylistPreview(PlaylistPreview playlistPreview) {
    return pocketbase.collection('playlistPreviews').create(body: playlistPreview.toPocketbaseRecord());
  }

  Future<List<Annotation>> getLocalAnnotationsForPlaylistId(String playlistId) async {
    final List<RecordModel> records = await pocketbase.collection('localAnnotations').getFullList(filter: "playlist = \"$playlistId\"");
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
}
