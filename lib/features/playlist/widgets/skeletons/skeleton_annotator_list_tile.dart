import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonAnnotatorListTile extends StatelessWidget {
  const SkeletonAnnotatorListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
      enabled: true,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
        ),
        title: Text("annotator.name"),
        subtitle: Text("annotator.spotifyId"),
      ),
    );
  }
}
