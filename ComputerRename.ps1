####################################################################
# Name: ComputerRename.ps1                                         #
# Purpose:                                                         #
#    - Prompt for desired computer name                            #
#    - Set new name and restart                                    #
# Notes:                                                           #
#   - Created ChrisLee - 2021Aug09                                 #
####################################################################

#Region - Prompt for name and set
    $NewName = Read-Host "Enter desired system name"
    Try {
        #Rename-Computer -newname $NewName -Restart:$false
        Write-Host -ForegroundColor Green "Successfully Renamed to $NewName, restarting in 10 seconds."
        shutdown -r -t 10
    } Catch {
        Write-Host -ForegroundColor Red "Failed to Rename to $NewName"
    }
#EndRegion