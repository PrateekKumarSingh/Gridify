<#
.SYNOPSIS
Returns parent process of a process ID

.DESCRIPTION
A recursive function that finds top parent process of a process ID in the process tree .

.PARAMETER ID
Process ID to find the parent process

.EXAMPLE
Get-ParentProcess -ID $PID
#>
Function Get-ParentProcess{
    Param(
        $ID = $PID
    )
    $Process = Get-WmiObject Win32_Process -Filter $("ProcessId = '{0}'" -f $ID)

    if(get-process -id $Process.ParentProcessId -ErrorAction SilentlyContinue) {
        $parent = Get-ParentProcess($Process.parentProcessid)

        # if no parents found further then print the [System.Diagnostics.Process] object
        if(-not $parent){
            Get-Process -Id $Process.ProcessId
        }

        return $parent
    }
}
