for /r "%CD%" %%a in (*.mp4) do (
ffmpeg -i "%%~dpnxa" -c:v libx265 -preset slow -crf 24 ..\Video\%%~na.mkv
)
