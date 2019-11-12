#!/bin/sh
# Build a distributable package

# Use the most recent git tag as a version
latestTag=$(git tag -l | tail -1)

# Create zip package
distPath=${PROJECT_DIR}/dist
distFile=${distPath}/bgpage-${latestTag}.zip
mkdir -p ${distPath}
rm -f ${distFile}
zip ${distFile} -j ${BUILT_PRODUCTS_DIR}/bgpage ${PROJECT_DIR}/agent/bgpage.plist
