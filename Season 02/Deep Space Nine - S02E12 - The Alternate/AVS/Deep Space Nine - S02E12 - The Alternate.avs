SetFilterMTMode("DEFAULT_MT_MODE", 2)
# Initialize Project Variables
#   The OVRfiles for TFM and TDecimate need to exist.  If they don't, it will generate an error. 
#   You can add an OVR file or remove the OVR= section from the commands below.

  d2vFile     = "G:\Enhanced Videos\DS9 Work\Season 02\Deep Space Nine - S02E12 - The Alternate\D2V\VTS_02_1 - 0xE0 - Video - MPEG-2 - 720x480 (NTSC) - 4~3.d2v"
  tfmOVR      = "Deep Space Nine - S02E12 - The Alternate_TFM.ovr"
  decimateOVR = "Deep Space Nine - S02E12 - The Alternate_TDecimate.ovr"
  logTFM      = "Deep Space Nine - S02E12 - The Alternate_TFMReport.log"
  
  tfmMI       = 24
 
# Source Cropping
  left        = 8
  top         = 0
  right       = -8
  bottom      = 0

# Load Source
  source=MPEG2Source(d2vFile, idct=5, moderate_h=40, moderate_v=40, cpu2="xxoooo").crop(left,top,right,bottom)

# Deinterlace Source
  deint=source.QTGMC( Preset="Slower", InputType=0, SourceMatch=3, Lossless=2, Sharpness=0.2, EZKeepGrain=0.0).SelectEven()

# Perform Reverse Telecine
  # Use the following command when testing for combed frames with problems 
  # Optional:   output=logTFM   to output TFM actions to a text file 
  source.tfm(d2v=d2vFile, PP=1, MI=tfmMI, clip2=deint, display=true, flags=5, OVR=TFMovr)
  # 
  # Use the following command for Production
  #source.tfm(d2v=d2vFile, PP=7, MI=tfmMI, clip2=deint, display=false, flags=5, ovr=tfmOVR)

# Decimate to remove duplicate Frames
  # Use the following command when testing for combed frames with problems
  #  TDecimate(hybrid = 1, dupThresh=1.5, vidThresh=2.0, display=true) 

  # Use the following command for Production
   TDecimate(hybrid = 1, dupThresh=1.5, vidThresh=2.0, display=false, ovr=decimateOVR)
   #z_ConvertFormat(pixel_type="RGBP16", colorspace_op="170m:601:170m:f=>rgb:srgb:170m:f").ImageWriter("G:\Enhanced Videos\DS9 Work\Season 02\Deep Space Nine - S02E12 - The Alternate\INPUTPNG\",type="png")

  # If testing, use this line to speed up the playback
  assumefps(120)

  #For multi-threaded performance. Change the number to the # of CPU cores you have.   
   Prefetch(16)
   
   #.ImageWriter("G:\Enhanced Videos\DS9 Work\Season 01\Deep Space Nine - S01E13 - Battle Lines\INPUTPNG\",type="png")
   #TDecimate(hybrid = 1, dupThresh=1.5, vidThresh=2.0, display=false, ovr=decimateOVR)
