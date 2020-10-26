# Localization Automation Scripts

## How do I start?

All automation scripts are in the localizationAutomation folder. the scripts should be run from the project's root directory.

- To get started, run the following command:
  `sh localizationAutomation/localize_init.sh`
  This will set up the project's file structure, generate a supported_locales.dart and the necessary arb and generated files for the intl package. It will ask you to create a Localization file. This is where the string resources in the app will be defined. There are commented examples for each of the cases (gender, plural, multiple arguments).

## Necessary step! - Adding Delegates and Supported Locales to Root widget

Find your MaterialApp or CupertinoApp widget in your widget tree, add these as arguments

```dart
      localizationsDelegates: AppLocalizationDelegates.delegates,
      supportedLocales: SupportedLocales.locales,
```

## Neecessary step! - Adding supported languages

The localize_init.sh generated a 'static_locales.dart' class. This is where the supported languages are defined. The script sets up only English and Spanish to start. Add more languages to this file if you plan on supporting more languages.

## Necessary step for iOS only

You need to add localization selections to iOS project specifically. Open up the workspace, open the "Runner" project file and select the "Runner" Project. Add the supported localizations to the "Localization" section. (See iosLocalizationSetup.png in the /help directory for visual example). (No further action is needed in Android)

## Now what? Adding string resources to the project

Add them to the \${FILE_NAME}Localization file that was generated from initial setup or create_localization_file.sh.

### Necessary Step - import messages_all.dart to all localization classes

You will need to import messages_all.dart to your localization class.

```dart
import 'package:PACKAGE_NAME/localization/l10n/generated/messages_all.dart';
```

## I added my string resources, now what?

Once you add your string resources. Run the following command:
`sh localizationAutomation/update_localization_files.sh`

This will generate the arb files if they are not present, and update all the generated files for the intl package to work.

## I need to add my translations. Where do I do that? - Translations

The generated .arb files are what the scripts use to determine translations. They live in lib/localization/I10n/arb/ folder
There is a main .arb file: "intl_messages.arb", and an .arb file for each language specified in: lib/localization/static_locales.dart,

(example: 'intl_en.arb' for English or 'intl_es.arb'.arb' for Spanish)

To add a translation, each of the language specific .arb files needs to be updated (e.g: 'intl_en.arb', 'intl_es.arb' etc.). Example .arb string resource:

```json
  "homePageTitleExample": "Hello World!",
  "@homePageTitleExample": {
    "description": "Basic Example Description",
    "type": "text",
    "placeholders": {}
  },
```

In the example above, the text for the string resource is "Hello World!"

There is great software for managing .arb files. It can be found here.
<https://www.codeandweb.com/babeledit/>

This software gives you a clear UI of all the string resources and the ability to import/export excel documents to give to translators.

### Necessary Step! After you add translations

If you change an .arb file, the changed text will not appear in the app until you run
`sh localizationAutomation/update_localization_files.sh`

### Note

There is a bool in the steps_for_diff that allows the script to remove unused strings from the arb files. Change that to false if you want the script to go through all the strings individually

## How do I use the string resources in my project?

String resources live in the Localization files created from 'create_localization_file.sh'. To use:

```dart
NAME_OF_FILE.of(context).NAME_OF_RESOURCE;
```

Example:
HomePageLocalization.of(context).homePageTitleExample;

## Adding a new page/component that needs translating?

run the following command:
`sh localizationAutomation/create_localization_file.sh`

### NOTICE

each string needs a unique name no matter what file it is in or duplicates will be overwritten. Suggested Naming convention: page-component-\$name

## Useful code snippets

Go to Code - Preferences - User Snippets (choose dart when prompted)
put in these inside the dart.json:

```json
  "localization message": {
    "prefix": "message",
    "body": [
      "\tString get ${1} {",
      "\t\treturn Intl.message(",
      "\t\t\t'textForMessage',",
      "\t\t\tname: '${1}',",
      "\t\t\tdesc: '',",
      "\t\t\tlocale: localeName,",
      ");",
      "}"
    ],
    "description": "Generate boilerplate for a basic string"
  },
  "localization gender": {
    "prefix": "gender",
    "body": [
      "\tString ${1}(String gender) {",
      "\t\treturn Intl.gender(",
      "\t\t\tgender,",
      "\t\t\tmale: 'textForMale',",
      "\t\t\tfemale: 'textForFemale',",
      "\t\t\tother: 'textForOther',",
      "\t\t\tname: '${1}',",
      "\t\t\tdesc: '',",
      "\t\t\targs: [gender],",
      "\t\t\tlocale: localeName,",
      "\t\t);",
      "\t}"
    ],
    "description": "Generate boilerplate for a string with gender"
  },
  "localization plural": {
    "prefix": "plural",
    "body": [
      "\tString ${1}(num messageCount) {",
      "\t\treturn Intl.plural(",
      "\t\t\tmessageCount,",
      "\t\t\tzero: 'textForZero',",
      "\t\t\tone: 'textForOne',",
      "\t\t\tother: 'textForCount', //This is where you use string interpolation for variables",
      "\t\t\tname: '${1}',",
      "\t\t\tdesc: '',",
      "\t\t\targs: [messageCount],",
      "\t\t\tlocale: localeName,",
      "\t\t);",
      "\t}"
    ],
    "description": "Generate boilerplate for a string with pluralization"
  },
    "localization single argument": {
    "prefix": "single",
    "body": [
      "\tString ${1}(String arg1) {",
      "\t\treturn Intl.message(",
      "\t\t\t'textForString', // use string interpolation for variables",
      "\t\t\tname: '${1}',",
      "\t\t\tdesc: 'description of multiple arguments example',",
      "\t\t\targs: [arg1],",
      "\t\t\tlocale: localeName,",
      "\t\t);",
      "\t}"
    ],
    "description": "Generate boilerplate for a string with multiple arguments"
  },
  "localization multiple arguments": {
    "prefix": "multiple",
    "body": [
      "\tString ${1}(String arg1, String arg2) {",
      "\t\treturn Intl.message(",
      "\t\t\t'textForString', // use string interpolation for variables",
      "\t\t\tname: '${1}',",
      "\t\t\tdesc: 'description of multiple arguments example',",
      "\t\t\targs: [arg1, arg2],",
      "\t\t\tlocale: localeName,",
      "\t\t);",
      "\t}"
    ],
    "description": "Generate boilerplate for a string with multiple arguments"
  }
```

To use in dart code, just type 'message', 'gender', 'plural', or 'multiple and auto-complete will do the rest.
