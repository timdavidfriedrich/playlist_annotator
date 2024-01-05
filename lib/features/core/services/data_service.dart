import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:playlist_annotator/features/core/models/playlist.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/services/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';

class DataService extends GetxService {
  Future<DataService> init() async {
    playlistPreviews.value = await Get.find<PocketbaseService>().getPlaylistPreviews();
    return this;
  }

  Future<void> addAndSavePlaylistPreview(PlaylistPreview playlistPreview) async {
    RecordModel recordModel = await Get.find<PocketbaseService>().addPlaylistPreview(playlistPreview);
    playlistPreviews.add(PlaylistPreview.fromPocketbaseRecord(recordModel));
  }

  RxList<PlaylistPreview> playlistPreviews = <PlaylistPreview>[].obs;
  RxList<Playlist> playlists = <Playlist>[].obs;

  void signOut() {
    playlistPreviews.clear();
    playlists.clear();
  }
}
