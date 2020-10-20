[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
    [string]$inputPath,

  [Parameter(Mandatory=$False)]
    [ValidateSet("23.976", "24","29.97", "30")]
    [String]$FrameRate        = "23.976",

  [Parameter(Mandatory=$False)]
    [String]$sourceFiles      = "%06d.png",

  [Parameter(Mandatory=$False)]
    [String]$VideoCodec       = "libx265",

  [Parameter(Mandatory=$False)]
    [ValidateSet("1920x1080", "3840x2160")]
    [String]$VideoSize        = "3840x2160",

  [Parameter(Mandatory=$False)]
    [String]$videoFormat      = "image2",

  [Parameter(Mandatory=$False)]
    [ValidateSet("veryslow","slower","slow","medium","fast","faster","veryfast","superfast","ultrafast","placebo")]     
    [String]$preset           = "slow",

  [Parameter(Mandatory=$False)]
    [string]$CRF              = "22",

  [Parameter(Mandatory=$False)]
    [ValidateSet("yuv420p12le","yuv420p10le","yuv420p")]
    [String]$encodePixFormat  = "yuv420p10le",

  [Parameter(Mandatory=$False)]
    [String]$outFile,

  [Parameter(Mandatory=$False)]
    [int]$startingFrame,

  [Parameter(Mandatory=$False)]
    [int]$NumberOfFrames,

  [Parameter(Mandatory=$False)]
    [switch]$overwrite,

  [Parameter(Mandatory=$False)]
    [switch]$showFFMEGArgsAtEnd,

  [Parameter(Mandatory=$False)]
    [string]$waitForFrameFile
    
)

Function activityMonitor() {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$false)][int]   $currentValue = "1",
    [Parameter(Mandatory=$false)][int]   $maxValue     = "40",
    [Parameter(Mandatory=$false)][string]$leftEnd      = "[",
    [Parameter(Mandatory=$false)][string]$rightEnd     = "]",
    [Parameter(Mandatory=$false)][string]$filler       = ".",
    [Parameter(Mandatory=$false)][string]$Active       = "oOo",
    [Parameter(Mandatory=$false)][ValidateSet("Forward","Backward")][string]$direction = "Forward"
    
  ) 
  
  
  $bar = ""
  $bar = $bar + $leftEnd
  $bar = $bar + $filler * $maxValue
  $bar = $bar.remove($currentValue,1).Insert($currentValue,$Active)
  $bar = $bar + $rightEnd

  If ($currentValue -gt $maxValue -1) { $direction = "Backward" }
  If ($currentValue -lt 2)         { $direction = "Forward"  }

  If ($direction.tolower() -eq "forward"  ) { $currentValue+=1 } 
  If ($direction.tolower() -eq "backward" ) { $currentValue-=1 }

  Write-Output [pscustomobject] @{
      Bar           = $bar
      direction     = $direction
      currentValue  = $currentValue
      maxValue      = $maxValue
      Active        = $Active
  }
}
Function get-fancyString() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
            [string]$text,
        [Parameter(Mandatory=$false)]
            [int]$size = 80
    )

    $fancyString = @()
    
    Do {
        If ($text.Length -gt $size) {
            $fancyString+= $text.Substring(0,$size)
            $text = $text.Substring(80)
        } Else {
            $fancyString+=$text
            $text = ""
            break
        }
    } Until ($text.lengh -eq 0)

    $fancyString
}

Function write-fancyString() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
            [string]$label,        
        [Parameter(Mandatory=$true)]
            [string]$labelPadding, 
        [Parameter(Mandatory=$true)]
            [string]$text,
        [Parameter(Mandatory=$false)]
            [String]$textSize = 80
    )
    
    write-host ":" -fore black -back DarkGray -nonewline
    write-host "$($($label).PadRight($labelPadding, " ")) " -fore Yellow -back darkgray -NoNewline 
    write-host ": "                                    -fore black  -back darkgray -nonewline

    $fancyStrings = get-fancyString -text $text -size $textSize
    $blank        = ""
    $counter = 0
    
    If ($global:lineItem -eq 0) {
        $textColor = @{
                ForegroundColor = "white"
                BackgroundColor = "darkgray"
        }
        $global:lineItem++
    } Else {
        $textColor = @{
                ForegroundColor = "black"
                BackgroundColor = "darkgray"
                
        }
        $global:lineItem = 0
    }

    ForEach ($fancyString in $fancyStrings) {        
        If ($counter -ne 0) { 
            write-host ":" -fore black -back DarkGray -nonewline
            write-host "$($blank.PadRight($labelPadding)) : " -fore black -back darkgray -NoNewline
        } 
        
        write-host $fancyString.PadRight($textSize) @textColor -NoNewline
        write-host " :" -fore black -back darkgray

        $counter++
    }    
}
# Initialize Options
    $labelPaddingSize = 20
    $textPaddingSize  = 80
    $lineBuffer       = 6

