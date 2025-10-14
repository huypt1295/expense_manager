#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Run flutter tests with coverage
echo "Running flutter tests with coverage..."
/Users/macbook1/Documents/sdk/3.35.4/flutter/bin/flutter test --coverage

# Check if lcov is installed
echo "Checking for lcov..."
if ! command -v genhtml &> /dev/null
then
    echo "lcov (genhtml) could not be found. Please install it with 'brew install lcov' or your system's package manager."
    exit 1
fi

# Generate HTML report from lcov.info
echo "Generating HTML coverage report..."
genhtml coverage/lcov.info --output-directory coverage/html

echo "Coverage HTML report generated at coverage/html/index.html" 