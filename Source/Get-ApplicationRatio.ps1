Function Get-GreatestCommonDivisor
{
    [alias('gcd')]
    param(
        [System.Collections.ArrayList] $Numbers
    )

    $Minimum = ($Numbers | Measure-Object -Minimum).Minimum
    foreach ($Remainder in $Numbers.foreach( { $_ % $Minimum }) )
    {
        # if remainder is greater than 0, that means a number is not completely divisible
        if ($Remainder -ne 0)
        {
            return 1 # in that case, greatest common divisor would be 1
        }
    }
    return $Minimum # if there are no remainders
}

Function Get-ApplicationRatio{
    [cmdletbinding()]
    [Alias('Ratio')]
    Param($String)
    $Rows = $String.split(',')
    for($i=0;$i -lt $Rows.count;$i++){
        $Row = ($Rows[$i]).split('*')
        $Row = $Row[0..$($Row.count-2)]
        $Ratio = Foreach($Item in $Row){
            if($Item -eq ''){
                "1"
            }else{
                $item
            }
        }
        $GreatestCommonDivisor = Get-GreatestCommonDivisor $Ratio
        $Ratio.ForEach({$_/$GreatestCommonDivisor}) -join ':'
        Write-Verbose $("Row{0} application ratio is {1}" -f ($i+1),($Ratio -join ':') )
    }
}

