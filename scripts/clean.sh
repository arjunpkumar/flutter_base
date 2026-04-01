#!/bin/bash

read -p "Enter platform: 1.Android 2.iOS 3.Android & iOS: " platform

flutter clean
flutter pub get

if [ "$platform" == "1" ] || [ "$platform" == "3" ]; then
   cd android
   ./gradlew clean
   cd ..
fi

if [ "$platform" == "2" ] || [ "$platform" == "3" ]; then
   cd ios
   rm -rf Pods
   rm Podfile.lock
   pod install
   cd ..
fi
