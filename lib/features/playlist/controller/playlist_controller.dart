import 'package:get/get.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';

class PlaylistController extends GetxController {
  Rxn<PlaylistPreview?> currentPlaylistPreview = Rxn<PlaylistPreview?>();

  void setCurrentPlaylistPreview(PlaylistPreview playlistPreview) {
    currentPlaylistPreview.value = playlistPreview;
  }
}
