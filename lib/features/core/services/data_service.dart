import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:log/log.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/resources/data_state.dart';
import 'package:playlist_annotator/features/core/resources/exceptions/playlist_exception.dart';
import 'package:playlist_annotator/features/core/services/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';

class DataService extends GetxService {
  Future<DataService> init() async {
    playlistPreviews.value = await Get.find<PocketbaseService>().getPlaylistPreviews();
    return this;
  }

  RxList<PlaylistPreview> playlistPreviews = <PlaylistPreview>[].obs;

  Future<void> addAndSavePlaylistPreview(PlaylistPreview playlistPreview) async {
    RecordModel recordModel = await Get.find<PocketbaseService>().addPlaylistPreview(playlistPreview);
    playlistPreviews.add(PlaylistPreview.fromPocketbaseRecord(recordModel));
  }

  Future<DataState<RecordModel?>> addPlaylistPreviewByCode(String code) async {
    try {
      DataState<RecordModel?> dataState = await Get.find<PocketbaseService>().addUserToPlaylistPreview(code);

      if (dataState is DataStateSuccess<RecordModel?>) {
        final RecordModel? recordModel = dataState.data;
        if (recordModel is RecordModel) {
          playlistPreviews.add(PlaylistPreview.fromPocketbaseRecord(recordModel));
        }
      }

      return dataState;
    } catch (e) {
      Log.error(e);
      return DataStateError(JoinPlaylistException(JoinPlaylistExceptionType.unknown));
    }
  }

  Future<void> removePlaylistPreviewById(String id) async {
    playlistPreviews.removeWhere((playlistPreview) => playlistPreview.id == id);
  }

  void signOut() {
    playlistPreviews.clear();
  }
}
