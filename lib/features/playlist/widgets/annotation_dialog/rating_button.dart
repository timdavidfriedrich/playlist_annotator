import 'package:flutter/material.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/utils/rating_icon.dart';

class RatingButton extends StatefulWidget {
  final Function(int) onRatingChanged;
  const RatingButton({super.key, required this.onRatingChanged});

  @override
  State<RatingButton> createState() => _RatingButtonState();
}

class _RatingButtonState extends State<RatingButton> {
  int _rating = 0;

  void _setRating(int newRating) {
    setState(() => _rating = newRating);
  }

  @override
  Widget build(BuildContext context) {
    final OverlayPortalController overlayPortalController = OverlayPortalController();

    final GlobalKey buttonKey = GlobalKey();

    void showRatingOverlay() {
      overlayPortalController.show();
    }

    void hideRatingOverlay() {
      overlayPortalController.hide();
    }

    return IconButton(
      key: buttonKey,
      onPressed: showRatingOverlay,
      icon: OverlayPortal(
          controller: overlayPortalController,
          overlayChildBuilder: (context) {
            final RenderBox box = buttonKey.currentContext?.findRenderObject() as RenderBox;
            final Offset parentPosition = box.localToGlobal(Offset.zero);
            final Size parentSize = box.size;
            return Stack(
              children: [
                GestureDetector(
                  onTap: hideRatingOverlay,
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                Positioned(
                  top: parentPosition.dy - parentSize.height - Measurements.minimalPadding,
                  left: parentPosition.dx - parentSize.width,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        final newRating = index - 1;
                        return IconButton(
                          onPressed: () {
                            widget.onRatingChanged(newRating);
                            _setRating(newRating);
                            hideRatingOverlay();
                          },
                          icon: RatingIcon.fromInt(newRating).icon,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
          child: RatingIcon.fromInt(_rating).icon),
    );
  }
}
