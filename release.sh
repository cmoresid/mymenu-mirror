#!/bin/bash

# script to deploy a release
# be sure to commit all changes
# e.g: ./deploy.sh 1.0.0

set -ex

if [ -n "$(git status --porcelain)" ]; then
  echo "There are changes. Commit them first.";
  exit 1
else
  echo "Proceeding with release.";
fi

# generate a changelog
github-changes -o UniversityOfAlberta -r MyMenu -a

# commit the changelog, and offically commit the release
git add -A
git commit -m 'Release '$1
git tag $1

# push upstream
git push -u origin master
git push --tags

# deploy the website
./deploy_website.sh
