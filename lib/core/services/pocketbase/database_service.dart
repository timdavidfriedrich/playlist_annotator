import 'package:get/state_manager.dart';
import 'package:playlist_annotator/core/models/playlist.dart';

class DatabaseService extends GetxController {

  RxList<Playlist> playlists = RxList<Playlist>([]);
}
