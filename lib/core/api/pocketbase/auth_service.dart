import 'package:get/get.dart';
import 'package:playlist_annotator/core/api/pocketbase/pocketbase.dart';
import 'package:playlist_annotator/core/models/user.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService extends GetxController {
  Future<void> signIn() async {
    Pocketbase pocketbase = Get.put(Pocketbase());
    final authData = await pocketbase.signInWithSpotify();
    _updateCurrentUser(authData);
  }

  void _updateCurrentUser(RecordAuth? authData) {
    if (authData?.record == null) return;
    final UserController user = Get.put(UserController());
    user.updateCurrentUser(User.fromPocketbaseRecord(authData!.record!));
  }
}
