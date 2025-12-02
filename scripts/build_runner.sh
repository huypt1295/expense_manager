#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
flutter packages pub run build_runner build  --delete-conflicting-outputs

# flutter pub run intl_utils:generate
# dart run build_runner