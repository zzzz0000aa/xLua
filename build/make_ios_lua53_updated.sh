#!/bin/bash

# Updated iOS lua53 build script for xLua
# This script should be run on macOS with Xcode installed

set -e

echo "Building iOS lua53 library for xLua..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: This script must be run on macOS with Xcode installed."
    echo "Current OS: $OSTYPE"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: Xcode is not installed or xcodebuild is not in PATH."
    echo "Please install Xcode from the App Store."
    exit 1
fi

# Get Xcode version
XCODE_VERSION=$(xcodebuild -version | head -n 1)
echo "Using $XCODE_VERSION"

# Change to build directory
cd "$(dirname "$0")"

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf build_ios_lua53

# Create build directory
mkdir -p build_ios_lua53
cd build_ios_lua53

echo "Configuring iOS build..."
# Configure for iOS (arm64 + armv7)
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake \
      -DPLATFORM=OS \
      -DDEPLOYMENT_TARGET=9.0 \
      -DENABLE_BITCODE=ON \
      -DENABLE_ARC=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -GXcode \
      ../

echo "Building iOS library..."
# Build the project
cmake --build . --config Release

# Go back to build directory
cd ..

# Create output directory
mkdir -p plugin_lua53/Plugins/iOS/

# Copy the built library
if [ -f "build_ios_lua53/Release-iphoneos/libxlua.a" ]; then
    cp build_ios_lua53/Release-iphoneos/libxlua.a plugin_lua53/Plugins/iOS/libxlua.a
    echo "✅ iOS library built successfully!"
    echo "Output: plugin_lua53/Plugins/iOS/libxlua.a"
    
    # Show library info
    echo ""
    echo "Library information:"
    file plugin_lua53/Plugins/iOS/libxlua.a
    echo ""
    lipo -info plugin_lua53/Plugins/iOS/libxlua.a
    echo ""
    ls -lh plugin_lua53/Plugins/iOS/libxlua.a
else
    echo "❌ Build failed: libxlua.a not found"
    exit 1
fi

echo ""
echo "🎉 iOS lua53 library compilation completed!"
echo "The library is ready for use in Unity iOS projects."
