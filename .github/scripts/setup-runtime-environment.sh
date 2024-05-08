#!/usr/bin/env bash

# 创建环境变量
github_sha_short="${GITHUB_SHA:0:8}"
repository_name="${GITHUB_REPOSITORY#*/}"
echo "GITHUB_SHA_SHORT=$github_sha_short" >> "$GITHUB_ENV"
echo "REPOSITORY_NAME=$repository_name" >> "$GITHUB_ENV"

# 创建输出值
if [ "$GITHUB_REF_NAME" == 'test' ];
then
  debug_flag='-debug'
  output_file_path="build/app/outputs/bundle/debug/app-debug.aab"
else
  output_file_path="build/app/outputs/bundle/release/app-release.aab"
fi
version_name="$(yq '.version' pubspec.yaml | cut -d'+' -f1)"
version_code="$(yq '.version' pubspec.yaml | cut -d'+' -f2)"
dist_file_name="v$version_name+$version_code$debug_flag($github_sha_short)"
dist_dir="$repository_name/$GITHUB_REF_NAME/v$version_name"

echo "version_name=$version_name" >> "$GITHUB_OUTPUT"
echo "version_code=$version_code" >> "$GITHUB_OUTPUT"
echo "dist_file_name=$dist_file_name" >> "$GITHUB_OUTPUT"
echo "dist_dir=$dist_dir" >> "$GITHUB_OUTPUT"
echo "output_file_path=$output_file_path" >> "$GITHUB_OUTPUT"