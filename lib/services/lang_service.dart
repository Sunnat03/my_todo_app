import 'package:my_todo_app/services/locals/ru_RU.dart';

import 'data_service.dart';
import 'locals/en_US.dart';
import 'locals/uz_UZ.dart';

enum Language { en, ru, uz }

class LangService {
  // field
  static Language _language = Language.uz;
  static final DataService _dataService = DataService();

  static Future<Language> currentLanguage() async {
    // await _dataService.init();
    // var result = await _dataService.readData(key: "language");
    // if (result != null) {
    //   _language = _stringToLanguage(result);
    // }
    return _language;
  }

  // setter
  static set language(Language language) {
    // _language = language;
    // _dataService.storeData(key: "language", value: _language.name);
  }

  // getter
  static Language get language => _language;

  static Language _stringToLanguage(String lang) {
    switch (lang) {
      case "en":
        return Language.en;
      case "uz":
        return Language.uz;
      case "ru":
        return Language.ru;
      default:
        return Language.uz;
    }
  }
}

extension LocalString on String {
  String get tr {
    switch (LangService.language) {
      case Language.en:
        return enUS[this] ?? this;
      case Language.ru:
        return ruRu[this] ?? this;
      case Language.uz:
        return uzUZ[this] ?? this;
    }
  }
}