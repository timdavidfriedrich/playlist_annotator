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
        leading: SizedBox(
          width: 50,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
              borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
            ),
          ),
        ),
        title: Text("app_title".tr),
        subtitle: Text("error_label".tr),
        trailing: const Icon(Icons.expand_more_rounded),
      ),
    );
  }
}
