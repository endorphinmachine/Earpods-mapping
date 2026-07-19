# Adds F13 → composer.toggleVoiceDictation into Cursor User keybindings.json
# so the headset script can toggle voice without Ctrl+Shift+Space.

$ErrorActionPreference = "Stop"
$path = Join-Path $env:APPDATA "Cursor\User\keybindings.json"
$fragmentPath = Join-Path $PSScriptRoot "cursor-keybindings.fragment.json"

if (-not (Test-Path $path)) {
    Write-Error "Not found: $path"
}

$raw = Get-Content -LiteralPath $path -Raw -Encoding UTF8
# Strip // line comments for parse (Cursor allows comments in keybindings.json)
$stripped = [regex]::Replace($raw, '(?m)^\s*//.*$', '')
$existing = $stripped | ConvertFrom-Json
if ($null -eq $existing) { $existing = @() }
if ($existing -isnot [System.Array]) { $existing = @($existing) }

$has = $false
foreach ($b in $existing) {
    if ($b.key -eq "f13" -and $b.command -eq "composer.toggleVoiceDictation") {
        $has = $true
        break
    }
}

if ($has) {
    Write-Host "Already bound: f13 -> composer.toggleVoiceDictation"
    exit 0
}

$list = [System.Collections.Generic.List[object]]::new()
foreach ($b in $existing) { [void]$list.Add($b) }
[void]$list.Add([pscustomobject]@{
    key     = "f13"
    command = "composer.toggleVoiceDictation"
})

$json = $list | ConvertTo-Json -Depth 8
# ConvertTo-Json may emit a single object if one item; normalize to array
if ($list.Count -eq 1 -and -not $json.TrimStart().StartsWith("[")) {
    $json = "[$json]"
}

Set-Content -LiteralPath $path -Value ($json + "`n") -Encoding UTF8
Write-Host "Updated $path"
Write-Host "Added: f13 -> composer.toggleVoiceDictation"
Write-Host "Reload Cursor window if the binding does not take effect immediately."
