import 'package:get/get_utils/get_utils.dart';
import 'package:pocketbase/pocketbase.dart';

class User {
  final String id;
  final String spotifyId;
  final String name;
  final String? email;
  final String? avatarUrl;

  User({
    required this.id,
    required this.spotifyId,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  User.fromPocketbaseRecord(RecordModel record)
      : id = record.id,
        spotifyId = record.data["username"],
        name = record.data["name"] ?? "unnamed_label".tr,
        email = record.data["email"],
        avatarUrl = record.data["avatarUrl"];
}
