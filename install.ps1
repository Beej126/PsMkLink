$download = "https://raw.githubusercontent.com/Beej126/PsMkLink/master/mklink.psm1"
$command = "mklink"

$modulesPath = ($env:psmodulepath -split ";")[0]
$installPath = "$modulesPath\$command"

Write-Host "Creating module directory"
New-Item -Type Container -Force -path $installPath | out-null

Write-Host "Downloading and installing"
(new-object net.webclient).DownloadString($download) | Out-File "$installPath`.psm1" 

Write-Host "Installed!"
Write-Host 'Use "Import-Module $command" and then "$command"'
