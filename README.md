PowerShell Gridify
-

'Gridify' module provides a cmdlet 'Set-GridLayout' that can resize and arrange applications in an automatic grid layout with predefined formats using the ProcessID's of the target applications passed as a parameter(-ProcessID) value.

Available Predifined formats are

* **Mosaic**

    ![](https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/GridLayout.png)

* **Vertical**
* **Horizontal**

and a customizable grid layout for special needs

* **Custom** : A custom format can  be used to set the applications in a grid-layout on the screen, by passing a custom string as a value to the parameter(-Custom).


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
{Prateekkumarsingh}/{gridify}#1
{Prateekkumarsingh}/{gridify}#2
