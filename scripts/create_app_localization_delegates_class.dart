import 'dart:convert';
import 'dart:io';

import 'create_folders_and_initial_files.dart';

void main() {
  print('starting create app localization delegates class');
  createAppLocalizationDelegates(mainLocalizationFilePath);
}

createAppLocalizationDelegates(String filePath) async {
  print('creating app localization delegates class');
  String fileName = "app_localization_delegates";
  String path = '$filePath/$fileName.dart';

  var file = new File(path);

  var listString = _getDelegateNames();
  var importsString = _getImportFilePaths();

  print('creating app_localization_delegates.dart');
  file.writeAsStringSync("""import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
$importsString

class AppLocalizationDelegates {
  static Iterable<LocalizationsDelegate<dynamic>> delegates = [
    // add your delegates here. If using Cupertino widgets, add appropriate delegates.
      $listString
  ];
}
  """);
  print('finished creating app_localization_delegates.dart!');
}

String _getDelegateNames() {
  Directory arbDirectory = Directory('lib/localization/l10n/generated');
  String jsonFileName = "appLocalizationDelegates.json";
  String jsonFilePath = '${arbDirectory.path}/$jsonFileName';

  String originalString = File(jsonFilePath)?.readAsStringSync();

  Map<String, dynamic> delegateJson = originalString.isEmpty
      ? Map<String, dynamic>()
      : jsonDecode(originalString);

  String listString = "";

  delegateJson.forEach((key, value) {
    print(key);
    String delegateName = key.contains('.delegate') ? key : '$key()';
    listString += "\n\t\t$delegateName,";
  });

  return listString;
}

String _getImportFilePaths() {
  Directory arbDirectory = Directory('lib/localization/l10n/generated');
  String jsonFileName = "appLocalizationDelegates.json";
  String jsonFilePath = '${arbDirectory.path}/$jsonFileName';

  String originalString = File(jsonFilePath)?.readAsStringSync();

  Map<String, dynamic> delegateJson = originalString.isEmpty
      ? Map<String, dynamic>()
      : jsonDecode(originalString);

  String listString = "";

  delegateJson.forEach((key, value) {
    if (!key.contains('.delegate')) {
      listString += "\nimport 'classes/$value.dart';";
    }
  });

  return listString;
}
