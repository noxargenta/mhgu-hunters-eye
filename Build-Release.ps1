$ErrorActionPreference = 'Stop'
$version = '0.1.0'
& (Join-Path $PSScriptRoot 'Verify-Patch.ps1')
$dist = Join-Path $PSScriptRoot 'dist'
New-Item -ItemType Directory -Path $dist -Force | Out-Null
$archive = Join-Path $dist "MHGU-Hunters-Eye-v$version.zip"
$inputs = @(
    (Join-Path $PSScriptRoot 'mod/MHGU-MapReveal-ExeFS'),
    (Join-Path $PSScriptRoot 'README.md'),
    (Join-Path $PSScriptRoot 'CHANGELOG.md'),
    (Join-Path $PSScriptRoot 'LICENSE')
)
Compress-Archive -LiteralPath $inputs -DestinationPath $archive -Force
$hash = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
"$hash  $([IO.Path]::GetFileName($archive))" | Set-Content -LiteralPath (Join-Path $dist 'SHA256SUMS.txt') -Encoding ascii
Write-Output "Release archive: $archive"
