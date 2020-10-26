#!/usr/bin/env bash
flutter pub get

# Create arb files
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/localization/l10n/arb lib/localization/classes/*.dart

# add new strings to arb files (and remove old ones)
BASEDIR=$(dirname "$0")
dart $BASEDIR/scripts/steps_for_diff.dart

# generate classes from arb files
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/localization/l10n/generated \
    --no-use-deferred-loading lib/localization/classes/* lib/localization/l10n/arb/intl_*.arb