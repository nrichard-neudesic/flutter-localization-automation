import 'dart:io';

void addIntlToPackages() async {
  try {
    var theFile = File('pubspec.yaml');

    var contents = theFile.readAsStringSync();
    stdout.writeln('Checking to see if intl package is in pubspec.yaml...');
    if (!contents.contains('intl:')) {
      stdout.writeln('No intl package found, adding as a dependency.');

      var dependenciesRegex = RegExp('dependencies:');
      var dependenciesIndices = dependenciesRegex.firstMatch(contents);

      if (dependenciesIndices != null) {
        var hasWhiteSpaceAfter = contents
                .substring(
                    dependenciesIndices.end + 1, dependenciesIndices.end + 2)
                .contains('\n') ||
            contents
                .substring(
                    dependenciesIndices.end + 1, dependenciesIndices.end + 2)
                .contains('\s');

        var packageName = 'intl: ^0.16.1';
        var intlInsert =
            hasWhiteSpaceAfter ? '\n  $packageName\n' : '  $packageName\n';

        contents = contents.substring(0, dependenciesIndices.end + 1) +
            intlInsert +
            contents.substring(dependenciesIndices.end);
      }

      theFile.writeAsStringSync(contents);
    } else {
      stdout.writeln(
          'intl package found as dependency. Continuing localization initialization.');
    }
  } catch (e) {
    stdout.writeln(e);
  }
}
