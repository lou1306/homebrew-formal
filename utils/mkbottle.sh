#!/bin/bash

## This script requires gh and jq. To obtain them:
## brew install gh ; brew install jq

gh repo set-default lou1306/homebrew-formal

FORMULA=$1
ARCH=$(arch)
VERSION=$(brew info --json lou1306/formal/$FORMULA | jq -r '.[] | .versions.stable')

brew rm lou1306/formal/$FORMULA >/dev/null 2>&1
brew install --build-bottle --bottle-arch=$ARCH lou1306/formal/$FORMULA

## Create bottle files
brew bottle --json --root-url https://github.com/lou1306/homebrew-formal/releases/download/$FORMULA-$VERSION lou1306/formal/$FORMULA

## Fix bottle.tar.gz filename
BOTTLE=$(ls $FORMULA*bottle*.tar.gz | head -n1) 
NEWNAME=$(ls $FORMULA*bottle*.tar.gz | sed 's/--/-/')
# mv $BOTTLE $NEWNAME

## Create GitHub release
## Todo: if release exists use gh release upload instead
#gh release create --generate-notes "$FORMULA-$VERSION" "$NEWNAME"

brew bottle --write --merge $FORMULA*$VERSION*.bottle.json
