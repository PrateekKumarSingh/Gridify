Function Set-ApplicationGrid {
    [CmdletBinding()]
    Param (
        [parameter(ValueFromPipelineByPropertyName = $True)]
        $ProcessID,
        [Double]$X,
        [Double]$Y,
        [Double]$Width,
        [Double]$Height
    )

    Begin
    {
        Try
        {
            [void][Window]
        }
        Catch
        {
            Add-Type @"
              using System;
              using System.Runtime.InteropServices;
              public class Window {
                [DllImport("user32.dll")]
                [return: MarshalAs(UnmanagedType.Bool)]
                public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

                [DllImport("User32.dll")]
                public extern static bool MoveWindow(IntPtr handle, int x, int y, int width, int height, bool redraw);
              }
              public struct RECT
              {
                public int Left;        // x Coordinate of upper-left corner
                public int Top;         // y Coordinate of upper-left corner
                public int Right;       // x Coordinate of lower-right corner
                public int Bottom;      // y Coordinate of lower-right corner
              }
"@
        }
    }
    Process
    {
        $Rectangle = New-Object RECT
        $Handle = (Get-Process -ID $ProcessID).MainWindowHandle
        $Return = [Window]::GetWindowRect($Handle, [ref]$Rectangle)
        If (-NOT $PSBoundParameters.ContainsKey('Width'))
        {
            $Width = $Rectangle.Right - $Rectangle.Left
        }
        If (-NOT $PSBoundParameters.ContainsKey('Height'))
        {
            $Height = $Rectangle.Bottom - $Rectangle.Top
        }
        If ($Return)
        {
            $Return = [Window]::MoveWindow($Handle, $x, $y, $Width, $Height, $True)
        }
        If ($PSBoundParameters.ContainsKey('Passthru'))
        {
            $Rectangle = New-Object RECT
            $Return = [Window]::GetWindowRect($Handle, [ref]$Rectangle)
            If ($Return)
            {
                $Height = $Rectangle.Bottom - $Rectangle.Top
                $Width = $Rectangle.Right - $Rectangle.Left
                $Size = New-Object System.Management.Automation.Host.Size -ArgumentList $Width, $Height
                $TopLeft = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Left, $Rectangle.Top
                $BottomRight = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Right, $Rectangle.Bottom
                If ($Rectangle.Top -lt 0 -AND $Rectangle.LEft -lt 0)
                {
                    Write-Warning "Window is minimized! Coordinates will not be accurate."
                }
                $Object = [pscustomobject]@{
                    ProcessID   = $ProcessID
                    Size        = $Size
                    TopLeft     = $TopLeft
                    BottomRight = $BottomRight
                }
                $Object.PSTypeNames.insert(0, 'System.Automation.WindowInfo')
                $Object
            }
        }
    }
}
