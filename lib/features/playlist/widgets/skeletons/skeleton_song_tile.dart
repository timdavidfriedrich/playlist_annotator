import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';

class SkeletonSongTile extends StatelessWidget {
  const SkeletonSongTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Measurements.minimalPadding + Measurements.smallPadding),
      child: ListTile(
        leading: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
            ),
            width: 50,
            height: 50),
        title: Text("app_title".tr),
        subtitle: Text("error_label".tr),
        trailing: const Icon(Icons.expand_more_rounded),
      ),
    );
  }
}
