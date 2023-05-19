#!/bin/bash
# Description: Encode a video for Instagram

# This script will:
# Encode lossless video from png files
# Join it to the audio
# Loop it, apply fades
# Convert to IG format

# todo
# Filter the audio to remove annoying sounds
# ffmpeg -i 2023-02-14_22-59-27-e3b90f4.wav -af "highpass=f=20,afftdn=nf=-20,lowpass=f=5000"
# Add a normalisation to it maybe

# The audio should be a .wav file with the same name as the video
export PATH=$PATH:/usr/local/bin/:/Users/tudvari/.pyenv/shims/

script_path="$(realpath "$0")"
script_dir="$(dirname "$script_path")"
cd "$script_dir"

echo "Script dir is $script_dir"

FILE_NAME="$1"
VIDEO_FILE=$FILE_NAME.avi
ffmpeg -y -r 60 -pattern_type glob -i '*.png' -c:v huffyuv -pix_fmt yuv444p $FILE_NAME-mute.avi
ffmpeg-normalize -t -25 $FILE_NAME.wav -o $FILE_NAME-norm.wav
ffmpeg -y -i $FILE_NAME-mute.avi -i $FILE_NAME-norm.wav -c:v copy -c:a copy $VIDEO_FILE

VIDEO_FILE_NAME=$(basename "$VIDEO_FILE")
VIDEO_FILE_NAME="${VIDEO_FILE_NAME%.*}"
VIDEO_FILE_EXT="${VIDEO_FILE##*.}"
VIDEO_FILE_DIR=$(dirname "$VIDEO_FILE")
LOOPED_VIDEO_FILE=$VIDEO_FILE_NAME-looped.$VIDEO_FILE_EXT

TARGET_LENGTH=180

LENGTH=$(ffprobe -i "$VIDEO_FILE" -show_entries format=duration -v quiet -of csv="p=0")
LOOP_COUNT=$(echo "$TARGET_LENGTH/$LENGTH" | bc)

# Loop the video LOOP_COUNT times without re-encoding
ffmpeg -y -stream_loop $LOOP_COUNT -i $VIDEO_FILE -c copy $LOOPED_VIDEO_FILE
LOOPED_VIDEO_FILE_LENGTH=$(ffprobe -i $LOOPED_VIDEO_FILE -show_entries format=duration -v quiet -of csv="p=0")

FADE_OUT_START=$(echo "$LOOPED_VIDEO_FILE_LENGTH-2.5" | bc)
AFADE_OUT_START=$(echo "$LOOPED_VIDEO_FILE_LENGTH-1" | bc)

ffmpeg -y -i $LOOPED_VIDEO_FILE \
    -vf "fade=t=in:st=0:d=1,fade=t=out:st=$FADE_OUT_START:d=2" \
    -af "highpass=f=20,afftdn=nf=-20,lowpass=f=5000,afade=t=in:st=0.25:d=1,afade=t=out:st=$AFADE_OUT_START:d=1" \
    -c:a libfdk_aac -profile:a aac_he_v2 -b:a 256k \
    -c:v libx264 -pix_fmt yuv420p -crf 2 -preset veryslow -tune animation -f mp4 \
    $VIDEO_FILE_DIR/$VIDEO_FILE_NAME-ig.mov

# set working directory to the directory of the video file
echo "output file: $VIDEO_FILE_NAME-ig.mov"

mv $VIDEO_FILE_NAME-ig.mov ./renders/$VIDEO_FILE_NAME-ig.mov 
open ./renders/$VIDEO_FILE_NAME-ig.mov  
#ffplay -loop -1 $VIDEO_FILE_NAME-looped-faded.mov