$ErrorActionPreference = 'Stop'
$path = Join-Path $PSScriptRoot 'mod/MHGU-MapReveal-ExeFS/exefs/MapReveal-1.4.0.pchtxt'
$text = [IO.File]::ReadAllText($path)
if ($text -notmatch '(?m)^@nsobid-FB08F1D20FD1204FE7070672777F869B\s*$') { throw 'Unexpected build ID' }
if ($text -notmatch '(?m)^@flag offset_shift 0x100\s*$') { throw 'Missing NSO header shift' }
$entries = [regex]::Matches($text, '(?m)^([0-9A-F]{8}) ([0-9A-F]{8})\s*$')
if ($entries.Count -ne 2) { throw 'Expected exactly two patch entries' }
$expected = @{ '0061CC94' = [Convert]::ToUInt32('E3A00001',16); '0061BAD0' = [Convert]::ToUInt32('E1A00000',16) }
foreach ($entry in $entries) {
    $address = $entry.Groups[1].Value
    $hex = $entry.Groups[2].Value
    [uint32]$word = 0
    for ($i = 0; $i -lt 4; $i++) { $word = $word -bor ([uint32][Convert]::ToByte($hex.Substring($i * 2, 2), 16) -shl ($i * 8)) }
    if (-not $expected.ContainsKey($address) -or $word -ne $expected[$address]) { throw "Unexpected instruction at $address" }
    $expected.Remove($address)
}
if ($expected.Count -ne 0) { throw 'Missing patch address' }
Write-Output 'Static checks passed. In-game behavior is NOT verified.'