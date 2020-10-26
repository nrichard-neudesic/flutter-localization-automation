import 'dart:io';

addFlutterLocalizationPackages() async {
  try {
    var theFile = new File('pubspec.yaml');

    var contents = theFile.readAsStringSync();
    stdout.writeln("Checking to see if intl package is in pubspec.yaml...");
    if (!contents.contains("flutter_localizations:")) {
      stdout.writeln(
          "No flutter_localizations package found, adding as a dependency.");

      var dependenciesRegex = new RegExp('dependencies:');
      var dependenciesIndices = dependenciesRegex.firstMatch(contents);

      if (dependenciesIndices != null) {
        bool hasWhiteSpaceAfter = contents
                .substring(
                    dependenciesIndices.end + 1, dependenciesIndices.end + 2)
                .contains("\n") ||
            contents
                .substring(
                    dependenciesIndices.end + 1, dependenciesIndices.end + 2)
                .contains("\s");

        String textToInsert = "flutter_localizations:\n    sdk: flutter";
        String intlInsert =
            hasWhiteSpaceAfter ? "\n  $textToInsert\n" : "  $textToInsert\n";

        contents = contents.substring(0, dependenciesIndices.end + 1) +
            intlInsert +
            contents.substring(dependenciesIndices.end);
      }

      theFile.writeAsStringSync(contents);
    } else {
      stdout.writeln(
          "flutter_localizations package found as dependency. Continuing localization initialization.");
    }
  } catch (e) {
    stdout.writeln(e);
  }
}
