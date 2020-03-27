#!/bin/sh

echo 'Tag:' $TRAVIS_TAG
echo 'Branch:' $TRAVIS_BRANCH

git config --global user.email "petru.flueras@gmail.com"
git config --global user.name "Petru Flueras"

cd $TRAVIS_BUILD_DIR/..
git clone --depth=50 --branch=master https://${GITHUB_TOKEN}@github.com/pflueras/ci-module2.git
cd ci-module2

# Update project version
mvn versions:set -DnewVersion=$TRAVIS_TAG

# Update version for all org.examples dependencies
mvn versions:use-dep-version -Dincludes=org.examples -DdepVersion=$TRAVIS_TAG -DforceVersion=true

git add pom.xml
git commit -m "Version update: $TRAVIS_TAG"
git tag "$TRAVIS_TAG"
git push --tags

# Clean up
cd $TRAVIS_BUILD_DIR
rm -rf ci-module2
