#!/usr/bin/env bash

set -euo pipefail

verbose=false

# Function to print help message
print_help() {
  echo "Usage: $0 input-file output-dir [-v|--verbose] [-h|--help]"
  echo "  input-file   : The input file"
  echo "  output-dir   : The output directory"
  echo "  -v, --verbose: Enable verbose output"
  echo "  -h, --help   : Display this help message"
}

# Parse command-line options
while getopts "hv" opt; do
  case "$opt" in
  h)
    print_help
    exit 0
    ;;
  v)
    verbose=true
    ;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    print_help
    exit 1
    ;;
  :)
    echo "Option -$OPTARG requires an argument." >&2
    print_help
    exit 1
    ;;
  esac
done

# Remove the parsed options from the argument list
shift $((OPTIND - 1))

# Check for the required number of positional arguments
if [ $# -ne 2 ]; then
  echo "Error: Incorrect number of arguments." >&2
  print_help
  exit 1
fi

inputPath="$1"
outputDir="$2"

filename=$(basename "$inputPath")
filename_without_ext="${filename%.*}"

convert() {
  qualityName="$1"
  outputPath="$outputDir/$qualityName/$filename_without_ext.webp"
  mkdir -p "$outputDir/$qualityName"

  quality="$2"
  resolution="$3"
  fps="$4"

  # https://ffmpeg.org/ffmpeg-all.html#libwebp
  ffmpeg \
    -hide_banner \
    -loglevel warning \
    -y \
    -i "$inputPath" \
    -an \
    -vcodec libwebp \
    -vf "scale=w=$resolution:h=$resolution:force_original_aspect_ratio=decrease,fps=fps=$fps,format=yuv420p" \
    -quality $quality \
    -compression_level 6 \
    "$outputPath"

  if $verbose; then
    echo -e "$outputPath\t@ $qualityName\t-> $(du -bh "$outputPath" | cut -f1)"
  fi
}

convert max 75 512 20
convert high 65 512 20
convert mid 65 320 20
convert low 55 320 15
convert min 40 320 15
