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
