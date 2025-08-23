#!/usr/bin/env bash

set -euo pipefail

inputPath="$1"
filename=$(basename "$inputPath")
filename_without_ext="${filename%.*}"
dirpath=$(dirname "$inputPath")
outputDir="$dirpath/converted"
mkdir -p "$outputDir"
outputPath="${outputDir}/${filename_without_ext}.webp"

fileType=$(file --brief --mime-type --dereference "$inputPath")

case "$fileType" in
*video*)
  echo "video file!"

  ffmpeg -hide_banner -loglevel warning -y -i "$inputPath" -an -vcodec libwebp -vf "scale=w=320:h=320:force_original_aspect_ratio=decrease,fps=fps=20" -quality 45 -compression_level 6 "$outputPath"
  # magick "$inputPath" -resize 512x512\> "$outputPath"
  ;;
*image*)
  echo "image file!"
  magick "$inputPath" -resize 512x512\> "$outputPath" # TODO: imagemagick seems to butcher 1 image out of 3..
  ;;

*)
  echo "unsupported file type $fileType"
  ;;
esac
