import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';

class SongTileAnnotationIndicator extends StatelessWidget {
  final bool read;
  const SongTileAnnotationIndicator({super.key, this.read = true});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(vertical: Measurements.smallPadding),
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        color: read ? Theme.of(context).hintColor : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(
          Measurements.defaultBorderRadius,
        ),
      ),
    );
  }
}
