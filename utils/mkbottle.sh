#!/bin/bash

## This script requires gh and jq. To obtain them:
## brew install gh ; brew install jq

gh repo set-default lou1306/homebrew-formal

FORMULA=$1
VERSION=$(brew info --json lou1306/formal/$FORMULA | jq -r '.[] | .versions.stable')

brew rm lou1306/formal/$FORMULA >/dev/null 2>&1
brew install --build-bottle lou1306/formal/$FORMULA

## Create bottle files
brew bottle --json --root-url https://github.com/lou1306/homebrew-formal/releases/download/$FORMULA-$VERSION lou1306/formal/$FORMULA


## Fix bottle.tar.gz filename
BOTTLE=$(ls $FORMULA*bottle*.tar.gz | head -n1) 
NEWNAME=$(ls $FORMULA*bottle*.tar.gz | sed 's/--/-/')
mv $BOTTLE $NEWNAME


## Create/update GitHub release
if gh release list | awk '{ print $0 }' | grep $FORMULA-$VERSION; then
  echo "release exists"
  gh release upload  "$FORMULA-$VERSION" $NEWNAME --clobber
else
  gh release create --generate-notes "$FORMULA-$VERSION" "$NEWNAME"
fi

brew bottle --write $FORMULA*$VERSION*.bottle.json
echo "All set!"
echo "Make sure that brew can resolve"
echo "the bottle file before submitting the PR :)"

