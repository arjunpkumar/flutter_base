#!/bin/bash

# 1. Get the Windows Environment Variable
# In Git Bash, Windows env vars are usually available as $VARIABLE_NAME
SDK_SOURCE="$FIREBASE_CPP_SDK_DIR"

# 2. Fallback: If the bash shell hasn't picked it up yet, ask Windows directly
if [ -z "$SDK_SOURCE" ]; then
    SDK_SOURCE=$(cmd //c echo %FIREBASE_CPP_SDK_DIR%)
fi

# 3. Validation
if [ -z "$SDK_SOURCE" ] || [ "$SDK_SOURCE" == "%FIREBASE_CPP_SDK_DIR%" ]; then
    echo "ERROR: FIREBASE_CPP_SDK_DIR is not set in your Windows Environment Variables."
    echo "Please set it to firebase_cpp_sdk_windows folder first."
    echo "Press Any Key To Exit"
    read key
    exit 1
fi

# 4. Define Target Path
PROJ_ROOT=$(pwd)
TARGET_DIR="$PROJ_ROOT/build/windows/x64/extracted/firebase_cpp_sdk_windows"

echo "Detected SDK Source: $SDK_SOURCE"
echo "Target Project:     $PROJ_ROOT"
echo ""

# 5. Create the 'extracted' directory if missing
mkdir -p "$PROJ_ROOT/build/windows/x64/extracted"

# 6. Remove existing link/folder
if [ -d "$TARGET_DIR" ] || [ -L "$TARGET_DIR" ]; then
    echo "Cleaning existing SDK folder/link..."
    rm -rf "$TARGET_DIR"
fi

# 7. Create the Junction
echo "Linking SDK from Environment Variable..."
# We use cygpath to ensure the paths are formatted correctly for the 'mklink' command
cmd //c mklink //J "$(cygpath -w "$TARGET_DIR")" "$(cygpath -w "$SDK_SOURCE")"

if [ $? -eq 0 ]; then
    echo "-------------------------------------------------------"
    echo "SUCCESS: Magic link created using FIREBASE_CPP_SDK_DIR!"
    echo "-------------------------------------------------------"
else
    echo "ERROR: Failed to create link. Ensure you are running as ADMINISTRATOR."
fi

echo "Press Any Key To Exit"
read key