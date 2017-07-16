#!/usr/bin/env sh

set -e

PROJECT="tilemill"

CWD=`pwd`
VERSION=`grep -m1 "$PROJECT ([a-z0-9~.-]*)" debian/changelog | sed "s/$PROJECT (\([a-z0-9~.-]*\)).*/\1/g"`
DIST=`grep -m1 "$PROJECT ([a-z0-9~.-]*)" debian/changelog | sed "s/$PROJECT ([a-z0-9~.-]*) \([a-z]*\);.*/\1/g"`
TAG=`echo $VERSION | sed "s/\([0-9.]*\).*/\1/g"`

if [ -z "$VERSION" ]; then
  echo "Version could not be determined from debian/changelog."
  exit
fi

if [ ! -f "$CWD/../../package.json" ]; then
  echo "package.sh must be run from the platforms/ubuntu directory."
  exit
fi

if [ ! -f "$CWD/orig/$PROJECT-$TAG.tar.gz" ]; then
  mkdir "$CWD/orig"
  cd "$CWD"
  tar cfz "$CWD/orig/$PROJECT-$TAG.tar.gz" "../../" \
  --exclude=.git* \
  --exclude=*.mbtiles \
  --exclude=*.node \
  --exclude=build \
  --exclude=libzip-0.9.3 \
  --exclude=platforms \
  --exclude=node_modules/jshint \
  --exclude=node_modules/expresso \
  --exclude=assets/pages \
  --exclude=test \
  --exclude=sqlite-autoconf \
  --transform "s,^,$PROJECT-$TAG/,"
fi

if [ -d "$DIST" ]; then
  echo "Build dir $DIST already exists. Please remove it first."
  exit
fi

mkdir "$CWD/$DIST"
cd "$CWD/$DIST"
tar zxf "$CWD/orig/$PROJECT-$TAG.tar.gz"
cp "$CWD/orig/$PROJECT-$TAG.tar.gz" "$CWD/$DIST/$PROJECT-$TAG.tar.gz"
cp "$CWD/orig/$PROJECT-$TAG.tar.gz" "$CWD/$DIST/${PROJECT}_${TAG}.orig.tar.gz"
cp -r "$CWD/debian" "$CWD/$DIST/$PROJECT-$TAG"
cd "$CWD/$DIST/$PROJECT-$TAG/debian"

debuild -inode_modules\|.git\|.png\|.ttf -i -us -uc -b