# Normalize and Calculate Variables, define 
    # Script Counters
        $global:lineItem  = 0
    # Input File
        If (!($inputPath.EndsWith("\"))) { $inputPath = "$($inputPath)\" }
        $inFile = "$($inputPath)$($sourceFiles)"
    # Output File
        If (!($outFile)) {
            $folderName = "$( Split-Path -Path $inputPath -Parent)"
            $filename   = "$( Split-Path -Path $inputPath -leaf).mkv"
            $outFile    = Join-Path -Path $folderName -ChildPath $filename
        }

    # Assemble Arguments    
                                    $ffmpegArgs = ""  
        If ($startingFrame)     {   $ffmpegArgs = $ffmpegArgs + "-start_number $($startingFrame) "}
                                    $ffmpegArgs = $ffmpegArgs + "-r $($FrameRate) "
                                    $ffmpegArgs = $ffmpegArgs + "-f $($videoFormat) "
                                    $ffmpegArgs = $ffmpegArgs + "-s $($VideoSize) "
                                    $ffmpegArgs = $ffmpegArgs + "-i `"$($inFile)`" "
        If ($NumberOfFrames)    {   $ffmpegArgs = $ffmpegArgs + "-frames:v $($numberOfFrames) "}
                                    $ffmpegArgs = $ffmpegArgs + "-vcodec $($VideoCodec) "
                                    $ffmpegArgs = $ffmpegArgs + "-preset $($preset) "
                                    $ffmpegArgs = $ffmpegArgs + "-crf $($CRF) "
                                    $ffmpegArgs = $ffmpegArgs + "-pix_fmt $($encodePixFormat) "
        If ($overwrite) {           $ffmpegArgs = $ffmpegArgs + "-y "}
                                    $ffmpegArgs = $ffmpegArgs + " `"$($outFile)`""

# Get some Status
  If ($NumberOfFrames) {
        $numFrames = $numberOfFrames
  } Else {
    Try {
        $numFrames = $(Get-ChildItem -Path $inputPath -Filter *.png -File -ErrorAction SilentlyContinue).count
    } Catch {
        $numFrames = 0
    }
  }
# Display Our details:
  Clear-Host 
    write-host $("-" * ($labelPaddingSize + $textPaddingSize + $lineBuffer)) -fore black -back darkgray
    write-fancystring -label "  Make Episode"     -labelpadding $labelPaddingSize -text "Convert PNG to MKV"      -textSize $textPaddingSize 
    write-host $("-" * ($labelPaddingSize + $textPaddingSize + $lineBuffer)) -fore black -back darkgray

    write-fancystring -label "  Input Filename"     -labelpadding $labelPaddingSize -text $inputPath        -textSize $textPaddingSize  
    write-fancystring -label "  Output Filename"    -labelpadding $labelPaddingSize -text $outFile          -textSize $textPaddingSize
    If ($startingFrame) { 
        write-fancystring -label "  Starting Frame" -labelpadding $labelPaddingSize -text $startingFrame    -textSize $textPaddingSize
    }    
    write-fancyString -label "  Number of Rames"    -labelPadding $labelPaddingSize -text $numFrames        -textSize $textPaddingSize
    write-fancystring -label "  Video Format"       -labelpadding $labelPaddingSize -text $videoFormat      -textSize $textPaddingSize
    write-fancystring -label "  Video Size"         -labelpadding $labelPaddingSize -text $videoSize        -textSize $textPaddingSize
    write-fancystring -label "  Video Codec"        -labelpadding $labelPaddingSize -text $VideoCodec       -textSize $textPaddingSize
    write-fancystring -label "  Encoder Preset"     -labelpadding $labelPaddingSize -text $preset           -textSize $textPaddingSize
    write-fancystring -label "  CRF"                -labelpadding $labelPaddingSize -text $CRF              -textSize $textPaddingSize
    If ($NumberOfFrames) {
        write-fancystring -label "  Frame Count"    -labelpadding $labelPaddingSize -text $NumberOfFrames   -textSize $textPaddingSize    
    }
    write-fancystring -label "  Pixel Format"       -labelpadding $labelPaddingSize -text $encodePixFormat  -textSize $textPaddingSize
    write-fancystring -label "  FFMPEG"             -labelpadding $labelPaddingSize -text $ffmpegArgs       -textSize $textPaddingSize
     
    If ($waitForFrameFile) {
      $frameStart = Join-Path -Path $inputPath -ChildPath $waitForFrameFile
      write-fancyString -label "  Waiting For"      -labelPadding $labelPaddingSize -text $frameStart     -textSize $textPaddingSize
      write-fancystring -label "  Started Waiting"  -labelpadding $labelPaddingSize -text "$(get-date)"   -textSize $textPaddingSize  
      $activity = activityMonitor -maxValue ($labelPaddingSize + $textPaddingSize + 5 - $waitForFrameFile.Length) -Active $waitForFrameFile
      while (!(Test-Path $frameStart)) {
          $activity = activityMonitor -currentValue $activity.currentValue -direction "$($activity.direction)" -maxValue $activity.maxValue -Active $activity.Active
          $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Host.UI.RawUI.CursorPosition.Y
      
        write-host $activity.bar -NoNewline
        start-sleep -Seconds 1
      }

      $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Host.UI.RawUI.CursorPosition.Y
      write-host $(" " * $activity.maxValue) -NoNewline
      $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Host.UI.RawUI.CursorPosition.Y
    }
    
    
# Launch Process        
    write-host $("-" * ($labelPaddingSize + $textPaddingSize + $lineBuffer)) -fore black -back darkgray 
    $timeStarted = Get-Date       
    write-fancystring -label "  Started"     -labelpadding $labelPaddingSize -text "$($timeStarted)"       -textSize $textPaddingSize  
    
    $ffmpegProcess = Start-Process -FilePath "ffmpeg.exe" -ArgumentList $ffmpegArgs -wait  #-UseNewEnvironment
        
    $timeCompleted = Get-Date
    write-fancystring -label "  Finished"     -labelpadding $labelPaddingSize -text "$($timeCompleted)"       -textSize $textPaddingSize 
    
    $totalTime = $timeCompleted - $timeStarted
    write-fancyString -label "  Total Time"   -labelPadding $labelPaddingSize -text "$("{0:hh\:mm\:ss\.fff}" -f $totaltime)" -textSize $textPaddingSize      
    write-host $("-" * ($labelPaddingSize + $textPaddingSize + $lineBuffer)) -fore black -back darkgray    

# Finish Up
    If ($showFFMEGArgsAtEnd) { write-host $ffmpegArgs}