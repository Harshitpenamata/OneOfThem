# Fits raw viewport captures (base64 .txt, any width) to 1306x690 with a 2.39:1 crop so every pass
# matches, then pads black frames up to -Length. Usage: fit_frames.ps1 -Src <raw dir> -Out <dir> -Length 2040
param([string]$Src, [string]$Out, [int]$Length, [int]$Step = 3)
Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force $Out | Out-Null
$n = 0
Get-ChildItem $Src -Filter 'f*.txt' | ForEach-Object {
  $im = [Drawing.Bitmap]::FromStream((New-Object IO.MemoryStream(,[Convert]::FromBase64String([IO.File]::ReadAllText($_.FullName)))))
  $cw = [Math]::Min($im.Width, [int]($im.Height * 2.39)); $cx = [int](($im.Width - $cw) / 2)
  $o = New-Object Drawing.Bitmap 1306, 690; $g = [Drawing.Graphics]::FromImage($o); $g.Clear([Drawing.Color]::Black); $g.InterpolationMode = 'HighQualityBicubic'
  $h = [int](1306 * $im.Height / $cw)
  $g.DrawImage($im, (New-Object Drawing.Rectangle 0, ([int]((690 - $h) / 2)), 1306, $h), (New-Object Drawing.Rectangle $cx, 0, $cw, $im.Height), [Drawing.GraphicsUnit]::Pixel)
  $ms = New-Object IO.MemoryStream; $o.Save($ms, [Drawing.Imaging.ImageFormat]::Png)
  [IO.File]::WriteAllText((Join-Path $Out $_.Name), [Convert]::ToBase64String($ms.ToArray()))
  $g.Dispose(); $o.Dispose(); $im.Dispose(); $n++
}
$last = Get-ChildItem $Out -Filter 'f*.txt' | Sort-Object Name | Select-Object -Last 1
$lastF = [int]$last.BaseName.Substring(1)
for ($f = $lastF + $Step; $f -lt $Length; $f += $Step) { Copy-Item $last.FullName (Join-Path $Out ('f{0:00000}.txt' -f $f)) }
"fitted $n"
