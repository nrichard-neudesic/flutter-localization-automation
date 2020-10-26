#!/usr/bin/env bash
BASEDIR=$(dirname "$0")

dart $BASEDIR/scripts/create_localization_file.dart
dart $BASEDIR/scripts/create_app_localization_delegates_class.dart
