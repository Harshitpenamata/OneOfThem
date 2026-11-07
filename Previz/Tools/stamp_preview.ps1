# Burns slate info, scene/shot tag and subtitles onto captured previz frames.
# Usage: stamp_preview.ps1 -Src <frames .txt dir> -Out <png dir> -Version v005 -Subs <subs.csv> [-BlackFrom 1980] [-MasterOffset 4320]
param([string]$Src, [string]$Out, [string]$Version = 'v005', [string]$Subs, [int]$BlackFrom = 1980, [int]$MasterOffset = 4320,
      [string]$Header = 'ONE OF THEM   |   SEQ 03  PASS 1: REFUSAL   |   EXT. CRASH SITE - NIGHT', [string]$Scene = 'SCENE 04',
      [string]$ShotList = '')
# -ShotList "0:S05-01,216:S05-02,..." overrides the default SC04 shot starts.
Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force $Out | Out-Null
$shots = @(
 @(0,'S04-01'),@(120,'S04-02'),@(192,'S04-03'),@(264,'S04-04'),@(360,'S04-05'),@(432,'S04-06'),
 @(528,'S04-07'),@(600,'S04-08'),@(768,'S04-09'),@(912,'S04-10'),@(1056,'S04-11'),@(1128,'S04-12'),
 @(1296,'S04-13'),@(1464,'S04-14'),@(1560,'S04-15'),@(1680,'S04-16'),@(1800,'S04-17'),@(1896,'S04-18'),@(2016,'S04-19'))
if ($ShotList) { $shots = @($ShotList.Split(',') | ForEach-Object { $p = $_.Split(':'); ,@([int]$p[0], $p[1]) }) }
$subRows = Import-Csv $Subs
$font = New-Object Drawing.Font('Consolas', 15, [Drawing.FontStyle]::Bold)
$big = New-Object Drawing.Font('Consolas', 22, [Drawing.FontStyle]::Bold)
$subFont = New-Object Drawing.Font('Arial', 21, [Drawing.FontStyle]::Bold)
$brush = [Drawing.Brushes]::White
$shadow = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(170,0,0,0))
$subBg = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(150,0,0,0))
$fmt = New-Object Drawing.StringFormat; $fmt.Alignment = 'Center'
$i = 0
Get-ChildItem $Src -Filter 'f*.txt' | Sort-Object Name | ForEach-Object {
  $f = [int]($_.BaseName.Substring(1))
  $bytes = [Convert]::FromBase64String([IO.File]::ReadAllText($_.FullName))
  $ms = New-Object IO.MemoryStream(,$bytes)
  $img = [Drawing.Bitmap]::FromStream($ms)
  $w = $img.Width - ($img.Width % 2); $h = $img.Height - ($img.Height % 2)
  $bmp = New-Object Drawing.Bitmap($w, $h)
  $g = [Drawing.Graphics]::FromImage($bmp)
  $g.TextRenderingHint = 'AntiAlias'
  if ($f -ge $BlackFrom) { $g.Clear([Drawing.Color]::Black) } else { $g.DrawImage($img, 0, 0, $img.Width, $img.Height) }
  $cur = ($shots | Where-Object { $_[0] -le $f } | Select-Object -Last 1)
  $shot = $cur[1]; $local = $f - $cur[0]
  $mf = $MasterOffset + $f
  $tc = '{0:00}:{1:00}:{2:00}:{3:00}' -f [math]::Floor($mf/86400), ([math]::Floor($mf/1440) % 60), ([math]::Floor($mf/24) % 60), ($mf % 24)
  $g.FillRectangle($shadow, 0, 0, $w, 28); $g.FillRectangle($shadow, 0, $h-28, $w, 28)
  $g.DrawString($Header, $font, $brush, 10, 4)
  $g.DrawString("TC $tc   master f$mf   shot f$local   PREVIZ $Version (editor capture, 8fps)", $font, $brush, 10, $h-24)
  $tag = "$Scene   SHOT $shot"
  $sz = $g.MeasureString($tag, $big)
  $g.FillRectangle($shadow, $w - $sz.Width - 24, 36, $sz.Width + 14, $sz.Height + 4)
  $g.DrawString($tag, $big, [Drawing.Brushes]::Gold, $w - $sz.Width - 17, 38)
  $line = $subRows | Where-Object { [int]$_.start -le $f -and $f -lt [int]$_.end } | Select-Object -First 1
  if ($line) {
    $txt = ($line.speaker + ':  ' + $line.text)
    $ts = $g.MeasureString($txt, $subFont, $w - 120)
    $y = $h - 46 - $ts.Height
    $g.FillRectangle($subBg, ($w - $ts.Width)/2 - 12, $y - 4, $ts.Width + 24, $ts.Height + 8)
    $rect = [Drawing.RectangleF]::new([single]60, [single]$y, [single]($w - 120), [single]($ts.Height + 4))
    $g.DrawString($txt, $subFont, [Drawing.Brushes]::White, $rect, $fmt)
  }
  $bmp.Save((Join-Path $Out ('img{0:00000}.png' -f $i)), [Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose(); $img.Dispose(); $ms.Dispose()
  $i++
}
"stamped $i"
