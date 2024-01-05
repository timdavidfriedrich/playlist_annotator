import 'package:get/get.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

class LocalStorageService extends GetxService {
  late final SecureSharedPref _secureSharedPreferences;

  Future<LocalStorageService> init() async {
    _secureSharedPreferences = await SecureSharedPref.getInstance();
    return this;
  }

  Future<void> signOut() async {
    await _secureSharedPreferences.clearAll();
  }

  Future<void> saveAuthStore(String authStoreData) async {
    return await _secureSharedPreferences.putString("auth_store", authStoreData);
  }

  Future<String?> loadAuthStore() async {
    return await _secureSharedPreferences.getString("auth_store");
  }

  Future<void> saveSpotifyRefreshToken(String refreshToken) async {
    return await _secureSharedPreferences.putString("spotify_refresh_token", refreshToken);
  }

  Future<String?> loadSpotifyRefreshToken() async {
    return await _secureSharedPreferences.getString("spotify_refresh_token");
  }
}
