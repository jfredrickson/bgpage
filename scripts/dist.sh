#!/bin/bash
# Build a distribution zip file.

# Increment build number
#versionNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${INFOPLIST_FILE})
#buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${INFOPLIST_FILE})
#buildNumber=$((${buildNumber} + 1))
#/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildNumber}" ${INFOPLIST_FILE}
#echo Packaging version ${versionNumber} build ${buildNumber}

# Create zip package
#distPath=${PROJECT_DIR}/dist
#distFile=${distPath}/bgpage-${versionNumber}.zip
#mkdir -p ${distPath}
#rm -f ${distFile}
#zip ${distFile} -j ${BUILT_PRODUCTS_DIR}/bgpage ${PROJECT_DIR}/agent/bgpage.plist

# Group distributable files together
distPath=${PROJECT_DIR}/dist
mkdir -p ${distPath}
rm -f ${distPath}/*
cp ${BUILT_PRODUCTS_DIR}/bgpage ${distPath}
cp ${PROJECT_DIR}/agent/bgpage.plist ${distPath}
