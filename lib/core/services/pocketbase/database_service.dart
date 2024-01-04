import 'package:get/state_manager.dart';
import 'package:playlist_annotator/core/models/playlist.dart';

class DataService extends GetxService {
  Future<DataService> init() async {
    return this;
  }

  RxList<Playlist> playlists = RxList<Playlist>([]);
}
