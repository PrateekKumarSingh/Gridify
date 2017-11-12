<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

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
An example

.NOTES
General notes
#>
Function Set-GridLayout {
    [CmdletBinding()]
    [Alias("sgl", "grid")]
    Param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $True,
            HelpMessage = "Provide a ProcessID of the application",
            Position = 0
        )] [String[]] $ProcessID,
        [Parameter(ParameterSetName = 'vertical')] [Switch] $Vertical,
        [Parameter(ParameterSetName = 'hosrizontal')] [Switch] $Horizontal,
        [Parameter(ParameterSetName = 'mosaic')] [Switch] $Mosaic,
        [Parameter(ParameterSetName = 'custom')]
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
        if(-NOT ($Vertical -or $Horizontal -or $Mosaic -or $Custom)){
            $Mosaic = $true
        }
    }
    Process{
    Foreach($ID in $ProcessID){

    }
        if($Vertical){
            $Height = $vRes
            $Width = $hRes/$Count
            $Position = 0
            $ProcessID | ForEach-Object{
                Set-ApplicationGrid -ProcessID $_ -X $Position -Y 0 -Height $Height -Width $Width
                $Position += $Width
            }
        }
        elseif($Horizontal) {
            $Height = $vRes/$Count
            $Width = $hRes
            $Position = 0
            $ProcessID | ForEach-Object{
                Set-ApplicationGrid -ProcessID $_ -X 0 -Y $Position -Height $Height -Width $Width
                $Position += $Height
            }
        }
        elseif($Mosaic){
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
                            Set-ApplicationGrid -ProcessID $ProcessID[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
                        }
                        else {
                            Set-ApplicationGrid -ProcessID $ProcessID[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
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
                            Set-ApplicationGrid -ProcessID $ProcessID[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
                        }
                        else {
                            Set-ApplicationGrid -ProcessID $ProcessID[$i] -X $PositionX -Y $PositionY -Height $Height -Width $Width
                        }

                        $PositionX += $Width
                    }
                }
        }
        elseif ($Custom) {
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
                        Set-ApplicationGrid -ProcessID $_ -X $XCoordinate -Y $YCoordinate -Height $Height -Width $Width
                        $XCoordinate += $width # move the XCoordinate of next app to the width of previous app
                        $AppsPlacedInGrid++
                    }
                    $YCoordinate += $height # Change YCoordinates for every row
                    $XCoordinate = 0 # XCoordinate resets after every row
                }

            }

        }
    }
    End{
    }
}

#$ProcessID = 1..10 | ForEach-Object { (Start-Process cmd -PassThru).ID }


#sgl -ProcessID $ProcessID #-Custom "*,*****,***,**"
#sgl $ProcessID -Custom ","

