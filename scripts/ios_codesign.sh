#!/bin/bash

CODESIGN_IDENTITY="Apple Distribution: TienPhong Bank (APV8TP45H4)"

# Path to the output directory containing the built frameworks
OUTPUT_DIR="./build/ios/framework/Release"

# List of frameworks to sign
FRAMEWORKS=("url_launcher_ios.xcframework" "video_player_avfoundation.xcframework")

# Loop through each framework and sign it
for FRAMEWORK in "${FRAMEWORKS[@]}"; do
  FRAMEWORK_PATH="$OUTPUT_DIR/$FRAMEWORK"
  
  # Verify if the framework exists
  if [ -d "$FRAMEWORK_PATH" ]; then
    echo "Signing $FRAMEWORK_PATH with identity $CODESIGN_IDENTITY"

    # Sign the framework
    /usr/bin/codesign --force --sign "$CODESIGN_IDENTITY" "$FRAMEWORK_PATH"

    # Check if signing was successful
    if [ $? -eq 0 ]; then
      echo "$FRAMEWORK_PATH signed successfully."
    else
      echo "Error: Code signing failed for $FRAMEWORK_PATH"
    fi
  else
    echo "Error: $FRAMEWORK_PATH not found."
  fi
done
