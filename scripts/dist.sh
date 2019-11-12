#!/bin/sh
#
# Build a distributable package
#

# Use the most recent git tag as a version
latestTag=$(git tag -l | tail -1)

# Set up for zip package
distPath=${PROJECT_DIR}/dist
distFile=${distPath}/bgpage-${latestTag}.zip
mkdir -p ${distPath}
rm -f ${distFile}

# Add executable
pushd ${BUILT_PRODUCTS_DIR}
  zip -r ${distFile} bgpage
popd

# Add examples
pushd ${PROJECT_DIR}
  zip -r ${distFile} examples
popd
