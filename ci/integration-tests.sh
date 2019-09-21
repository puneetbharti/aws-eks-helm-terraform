#!/bin/bash
# This is just a dummy testing script to mock test environment 
#set -euxo pipefail
BUILD_NUMBER={1}
BUILD_NUMBER=${1?:"Missing parameter Build number"}

if [ `echo "${BUILD_NUMBER} % 2" | bc` -eq 0 ]
then 
  echo "even"
else 
  echo "odd"
  
fi
exit 0