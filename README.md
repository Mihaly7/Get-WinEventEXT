# Get-WinEventEXT
Original idea came from https://github.com/jopalhei.
A small extension to Powershell Cmd-Let Get-WinEvent. That short script helps to read events easily from command line, with setting time windows and eventIDs. 

Example usage:

Get-WinEventEXT -Path D:\!Cases\zzzzz\2021-09-22\info\ -Eventlogname *system* -Date 09/25/2021 -Time 21:00:00 -Duration 00:10:00 -FilterInformation 0 -Backwards 0 -Detailed 1

Parameters:

-Path : Folder where to search for events, search is recursive.
-Eventlogname : log file's name accepts wildcards like *clustering-operational*
-Date : Day of start the search
-Time : Time of start
-Duration: time window of search single digit is hours or you can use HH:MM:SS format
-FilterInformation: Filters out informational events.
-Backwards : Search backwards from time of start
-Detailed : Show meassage details with format-list
