<#
.SYNOPSIS
Sets applications automatically in a grid layout on the screen

.DESCRIPTION

Sets applications in an automatic grid layout with predefined formats ('Vertical','Horizontal','Mosaic') using the Process object of the target applications
passed as a parameter(-Process) value and also brings the window(s) of the target application(s) to the foreground

A custom format can also be used to set the applications in a grid-layout on the display, by passing a custom string as a value to the parameter(-Custom).

Run below commands to see some examples

    Get-Help Set-GridLayout -Examples

.PARAMETER Process
Process(s) objects of the application(s) you want to set in a grid-layout

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
.PARAMETER IncludeSource
Switch parameter that includes the source process that executes the cmdlet in the th Grid-Layout.
.EXAMPLE
Get-Process notepad | Set-GridLayout

Capture all running notepad process objects and set them in 'Mosaic' (Default) grid-layout.

.EXAMPLE
$Process = @()
$Process = 1..3 | Foreach {(Start-Process Powershell.exe -WorkingDirectory c:\ -PassThru)}
$Process += 1 | Foreach {(Start-Process notepad.exe -PassThru)}
$Process += 1..5 | Foreach {(Start-Process cmd.exe -WorkingDirectory c:\ -PassThru)}

Get the Process objects of target applications,

Set-GridLayout -Process $Process

then run the below cmdlet to set them in 'Mosaic' (Default) grid-layout.


.EXAMPLE
Set-GridLayout $Process -layout Vertical

Use the 'Layout' parameter set the applications in a 'Vetrical' grid-layout


.EXAMPLE
Set-GridLayout -Process $Process -Layout Horizontal

Use the 'Layout' parameter set the applications in a 'Horizontal' grid-layout


.EXAMPLE
Set-GridLayout -Process $Process -Custom '**,**,*,****'

To set applications is custom grid-layout utilize the 'Custom' parameter and pass the custom layout as comma-separated string of '*' (Astrix)

Where '*' represent an application and ',' separates a row in the grid-layout"
So, with custom format = '***,**,*,****' in the grid layout
    Row1 has 3 applications
    Row2 has 2 applications
    Row3 has 1 applications
    Row4 has 4 applications

.EXAMPLE
Grid $Process

'grid' is an alias of cmdlet Set-GridLayout

.EXAMPLE
sgl $Process -Layout Vertical

'sgl' is an alias of cmdlet Set-GridLayout

