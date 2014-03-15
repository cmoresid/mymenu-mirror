#!/bin/bash

set -ex

# Only works for one device
adb uninstall ca.mymenuapp.debug
adb uninstall ca.mymenuapp.debug.test

adb shell input keyevent 82
./gradlew spoon

start mymenu-app/build/spoon/debugTest/index.html