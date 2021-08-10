####################################################################
# Name: FixDefaultOUs.ps1                                          #
# Purpose:                                                         #
#    - Convert Computers Folder to Computers OU and set as         #
#        default Computers location                                #
#    - Rename Users Folder to Default_Users                        #
#    - Create Users OU and set as default Users location           #
# Notes:                                                           #
#   - Created ChrisLee - 2021Aug09                                 #
####################################################################

# Region - Gather Domain information
   $Domain = (Get-ADDomain).DistinguishedName
   $OldComputers = (Get-ADDomain).ComputersContainer
   $OldUsers = (Get-ADDomain).UsersContainer
# Endregion

# Region - Fix Computers
    Try {
        New-ADOrganizationalUnit -Name temp -DisplayName temp -ProtectedFromAccidentalDeletion:$false
        $Temp = Get-ADObject -LDAPFilter "(DisplayName=temp)"
        Get-ADObject -SearchBase $OldComputers -Filter {Objectclass -eq "computer"} | Move-ADObject -TargetPath $Temp
        Redircmp $Temp
        Get-ADObject $OldComputers | Remove-ADObject -Confirm:$false
        New-ADOrganizationalUnit -Name Computers -DisplayName Computers
        $NewComputers = Get-ADObject -LDAPFilter "(DisplayName=Computers)"
        Redircmp $NewComputers
        Write-Host -ForegroundColor Green "Successfully Converted Computers Folder to OU"
    } Catch {
        Write-Host -ForegroundColor Red "Failed to Convert Computers Folder to OU"
    }
# Endregion

# Region - Rename Users Folder
    Try {
        Redirusr $Temp #Have to change default UsersContainer value prior to rename
        Rename-ADObject -Identity $OldUsers -NewName Default_Users
        Write-Host -ForegroundColor Green "Successfully Renamed Users Folder to Defualt_Users Folder"
    } Catch {
        Write-Host -ForegroundColor Red "Failed to Rename Users Folder to Defualt_Users Folder"
    }
# Endregion

# Region - Create Users OU
    Try {
        New-ADOrganizationalUnit -Name Users -DisplayName Users
        $NewUsers = Get-ADObject -LDAPFilter "(DisplayName=Users)"
        Redirusr $NewUsers
        Write-Host -ForegroundColor Green "Successfully Created Users OU"
    } Catch {
        Write-Host -ForegroundColor Red "Failed to Create Users OU"
    }
# Endregion

# Region - Clean Up
    Try {
        Get-ADObject $Temp | Remove-ADObject -Confirm:$false
        Write-Host -ForegroundColor Green "Successfully Removed temp OU"
    } Catch {
        Write-Host -ForegroundColor Red "Failed to Remove temp OU"
    }
# Endregion