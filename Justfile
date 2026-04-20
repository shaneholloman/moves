set dotenv-load := true

default := "build"

build:
	xcodebuild -scheme Moves -configuration Debug build

archive:
	bash -lc 'set -euo pipefail; rm -rf build/Moves.xcarchive; xcodebuild -scheme Moves -configuration Release archive -destination "generic/platform=macOS" -archivePath build/Moves.xcarchive ARCHS="arm64 x86_64" ONLY_ACTIVE_ARCH=NO'

release VERSION="":
	bash -lc 'set -euo pipefail; scripts/release-package.sh "{{VERSION}}"'

distribute VERSION="":
	bash -lc 'set -euo pipefail; scripts/distribute-release.sh "{{VERSION}}"'
