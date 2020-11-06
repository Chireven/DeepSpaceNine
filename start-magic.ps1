[CmdletBinding()]
param(
  [Parameter(Mandatory=$false)] [string]$Season =2,
  [Parameter(Mandatory=$false)] [string]$dgIndexPath = "D:\Video\Tools\DGIndex\DGIndex.exe"
)


cls

$seasonFolder = ".\Season $($season.PadLeft(2,"0"))"
If (!(Test-Path $seasonFolder )) {
    Write-Host "ERROR:" -fore white -back red -nonewline
    write-host " Season $($seasonFolder) " -fore yellow -nonewline
    write-host "Not Found" -fore DarkGray
    exit
}

Write-Host "Season : " -fore DarkCyan -NoNewline
write-host $seasonFolder -fore DarkGray

ForEach ($episodeFolder in Get-ChildItem $seasonFolder -Directory -Filter "* - S0*" ) {
    # Create Variables for all required file types
      $doneFile    = Join-Path -Path $episodeFolder.FullName -ChildPath "$($episodeFolder.Name).done"  
      $notDoneFile = Join-Path -Path $episodeFolder.FullName -ChildPath "$($episodeFolder.Name).notdone"  
      $ifoFile     = Join-Path -Path $episodeFolder.FullName -ChildPath "$($episodeFolder.Name).IFO"
      $vobFile     = Join-Path -Path $episodeFolder.FullName -ChildPath "$($episodeFolder.Name).VOB" 
      $chapterFile = Join-Path -Path $episodeFolder.FullName -ChildPath "$($episodeFolder.Name)_Chapters.txt"
      $streamFile  = Join-Path -Path $episodeFolder.FullName -ChildPath "$($episodeFolder.Name) - Stream Information.txt"
      $d2vFile     = Join-Path -Path $episodeFolder.FullName -ChildPath "$($episodeFolder.Name).d2v"
      $srtFile     = Join-Path -Path $episodeFolder.FullName -ChildPath "$($episodeFolder.Name).English.srt"
      $mkvFile     = Join-Path -Path $episodeFolder.FullName -ChildPath "$($episodeFolder.Name).mkv"

    # See if we need to process this episode
      If (Test-Path $doneFile) {
        Write-Host $episodeFolder.Name -fore Green        
      } Else {
        Write-Host $episodeFolder.Name -fore yellow
        If (!(Test-Path $notDoneFile)) { 
            "This Episode is Not Done" | Out-File -FilePath $notDoneFile 
        }
    
      # Check Ifo
        If (!(Test-Path $ifoFile)) {
          If ( ($(Get-ChildItem -Path $episodeFolder.fullname -Filter *.ifo).count -eq 1)) {
            write-host "  Fixing IFO" -fore yellow
            $invalidIFO = $(Get-ChildItem -Path $episodeFolder.fullname -Filter *.ifo)
            Rename-Item -Path $invalidIFO.FullName -NewName $ifoFile
          }  Else { write-host "  File Not Found: IFO" -fore DarkGray }
        } Else {
          # write-host "  IFO Good" -fore DarkGray
        }


      # Check VOB
        If (!(Test-Path $vobFile)) {
          If ( ($(Get-ChildItem -Path $episodeFolder.fullname -Filter *.vob).count -eq 1)) {
            write-host "  Fixing vob" -fore yellow
            $invalidvob = $(Get-ChildItem -Path $episodeFolder.fullname -Filter *.vob)
            Rename-Item -Path $invalidvob.FullName -NewName $vobFile
          }  Else { write-host "  File Not Found: VOB" -fore DarkGray }
        } Else { 
          # write-host "  VOB Good" -fore DarkGray
        }  
        
      # Chapter Files
        If (!(Test-Path $chapterFile)) {
          If ( ($(Get-ChildItem -Path $episodeFolder.fullname -Filter "*Chapter Information - OGG.txt").count -eq 1)) {
            write-host "  Fixing chapter" -fore yellow
            $invalidchapter = $(Get-ChildItem -Path $episodeFolder.fullname -Filter "*Chapter Information - OGG.txt")
            Rename-Item -Path $invalidchapter.FullName -NewName $chapterFile
          }  Else { write-host "  File Not Found: *Chapter Information - OGG.txt" -fore DarkGray }
        } Else {
           # write-host "  Chapter Good" -fore DarkGray
        }
        
        # Stream File
          If (!(Test-Path $streamFile)) {
            If ( ($(Get-ChildItem -Path $episodeFolder.fullname -Filter "*Stream Information.txt").count -eq 1)) {
              write-host "  Fixing Stream" -fore yellow
              $invalidStream = $(Get-ChildItem -Path $episodeFolder.fullname -Filter "*Stream Information.txt")
              Rename-Item -Path $invalidStream.FullName -NewName $streamFile
            }  Else { write-host "  File Not Found: *Stream Information.txt" -fore DarkGray }
        } Else { 
          # write-host "  Stream Good" -fore DarkGray
        }
        
        # Check D2V
         $nakedD2V = $d2vFile.replace(".d2v","")
          If (!(Test-Path $d2vFile)) {
            If (Test-Path $vobFile) {
                Write-Host "  Generating D2V" -fore DarkCyan
                $dgArguments = ""
                $dgArguments = $dgArguments + " -i $('"{0}"' -f $vobFile)"
                $dgArguments = $dgArguments + " -o $('"{0}"' -f $nakedD2V )"
                $dgArguments = $dgArguments + " -fo 0"
                $dgArguments = $dgArguments + " -yr 1"
                $dgArguments = $dgArguments + " -om 0"
                $dgArguments = $dgArguments + " -ia 6"
                $dgArguments = $dgArguments + " -exit"
                $dgArguments = $dgArguments + " -hide"
                
                
                $dgIndexProcess = Start-Process -FilePath $dgIndexPath -ArgumentList $dgArguments -wait  -RedirectStandardOutput "NUL"
            }  Else { write-host "  File Not Found: D2V (Can't generate due to missing VOB)" -fore DarkGray }
          } else { 
            # write-host "  D2V good" -fore DarkGray
          }

        # Check SRT
        If (!(Test-Path $srtFile)) {
          If ( ($(Get-ChildItem -Path $episodeFolder.fullname -Filter *.English.srt).count -eq 1)) {
            write-host "  Fixing SRT" -fore yellow
            $invalidSRT = $(Get-ChildItem -Path $episodeFolder.fullname -Filter *.English.srt)
           # Rename-Item -Path $invalidSRT.FullName -NewName $srtFile
          }  Else { write-host "  File Not Found: *.English.SRT" -fore DarkGray }
        } Else {
          # write-host "  SRT Good" -fore DarkGray
        }
         
        # Check MKV (DVD source)
        If (!(Test-Path $mkvFile)) {
          If (!((Test-Path $vobFile) -and (Test-Path $d2vFile))) {
            write-host "  File Not Found: MKV (Missing VOB/D2V, cannot generate)" -fore DarkGray
          } Else {
            Write-Host "Can Generate MKV for VEIA" -fore Green
          }
        } Else {
          # Write-Host "  MKV Good" -fore DarkGray
        }
    }

}