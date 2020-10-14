# Variables
  d2vFile     = "Deep Space Nine - S07E09 - Covenant.d2v"
  CPUCores    = 7
  MTMode      = 2

SetFilterMTMode("DEFAULT_MT_MODE", MTMode)

MPEG2Source(d2vFile) #, idct=5,cpu2="xxoooo" )
TFM()
TDecimate()
QTGMC2 = QTGMC(Preset="Slower", SourceMatch=3, TR2=5, InputType=2, Lossless=2, noiserestore=0.1, NoiseDeint="Generate", grainrestore=0.1, MatchEnhance=0.75, Sharpness=0.5, MatchPreset="Slower", MatchPreset2="Slower")
QTGMC3 = QTGMC(preset="Slower", SourceMatch=3, Lossless=2, InputType=3, TR2=5)
Repair(QTGMC2, QTGMC3, 9)

Spline36Resize(640,480)



Prefetch(CPUCores)
