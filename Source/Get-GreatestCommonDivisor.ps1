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
