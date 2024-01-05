import 'package:flutter/material.dart';

class RatingIcon {
  final Icon icon;

  const RatingIcon._(this.icon);

  factory RatingIcon.fromInt(int rating, {double size = 24, Color? color}) {
    switch (rating) {
      case -1:
        return RatingIcon._(Icon(Icons.thumb_down_rounded, size: size, color: color));
      case 0:
        return RatingIcon._(Icon(Icons.thumbs_up_down_rounded, size: size, color: color));
      case 1:
        return RatingIcon._(Icon(Icons.thumb_up_rounded, size: size, color: color));
      default:
        throw Exception("Rating must be -1, 0, or 1");
    }
  }
}
