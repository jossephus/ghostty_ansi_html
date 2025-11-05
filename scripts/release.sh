#!/bin/bash

tag=$1

if [ -z "$tag" ]; then
  echo "Tag should be specified to make a release"
  exit 1
fi

cd packages/core/lib
zig build -Doptimize=ReleaseSmall
tree zig-out/
cd ../../../

platform_directories=(
  "./packages/core/lib/zig-out/lib/libghostty-ansi-html.so"
  "./packages/core/lib/zig-out/lib/libghostty-ansi-html-linux.node"
  "./packages/core/lib/zig-out/bin/ghostty-ansi-html.dll"
  "./packages/core/lib/zig-out/lib/libghostty-ansi-html-windows.node"
)

package_dirs=(
  "packages/platforms/linux-x64"
  "packages/platforms/linux-x64-node"
  "packages/platforms/win32-x64"
  "packages/platforms/win32-x64-node"
)

for i in "${!platform_directories[@]}"; do
  native_lib="${platform_directories[$i]}"
  package_dir="${package_dirs[$i]}"
  cp -rvf "$native_lib" "$package_dir"
  sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$tag\"/" "$package_dir/package.json"
  cd "$package_dir" && bun publish && cd ../../../
done

cd packages/core
bun update ghostty-ansi-html-linux-x64 
bun update ghostty-ansi-html-linux-x64-node
bun update ghostty-ansi-html-win32-x64
bun update ghostty-ansi-html-linux-x64-node
bun run build
bun publish
