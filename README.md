PowerShell Gridify
-

**'Gridify'** module provides a cmdlet **'Set-GridLayout'** that can **resize** and **arrange** applications in an **automatic grid layout** with predefined formats using the ProcessID's of the target applications passed as a parameter(**-ProcessID**) value.

![](https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/GridLayout.png)

Cmdlet can automatically calculate the your screen resolution and set Applications in a neat grid layout in predefined/custom layout

Available predifined layout formats are

* **Mosaic** : This is the default layout of the cmdlet.

    ```PowerShell
    Set-GridLayout -ProcessID $ProcessID
    ```


    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Mosaic.gif" height="369" width="680" >

* **Vertical** : Vertical Layout sets all application vertically side by side in a single row to fit the screen resolution

    ```PowerShell
    Set-GridLayout -ProcessID $ProcessID -Layout Vertical
    ```

    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Vertical.gif">

* **Horizontal** : Horizontal Layout sets all application horizontally one over another in a single column to fit the screen resolution

    ```PowerShell
    Set-GridLayout -ProcessID $ProcessID -Layout Horizontal
    ```
    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/Horizontal.gif" height="369" width="680" >

and a customizable grid layout for special requirements

* **Custom** : A custom format can  be used to set the applications in a grid-layout on the screen, by passing a custom string as a value to the parameter(-Custom).

    <img src="https://raw.githubusercontent.com/PrateekKumarSingh/Gridify/master/Images/CustomMosaic.gif" height="369" width="680" >

    To set applications is custom grid-layout utilize the 'Custom' parameter and pass the custom layout as comma-separated string of * (Asterisk)

    Where **"*"** represent an application and **","** separates a row in the grid-layout
    So, with custom format like in the below example the grid layout would be like

        Row1 has 3 applications

        Row2 has 2 applications

        Row3 has 1 applications

        Row4 has 4 applications

    ```PowerShell
    Set-GridLayout -ProcessID $ProcessID -Custom '***,**,*,****'
    ```


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
