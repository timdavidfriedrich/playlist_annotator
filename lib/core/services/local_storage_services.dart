import 'package:get/get.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

class LocalStorageService extends GetxService {
  // static LocalStorageService get to => Get.find();
  late final SecureSharedPref _prefs;

  Future<LocalStorageService> init() async {
    _prefs = await SecureSharedPref.getInstance();
    return this;
  }

  Future<void> saveSpotifyRefreshToken(String refreshToken) async {
    return await _prefs.putString("spotify_refresh_token", refreshToken);
  }

  Future<String?> loadSpotifyRefreshToken() async {
    return await _prefs.getString("spotify_refresh_token");
  }
}
