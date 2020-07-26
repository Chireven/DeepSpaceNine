avsr64 "G:\Enhanced Videos\DS9 Work\Season 02\Deep Space Nine - S02E26 - The Jem'Hadar\AVS\Deep Space Nine - S02E26 - The Jem'Hadar.avs"
"Topaz Video Enhance AI.exe" -i "G:\Enhanced Videos\DS9 Work\Season 02\Deep Space Nine - S02E26 - The Jem'Hadar\INPUTPNG\000000.png" -c 1
ffmpeg -i "..\MP4 VEAI\convert_png_to_H.265.avs" -c:v libx265 -preset slow -crf 20 -pix_fmt yuv420p10le -x265-params no-sao=1 ..\Video\S02E26.mkv
mkvmerge -o "\\192.168.1.222\video\TV\Star Trek Deep Space Nine 4K\Deep Space Nine - S02E26 - The Jem'Hadar.mkv" -D -a 1 -s 4 "\\192.168.1.222\video\DS9 Work\1. DVD Rips\S02E26.mkv" "..\Video\S02E26.mkv"
