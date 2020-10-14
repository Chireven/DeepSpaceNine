# Initialize Project Variables
#   The OVRfiles for TFM and TDecimate need to exist.  If they don't, it will generate an error. 
#   You can add an OVR file or remove the OVR= section from the commands below.

  d2vFile     = "Deep Space Nine - S06E08 - Resurrection.d2v"
  tfmOVR      = "Deep Space Nine - S06E08 - Resurrection_TFM.ovr"
  decimateOVR = "Deep Space Nine - S06E08 - Resurrection_TDecimate.ovr"
  logTFM      = "Deep Space Nine - S06E08 - Resurrection_TFMReport.log"
  
  tfmMI       = 24
 
# Source Cropping
  left        = 0
  top         = 0
  right       = 0
  bottom      = 0



# Load Source
  source=MPEG2Source(d2vFile, idct=5, moderate_h=40, moderate_v=40, cpu2="xxoooo").crop(left,top,right,bottom)


# Deinterlace Source
  deint=source.QTGMC( Preset="Slower", InputType=0, SourceMatch=3, Lossless=2, Sharpness=0.2, EZKeepGrain=0.0).SelectEven()

# Perform Reverse Telecine
  # Use the following command when testing for combed frames with problems 
  # Optional:   output=logTFM   to output TFM actions to a text file 
  #   source.tfm(d2v=d2vFile, PP=1, MI=tfmMI, clip2=deint, display=true, flags=5, OVR=TFMovr)
  # 
  # Use the following command for Production
    source.tfm(d2v=d2vFile, PP=7, MI=tfmMI, clip2=deint, display=false, flags=5, ovr=tfmOVR)



# Decimate to remove duplicate Frames
  # Use the following command when testing for combed frames with problems
  #  TDecimate(hybrid = 1, dupThresh=1.5, vidThresh=2.0, display=true) 

  # Use the following command for Production
    TDecimate(hybrid = 1, dupThresh=1.5, vidThresh=2.0, display=false, ovr=decimateOVR)

# If testing, use this line to speed up the playback
  # assumefps(120)


