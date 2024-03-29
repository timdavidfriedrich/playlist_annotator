import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:playlist_annotator/core/localization/messages.dart';
import 'package:playlist_annotator/core/models/user.dart';
import 'package:playlist_annotator/home/pages/home_page.dart';
import 'package:playlist_annotator/onboarding/pages/sign_in_page.dart';

void main() {
  runApp(const PlaylistAnnotator());
}

class PlaylistAnnotator extends StatelessWidget {
  const PlaylistAnnotator({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController user = Get.put(UserController());

    return GetMaterialApp(
      title: "app_title".tr,
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Obx(() {
        return user.current.value == null ? const SignInPage() : const HomePage();
      }),
    );
  }
}
