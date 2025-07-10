#!/bin/bash

# Install Flutter
echo "Installing Flutter..."
curl -o- https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.5-stable.tar.xz | tar -xJ
export PATH="$PATH:`pwd`/flutter/bin"

# Check Flutter installation
echo "Checking Flutter installation..."
flutter doctor

# Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Build web app
echo "Building Flutter web app..."
flutter build web

echo "Build completed successfully!" 