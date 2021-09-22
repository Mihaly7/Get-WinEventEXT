# Get-WinEventEXT
Original idea came from https://github.com/jopalhei.
A small extension to Powershell Cmd-Let Get-WinEvent. That short script helps to read events easily from command line, with setting time windows and eventIDs. 

Example usage:
Get-WinEventEXT -Eventlogname *replica-admin* -date 09/17/2021 -starttime 0:00:00 -endtime 23:00:00 -EventId 12000
