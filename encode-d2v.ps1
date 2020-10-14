[CmdletBinding()]
param(
  [Parameter(Mandatory=$false)] [string]$inputPath,
  [Parameter(Mandatory=$false)] [string]$inputFile,
  [Parameter(Mandatory=$false)] [string]$outFile,
  [Parameter(Mandatory=$false)] [switch]$showFFMEGArgsAtEnd,
  [Parameter(Mandatory=$false)] [string]$ffmpegx86 = "D:\Video\Tools\ffmpeg\x86\ffmpeg.exe",
  [Parameter(Mandatory=$false)] $startTime,
  [Parameter(Mandatory=$false)] $stopTime
)

Import-Module .\_Shared\fancystrings.psm1 


#Initialize Options
    $labelPaddingSize = 20
    $textPaddingSize  = 80
    $lineBuffer       = 6

# Normalize and Calculate Variables, define 
    # Script Counters
        $global:lineItem  = 0
        
# Filaenames
    If (!($inputFile)) {
        $inputFile        = Join-Path -Path ($inputPath) -ChildPath "$( split-path -Path $inputPath -Leaf).avs"
    } Else {
        $inputPath = Split-Path $inputFile -Parent
    }

    If (!($outFile)) {
        If ($inputFile) { 
            $outFile = $inputFile.replace(".avs",".mkv")
        } Else {
            $filename   = "$( Split-Path -Path $inputPath -leaf).mkv"
            $outFile    = Join-Path -Path $inputPath -ChildPath $filename
        }
    }

    $ffmpegArgs = ""  
    If ($startTime) { $ffmpegArgs = $ffmpegArgs + " -ss $($startTime)" }
    If ($stopTime)  { $ffmpegArgs = $ffmpegArgs + " -t $($stopTime)"   }
    $ffmpegArgs = $ffmpegArgs + " -i `"$($inputFile)`""
    $ffmpegArgs = $ffmpegArgs + " -c copy  `"$($outFile)`""

# Display Our details:
    Clear-Host 
    write-host $("-" * ($labelPaddingSize + $textPaddingSize + $lineBuffer)) -fore black -back darkgray
    write-fancystring -label "  Encode D2V"     -labelpadding $labelPaddingSize -text "Convert D2V to MKV using AVS Script"      -textSize $textPaddingSize 
    write-host $("-" * ($labelPaddingSize + $textPaddingSize + $lineBuffer)) -fore black -back darkgray

    write-fancystring -label "  Input Filename"     -labelpadding $labelPaddingSize -text $inputFile        -textSize $textPaddingSize  
    write-fancystring -label "  Output Filename"    -labelpadding $labelPaddingSize -text $outFile          -textSize $textPaddingSize
    If ($starTime) { write-fancystring -label "  Start Time"         -labelpadding $labelPaddingSize -text $startTime        -textSize $textPaddingSize }
    If ($stopTime) { write-fancystring -label "  Stop Time"          -labelpadding $labelPaddingSize -text $stopTime         -textSize $textPaddingSize }
    write-fancystring -label "  FFMPEG x86"         -labelpadding $labelPaddingSize -text $ffmpegx86        -textSize $textPaddingSize

      If (!(Test-Path $ffmpegx86)) { Write-Error "FFMPEG x86 not found!" -ErrorAction Stop}
    write-fancystring -label "  FFMPEG Arguments"   -labelpadding $labelPaddingSize -text $ffmpegArgs       -textSize $textPaddingSize
     
# Launch Process        
    write-host $("-" * ($labelPaddingSize + $textPaddingSize + $lineBuffer)) -fore black -back darkgray 
    $timeStarted = Get-Date       
    write-fancystring -label "  Started"     -labelpadding $labelPaddingSize -text "$($timeStarted)"       -textSize $textPaddingSize  

    $ffmpegProcess = Start-Process -FilePath $ffmpegx86 -ArgumentList $ffmpegArgs -wait  #-UseNewEnvironment
    
    $timeCompleted = Get-Date
    write-fancystring -label "  Finished"     -labelpadding $labelPaddingSize -text "$($timeCompleted)"       -textSize $textPaddingSize 

    $totalTime = $timeCompleted - $timeStarted
    write-fancyString -label "  Total Time"   -labelPadding $labelPaddingSize -text "$("{0:hh\:mm\:ss\.fff}" -f $totaltime)" -textSize $textPaddingSize      
    write-host $("-" * ($labelPaddingSize + $textPaddingSize + $lineBuffer)) -fore black -back darkgray    

# Finish Up
    If ($showFFMEGArgsAtEnd) { write-host $ffmpegArgs}