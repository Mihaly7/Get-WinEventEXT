Function Get-WinEventEXT
{    
    
# Parameters   
        Param
        (
         [Parameter(Mandatory=$true)]
            [string]$Logname = (Read-Host "Logname (* for wildcard)"), 
            [string]$Date = (Read-Host  "Start date (format should be MM/DD/YYYY)"), 
            [string]$Time = (Read-Host "Start time (HH:MM:SS)"),
            [string]$Duration  = (Read-Host  "Duration (HH:MM:SS)"),

            
        [Parameter(Mandatory=$false)]
            [string]$Path = (Get-Location).path,
            [string]$Message = $null,
            [array]$EventId = $null,
            [array]$ProviderName = $null,
            [bool]$FilterInformation = $false,
            [bool]$Detailed = $false,
            [bool]$Backwards = $false
        )    
    
# Date and time conversion
$StartTime = $Date+" "+$Time | Get-date
If ($Backwards -ne $false)
    {
    $M = "-"
    }
Else 
    {
    $M = $null
    }

#Duration calculator

If ($Duration -like "*:*")
    {
    $CDuration = $Duration.split(':')
    $endTime = ($StartTime).AddSeconds(($m+(new-timespan -hour $CDuration[0] -Minutes $CDuration[1] -Seconds $CDuration[2]).TotalSeconds).tostring())
    }

Else
    {
    $endTime = ($StartTime).Addhours($m+($Duration).tostring())
    }

#$Backward Check

If ($backwards -eq $true) 
    {
    $sTime = $endTime
    $eTime = $StartTime
    }
Else
    {
    $sTime = $StartTime
    $eTime = $endTime
    }    



# Default event level: Informational included
# Information level filter
$maxlevel = 4

if ($Filterinformation -eq $true)
    {
        [int]$maxlevel = 3 
    }

# Gather evtx files

$Evtxfiles = Get-ChildItem -path $path -filter "$LogName*" -Include *.evtx -Recurse


# Read logs

    foreach($Evtxfile in $Evtxfiles)
    {

# Show actual log file

    ((Get-WinEvent -Path $Evtxfile.FullName -MaxEvents 10 ) | Where machinename -ne $null | select Machinename,logname)[0]
    
    Write-Host "Log location: $Evtxfile `n"


#create Hashtable

$Filter = @{Path=$Evtxfile.FullName;Starttime = $sTime; Endtime = $eTime}

If ($EventId -ne $null)
    {
    $Filter = $Filter+@{ID= $EventID}
    }
If ($ProviderName -ne $null)
    {
    $Filter = $Filter+@{ProviderName= $ProviderName}
    }



# Read log

            $output =  Get-winevent -FilterHashtable $Filter -ErrorAction SilentlyContinue  | where {$_.Level -gt 0 -and $_.Level -le $maxlevel}   
                        
# Filter by message
            
            $output = $output | where message -like "*$message*"

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


