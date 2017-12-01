PowerShell Gridify
-

**'Gridify'** module provides a cmdlet **'Set-GridLayout'** that can **resize** and **arrange** applications in an **automatic grid layout** with predefined formats using the Processes of the target applications passed as a parameter(**-Process**) value.

![](https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/mosaic2.jpg)

Cmdlet can automatically calculate the your screen resolution and set Applications in a neat grid layout in predefined/custom layout

Available predifined layout formats are

* **Mosaic** : This is the default layout of the cmdlet.

    ```PowerShell
    Set-GridLayout -Process $Process
    ```


    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Mosaic.gif">

* **Vertical** : Vertical Layout sets all application vertically side by side in a single row to fit the screen resolution

    ```PowerShell
    Set-GridLayout -Process $Process -Layout Vertical
    ```

    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Vertical.gif">

* **Horizontal** : Horizontal Layout sets all application horizontally one over another in a single column to fit the screen resolution

    ```PowerShell
    Set-GridLayout -Process $Process -Layout Horizontal
    ```
    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Horizontal.gif">
* **Cascade** : Cascade Layout sets all application in a step like layout, such that the next one overlaping the previous one

    ```PowerShell
    Set-GridLayout -Process $Process -Layout Cascade
    ```
    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Cascade.gif">

and a customizable grid layout for special requirements

* **Custom** : A custom format can  be used to set the applications in a grid-layout on the screen, by passing a custom string as a value to the parameter(-Custom).

    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/CustomMosaic.gif">

    To set applications is custom grid-layout utilize the 'Custom' parameter and pass the custom layout as comma-separated string of * (Asterisk)

    Where **"*"** represent an application and **","** separates a row in the grid-layout

    So, with custom format like in the below example the grid layout would be like
    ```
        Row1 has 3 applications
        Row2 has 2 applications
        Row3 has 1 applications
        Row4 has 4 applications
    ```

    ```PowerShell
    Set-GridLayout -Process $Process -Custom '***,**,*,****'
    ```

    This parameter also enables you to define width-ratio of applications in every row, to give the ability to customize application width sizes as per the requirement.

    ```PowerShell
    # to define a ratio preceede the asterix of that application with a number
    # such as -custom "*2*3*" is 1:2:3
    $process |Set-GridLayout -Custom "***,***,***"
    $process |Set-GridLayout -Custom "*2*2**,*2*,3***"
    $process |Set-GridLayout -Custom "*3*2**,*2*,3***" -Verbose
    VERBOSE: Setting Processes in Custom layout
    VERBOSE: Row1 application ratio is 1:3:2:1
    VERBOSE: Row2 application ratio is 1:2
    VERBOSE: Row3 application ratio is 3:1:1
    ```

    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/CustomRatio.gif">


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

What's New
-
**12/02/2017**
* Accepts process[] objects as an input from the pipeline
* '-IncludeSource' switch to add source process to the grid layout
* '-Layout Cascade' included
* Ability to define application width ratios in a -Custom layout

Help Information
-
Run below commands to see some examples
```PowerShell
Get-Help Set-GridLayout -Examples
```


Known Issues
-

Issue # | Short Description
---------|----------
![Issue#1](https://github.com/PrateekKumarSingh/Gridify/issues/1) | Fixed Application window size
![Issue#2](https://github.com/PrateekKumarSingh/Gridify/issues/2) | Limited only to the Primary monitor
