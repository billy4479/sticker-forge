#!/usr/bin/env bash

set -euo pipefail

stickerSetName="$1"
mkdir -p "$stickerSetName"

fileIds=$(curl -sSL -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getStickerSet" \
  -d "name=$stickerSetName" |
  jq -r '.result.stickers.[].file_id')

for id in $fileIds; do
  filePath=$(curl -sSL -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getFile" \
    -d "file_id=$id" |
    jq -r '.result.file_path')
  curl -sSL -O --output-dir "$stickerSetName" "https://api.telegram.org/file/bot$TELEGRAM_BOT_TOKEN/$filePath"
  echo "$stickerSetName/$filePath"
done
