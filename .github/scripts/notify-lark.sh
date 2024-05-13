#!/usr/bin/env bash

while getopts 's:' opt; do
  case $opt in
  s)
    state=$OPTARG
    ;;
  ?)
    echo "未知参数"
    exit 1
    ;;
  esac
done

env="$GITHUB_REF_NAME"
project_name="$PROJECT_NAME"
commit_hash="$GITHUB_SHA_SHORT"

lark_chatroom_id="$LARK_CHATROOM_ID"
download_url="$DOWNLOAD_URL"
version="$VERSION"
platform="$PLATFORM"
product_img_url="$PRODUCT_IMG_URL"
qrcode_img_path="$QRCODE_IMG_PATH"
qrcode_img_url="img_v3_02an_b81d843b-4e16-4955-bffa-6a557d267e2g"

if [ "$platform" == "Android" ]; then
  platform_img_url="img_v3_02an_3c0b2c74-3c7e-47e6-8e36-1e302196ed3g"
else
  platform_img_url="img_v3_02an_2378cdec-8953-4f22-9b62-6c3dec5685dg"
fi

if [ -n "$qrcode_img_path" ]; then
  # 获取tenant_access_token
  resp_access_token=$(curl -X "POST" "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
    -H 'Content-Type: application/json; charset=utf-8' \
    -d $'{
        "app_id": "'$LARK_APP_ID'",
        "app_secret": "'$LARK_APP_SECRET'"
      }')

  tenant_access_token=$(echo "$resp_access_token" | jq -r '.tenant_access_token')

  # 上传图片到飞书
  resp_upload_img=$(curl --location --request POST 'https://open.feishu.cn/open-apis/im/v1/images' \
    --header "Authorization: Bearer $tenant_access_token" \
    --header 'Content-Type: multipart/form-data' \
    --form 'image_type="message"' \
    --form "image=@\"$qrcode_img_path\"")
  qrcode_img_url=$(echo "$resp_upload_img" | jq -r '.data.image_key')
fi

if [ "$state" == "success" ]; then
  # 发送成功通知
  curl -X "POST" "https://open.feishu.cn/open-apis/bot/v2/hook/$lark_chatroom_id" \
    -H 'Content-Type: text/plain; charset=utf-8' \
    -d $'{
    "msg_type": "interactive",
    "card": {
      "type": "template",
      "data": {
        "template_id": "ctp_AAkOYUy054dH",
        "template_variable": {
          "env": "'$env'",
          "version": "'$version'",
          "project_name": "'$project_name'",
          "platform": "'$platform'",
          "commit_hash": "'$commit_hash'",
          "download_url": "'$download_url'",
          "qrcode_img_url": "'$qrcode_img_url'",
          "product_img_url": "'$product_img_url'",
          "platform_img_url": "'$platform_img_url'",
          "remark": ""
        }
      }
    }
  }'
else
  # 发送失败通知
  curl -X "POST" "https://open.feishu.cn/open-apis/bot/v2/hook/$lark_chatroom_id" \
    -H 'Content-Type: text/plain; charset=utf-8' \
    -d $'{
    "msg_type": "interactive",
    "card": {
      "type": "template",
      "data": {
        "template_id": "ctp_AAk5c1XkbFjl",
        "template_variable": {
          "env": "'$env'",
          "version": "'$version'",
          "project_name": "'$project_name'",
          "platform": "'$platform'",
          "commit_hash": "'$commit_hash'",
          "product_img_url": "'$product_img_url'",
          "platform_img_url": "'$platform_img_url'",
          "logs_url": "https://github.com/logs"
        }
      }
    }
  }'
fi
