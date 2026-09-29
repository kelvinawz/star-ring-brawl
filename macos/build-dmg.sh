#!/bin/zsh
set -euo pipefail

script_dir="${0:A:h}"
project_dir="${script_dir:h}"
dist_dir="${project_dir}/dist"
dmg_path="${dist_dir}/星环乱斗-macOS-arm64-0.2.0.dmg"
stage_dir="$(mktemp -d)"
app_path="${stage_dir}/星环乱斗.app"
trap 'rm -rf "$stage_dir"' EXIT

mkdir -p "${dist_dir}"
mkdir -p "${app_path}/Contents/MacOS" "${app_path}/Contents/Resources"
cp -X "${script_dir}/Info.plist" "${app_path}/Contents/Info.plist"
cp -X "${project_dir}/index.html" "${app_path}/Contents/Resources/index.html"
/usr/bin/clang -O2 -fobjc-arc -target arm64-apple-macos13.0 \
    -framework Cocoa -framework WebKit \
    "${script_dir}/StarBrawlApp.m" \
    -o "${app_path}/Contents/MacOS/StarBrawl"
/usr/bin/codesign --force --sign - --timestamp=none "${app_path}"
ln -s /Applications "${stage_dir}/Applications"
/usr/bin/hdiutil create -volname "星环乱斗" -srcfolder "${stage_dir}" \
    -ov -format UDZO "${dmg_path}"
/usr/bin/hdiutil verify "${dmg_path}"
print "Built: ${dmg_path}"
