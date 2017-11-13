PowerShell Gridify
-

'Gridify' module provides a cmdlet 'Set-GridLayout' that can resize and arrange applications in an automatic grid layout with predefined formats using the ProcessID's of the target applications passed as a parameter(-ProcessID) value.

Cmdlet can automatically calculate the your screen resolution and set Applications in a neat grid layout in predefined/custom layout

Available predifined layout formats are

* **Mosaic**

    ![](https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/GridLayout.png)

    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Mosaic.gif" align="left" height="500" width="400" >
    ![](https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Mosaic.gif = 600x1000)

* **Vertical**

    ![](https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Vertical.gif = 500x400)

* **Horizontal**

    ![](https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Horizontal.gif = 500x400)

and a customizable grid layout for special requirements

* **Custom** : A custom format can  be used to set the applications in a grid-layout on the screen, by passing a custom string as a value to the parameter(-Custom).

    ![](https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/CustomMosaic.gif = 500x400)

Help Information
-
Run below commands to see some examples
```PowerShell
Get-Help Set-GridLayout -Examples
```


Installation
-
#### [PowerShell V5](https://www.microsoft.com/en-us/download/details.aspx?id=50395) and Later
You can install the `Gridify` module directly from the PowerShell Gallery

* [Recommended] Install to your personal PowerShell Modules folder
```PowerShell
Install-Module Gridify -scope CurrentUser
```

![](https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Installation_v5.jpg)

* [Requires Elevation] Install for Everyone (computer PowerShell Modules folder)
```PowerShell
Install-Module Gridify
```

#### PowerShell V4 and Earlier
To install to your personal modules folder run:

```PowerShell
iex (new-object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Install.ps1')
```

Known Issues
-
Prateekkumarsingh/gridify#1

Prateekkumarsingh/gridify#2
