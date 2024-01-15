import 'package:get/get.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/models/playlist_preview.dart';
import 'package:playlist_annotator/features/core/services/pocketbase_service.dart';

class LocalAnnotationController extends GetxController {
  RxList<Annotation> annotations = <Annotation>[].obs;

  Future<LocalAnnotationController> init(PlaylistPreview playlistPreview) async {
    annotations.value = await Get.find<PocketbaseService>().getLocalAnnotationsByPlaylistPreview(playlistPreview);
    return this;
  }

  Future<void> addAnnotation(Annotation annotation) async {
    annotations.add(annotation);
    await Get.find<PocketbaseService>().saveLocalAnnotation(annotation);
  }
}
