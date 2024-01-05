import 'package:get/get.dart';
import 'package:playlist_annotator/features/core/models/annotation.dart';
import 'package:playlist_annotator/features/core/services/pocketbase_service.dart';

class LocalAnnotationController extends GetxController {
  RxList<Annotation> annotations = <Annotation>[].obs;

  Future<LocalAnnotationController> init(String playlistId) async {
    annotations.value = await Get.find<PocketbaseService>().getLocalAnnotationsForPlaylistId(playlistId);
    return this;
  }

  Future<void> addAnnotation(Annotation annotation) async {
    annotations.add(annotation);
    await Get.find<PocketbaseService>().saveLocalAnnotation(annotation);
  }
}
