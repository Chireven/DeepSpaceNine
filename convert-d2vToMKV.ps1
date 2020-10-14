[CmdletBinding()]
param(
    [Parameter()][string]$avsFile
)

If (!(Test-Path $avsFile -ErrorAction SilentlyContinue)) {
    Write-Error "File Not Found: $($avsFile)" -ErrorAction Stop
}

$mkvName = $avsFile.Replace(".avs",".mkv")

If (Test-Path $mkvName -ErrorAction SilentlyContinue) {
    Write-Error "Destination File Exists: $($mkvName)" -ErrorAction Stop
}

d:\Video\Tools\ffmpeg\x86\ffmpeg.exe  -i $avsFile -c copy $mkvName