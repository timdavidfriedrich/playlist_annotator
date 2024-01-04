import 'package:get/get.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

class LocalStorageService extends GetxService {
  // static LocalStorageService get to => Get.find();
  late final SecureSharedPref _prefs;

  Future<LocalStorageService> init() async {
    _prefs = await SecureSharedPref.getInstance();
    return this;
  }

  Future<String?> loadSecureString(String key) async {
    return await _prefs.getString(key);
  }

  Future<void> saveSecureString(String key, String value) async {
    return await _prefs.putString(key, value);
  }
}
