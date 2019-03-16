﻿. "$PSScriptRoot\CredMan.ps1"
. "$PSScriptRoot\Utils.ps1"

$MMUrl = (Read-Host "1. Provide full address to mattermost web app").TrimEnd("/")
$Team = Read-Host "2. Provide the name of your MM team"
$User = Read-Host "3. Your MM user name"
Write-Host "4. Open Mattermost, expand the menu next to your profile picture and select `"Account settings`""
Write-Host "5. Open Security tab"
Write-Host "6. Click `"Personal Access Tokens`""
Write-Host "7. Create a new token with any description"
Write-Host "8. Copy `"Access Token`" value to clipboard"
$Token = Read-Host "9. Please provide this token now"

Write-Host
Write-Host "Ok, got everything. Working..."

Write-Host "Creating config..."
@(
    "# Generated by Setup.ps1",
    "`$apiUrl = `"$MMURL/api/v4`";",
    "`$team = `"$Team`";"
) | Out-File "Config.ps1" -Force

Write-Host "Adding token to Windows credential manager..."
Write-Creds "MM-Quickshare" $User $Token

$psPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$sendToDir = "${env:AppData}\Microsoft\Windows\SendTo"
$mainScriptPath = "$PSScriptRoot\UploadToMattermost.ps1"

Write-Host "Creating shortcuts in `"Send to`"..."
Write-Shortcut $sendToDir $psPath "$mainScriptPath -channelPicker" "Mattermost (channel)"
Write-Shortcut $sendToDir $psPath "$mainScriptPath -public" "Mattermost (public link)"

Write-Host "Setup complete. Press any key to exit..."
Read-Host