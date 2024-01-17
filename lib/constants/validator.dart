class Validator {
  Validator._();

  static const int playlistCodeLength = 15;
  static RegExp playlistCodeRegExp = RegExp(r'^[a-z0-9]+$');

  static bool isPlaylistCodeValid(String code) {
    return code.length == playlistCodeLength && playlistCodeRegExp.hasMatch(code);
  }
}
