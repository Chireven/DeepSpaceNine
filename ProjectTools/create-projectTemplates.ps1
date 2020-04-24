$projectRoot = "D:\git\DeepSpaceNine\"

# Normalize 
  If (!($projectRoot.endswith("\"))) { $projectRoot = "$($projectRoot)\" }


  Write-Host "Loading Episodes: " -fore DarkCyan -NoNewline
  $episodes = & "$($projectRoot)projectTools\create-episodeInfo.ps1"
  write-host $episodes.count -fore Gray



$subFolders = @("AVS", "D2V", "MKV", "Video")




ForEach($episode in $episodes) {
  Write-Host "  Processing Episode: " -fore DarkCyan -NoNewline
  write-host "S$($episode.Season)$($episode.Episode)" -fore DarkGray

  # Make sure the Season Path Exists
    $thisSeasonPath  = "$($projectRoot)Season $($Episode.season)"
    If (!(Test-Path $thisSeasonPath -ErrorAction SilentlyContinue)) { 
      $nf = New-Item -path $thisSeasonPath -directory 
      write-host "    Created $($thisSeasonPath)" -fore DarkYellow
    }

  # Make sure a folder exists for each episode    
    $thisEpisodePath = "$($thisSeasonPath)\$($Episode.Show) - S$($episode.season)$($episode.Episode) - $($episode.EpisodeTitle)"
    If (!(Test-Path $thisEpisodePath -ErrorAction SilentlyContinue)) {
      $nf = New-Item -Path $thisEpisodePath -ItemType Directory
      write-host "    Created $($thisEpisodePath)" -fore DarkYellow
    }

  # Create Project SubFolders
    ForEach ($folder in $subFolders) {
      $thisSubfolderPath = "$($thisEpisodePath)\$($folder)"
      If (!(Test-Path $thisSubfolderPath -ErrorAction SilentlyContinue)) {
        $nf = New-Item -Path $thisSubfolderPath -ItemType Directory
        write-host "    Created $($thisSubfolderPath)" -fore DarkYellow
      }
    }
  
   # Populate Templates
     $templatesPath = Join-Path -Path $projectRoot -ChildPath ".templates"
     
     ForEach ($templateType in Get-ChildItem -Path $templatesPath) {
       ForEach ($template in Get-ChildItem $templateType.fullname -file) {
          $templatePath = Join-Path -Path  $thisEpisodePath -ChildPath $templateType
          $templateFileName  = $template.name.replace("template", "$($episode.Show) - S$($episode.Season)$($episode.Episode) - $($episode.EpisodeTitle)")
          $templateFilename  = join-path -path $templatePath -ChildPath $templateFileName
          
          If (!(Test-Path $templateFileName)) {
            $content = Get-Content $template.FullName
            $content = $content.replace("[show]", $episode.show)
            $content = $content.replace("[episode]", "S$($episode.season)$($episode.Episode)")
            $content = $content.replace("[episodetitle]", $episode.EpisodeTitle)
            $content | Add-Content -path  $templateFileName
            write-host "    Created $($templateFileName)" -fore DarkYellow
          }
        }

       
     }
}