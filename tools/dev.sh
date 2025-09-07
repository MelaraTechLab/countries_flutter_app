#!/usr/bin/env bash
set -e
flutter pub get
dart format .
dart analyze
echo "Ready!"
