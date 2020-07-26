avsr64 "G:\Enhanced Videos\DS9 Work\Season 02\Deep Space Nine - S02E06 - Melora\AVS\Deep Space Nine - S02E06 - Melora.avs"
"Topaz Video Enhance AI.exe" -i "G:\Enhanced Videos\DS9 Work\Season 02\Deep Space Nine - S02E06 - Melora\INPUTPNG\000000.png" -c 0
ffmpeg -i "..\MP4 VEAI\convert_png_to_H.265.avs" -c:v libx265 -preset slow -crf 20 -pix_fmt yuv420p10le -x265-params no-sao=1 ..\Video\S02E06.mkv
mkvmerge -o "\\192.168.1.222\video\TV\Star Trek Deep Space Nine 4K\Deep Space Nine - S02E06 - Melora.mkv" -D -a 1 -s 4 "\\192.168.1.222\video\DS9 Work\1. DVD Rips\S02E06.mkv" "..\Video\S02E06.mkv"
