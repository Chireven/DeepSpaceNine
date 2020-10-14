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