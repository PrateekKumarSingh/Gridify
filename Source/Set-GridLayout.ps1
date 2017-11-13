<#
.SYNOPSIS
Sets applications automatically in a grid layout on the screen

.DESCRIPTION

Sets applications in an automatic grid layout with predefined formats ('Vertical','Horizontal','Mosaic') using the ProcessID's of the target applications passed as a parameter(-ProcessID) value

A custom format can also be used to set the applications in a grid-layout on the display, by passing a custom string as a value to the parameter(-Custom).

Run below commands to see some examples

    Get-Help Set-GridLayout -Examples

.PARAMETER ProcessID
ProcessID(s) of the application(s) you want to set in a grid-layout

.PARAMETER Vertical
Switch to align application(s) in 'Vertical' grid-layout

.PARAMETER Horizontal
Switch to align application(s) in 'Horizontal' grid-layout

.PARAMETER Mosaic
Switch to align application(s) in 'Mosaic' grid-layout, that can best fit 'n' number of application(s) in rows

.PARAMETER Custom
Accepts a Customizable grid-layout format like '***,**,*,****'
Where '*' represent an application and ',' separates a row in the grid-layout"
So, with custom format = '***,**,*,****' in the grid layout
    Row1 has 3 applications
    Row2 has 2 applications
    Row3 has 1 applications
    Row4 has 4 applications

.EXAMPLE
$ProcessID = @()
$ProcessID = 1..3 | Foreach {(Start-Process Powershell.exe -WorkingDirectory c:\ -PassThru).ID}
$ProcessID += 1 | Foreach {(Start-Process notepad.exe -PassThru).ID}
$ProcessID += 1..5 | Foreach {(Start-Process cmd.exe -WorkingDirectory c:\ -PassThru).ID}

Get the Process ID's of target applications,

Set-GridLayout -ProcessID $ProcessID

then run the below cmdlet to set them in 'Mosaic' (Default) grid-layout.


.EXAMPLE
Set-GridLayout $ProcessID -layout Vertical

Use the 'Layout' parameter set the applications in a 'Vetrical' grid-layout


.EXAMPLE
Set-GridLayout -ProcessID $ProcessID -Layout Horizontal

Use the 'Layout' parameter set the applications in a 'Horizontal' grid-layout


.EXAMPLE
Set-GridLayout -ProcessID $ProcessID -Custom '**,**,*,****'

To set applications is custom grid-layout utilize the 'Custom' parameter and pass the custom layout as comma-separated string of '*' (Astrix)

Where '*' represent an application and ',' separates a row in the grid-layout"
So, with custom format = '***,**,*,****' in the grid layout
    Row1 has 3 applications
    Row2 has 2 applications
    Row3 has 1 applications
    Row4 has 4 applications

.EXAMPLE
Grid $ProcessID

'grid' is an alias of cmdlet Set-GridLayout

.EXAMPLE
sgl $ProcessID -Layout Vertical

'sgl' is an alias of cmdlet Set-GridLayout

.INPUTS
System.Int32

.OUTPUTS
None

.NOTES
Author          : Prateek Singh
TechnologyBlog  : http://Geekeefy.wordpress.com
Twitter         : http://twitter.com/SinghPrateik
Github          : http://github.com/PrateekKumarSingh
LinkedIn        : http://in.linkedIn.com/in/PrateekSingh1590
Reddit          : http://Reddit.com/user/PrateekSingh1590
Medium          : http://Medium.com/@SinghPrateik

