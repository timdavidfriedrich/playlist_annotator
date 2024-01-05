import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/models/user.dart';

import '../../core/services/user_service.dart';

class EmptyHomeBody extends StatelessWidget {
  final Function() onAddPlaylist;
  const EmptyHomeBody({super.key, required this.onAddPlaylist});

  @override
  Widget build(BuildContext context) {
    User? currentUser = Get.find<UserService>().currentUser.value;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "empty_home_greeting".trParams({"name": currentUser?.name ?? ""}),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Measurements.normalPadding),
          FilledButton(
            onPressed: onAddPlaylist,
            child: Text("add_playlist_label".tr),
          ),
        ],
      ),
    );
  }
}
