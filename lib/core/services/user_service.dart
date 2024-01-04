import 'package:get/state_manager.dart';
import 'package:playlist_annotator/core/models/user.dart';

class UserService extends GetxService {
  Future<UserService> init() async {
    return this;
  }

  Rxn<User?> current = Rxn<User?>();

  updateCurrentUser(User? user) {
    current.value = user;
  }
}
