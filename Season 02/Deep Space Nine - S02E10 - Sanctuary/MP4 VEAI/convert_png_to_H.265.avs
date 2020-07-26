SetFilterMTMode("DEFAULT_MT_MODE", 2)
outfolder = "G:\Enhanced Videos\DS9 Work\Season 02\Deep Space Nine - S02E10 - Sanctuary\INPUTPNG\000000_4.50x_3168x2160_Gaia-HQ_tif16"

IFN     = outfolder + "\*.tif"                                      # relative current directory
#IFN     = outfolder + "\*.png"

TmpFile = ".\TmpFileList.tmp"

IFN     = RT_GetFullPathName(IFN)                                   # Get full path filename
TmpFile = RT_GetFullPathName(TmpFile)

FileCnt = RT_WriteFileList(IFN,TmpFile)                             # write list of files, returning count of files found
Assert(FileCnt > 0, "Problem getting image filecnt")
RT_FileDelete(TmpFile)                                              # Finished with file list

#For 16 bit tiffs
ImageSource(file=outfolder+"\%06d.tif",start=0,end=FileCnt-1,fps=23.976,pixel_type="RGB48")

#ImageSource(file=outfolder+"\%06d.png",start=0,end=FileCnt-1,fps=23.976)
ConvertToPlanarRGB()
z_ConvertFormat(width=2880, height=2160, resample_filter="bicubic",pixel_type="YUV420P16", colorspace_op="rgb:srgb:170m:f=>709:709:709:f")
TemporalDegrain2(grainLevel=false)
neo_f3kdb(range=31, grainY=15, grainC=10, sample_mode=2, dither_algo=3, dynamic_grain=true, keep_tv_range=false, output_depth=10)
Prefetch(16)
