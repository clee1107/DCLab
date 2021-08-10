# DCLab
PowerShell Scripts for Active Directory Domain Controller in lab.

# Table of Contents

## FixDefaultOUs.ps1

    + Converts Computers Folder to OU
    + Renames current Users Folder to Default_Users
    + Creates new Users OU and sets as default OU for Users

## DCNetworkPrep.ps1

    + Display list of Interfaces for selection (Use InterfaceIndex for selection)
    + Prompt for IP configuration settings
    + Set DNS for local host (127.0.0.1)

## ComputerRename.ps1

    + Prompt for new computer name
    + Set name and restart