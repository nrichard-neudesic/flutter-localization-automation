import 'dart:io';

createSupportedLocales(String filePath) async {
  String fileName = 'supported_locales';
  String path = '$filePath/$fileName.dart';

  var file = new File(path);

  print('creating supported locales file.');
  file.writeAsStringSync("""import 'dart:ui';
import './static_locales.dart';

class SupportedLocales {
  static Iterable<Locale> get locales {
    return StaticLocales.localeList
        .map((locale) => Locale(locale.elementAt(0), locale.elementAt(1)));
  }

  static List<String> get languageCodeList {
    return locales.map((locale) => locale.languageCode).toList();
  }
}
  """);
  print('finished creating supported_locales.dart!');
}
