avsr64 "G:\Enhanced Videos\DS9 Work\Season 02\Deep Space Nine - S02E16 - Shadowplay\AVS\Deep Space Nine - S02E16 - Shadowplay.avs"
"Topaz Video Enhance AI.exe" -i "G:\Enhanced Videos\DS9 Work\Season 02\Deep Space Nine - S02E16 - Shadowplay\INPUTPNG\000000.png" -c 1
ffmpeg -i "..\MP4 VEAI\convert_png_to_H.265.avs" -c:v libx265 -preset slow -crf 20 -pix_fmt yuv420p10le -x265-params no-sao=1 ..\Video\S02E16.mkv
mkvmerge -o "\\192.168.1.222\video\TV\Star Trek Deep Space Nine 4K\Deep Space Nine - S02E16 - Shadowplay.mkv" -D -a 1 -s 4 "\\192.168.1.222\video\DS9 Work\1. DVD Rips\S02E16.mkv" "..\Video\S02E16.mkv"