#>
Function Set-GridLayout {
    [CmdletBinding(
        DefaultParameterSetName = 'default'
    )]
    [Alias("sgl", "grid")]
    Param(
        [Parameter(ParameterSetName = 'Layout', Position = 0)]
        [Parameter(ParameterSetName = 'Custom', Position = 0)]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'default',
            HelpMessage = "Provide a ProcessID of the application",
            Position = 0
        )] [int[]] $ProcessID,
        [Parameter(ParameterSetName = 'Layout', Position = 1)] [ValidateSet('Vertical', 'Horizontal', 'Mosaic')] [string] $Layout,
        [Parameter(ParameterSetName = 'Custom', Position = 1)]
        [ValidateScript({
                            If ($_ -match '^[-\w\s\*]+(?:,[-\w\s\*]+)*$'){$True}
                            Else {
                                Throw "`nAccepted custom grid format is something like -custom '***,**,*,****' `nhere '*' represent an application and ',' separates a row in the grid-layout"
                            }
        })] [String] $Custom
    )

    Begin{
        Add-Type -AssemblyName System.Windows.Forms
        $Monitor = [System.Windows.Forms.Screen]::AllScreens.Where( {$_.Primary -eq $true }).Bounds
        $vRes = $monitor.Height -40  # -40 to make the edges appear above the task bar
        $hRes = $monitor.Width
        $Count = $ProcessID.count

        # If no switch is selected mark 'Mosaic' as default choice
        if(-NOT $Layout){
            $Layout = 'Mosaic'
        }
        elseif($Custom){
            $Layout = 'Custom'
        }
    }
    Process{
        Write-Verbose "Setting Processes in $Layout layout"
        if($Layout -eq 'Vertical'){
            $Height = $vRes
            $Width = $hRes/$Count
            $Position = 0
            $ProcessID | ForEach-Object {
                MoveApplication -ProcessID $_ -X $Position -Y 0 -Height $Height -Width $Width
                $Position += $Width
            }
        }
        elseif($Layout -eq 'Horizontal') {
            $Height = $vRes/$Count
            $Width = $hRes
            $Position = 0
            $ProcessID | ForEach-Object {
                MoveApplication -ProcessID $_ -X 0 -Y $Position -Height $Height -Width $Width
                $Position += $Height
            }
        }
        elseif ($Layout -eq 'Mosaic'){
                $PositionX = 0
                $PositionY = 0
                $Rows = 2 #Row more than 2 won't be able to display data properly, hence made it static
                $even = If($Count%2 -eq 0){$true}else{$false}

                    If($even){
                        $Col = 0
                        $Columns = $Count/$Rows
                        $Height = $vRes/$Rows
                        $Width = $hRes/$Columns

                        For($i =0 ;$i -lt $Count;$i++)
                        {
                            $Col++
                            If($col -gt $Columns)
                            {
                                $PositionX = 0
                                $Col = 0
                                $PositionY = $Height
                                MoveApplication -ProcessID $ProcessID[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
                            }
                            else {
                                MoveApplication -ProcessID $ProcessID[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
                            }

                            $PositionX += $Width
                        }
                    }
                    else{
                        $Col = 0
                        $Columns = [math]::Floor($Count/$Rows)
                        $Height = $vRes/$Rows
                        $Width = $hRes/$Columns

                        For($i =0 ;$i -lt $Count;$i++)
                        {
                            $Col++
                            If($col -gt $Columns)
                            {
                                ++$Columns
                                $Width = $hRes/$Columns
                                $PositionX = 0
                                $Col = 0
                                $PositionY = $Height
                                MoveApplication -ProcessID $ProcessID[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
                            }
                            else {
                                MoveApplication -ProcessID $ProcessID[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
                            }

                            $PositionX += $Width
                        }
                    }
        }

            if ($Custom) {
                $AppsPlacedInGrid = 0
                $XCoordinate = 0 ; $YCoordinate = 0
                $CustomString = $Custom
                $Array = @()
                $NumberOfRows = ($Custom -split "," | Tee-Object -Variable Array).count
                $NumberOfApps = ($CustomString -replace ",","").length
                $height = $vRes/$NumberOfRows

                if($NumberOfApps -ne $ProcessID.Count){
                    throw "Number of apps = $NumberOfApps in custom grid layout is not equal to the Process Id's passed = $($ProcessID.Count)"
                }
                else{
                    For($i=0;$i -lt $NumberOfRows;$i++){
                        $NumberOfAppsInCurrentRow = $Array[$i].Length
                        $width = $hRes / $NumberOfAppsInCurrentRow
                        # Iterate through ProcessID's
                        $ProcessID[$AppsPlacedInGrid..$($AppsPlacedInGrid+$NumberOfAppsInCurrentRow-1)] | ForEach-Object {
                            # Set application in a grid with coordinates, height and width
                            MoveApplication -ProcessID $_ -X $XCoordinate -Y $YCoordinate -Height $Height -Width $Width
                            $XCoordinate += $width # move the XCoordinate of next app to the width of previous app
                            $AppsPlacedInGrid++
                        }
                        $YCoordinate += $height # Change YCoordinates for every row
                        $XCoordinate = 0 # XCoordinate resets after every row
                    }

                }

            }
        }

}
