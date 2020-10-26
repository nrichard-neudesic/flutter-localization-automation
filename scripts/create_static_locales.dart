import 'dart:io';

void createStaticLocales(String filePath) async {
  print(filePath);
  const fileName = 'static_locales';
  final path = '$filePath/$fileName.dart';

  var file = new File(path);

  print('Creating Static Locales.');
  file.writeAsStringSync("""class StaticLocales {
  static List<Set<String>> localeList = [
    // the first string is the language code, the second empty string is where a country code is defined if needed.
    // add more to support more languages.
    // Language code list:
    // https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
    {'en', ''},
    {'es', ''}
  ];
}
  """);
  print('finished creating supported_locales.dart.');
}
