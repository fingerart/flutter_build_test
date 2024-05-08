#!/usr/bin/env bash

# 创建环境变量
echo "GITHUB_SHA_SHORT=${GITHUB_SHA:0:8}" >> "$GITHUB_ENV"
echo "REPOSITORY_NAME=${GITHUB_REPOSITORY#*/}" >> "$GITHUB_ENV"

# 创建输出值
echo "version_name=$(yq '.version' pubspec.yaml | cut -d'+' -f1)" >> "$GITHUB_OUTPUT"
echo "version_code=$(yq '.version' pubspec.yaml | cut -d'+' -f2)" >> "$GITHUB_OUTPUT"