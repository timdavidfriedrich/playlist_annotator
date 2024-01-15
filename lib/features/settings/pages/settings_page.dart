import 'package:cached_network_image/cached_network_image.dart';
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
                backgroundColor: Theme.of(context).hintColor,
                backgroundImage: currentUser.avatarUrl == null ? null : CachedNetworkImageProvider(currentUser.avatarUrl!),
              ),
              title: Text(currentUser.name),
              subtitle: Text(currentUser.spotifyId),
              trailing: IconButton(
                onPressed: signOut,
                icon: const Icon(Icons.logout_rounded),
              ),
            ),
        ],
      ),
    );
  }
}
