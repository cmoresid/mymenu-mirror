#!/bin/bash
#
# Simple script to test Java-based execution of Spoon. You must have assembled
# the jar prior to running this script (i.e., ./gradlew clean build).

set -e

APK=`\ls mymenu-app/build/apk/*debug-unaligned*.apk`
TEST_APK=`\ls mymenu-app/build/apk/*test-unaligned*.apk`

java -jar spoon-*-jar-with-dependencies.jar --apk "$APK" --test-apk "$TEST_APK" --output target

open target/index.html
