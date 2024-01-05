import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/user.dart';
import 'package:playlist_annotator/features/core/services/auth_service.dart';
import 'package:playlist_annotator/features/core/services/user_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signOut() async {
      await Get.find<AuthService>().signOut();
      Get.back();
    }

    User? currentUser = Get.find<UserService>().currentUser.value;
    return Scaffold(
      appBar: AppBar(
        title: Text("settings_label".tr),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: Measurements.normalPadding),
        children: [
          if (currentUser != null)
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.avatarUrl),
              ),
              title: Text(currentUser.name),
              subtitle: Text(currentUser.spotifyId),
              trailing: IconButton(
                onPressed: signOut,
                icon: const Icon(Icons.logout_rounded),
              ),
            ),
          const ListTile(
            title: Text("Irgendeine Einstellung"),
            subtitle: Text("hi hi, was geht. ich bin eine kleine einstellung - als wäre ich ein close-up, lol."),
          ),
          ListTile(
            title: Text("credits_label".tr),
            subtitle: const Text(
              "A heartfelt thank you to Elisabeth Endres for her unwavering support "
              "since the inception of our journey. Her generosity, through substantial donations, "
              "including a notable contribution of €2, has been instrumental in shaping and enhancing "
              "our platform. We are immensely grateful for her commitment and belief in our vision."
              "\n\nDeveloped by Tim David Friedrich.",
            ),
          ),
        ],
      ),
    );
  }
}
