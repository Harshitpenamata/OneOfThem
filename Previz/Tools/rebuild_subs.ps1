# Rebuilds each sequence's subtitle and cue CSVs from Unreal's actual dialogue sections
# (Saved/timeline_dump.csv: END/SHOT/DX rows). Text comes from the previous subs by matching
# each clip's old cue start; overrides supply new or rewritten lines. SFX caption rows are dropped.
param([string]$Dump = 'A:\MovieProjects\OneOfThem\Saved\timeline_dump.csv', [string]$Dir = 'A:\MovieProjects\OneOfThem\Previz\Dialogue')
$map = @{ SQ01 = 'SQ01_Warning'; SQ03 = 'SQ03_Pass1'; SQ04 = 'SQ04_Pass2'; SQ05 = 'SQ05_Pass3'; SQ06 = 'SQ06_Pass4'; SQ07 = 'SQ07_Return' }
$over = @{
  'S04-13B_VIKRAM_01' = @('VIKRAM (breaking)', "They're my brothers.")
  'S05-14_VIKRAM_01'  = @('VIKRAM (clueless)', 'They all?')
  'S07-20_VIKRAM_01'  = @('VIKRAM (softly)', 'Rohan.')
  'S07-28_OLDMAN_01'  = @('OLD MAN (gentle smile)', "Don't you know who I am yet?")
  'S05-05_VIKRAM_01'  = @('VIKRAM', 'Call an ambulance.')
}
$rows = Import-Csv $Dump -Header kind, sq, a, b, name
foreach ($sq in $map.Keys) {
  $base = $map[$sq]
  $oldSubs = @(Import-Csv "$Dir\${base}_subs.csv")
  $oldCues = @(Import-Csv "$Dir\${base}_cues.csv")
  Copy-Item "$Dir\${base}_subs.csv" "$Dir\${base}_subs_preScript2.csv" -Force
  Copy-Item "$Dir\${base}_cues.csv" "$Dir\${base}_cues_preScript2.csv" -Force
  $cueStart = @{}; foreach ($c in $oldCues) { $cueStart[$c.file.Trim('"')] = [int]$c.start }
  $subAt = @{}; foreach ($s in $oldSubs) { if ($s.speaker -ne 'SFX' -and $s.speaker -ne 'RADIO') { $subAt[[int]$s.start] = $s } }
  $shots = $rows | Where-Object { $_.kind -eq 'SHOT' -and $_.sq -eq $sq } | Sort-Object { [int]$_.a }
  $dx = $rows | Where-Object { $_.kind -eq 'DX' -and $_.sq -eq $sq -and $_.name -ne 'None' } | Sort-Object { [int]$_.a }
  $newSubs = @(); $newCues = @(); $miss = @()
  foreach ($d in $dx) {
    $file = $d.name -replace '^DX_(S\d\d)_([0-9A-Z]+)_', '$1-$2_'
    $cueFile = if ($cueStart.ContainsKey($file)) { $file } elseif ($cueStart.ContainsKey("${file}_distant")) { "${file}_distant" } else { $file }
    $start = [int]$d.a; $end = [int]$d.b + 8
    $shot = ($shots | Where-Object { [int]$_.a -le $start } | Select-Object -Last 1).name
    if ($over.ContainsKey($file)) { $spk = $over[$file][0]; $txt = $over[$file][1] }
    elseif ($cueStart.ContainsKey($cueFile) -and $subAt.ContainsKey($cueStart[$cueFile])) { $spk = $subAt[$cueStart[$cueFile]].speaker; $txt = $subAt[$cueStart[$cueFile]].text }
    else { $miss += $file; continue }
    $newSubs += [pscustomobject]@{ start = $start; end = $end; shot = $shot; speaker = $spk; text = $txt }
    $newCues += "$start,$cueFile"
  }
  $out = @('start,end,shot,speaker,text') + ($newSubs | ForEach-Object { '{0},{1},{2},"{3}","{4}"' -f $_.start, $_.end, $_.shot, $_.speaker, $_.text })
  $out | Set-Content "$Dir\${base}_subs.csv" -Encoding ascii
  (@('start,file') + $newCues) | Set-Content "$Dir\${base}_cues.csv" -Encoding ascii
  "{0}: {1} lines{2}" -f $sq, $newSubs.Count, $(if ($miss) { ' | missing text: ' + ($miss -join ' ') } else { '' })
}

