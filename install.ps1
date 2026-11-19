# Blastkit one-liner installer (Windows):
#   powershell -c "irm https://raw.githubusercontent.com/evilsonnet/bulk-sender/main/install.ps1 | iex"
$ErrorActionPreference = "Stop"
$repo = "evilsonnet/bulk-sender"
$ver = "1.0.0"
$dir = Join-Path $env:LOCALAPPDATA "Blastkit"

Write-Host "-> Downloading Blastkit $ver ..."
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$zip = Join-Path $dir "sender.zip"
Invoke-WebRequest "https://github.com/$repo/releases/download/v$ver/sender-$ver-win64.zip" -OutFile $zip
Expand-Archive $zip -DestinationPath $dir -Force
Remove-Item $zip

Write-Host "-> Installed to $dir"
Write-Host ""
Write-Host "Blastkit is starting - it shows your MACHINE CODE on first launch."
Write-Host "Send that code back to the bot and your licence file lands right here."
Start-Process (Join-Path $dir "sender.exe")
