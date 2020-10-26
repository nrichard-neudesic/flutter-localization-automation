import 'dart:convert';
import 'dart:io';

import 'create_folders_and_initial_files.dart';

void main() {
  print('starting create app localization delegates class');
  createAppLocalizationDelegates(mainLocalizationFilePath);
}

void createAppLocalizationDelegates(String filePath) async {
  print('creating app localization delegates class');
  const fileName = 'app_localization_delegates';
  var path = '$filePath/$fileName.dart';

  var file = File(path);

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
  var arbDirectory = Directory('lib/localization/l10n/generated');
  const jsonFileName = 'appLocalizationDelegates.json';
  var jsonFilePath = '${arbDirectory.path}/$jsonFileName';

  var originalString = File(jsonFilePath)?.readAsStringSync();

  var delegateJson =
      originalString.isEmpty ? <String, dynamic>{} : jsonDecode(originalString);

  var listString = '';

  delegateJson.forEach((key, value) {
    print(key);
    var delegateName = key.contains('.delegate') ? key : '$key()';
    listString += '\n\t\t$delegateName,';
  });

  return listString;
}

String _getImportFilePaths() {
  var arbDirectory = Directory('lib/localization/l10n/generated');
  const jsonFileName = 'appLocalizationDelegates.json';
  var jsonFilePath = '${arbDirectory.path}/$jsonFileName';

  var originalString = File(jsonFilePath)?.readAsStringSync();

  var delegateJson =
      originalString.isEmpty ? <String, dynamic>{} : jsonDecode(originalString);

  var listString = '';

  delegateJson.forEach((key, value) {
    if (!key.contains('.delegate')) {
      listString += "\nimport 'classes/$value.dart';";
    }
  });

  return listString;
}
