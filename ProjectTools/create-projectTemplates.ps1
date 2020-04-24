$episodes = Get-ChildItem -Path "D:\git\DeepSpaceNine\Season 01" 
$subFolders = @("AVS", "D2V", "MKV", "Video")



$episodes+= [pscustomobject]@{
  Season="Season 01"
  Episode = "Deep Space Nine - S01E20 - In the Hands of the Prophet"
}


ForEach($episode in $episodes) {
  write-host $episode.name -fore DarkCyan

  
  If (!(Test-Path $(Join-Path -Path $episode.FullName -ChildPath AVS))) { 
    $nf = New-Item -Path $(Join-Path $episodes.FullName -ChildPath AVS) -ItemType Directory 
  } 
}