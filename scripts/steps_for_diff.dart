import 'dart:convert';
import 'dart:io';
import '../../lib/localization/static_locales.dart';
import 'user_confirmed.dart';

bool shouldRemoveUnusedKeys = true;

void main() {
  try {
    var arbDirectory = Directory('lib/localization/l10n/arb');

    _createARBFiles(arbDirectory);

    var baseInternationalMessages = _getBaseLocalizationJson(arbDirectory);

    var entities = arbDirectory.listSync(recursive: true);

    for (var entity in entities) {
      if (entity is File &&
          entity.path.contains('arb') &&
          !entity.path.contains('messages')) {
        var originalString = File(entity.path)?.readAsStringSync();
        var entityJson = _convertToJson(originalString);

        entityJson = _addStringResources(
          baseInternationalMessages,
          entityJson,
        );

        if (shouldRemoveUnusedKeys) {
          print(
              'Removing unused keys. (this is a global bool that can be changed in the steps_for_diff.dart');
          entityJson =
              _removeAllUnusedKeys(entityJson, baseInternationalMessages);
        } else {
          print('Will keep all unused keys');
          entityJson = _askToRemoveIndividualKey(
            entityJson,
            baseInternationalMessages,
            entity,
            arbDirectory,
          );
        }

        var jsonString = JsonEncoder.withIndent('  ').convert(entityJson);
        entity.writeAsStringSync(jsonString);
      }
    }
    ;
  } catch (error) {
    print(error);
  }
}

void _createARBFiles(Directory arbDirectory) {
  for (var locale in StaticLocales.localeList) {
    final fileName = 'intl_${locale.elementAt(0)}.arb';

    if (!File('${arbDirectory.path}/$fileName').existsSync()) {
      File('${arbDirectory.path}/$fileName').createSync();
    }
  }
  ;
}

Map<String, dynamic> _getBaseLocalizationJson(Directory arbDirectory) {
  final baseLocalizationFileAsString =
      File('${arbDirectory.path}/intl_messages.arb').readAsStringSync();

  return jsonDecode(baseLocalizationFileAsString);
}

Map<String, dynamic> _addStringResources(
    Map<String, dynamic> baseInternationalMessages,
    Map<String, dynamic> entityJson) {
  baseInternationalMessages.forEach((key, value) {
    if (!entityJson.containsKey(key)) {
      //append key and value
      entityJson[key] = value;
      // update datetime
      entityJson['@@last_modified'] = DateTime.now().toIso8601String();
    }
  });
  return entityJson;
}

Map<String, dynamic> _convertToJson(String originalString) {
  return originalString.isEmpty
      ? <String, dynamic>{}
      : jsonDecode(originalString);
}

Map<String, dynamic> _askToRemoveIndividualKey(
    Map<String, dynamic> entityJson,
    Map<String, dynamic> baseInternationalMessages,
    File entity,
    Directory arbDirectory) {
  // cannot remove concurrently in for loop, so a stored list is used to remove keys after for loop interations.
  var keysToRemove = <String>[];
  var keysToKeep = <String>[];
  entityJson.forEach((key, value) {
    if (!baseInternationalMessages.containsKey(key) &&
        !keysToRemove.contains(key) &&
        !keysToKeep.contains(key)) {
      print(
          "The key '$key' exists in ${entity.path},\nbut doesn't exist in ${arbDirectory.path}/intl_messages.arb.\nShould we remove '$key'?.\nY or N:");

      if (userConfirmed()) {
        keysToRemove.add(key);
        keysToRemove.add('@$key');
      } else {
        keysToKeep.add(key);
        keysToKeep.add('@$key');
      }
    }
  });

  entityJson.removeWhere((entityKey, value) =>
      keysToRemove.contains(entityKey) || keysToRemove.contains('@$entityKey'));

  return entityJson;
}

Map<String, dynamic> _removeAllUnusedKeys(
  Map<String, dynamic> entityJson,
  Map<String, dynamic> baseInternationalMessages,
) {
  var filteredMap = entityJson;

  filteredMap
      .removeWhere((key, value) => !baseInternationalMessages.containsKey(key));

  return filteredMap;
}
