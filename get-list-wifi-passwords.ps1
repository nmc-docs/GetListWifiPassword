$wifiProfiles = netsh wlan show profiles | Select-String -Pattern "All User Profile" | ForEach-Object { $_.ToString().Split(":")[1].Trim() }

$passwordList = @()
Write-Host "Getting list Wifi Passwords..."
foreach ($profile in $wifiProfiles) {
    $profileInfo = netsh wlan show profile name="$profile" key=clear
    $password = $profileInfo | Select-String -Pattern "Key Content" | ForEach-Object { $_.ToString().Split(":")[1].Trim() }
    $passwordList += [PSCustomObject]@{
        ProfileName = $profile
        Password = $password
    }
}

if ($passwordList) {
    Write-Host "List of saved Passwords:"
    $passwordList | Format-Table -AutoSize
} else {
    Write-Host "No saved Passwords found."
}
