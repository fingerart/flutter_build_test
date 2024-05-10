#!/usr/bin/env bash

# 创建环境变量
github_sha_short="${GITHUB_SHA:0:6}"
repository_name="${GITHUB_REPOSITORY#*/}"
project_name="${REPOSITORY_ALIAS:-$repository_name}"
{
  echo "GITHUB_SHA_SHORT=$github_sha_short"
  echo "REPOSITORY_NAME=$repository_name"
  echo "PROJECT_NAME=$project_name"
} >>"$GITHUB_ENV"

# 创建输出值
if [ "$GITHUB_REF_NAME" == 'test' ]; then
  debug_flag='-debug'
  output_file_path="build/app/outputs/bundle/debug/app-debug"
else
  output_file_path="build/app/outputs/bundle/release/app-release"
fi

# macOS平台覆盖output_file_path
if command -v defaults &>/dev/null; then
  bundle_name=$(defaults read "$(pwd)/ios/Runner/Info.plist" CFBundleName)
  output_file_path="build/ios/ipa/$bundle_name.ipa"
fi

version_name="$(yq '.version' pubspec.yaml | cut -d'+' -f1)"
version_code="$(yq '.version' pubspec.yaml | cut -d'+' -f2)"
dist_file_name="$project_name-v$version_name+$version_code$debug_flag($github_sha_short)"
dist_dir="$project_name/$GITHUB_REF_NAME/v$version_name"

{
  echo "version_name=$version_name"
  echo "version_code=$version_code"
  echo "dist_file_name=$dist_file_name"
  echo "dist_dir=$dist_dir"
  echo "output_file_path=$output_file_path"
} >>"$GITHUB_OUTPUT"
