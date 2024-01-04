import 'package:get/get.dart';
import 'package:playlist_annotator/core/services/pocketbase/pocketbase.dart';
import 'package:playlist_annotator/core/models/user.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService extends GetxService {
  Future<AuthService> init() async {
    return this;
  }

  Future<void> signIn() async {
    PocketbaseService pocketbase = Get.find();
    final authData = await pocketbase.signInWithSpotify();
    _updateCurrentUser(authData);
  }

  void _updateCurrentUser(RecordAuth? authData) {
    if (authData?.record == null) return;
    final UserService user = Get.find();
    user.updateCurrentUser(User.fromPocketbaseRecord(authData!.record!));
  }
}
