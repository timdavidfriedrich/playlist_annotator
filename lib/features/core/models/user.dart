import 'package:pocketbase/pocketbase.dart';

class User {
  final String id;
  final String username;
  final String name;
  final String email;
  final String avatarUrl;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  User.fromPocketbaseRecord(RecordModel record)
      : id = record.id,
        username = record.data["username"],
        name = record.data["name"],
        email = record.data["email"],
        avatarUrl = record.data["avatarUrl"];
}
