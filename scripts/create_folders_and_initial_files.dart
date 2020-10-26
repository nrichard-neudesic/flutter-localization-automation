import 'create_app_localization_delegates_class.dart';
import 'create_localization_file.dart';
import 'create_localization_file_structure.dart';
import 'create_static_locales.dart';
import 'create_supported_locales.dart';

String mainLocalizationFilePath = './lib/localization';
void main() async {
  await createStaticLocales(mainLocalizationFilePath);
  await createFileStructure(mainLocalizationFilePath);
  print('finished creating file structure!');
  await createSupportedLocales(mainLocalizationFilePath);
  await createLocalizationFile('$mainLocalizationFilePath/classes');
  await createAppLocalizationDelegates(mainLocalizationFilePath);
}
