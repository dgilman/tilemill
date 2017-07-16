PRODUCT="build/Release/TileMill.app"
JOBS=`sysctl -n hw.ncpu`
VERSION=`node -e "console.log(require('../../package.json').version)"`

build:
	# clear out hidden files which might break codesigning
	find ../../node_modules/ -name "._*" -exec rm {} \;
	@xcodebuild -jobs $(JOBS) -project TileMill.xcodeproj

clean:
	@xcodebuild -jobs $(JOBS) -project TileMill.xcodeproj clean
	rm -rf ./build

package: build

run: package
	open ./build/Release/TileMill.app

zip: package
	cd build/Release/; ditto -c -k --sequesterRsrc --keepParent --zlibCompressionLevel 9 TileMill.app/ ../../TileMill.zip

.PHONY: build clean package run zip
