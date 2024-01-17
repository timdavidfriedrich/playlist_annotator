import 'package:get/get.dart';
import 'package:log/log.dart';
import 'package:playlist_annotator/features/core/resources/exceptions/app_exception.dart';

abstract class PlaylistException extends AppException {
  PlaylistException([super.message]) {
    Log.error(toString());
  }
}

class JoinPlaylistException extends PlaylistException {
  final JoinPlaylistExceptionType type;

  JoinPlaylistException(this.type, [String? message]) : super(_getExceptionMessage(type, message));

  static String? _getExceptionMessage(JoinPlaylistExceptionType type, String? message) {
    switch (type) {
      case JoinPlaylistExceptionType.notFound:
        return "playlist_not_found_error".tr;
      case JoinPlaylistExceptionType.alreadyJoined:
        return "playlist_already_joined_error".tr;
      case JoinPlaylistExceptionType.unknown:
        return "unknown_error".tr;
      default:
        return message;
    }
  }
}

enum JoinPlaylistExceptionType {
  notFound,
  alreadyJoined,
  unknown,
}

class AddPlaylistException extends PlaylistException {
  final AddPlaylistExceptionType type;

  AddPlaylistException(this.type, [String? message]) : super(_getErrorMessage(type, message));

  static String? _getErrorMessage(AddPlaylistExceptionType type, String? message) {
    switch (type) {
      case AddPlaylistExceptionType.notFound:
        return "spotify_playlist_not_found_error".tr;
      case AddPlaylistExceptionType.alreadyAdded:
        return "playlist_already_added_error".tr;
      case AddPlaylistExceptionType.unknown:
        return "unknown_error".tr;
      default:
        return message;
    }
  }
}

enum AddPlaylistExceptionType {
  notFound,
  alreadyAdded,
  unknown,
}
