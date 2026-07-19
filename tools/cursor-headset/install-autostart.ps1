#Requires -Version 5.1
<#
.SYNOPSIS
  Create a current-user Startup shortcut for cursor-headset.ahk (no admin).
#>
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ahkScript = Join-Path $scriptDir "cursor-headset.ahk"

if (-not (Test-Path -LiteralPath $ahkScript)) {
    Write-Error "Not found: $ahkScript"
}

$ahkExeCandidates = @(
    (Join-Path $env:LOCALAPPDATA "Programs\AutoHotkey\v2\AutoHotkey64.exe"),
    (Join-Path $env:LOCALAPPDATA "Programs\AutoHotkey\v2\AutoHotkey32.exe"),
    (Join-Path ${env:ProgramFiles} "AutoHotkey\v2\AutoHotkey64.exe"),
    (Join-Path ${env:ProgramFiles} "AutoHotkey\v2\AutoHotkey32.exe"),
    (Join-Path ${env:ProgramFiles} "AutoHotkey\AutoHotkey64.exe")
)
$ahkExe = $ahkExeCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

$startup = [Environment]::GetFolderPath("Startup")
$shortcutPath = Join-Path $startup "Cursor Headset Mapping.lnk"

$wsh = New-Object -ComObject WScript.Shell
$sc = $wsh.CreateShortcut($shortcutPath)
if ($ahkExe) {
    $sc.TargetPath = $ahkExe
    $sc.Arguments = "`"$ahkScript`""
} else {
    # Fall back to file association (.ahk → AutoHotkey).
    $sc.TargetPath = $ahkScript
    $sc.Arguments = ""
}
$sc.WorkingDirectory = $scriptDir
$sc.WindowStyle = 7  ; minimized
$sc.Description = "Apple headset media keys → Cursor Agent (AutoHotkey v2)"
$sc.Save()

Write-Host "Startup shortcut created:"
Write-Host "  $shortcutPath"
if ($ahkExe) {
    Write-Host "Target: $ahkExe `"$ahkScript`""
} else {
    Write-Host "Target: $ahkScript (via .ahk association)"
    Write-Host "Tip: install AutoHotkey v2 if the shortcut does not launch the script."
}
Write-Host "Remove the shortcut from the Startup folder to disable autostart."
