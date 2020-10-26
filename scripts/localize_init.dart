import 'add_flutter_localization_package.dart';
import 'add_intl_to_packages.dart';
import 'add_intl_translation_to_packages.dart';
import 'create_app_localization_delegates_class.dart';
import 'create_localization_file.dart';
import 'create_localization_file_structure.dart';
import 'create_static_locales.dart';
import 'create_supported_locales.dart';

void main() async {
  String mainLocalizationFilePath = './lib/localization';

  print('Starting localization initilization process');
  await createFileStructure(mainLocalizationFilePath);
  //TODO: specifiy what languages the app should support.
  await createStaticLocales(mainLocalizationFilePath);
  await createSupportedLocales(mainLocalizationFilePath);

  await addFlutterLocalizationPackages();
  await addIntlTranslationToPackages();
  await addIntlToPackages();

  await createLocalizationFile('$mainLocalizationFilePath/classes');
  await createAppLocalizationDelegates(mainLocalizationFilePath);
}
