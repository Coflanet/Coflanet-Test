#!/bin/bash

# Base paths
BASE_URL="https://repo1.maven.org/maven2/org/jetbrains/kotlin"
DEST_DIR="/c/Users/Administrator/Desktop/kotlin_deps/repo"

# Create directory structure
mkdir -p "$DEST_DIR"

# Function to download with retry
download_file() {
    local artifact=$1
    local version=$2
    local filename=$3

    local url="$BASE_URL/$artifact/$version/$filename"
    local dir="$DEST_DIR/org/jetbrains/kotlin/$artifact/$version"
    local dest="$dir/$filename"

    mkdir -p "$dir"

    if [ -f "$dest" ]; then
        echo "Already exists: $filename"
        return 0
    fi

    echo "Downloading: $filename"
    curl --http1.1 --limit-rate 500K -L -o "$dest" "$url" 2>/dev/null

    if [ $? -eq 0 ] && [ -s "$dest" ]; then
        echo "Success: $filename"
    else
        echo "Failed: $filename"
        rm -f "$dest"
    fi
}

# List of required Kotlin dependencies for version 1.9.22
VERSION="1.9.22"

# Core dependencies
download_file "kotlin-gradle-plugin" "$VERSION" "kotlin-gradle-plugin-$VERSION.jar"
download_file "kotlin-gradle-plugin" "$VERSION" "kotlin-gradle-plugin-$VERSION.pom"
download_file "kotlin-gradle-plugin" "$VERSION" "kotlin-gradle-plugin-$VERSION-gradle82.jar"

download_file "kotlin-gradle-plugin-api" "$VERSION" "kotlin-gradle-plugin-api-$VERSION.jar"
download_file "kotlin-gradle-plugin-api" "$VERSION" "kotlin-gradle-plugin-api-$VERSION.pom"

download_file "kotlin-gradle-plugin-model" "$VERSION" "kotlin-gradle-plugin-model-$VERSION.jar"
download_file "kotlin-gradle-plugin-model" "$VERSION" "kotlin-gradle-plugin-model-$VERSION.pom"

download_file "kotlin-compiler-embeddable" "$VERSION" "kotlin-compiler-embeddable-$VERSION.jar"
download_file "kotlin-compiler-embeddable" "$VERSION" "kotlin-compiler-embeddable-$VERSION.pom"

download_file "kotlin-stdlib" "$VERSION" "kotlin-stdlib-$VERSION.jar"
download_file "kotlin-stdlib" "$VERSION" "kotlin-stdlib-$VERSION.pom"

download_file "kotlin-util-klib" "$VERSION" "kotlin-util-klib-$VERSION.jar"
download_file "kotlin-util-klib" "$VERSION" "kotlin-util-klib-$VERSION.pom"

download_file "kotlin-scripting-compiler-embeddable" "$VERSION" "kotlin-scripting-compiler-embeddable-$VERSION.jar"
download_file "kotlin-scripting-compiler-embeddable" "$VERSION" "kotlin-scripting-compiler-embeddable-$VERSION.pom"

download_file "kotlin-scripting-compiler-impl-embeddable" "$VERSION" "kotlin-scripting-compiler-impl-embeddable-$VERSION.jar"
download_file "kotlin-scripting-compiler-impl-embeddable" "$VERSION" "kotlin-scripting-compiler-impl-embeddable-$VERSION.pom"

download_file "kotlin-daemon-embeddable" "$VERSION" "kotlin-daemon-embeddable-$VERSION.jar"
download_file "kotlin-daemon-embeddable" "$VERSION" "kotlin-daemon-embeddable-$VERSION.pom"

download_file "kotlin-script-runtime" "$VERSION" "kotlin-script-runtime-$VERSION.jar"
download_file "kotlin-script-runtime" "$VERSION" "kotlin-script-runtime-$VERSION.pom"

download_file "kotlin-reflect" "$VERSION" "kotlin-reflect-$VERSION.jar"
download_file "kotlin-reflect" "$VERSION" "kotlin-reflect-$VERSION.pom"

download_file "kotlin-compiler-runner" "$VERSION" "kotlin-compiler-runner-$VERSION.jar"
download_file "kotlin-compiler-runner" "$VERSION" "kotlin-compiler-runner-$VERSION.pom"

download_file "kotlin-android-extensions" "$VERSION" "kotlin-android-extensions-$VERSION.jar"
download_file "kotlin-android-extensions" "$VERSION" "kotlin-android-extensions-$VERSION.pom"

download_file "kotlin-gradle-plugin-idea" "$VERSION" "kotlin-gradle-plugin-idea-$VERSION.jar"
download_file "kotlin-gradle-plugin-idea" "$VERSION" "kotlin-gradle-plugin-idea-$VERSION.pom"

download_file "kotlin-gradle-plugin-idea-proto" "$VERSION" "kotlin-gradle-plugin-idea-proto-$VERSION.jar"
download_file "kotlin-gradle-plugin-idea-proto" "$VERSION" "kotlin-gradle-plugin-idea-proto-$VERSION.pom"

download_file "kotlin-klib-commonizer-api" "$VERSION" "kotlin-klib-commonizer-api-$VERSION.jar"
download_file "kotlin-klib-commonizer-api" "$VERSION" "kotlin-klib-commonizer-api-$VERSION.pom"

download_file "kotlin-build-tools-api" "$VERSION" "kotlin-build-tools-api-$VERSION.jar"
download_file "kotlin-build-tools-api" "$VERSION" "kotlin-build-tools-api-$VERSION.pom"

download_file "kotlin-gradle-plugins-bom" "$VERSION" "kotlin-gradle-plugins-bom-$VERSION.pom"

echo "Download complete!"
