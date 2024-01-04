import 'package:get/get.dart';
import 'package:playlist_annotator/core/services/pocketbase_service.dart';
import 'package:playlist_annotator/core/models/user.dart';
import 'package:playlist_annotator/core/services/user_service.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService extends GetxService {
  Future<AuthService> init() async {
    return this;
  }

  Future<void> signIn() async {
    PocketbaseService pocketbaseService = Get.find();
    final authData = await pocketbaseService.signInWithSpotify();
    _updateCurrentUser(authData);
  }

  void _updateCurrentUser(RecordAuth? authData) {
    if (authData?.record == null) return;
    final UserService userService = Get.find();
    userService.updateCurrentUser(User.fromPocketbaseRecord(authData!.record!));
  }
}
