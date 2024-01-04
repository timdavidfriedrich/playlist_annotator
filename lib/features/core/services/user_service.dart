import 'package:get/state_manager.dart';
import 'package:playlist_annotator/features/core/models/user.dart';

class UserService extends GetxService {
  Future<UserService> init() async {
    return this;
  }

  Rxn<User?> currentUser = Rxn<User?>();

  updateCurrentUser(User? user) {
    currentUser.value = user;
  }
}
