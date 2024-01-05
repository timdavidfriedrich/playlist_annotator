import 'package:get/get.dart';

class SelectedSongController extends GetxController {
  final RxList<String> selectedSongIds = <String>[].obs;

  bool get hasSelectedSong => selectedSongIds.isNotEmpty;
  bool get hasNoSelectedSong => selectedSongIds.isEmpty;

  void selectSongId(String songId) {
    selectedSongIds.add(songId);
  }

  void deselectSongId(String songId) {
    selectedSongIds.remove(songId);
  }

  void replaceSongIds(List<String> songIds) {
    selectedSongIds.value = songIds;
  }

  void deselectAllSongIds() {
    selectedSongIds.value = [];
  }
}
