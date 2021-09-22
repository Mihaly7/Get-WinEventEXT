Function Get-WinEventEXT
{    
    
# Parameters   
        Param
        (
         [Parameter(Mandatory=$true)]
            [string]$Eventlogname = (Read-Host "Logname (* for wildcard)"), 
            [string]$Date = (Read-Host  "Start date (format should be MM/DD/YYYY)"), 
            [string]$Time = (Read-Host "Start time (HH:MM:SS)"),
            [string]$Duration  = (Read-Host  "Duration (HH:MM:SS)"),

            
        [Parameter(Mandatory=$false)]
            [string]$Path = (Get-Location).path,
            [array]$EventId,
            [bool]$FilterInformation = $false,
            [bool]$Detailed = $false
        )    
    
# Date and time conversion
$StartTime = $Date+" "+$Time | Get-date
If ($Duration -like "*:*")
    {
    $CDuration = $Duration.split(':')
    $endTime = ($StartTime).Add((new-timespan -hour $CDuration[0] -Minutes $CDuration[1] -Seconds $CDuration[2]).Ticks)
    }
Else
    {
    $endTime = ($StartTime).Addhours($Duration)
    }



# Default event level: Informational included
$maxlevel = 4

if ($Filterinformation -eq $true)
    {
        [int]$maxlevel = 3 
    }

# Gather evtx files

$Evtxfiles = Get-ChildItem -path $path -filter "$EventLogName*" -Include *.evtx -Recurse

# Read logs

    foreach($Evtxfile in $Evtxfiles)
    {

# Show actual log file

    ((Get-WinEvent -Path $Evtxfile.FullName -MaxEvents 10 ) | Where machinename -ne $null | select Machinename,logname)[0]
    
    Write-Host "Log location: $Evtxfile `n"

# Read log

        if ($EventId.count -ge 1)
            {
            $output =  Get-winevent -FilterHashtable @{Path=$Evtxfile.FullName;
            Id=$EventId;
            StartTime = $starttime;
            EndTime = $endTime} -ErrorAction SilentlyContinue  | where {$_.Level -gt 0 -and $_.Level -le $maxlevel } 
            }

        else
            {
            $output = Get-winevent -FilterHashtable @{Path=$Evtxfile.FullName;
            StartTime = $starttime;
            EndTime = $endTime} -ErrorAction SilentlyContinue  |  where {$_.Level -gt 0 -and $_.Level -le $maxlevel }
            }
# Write log entries to host
    
        if ($detailed -ne $false)
            {
            $output | Sort-Object TimeCreated | Format-List Timecreated,Providername,Id,Leveldisplayname,Message 
            }
        else
            {
            $output | Sort-Object TimeCreated | Format-Table Timecreated,Providername,Id,Leveldisplayname,Message 
            }
    }
}


