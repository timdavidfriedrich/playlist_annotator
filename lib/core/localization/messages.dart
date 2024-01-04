import 'package:get/get.dart';
import 'package:playlist_annotator/core/localization/translations/de_de.dart';
import 'package:playlist_annotator/core/localization/translations/en_us.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      "de_DE": deDE,
      "en_US": enUS,
    };
  }
}
