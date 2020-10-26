import 'dart:convert';
import 'dart:io';
import 'create_folders_and_initial_files.dart';

void main() {
  createLocalizationFile('$mainLocalizationFilePath/classes');
}

createLocalizationFile(String filePath) {
  stdout.writeln('Creating Localization File');
  stdout.writeln("""Class Name?
(example: SignInPage) The script will auto append Localization""");
  String classNamePrefix = stdin.readLineSync();
  String className = '${classNamePrefix}Localization';

  String exampleMessageName =
      '${classNamePrefix[0].toLowerCase()}${classNamePrefix.substring(1)}';

  stdout.writeln("""File Name?
(example: sign_in_page) The script will auto append _localization""");
  String fileName = stdin.readLineSync();
  RegExp justNumbers = new RegExp('[0-9]');
  while (justNumbers.hasMatch(fileName[0])) {
    print('cannot start with a number');
    fileName = stdin.readLineSync();
    break;
  }

  var file = new File('$filePath/${fileName}_localization.dart');
  var sink = file.openWrite();

  sink.write("""
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../supported_locales.dart';

class $className {
  $className(this.localeName);

  static Future<$className> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

// after the scripts run, you need to import the messages_all.dart
    return initializeMessages(localeName).then((_) {
      return $className(localeName);
    });
  }

  static $className of(BuildContext context) {
    return Localizations.of<$className>(context, $className);
  }

  final String localeName;

//***** This is where you create your strings.
// Make sure your strings are uniquely named

  String get ${exampleMessageName}TitleExample {
    return Intl.message(
      'Hello World!',
      name: '${exampleMessageName}TitleExample',
      desc: 'Basic Example',
      locale: localeName,
    );
  }

  // String genderExample(String gender) {
  //   return Intl.gender(
  //     gender,
  //     male: 'Hello, man!',
  //     female: 'Hello, woman!',
  //     other: 'Hello there!',
  //     name: 'genderExample',
  //     desc: '',
  //     args: [gender],
  //     locale: localeName,
  //   );
  // }

  // String pluralExample(num messageCount) {
  //   return Intl.plural(
  //     messageCount,
  //     zero: '0 messages',
  //     one: '1 message',
  //     other: '\$messageCount messages',
  //     name: 'pluralExample',
  //     desc: '',
  //     args: [messageCount],
  //     locale: localeName,
  //   );
  // }

  // String multipleArgumentsExample(String timeOfDay, String name) {
  //   return Intl.message(
  //     '\$timeOfDay, \$name! ',
  //     name: 'multipleArgumentsExample',
  //     desc: 'description of multiple arguments example',
  //     args: [timeOfDay, name],
  //     locale: localeName,
  //   );
  // }

 // *****
}

class ${className}Delegate
    extends LocalizationsDelegate<$className> {
  const ${className}Delegate();

  @override
  bool isSupported(Locale locale) =>
      SupportedLocales.languageCodeList.contains(locale.languageCode);

  @override
  Future<$className> load(Locale locale) =>
      $className.load(locale);

  @override
  bool shouldReload(${className}Delegate old) => false;
} 
  """);

  sink.close();
  _addToJsonFile('${className}Delegate', '${fileName}_localization');
}

_addToJsonFile(String delegateName, String fileName) {
  Directory arbDirectory = Directory('lib/localization/l10n/generated');
  String jsonFileName = 'appLocalizationDelegates.json';
  String jsonFilePath = '${arbDirectory.path}/$jsonFileName';

  print('checking to see if appLocalizationDelegates.json exists');
  if (!File("$jsonFilePath").existsSync()) {
    print('appLocalizationDelegates.json does not exist. Creating file.');
    File("$jsonFilePath").createSync();
    print('created appLocalizationDelegates.json');
  }

  try {
    print('getting original string at $jsonFilePath');
    String originalString = File(jsonFilePath)?.readAsStringSync();

    Map<String, dynamic> delegateJson = originalString.isEmpty
        ? Map<String, dynamic>()
        : jsonDecode(originalString);

    delegateJson['GlobalMaterialLocalizations.delegate'] =
        'GlobalMaterialLocalizations.delegate';

    delegateJson['GlobalWidgetsLocalizations.delegate'] =
        'GlobalWidgetsLocalizations.delegate';

    print('added GlobalMaterialLocalizations and GlobalWidgetsLocalizations');
    delegateJson[delegateName] = fileName;
    String jsonString = JsonEncoder.withIndent('  ').convert(delegateJson);
    print('converting delegate to json.');
    File jsonFile = arbDirectory.listSync(recursive: true).firstWhere((file) =>
        file is File && file.path.contains('appLocalizationDelegates'));

    print('found json file. $jsonFile. Writing as string');

    jsonFile.writeAsStringSync(jsonString);
    print('finished writing as string.');
  } catch (e) {
    print(e);
  }
}
