#!/bin/bash

# script to deploy a release
# be sure to commit all changes
# e.g: ./deploy.sh 1.0.0

set -ex

# check if there are any dirty files
git diff --exit-code
echo $?
