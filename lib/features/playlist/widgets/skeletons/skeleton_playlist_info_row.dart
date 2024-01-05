import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SkeletonPlaylistInfoRow extends StatelessWidget {
  const SkeletonPlaylistInfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("app_title".tr),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text("collapse_all_label".tr),
        )
      ],
    );
  }
}
