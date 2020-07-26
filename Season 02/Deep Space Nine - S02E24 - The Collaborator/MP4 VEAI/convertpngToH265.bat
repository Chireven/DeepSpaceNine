ffmpeg -i convert_png_to_H.265.avs -c:v libx265 -preset slow -crf 20 -pix_fmt yuv420p10le -x265-params no-sao=1 ..\Video\S02E24.mkv
mkvmerge -o "\\192.168.1.222\video\TV\Star Trek Deep Space Nine 4K\Deep Space Nine - S02E24 - The Collaborator.mkv" -D -a 1 -s 4 "\\192.168.1.222\video\DS9 Work\1. DVD Rips\S02E24.mkv" "..\Video\S02E24.mkv"
