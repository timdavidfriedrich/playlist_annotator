import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:playlist_annotator/config/themes/theme_config.dart';
import 'package:playlist_annotator/features/core/localization/messages.dart';
import 'package:playlist_annotator/features/core/models/user.dart';
import 'package:playlist_annotator/features/core/services/local_storage_service.dart';
import 'package:playlist_annotator/features/core/services/auth_service.dart';
import 'package:playlist_annotator/features/core/services/data_service.dart';
import 'package:playlist_annotator/features/core/services/pocketbase_service.dart';
import 'package:playlist_annotator/features/core/services/spotify_service.dart';
import 'package:playlist_annotator/features/core/services/user_service.dart';
import 'package:playlist_annotator/features/home/pages/home_page.dart';
import 'package:playlist_annotator/features/onboarding/pages/sign_in_page.dart';

Future<void> main() async {
  await initServices();
  runApp(const PlaylistAnnotator());
}

Future<void> initServices() async {
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => LocalStorageService().init());
  await Get.putAsync(() => SpotifyService().init());
  await Get.putAsync(() => UserService().init());

  /// Depends on LocalStorageService and UserService
  await Get.putAsync(() => PocketbaseService().init());

  /// Depends on PocketbaseService
  await Get.putAsync(() => DataService().init());
}

class PlaylistAnnotator extends StatelessWidget {
  const PlaylistAnnotator({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = Get.find<UserService>().currentUser.value;

    return GetMaterialApp(
      title: "app_title".tr,
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.light(context),
      darkTheme: ThemeConfig.dark(context),
      home: Obx(() {
        return _buildHome(currentUser != null);
      }),
    );
  }
}

Widget _buildHome(bool isSignedIn) {
  return isSignedIn ? const HomePage() : const SignInPage();
}
