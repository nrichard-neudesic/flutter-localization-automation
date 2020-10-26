import 'dart:io';

void addDelegatesToApp() {
  //TODO finish
  try {
    var theFile = File('./lib/main.dart');

    var contents = theFile.readAsStringSync();
    // find last index of MaterialApp( or CupertinoApp(
    stdout.writeln('Searching for Material or CupertinoApp');
    var appRegex = RegExp(r"MaterialApp\(|CupertinoApp\(");
    var appWidgetDeclaration = appRegex.firstMatch(contents);

    var endOfAppWidget = RegExp(r"\);");

    var allPossibleEnds =
        endOfAppWidget.allMatches(contents.substring(appWidgetDeclaration.end));

    print(allPossibleEnds);

    // var noodle = allPossibleEnds.firstWhere((possibleEnding) {
    //   String range =
    //       contents.substring(appWidgetDeclaration.end, possibleEnding.start);

    //   return RegExp(r"{")?.allMatches(range)?.length ==
    //       RegExp(r"}")?.allMatches(range)?.length;
    // }, orElse: () => null);

    // print('HERE!!!@#!@!@');
    // print(contents.substring(noodle.start, noodle.end));

    print('content length!!!!!!! ${contents.length}');

    allPossibleEnds.forEach((possibleEnding) {
      print('possible ending start:   ${possibleEnding.start}');
      print('possible ending end:   ${possibleEnding.end}');

      var range = contents.substring(
          appWidgetDeclaration.end,
          (possibleEnding.start + appWidgetDeclaration.end) >= contents.length
              ? contents.length
              : possibleEnding.start + appWidgetDeclaration.end);
      print('RANGE!!!!   $range');

      var allStart = RegExp(r"{").allMatches(range);
      var allEnd = RegExp(r"}").allMatches(range);

      print('all start length ${allStart.length}');
      print('all end length ${allEnd.length}');

      // if (allStart.length == allEnd.length) {
      //   winningMatch = possibleEnding;
      // }
    });

    // if (winningMatch != null) {
    //   print('found winning match');

    //   print(contents.substring(appWidgetDeclaration.end,
    //       winningMatch.start + appWidgetDeclaration.start));
    // }

    // check if localizationDelegates is in app build function

    // find end of Material/Cupertino App Widget
// the end is where it finds );
    // firstWhere

    // if it ain't
    // insert new line at App( end index
    // insert localizationsDelegates: AppLocalizationDelegates.delegates,
    // then insert import 'localization/app_localization_delegates.dart'; \n at index 0

    // check if supportedLocales is there
    // if it ain't
    // insert new line at App( end inded)
    // then insert supportedLocales: SupportedLocales.locales,
    // then insert import 'localization/supported_locales.dart'; \n at index 0

    // if (materialAppRegexMatch != null) {
    //   bool hasWhiteSpaceAfter = contents
    //           .substring(materialAppRegexMatch.end + 1,
    //               materialAppRegexMatch.end + 2)
    //           .contains("\n") ||
    //       contents
    //           .substring(materialAppRegexMatch.end + 1,
    //               materialAppRegexMatch.end + 2)
    //           .contains("\s");

    //   String packageName = "intl: ^0.16.1";
    //   String intlInsert =
    //       hasWhiteSpaceAfter ? "\n  $packageName\n" : "  $packageName\n";

    //   contents = contents.substring(0, materialAppRegexMatch.end + 1) +
    //       intlInsert +
    //       contents.substring(materialAppRegexMatch.end);
    // }

    theFile.writeAsStringSync(contents);
  } catch (e) {
    stdout.writeln(e);
  }
}
