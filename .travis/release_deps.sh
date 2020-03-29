#!/bin/sh

echo 'Tag:' $TRAVIS_TAG

git config --global user.email "petru.flueras@gmail.com"
git config --global user.name "Petru Flueras"

cd $TRAVIS_BUILD_DIR/..
git clone --depth=50 --branch=master https://${GITHUB_TOKEN}@github.com/pflueras/ci-module2.git
cd ci-module2

# Update project version and org.examples dependencies
mvn versions:set -DnewVersion=$TRAVIS_TAG
mvn versions:use-dep-version -Dincludes=org.examples -DdepVersion=$TRAVIS_TAG -DforceVersion=true

git add pom.xml
git commit -m "Release version $TRAVIS_TAG"
git tag "$TRAVIS_TAG" -m "Release version $TRAVIS_TAG"

# New version
MAJOR=$(echo $TRAVIS_TAG | cut -f 1 -d '.')
MINOR=$(echo $TRAVIS_TAG | cut -f 2 -d '.')
PATCH=$(echo $TRAVIS_TAG | cut -f 3 -d '.')
NEW_VERSION=$MAJOR.$MINOR.$(($PATCH + 1))-SNAPSHOT
echo 'New version:' $NEW_VERSION

# Prepare for next development version
mvn versions:set -DnewVersion=$NEW_VERSION
mvn versions:use-dep-version -Dincludes=org.examples -DdepVersion=$NEW_VERSION -DforceVersion=true
git add pom.xml
git commit -m "Next development version $NEW_VERSION"

git push --follow-tags

# Clean up
cd $TRAVIS_BUILD_DIR
rm -rf ci-module2
