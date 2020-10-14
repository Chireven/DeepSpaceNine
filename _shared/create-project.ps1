# Init
    $projectRoot = 'D:\Star Trek\Deep Space 9'
    $episodes    = & 'D:\Star Trek\Deep Space 9\_projectSetup\get-episodeObjects.ps1'

$avsTemplate =  @'
# Variables
  d2vFile     = "%FILENAME%"
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
'@

# Season Folders
  ForEach ($episode in $episodes) {
      $season = Join-Path -Path $projectRoot -ChildPath "Season $($episode.season)"
      If (!(Test-Path $season -ErrorAction SilentlyContinue)) { New-Item $season -ErrorAction SilentlyContinue -itemtype directory   }

      $episodeName = "$($episode.Show) - S$($episode.Season)$($episode.Episode) - $($episode.EpisodeTitle)".replace(".", "")
      


      $ef = Join-Path -Path $season -ChildPath $episodeName
      If (!(Test-Path $ef -ErrorAction SilentlyContinue)) { new-item $ef -erroraction SilentlyContinue -itemtype directory  }


      $avsContent = $avsTemplate.replace("%FILENAME%", "$($episodeName).d2v")
      $avsFile    = join-path $ef -ChildPath "$($episodeName).avs"
      If (!(Test-Path $avsFile -ErrorAction SilentlyContinue)) { $avsContent | Out-File $avsFile -Encoding ascii }
  }