.INPUTS
System.Diagnostics.Process

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
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Custom',
            ValueFromPipeline=$true,
            Position=0,
            HelpMessage = "Provide a System.Diagnostics.Process[] object"
            )]

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'default',
            ValueFromPipeline=$true,
            Position=0,
            HelpMessage = "Provide a System.Diagnostics.Process[] object"
        )] [System.Diagnostics.Process[]] $Process,
        [Parameter(ParameterSetName = 'default')] [ValidateSet('Vertical', 'Horizontal', 'Cascade', 'Mosaic')] [string] $Layout='Mosaic',
        [Parameter(ParameterSetName = 'Custom')]
        [ValidateScript({
                            If ($_ -match '^[-\w\s\*]+(?:,[-\w\s\*]+)*$'){$True}
                            Else {
                                Throw "`nAccepted custom grid format is something like -custom '***,**,*,****' `nhere '*' represent an application and ',' separates a row in the grid-layout"
                            }
        })] [String] $Custom,
        [Switch] $IncludeSource
    )

    Add-Type -AssemblyName System.Windows.Forms
    $Monitor = [System.Windows.Forms.Screen]::AllScreens.Where( {$_.Primary -eq $true }).Bounds
    $vRes = $monitor.Height -40  # -40 to make the edges appear above the task bar
    $hRes = $monitor.Width

    # Handling the Layout verbosity
    if($Custom){
        Write-Verbose "Setting Processes in Custom layout"
    }else{
        Write-Verbose "Setting Processes in $Layout layout"
    }

    # Handling the pipeline input with -IncludeSource switch
    if($IncludeSource -and $Input){ # when PipelineInput = $true AND $IncludeSource = $true
        $Process = $Input + $(Get-ParentProcess)
    }
    elseif($IncludeSource -and $Process){ # when PipelineInput = $false AND $IncludeSource = $true
        $Process = $Process + $(Get-ParentProcess)
    }
    elseif($Input -and -not $IncludeSource){ # when PipelineInput = $true AND $IncludeSource = false
        $Process = $Input
    }

    # when PipelineInput = $false AND $IncludeSource = false
    $Count = $Process.Count

    if($Layout -eq 'Vertical'){
        $Height = $vRes
        $Width = $hRes/$Count
        $Position = 0

        $Process | ForEach-Object {
            MoveApplication -Process $_ -X $Position -Y 0 -Height $Height -Width $Width
            $Position += $Width
        }
    }
    elseif($Layout -eq 'Horizontal') {
        $Height = $vRes/$Count
        $Width = $hRes
        $Position = 0

        $Process | ForEach-Object {
            MoveApplication -Process $_ -X 0 -Y $Position -Height $Height -Width $Width
            $Position += $Height
        }
    }
    elseif($Layout -eq 'Cascade') {
        $Height = $vRes/1.5
        $Width = $hRes/1.2
        $X = 40
        $y = 40

        $Process | ForEach-Object {
            MoveApplication -Process $_ -X $X -Y $Y -Height $Height -Width $Width
            $X += 25 ;  $Y += 25
        }
    }
    elseif ($Layout -eq 'Mosaic'){
        $PositionX = 0
        $PositionY = 0
        $Rows = 2 #Row more than 2 won't be able to display data properly, hence made it static
        $even = $Count%2 -eq 0

        If($even){
            $Col = 0
            $Columns = $Count/$Rows
            $Height = $vRes/$Rows
            $Width = $hRes/$Columns

            For($i =0 ;$i -lt $Count;$i++)
            {
                $Col++
                If($col -gt $Columns){
                    $PositionX = 0
                    $Col = 0
                    $PositionY = $Height
                }

                MoveApplication -Process $Process[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
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
                If($col -gt $Columns){
                    ++$Columns
                    $Width = $hRes/$Columns
                    $PositionX = 0
                    $Col = 0
                    $PositionY = $Height
                    MoveApplication -Process $Process[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
                }
                else {
                    MoveApplication -Process $Process[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
                }
                $PositionX += $Width
            }
        }
    }

    if ($Custom) {
        $AppsPlacedInGrid = 0
        $XCoordinate = 0 ; $YCoordinate = 0
        $RowArray = ($Custom -split ",").foreach({$_.ToCharArray().Where({$_ -eq '*'}) -join ''})
        $Ratio = Get-ApplicationRatio -String $Custom

        $NumberOfRows = $RowArray.count
        $NumberOfApps = ( ($RowArray -join '') -replace ",","").length
        $height = $vRes/$NumberOfRows

        if($NumberOfApps -ne $Process.Count){
            throw "Number of apps = $NumberOfApps in custom grid layout is not equal to the Process Id's passed = $($Process.Count)"
        }
        else{
            # Iterate through each row
            For($i=0;$i -lt $NumberOfRows;$i++){
                $NumberOfAppsInCurrentRow = $RowArray[$i].Length
                $RowApplicationRatioArray =  $Ratio[$i] -split ':'
                #$N = ($RowApplicationRatio -split ':' | Measure-Object -Sum).Sum
                $width = $hRes / $(($RowApplicationRatioArray | Measure-Object -Sum).Sum)
                #$width = $hRes / $NumberOfAppsInCurrentRow

                $j = 0 # counter to access application ratio per row

                # Iterate through ProcessID's
                $Process[$AppsPlacedInGrid..$($AppsPlacedInGrid+$NumberOfAppsInCurrentRow-1)] | ForEach-Object {
                    # Set application in a grid with coordinates, height and width
                    $CurrentAppplicationWidth = $Width * $RowApplicationRatioArray[$j] # base width multiplied by the ratio
                    MoveApplication -Process $_ -X $XCoordinate -Y $YCoordinate -Height $Height -Width $CurrentAppplicationWidth
                    $XCoordinate += $CurrentAppplicationWidth # move the XCoordinate of next app to the width of previous app
                    $AppsPlacedInGrid++
                    $j++ # Next application ratio in the Row
                }
                $YCoordinate += $height # Change YCoordinates for every row
                $XCoordinate = 0 # XCoordinate resets after every row
            }
        }
    }
}
