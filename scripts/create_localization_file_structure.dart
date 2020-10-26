import 'dart:io';

Future<void> createFileStructure(mainLocalizationFilePath) async {
  print('creating file structure.');
  print('creating classes folder');
  await Directory(mainLocalizationFilePath + '/classes')
      .create(recursive: true);
  print('creating l10n and arb sub folder');
  await Directory(mainLocalizationFilePath + '/l10n/arb')
      .create(recursive: true);
  print('creating generated folder');
  await Directory(mainLocalizationFilePath + '/l10n/generated')
      .create(recursive: true);
  print('finished creating file structure.');
}
