# Notes:
 Upscaled PNG Folder size: 650GB

# Known Issues

## ISSUE 1 : During the intro, the scrolling text skips

This can be corrected by using the OVR files from the project for this episode.  I wasn't able to discover a way to integrate it into the main AVS script, but I provided a second script that you can use to resolve this with little effort.  It still isn't perfect, but it does reduce some of the skipping.

Start by following the documentation.  After you have created your MKV file from the D2V, insert these steps before continuing.

.\encode-d2v.ps1 -stopTime 0:00:08 -inputFile '.\Season 01\Deep Space Nine - S01E01E02 - Emissary\Deep Space Nine - S01E01E02 - Emissary_intro.avs'

This will create a video with the first 8 seconds, but it will tell TFM to treat the it as video, which should clean up some of the skipping.

Continue the process in the documentation, but run both of these MKV files through Video Enhance AI.  I'd recommend starting with the 8s video, as it won't take but a few minutes to complete.  The longer video will take 10+ hours.  The end result will be two different folders with PNG files in.

Copy all of the PNG files from the 8s video folder into the full video folder and allow it to overwrite.  From here, continue on with the process.  You will no longer need the folder with the 8s of PNG files as you've copied them into the working folder for the video.

