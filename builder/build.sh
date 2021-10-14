#!/bin/bash

mkdir builder
xcrun actool Assets.xcassets --compile builder --platform iphoneos --minimum-deployment-target 12.0
SDK_PATH=`xcrun --sdk iphonesimulator --show-sdk-path`
swiftc -whole-module-optimization -c -parse-as-library TheAppApp.swift ContentView.swift Data.swift -o builder/TheApp.o -sdk ${SDK_PATH} -target x86_64-apple-ios14.4-simulator
ld builder/TheApp.o -o builder/TheApp -syslibroot $SDK_PATH -arch x86_64 -L/usr/lib/swift -lSystem
mkdir builder/TheApp.app
cp builder/TheApp builder/TheApp.app/TheApp
cp Info.plist builder/TheApp.app/Info.plist
cp builder/Assets.car builder/TheApp.app/Assets.car
simulator_id="$(xcrun simctl list devices | grep -v unavailable | grep -m 1 -o '[0-9A-F\-]\{36\}')"
xcrun simctl boot "$simulator_id"
xcrun simctl install booted ./builder/TheApp.app/
xcrun simctl launch booted Marina.TheApp

