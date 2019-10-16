#!/bin/sh

# Create zip package
distPath=${PROJECT_DIR}/dist
distFile=${distPath}/bgpage.zip
mkdir -p ${distPath}
rm -f ${distFile}
zip ${distFile} -j ${BUILT_PRODUCTS_DIR}/bgpage ${PROJECT_DIR}/agent/bgpage.plist
