import 'dart:convert';
import 'dart:io';
import '../../lib/localization/static_locales.dart';
import 'user_confirmed.dart';

bool shouldRemoveUnusedKeys = true;

void main() {
  try {
    Directory arbDirectory = Directory('lib/localization/l10n/arb');

    _createARBFiles(arbDirectory);

    Map<String, dynamic> baseInternationalMessages =
        _getBaseLocalizationJson(arbDirectory);

    var entities = arbDirectory.listSync(recursive: true);

    entities.forEach((entity) {
      if (entity is File &&
          entity.path.contains('arb') &&
          !entity.path.contains('messages')) {
        String originalString = File(entity.path)?.readAsStringSync();
        Map<String, dynamic> entityJson = _convertToJson(originalString);

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

        String jsonString = JsonEncoder.withIndent('  ').convert(entityJson);
        entity.writeAsStringSync(jsonString);
      }
    });
  } catch (error) {
    print(error);
  }
}

void _createARBFiles(Directory arbDirectory) {
  StaticLocales.localeList.forEach((locale) {
    String fileName = "intl_${locale.elementAt(0)}.arb";

    if (!File("${arbDirectory.path}/$fileName").existsSync()) {
      File("${arbDirectory.path}/$fileName").createSync();
    }
  });
}

Map<String, dynamic> _getBaseLocalizationJson(Directory arbDirectory) {
  String baseLocalizationFileAsString =
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
      ? Map<String, dynamic>()
      : jsonDecode(originalString);
}

Map<String, dynamic> _askToRemoveIndividualKey(
    Map<String, dynamic> entityJson,
    Map<String, dynamic> baseInternationalMessages,
    File entity,
    Directory arbDirectory) {
  // cannot remove concurrently in for loop, so a stored list is used to remove keys after for loop interations.
  List<String> keysToRemove = [];
  List<String> keysToKeep = [];
  entityJson.forEach((key, value) {
    if (!baseInternationalMessages.containsKey(key) &&
        !keysToRemove.contains(key) &&
        !keysToKeep.contains(key)) {
      print("""The key '$key' exists in ${entity.path}, 
but doesn't exist in ${arbDirectory.path}/intl_messages.arb. 
Should we remove '$key'?. 
Y or N:""");

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
  Map<String, dynamic> filteredMap = entityJson;

  filteredMap
      .removeWhere((key, value) => !baseInternationalMessages.containsKey(key));

  return filteredMap;
}
