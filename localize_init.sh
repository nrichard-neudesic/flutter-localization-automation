#!/usr/bin/env bash
BASEDIR=$(dirname "$0")

# Run Localization Initialization
dart "$BASEDIR"/scripts/localize_init.dart

# Get Flutter packages.
flutter pub get

# creates arb files
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/localization/l10n/arb lib/localization/classes/*.dart

# generate classes based on arb files
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/localization/l10n/generated \
    --no-use-deferred-loading lib/localization/classes/* lib/localization/l10n/arb/intl_*.arb

# Add new string resources
dart $BASEDIR/scripts/steps_for_diff.dart

#  Generate flutter files from arb files.
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/localization/l10n/generated \
    --no-use-deferred-loading lib/localization/classes/* lib/localization/l10n/arb/intl_*.arb