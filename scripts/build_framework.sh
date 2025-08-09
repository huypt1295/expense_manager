#!/bin/bash

# Script to build Flutter project for Android or iOS
# Usage: ./build.sh
# Prompts user to select platform (Android or iOS) and runs appropriate build command
# For iOS, runs ios_codesign.sh if build is successful

set -e # Exit on error

# Function to display usage
usage() {
    echo "Usage: $0"
    echo "Select platform to build: Android or iOS"
    exit 1
}

# Function to check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        echo "Error: Flutter is not installed or not in PATH"
        exit 1
    fi
}

# Function to build for Android
build_android() {
    echo "Building Android AAR..."
    flutter build aar --no-debug --no-profile || {
        echo "Error: Android build failed"
        exit 1
    }
    echo "Android AAR build completed successfully"
}

# Function to build for iOS and run code signing
build_ios() {
    echo "Building iOS framework..."
    flutter build ios-framework --no-debug --no-profile || {
        echo "Error: iOS build failed"
        exit 1
    }
    echo "iOS framework build completed successfully"

    # Check if ios_codesign.sh exists and is executable
    if [ -f "./ios_codesign.sh" ]; then
        if [ -x "./ios_codesign.sh" ]; then
            echo "Running ios_codesign.sh..."
            ./ios_codesign.sh || {
                echo "Error: ios_codesign.sh failed"
                exit 1
            }
            echo "iOS code signing completed successfully"
        else
            echo "Error: ios_codesign.sh is not executable"
            echo "Run: chmod +x ios_codesign.sh"
            exit 1
        fi
    else
        echo "Error: ios_codesign.sh not found in current directory"
        exit 1
    fi
}

# Main logic
echo "Select platform to build:"
echo "1) Android"
echo "2) iOS"
read -p "Enter choice (1 or 2): " choice

# Validate choice
case $choice in
    1)
        check_flutter
        build_android
        ;;
    2)
        check_flutter
        build_ios
        ;;
    *)
        usage
        ;;
esac