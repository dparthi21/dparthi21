$username= $TaskUsername
$password= $TaskPassword

#get date with -1 hour because task should run again..
$taskDate = (get-date).AddHours(-1).ToString("hh:mm")

#Name of Task Scheduler
$taskName = "BI Task Report Refresh"

#Get the Name of Task Scheduler present.
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }

#Get the Status of our Task Scheduler.
$taskStatus = (Get-ScheduledTask | Where TaskName -eq $taskName ).State

#Main Program stars here..
#Checking the Status is Present on same name.
if($taskExists) {
   Write-Output "Existing Task is found -> $taskName"
   
#if the Existing Task is running on the same name. will be stopped here, until the status is get Ready.
   if($taskStatus -eq "Running"){
    Write-Output "Existing Task is running.."
    do {
        Write-Output "Trying to stop it.."
        Start-Sleep -Seconds 1
        Stop-ScheduledTask -TaskName $taskName
        $taskStatus = (Get-ScheduledTask | Where TaskName -eq $taskName ).State
        Write-Output "current status:- $taskStatus"
        } until ($taskStatus -eq "Ready")
        }

#Updating the password because user will be expired in every 90 days and Run the Task.
   Write-Output "Updating user's password from octopus to $taskName task.."
   SCHTASKS /CHANGE /TN $taskName /RU $username /RP $password
   sleep -Seconds 10
   Write-Output "Running the $taskName..."
   Start-ScheduledTask -TaskName $taskName

} else {

#Create the task scheduler only to run on Week days with admin username and password then run the Task scheduler
   Write-Output "Create the new task scheduler $taskName" 
   SCHTASKS /CREATE /SC ONCE /TN $taskName /TR "powershell.exe F:\Bi_Scripts\TaskReport\AutomationScript\Task_Report_Automation_Script.ps1" /RU $username /RP $password /ST $taskDate
   Write-Output "Running the $taskName..."
   Start-ScheduledTask -TaskName $taskName
}	