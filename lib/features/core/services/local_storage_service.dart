import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:log/log.dart';

class LocalStorageService extends GetxService {
  late final FlutterSecureStorage _storage;

  Future<LocalStorageService> init() async {
    _storage = const FlutterSecureStorage();
    return this;
  }

  Future<void> signOut() async {
    await _storage.deleteAll();
  }

  Future<void> saveAuthStore(String authStoreData) async {
    return await _storage.write(key: "auth_store", value: authStoreData);
  }

  Future<String?> loadAuthStore() async {
    try {
      return await _storage.read(key: "auth_store");
    } catch (e) {
      Log.error(e);
      return null;
    }
  }

  Future<void> saveSpotifyRefreshToken(String refreshToken) async {
    return await _storage.write(key: "spotify_refresh_token", value: refreshToken);
  }

  Future<String?> loadSpotifyRefreshToken() async {
    try {
      return await _storage.read(key: "spotify_refresh_token");
    } catch (e) {
      Log.error(e);
      return null;
    }
  }
}
