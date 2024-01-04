import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:playlist_annotator/core/localization/messages.dart';
import 'package:playlist_annotator/core/services/local_storage_services.dart';
import 'package:playlist_annotator/core/services/auth_service.dart';
import 'package:playlist_annotator/core/services/database_service.dart';
import 'package:playlist_annotator/core/services/pocketbase_service.dart';
import 'package:playlist_annotator/core/services/spotify_service.dart';
import 'package:playlist_annotator/core/services/user_service.dart';
import 'package:playlist_annotator/home/pages/home_page.dart';
import 'package:playlist_annotator/onboarding/pages/sign_in_page.dart';

Future<void> main() async {
  await initServices();
  runApp(const PlaylistAnnotator());
}

Future<void> initServices() async {
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => DataService().init());
  await Get.putAsync(() => LocalStorageService().init());
  await Get.putAsync(() => PocketbaseService().init());
  await Get.putAsync(() => SpotifyService().init());
  await Get.putAsync(() => UserService().init());
}

class PlaylistAnnotator extends StatelessWidget {
  const PlaylistAnnotator({super.key});

  @override
  Widget build(BuildContext context) {
    UserService userService = Get.find();

    return GetMaterialApp(
      title: "app_title".tr,
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Obx(() {
        return userService.current.value == null ? const SignInPage() : const HomePage();
      }),
    );
  }
}
