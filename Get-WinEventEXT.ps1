Function Get-WinEventEXT
{    
    
   
        Param
        (
         [Parameter(Mandatory=$true)]
            [string]$Eventlogname = (Read-Host "Logname (* for wildcard)"), 
            [string]$date = (Read-Host  "Start date (format should be MM/DD/YYYY)"),
            [string]$starttime = (Read-Host "Start time (H:MM:SS)"),
            [string]$endtime  = (Read-Host  "End time (H:MM:SS)"),

            
        [Parameter(Mandatory=$false)]
            [string]$path = (Get-Location).path,
            [array]$EventId
            #[string]$Level
        )    
    

$startdate = $date+" "+$startime
$enddate = $date+" "+$endtime
$starttime = Get-Date $startdate
$endTime = Get-Date $enddate

####################################################

$Evtxfiles = Get-ChildItem -path $path -filter "$EventLogName*" -Include *.evtx -Recurse

    foreach($Evtxfile in $Evtxfiles)
    {

    ((Get-WinEvent -Path $Evtxfile.FullName -MaxEvents 10 ) | Where machinename -ne $null | select Machinename,logname)[0]
    Write-Host "Log location: $Evtxfile"

        if ($EventId.count -ge 1)
        {
            Get-winevent -FilterHashtable @{Path=$Evtxfile.FullName;
            Id=$EventId;
            StartTime = $starttime;
            EndTime = $endTime} -ErrorAction SilentlyContinue  | where {$_.Level -gt 0 -and $_.Level -le 3} | Sort-Object TimeCreated | ft 

        }
        elseif($eventid -eq "All")
        {
            Get-winevent -FilterHashtable @{Path=$Evtxfile.FullName;
            StartTime = $starttime;
            EndTime = $endTime} -ErrorAction SilentlyContinue  | Sort-Object TimeCreated | ft 
        }


        else
        {
            Get-winevent -FilterHashtable @{Path=$Evtxfile.FullName;
            StartTime = $starttime;
            EndTime = $endTime} -ErrorAction SilentlyContinue  | select TimeCreated, ID, LevelDisplayName, Message -Unique | Sort-object TimeCreated | ft 
        }
    }
}