#!/usr/bin/env bash

####################################################################################################
# 制作iOS安装清单文件
####################################################################################################

while getopts "u:b:n:o:" opt
do
  case $opt in
    u)
      ipa_download_url=$OPTARG
      ;;
    b)
      bundle_id=$OPTARG
      ;;
    n)
      app_name=$OPTARG
      ;;
    o)
      output_dir=$OPTARG
      ;;
    ?)
      echo "未知参数"
      exit 1
      ;;
  esac
done

mkdir -p "$output_dir"
output_file_path="$output_dir/manifest.plist"

cat > "$output_file_path" <<EOF
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>items</key>
        <array>
            <dict>
                <key>assets</key>
                <array>
                    <dict>
                        <key>kind</key>
                        <string>software-package</string>
                        <key>url</key>
                        <string><![CDATA[$ipa_download_url]]></string>
                    </dict>
                </array>
                <key>metadata</key>
                <dict>
                    <key>bundle-identifier</key>
					<string>$bundle_id</string>
					<key>bundle-version</key>
                    <string>4.4</string>
                    <key>kind</key>
                    <string>software</string>
                    <key>title</key>
                    <string>$app_name</string>
                </dict>
            </dict>
        </array>
    </dict>
</plist>
EOF

echo "manifest_path=$output_file_path" >> "$GITHUB_OUTPUT"