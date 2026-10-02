$root = "img"
if (-not (Test-Path $root)) {
    New-Item -ItemType Directory -Path $root | Out-Null
}

Add-Type -AssemblyName System.Drawing

$configs = @(
    @('#0f172a', '#1d4ed8', '#38bdf8', 'generated_1.jpg'),
    @('#0b1020', '#10b981', '#a7f3d0', 'generated_2.jpg')
)

foreach ($cfg in $configs) {
    $c1 = [System.Drawing.ColorTranslator]::FromHtml($cfg[0])
    $c2 = [System.Drawing.ColorTranslator]::FromHtml($cfg[1])
    $accent = [System.Drawing.ColorTranslator]::FromHtml($cfg[2])
    $name = $cfg[3]

    $bmp = New-Object System.Drawing.Bitmap(1200, 900)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear($c1)

    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        (New-Object System.Drawing.Rectangle(0,0,$bmp.Width,$bmp.Height)),
        $c1,
        $c2,
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $g.FillRectangle($brush, 0, 0, $bmp.Width, $bmp.Height)

    for ($i = 0; $i -lt 8; $i++) {
        $x = 90 + $i * 120
        $y = 110 + ($i % 3) * 150
        $w = 200 + ($i % 4) * 30
        $h = 160 + (($i + 1) % 5) * 25
        $shapeColor = if ($i % 2 -eq 0) { [System.Drawing.Color]::FromArgb(140, $accent.R, $accent.G, $accent.B) } else { [System.Drawing.Color]::FromArgb(70, 255, 255, 255) }
        $rounded = New-Object System.Drawing.Drawing2D.GraphicsPath
        $rec = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
        $diameter = 30
        $arc = [System.Drawing.Rectangle]::FromLTRB($rec.Left, $rec.Top, $rec.Left + $diameter, $rec.Top + $diameter)
        $rounded.AddArc($arc, 180, 90)
        $arc = [System.Drawing.Rectangle]::FromLTRB($rec.Right - $diameter, $rec.Top, $rec.Right, $rec.Top + $diameter)
        $rounded.AddArc($arc, 270, 90)
        $arc = [System.Drawing.Rectangle]::FromLTRB($rec.Right - $diameter, $rec.Bottom - $diameter, $rec.Right, $rec.Bottom)
        $rounded.AddArc($arc, 0, 90)
        $arc = [System.Drawing.Rectangle]::FromLTRB($rec.Left, $rec.Bottom - $diameter, $rec.Left + $diameter, $rec.Bottom)
        $rounded.AddArc($arc, 90, 90)
        $rounded.CloseFigure()
        $g.FillPath((New-Object System.Drawing.SolidBrush($shapeColor)), $rounded)
    }

    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(70, 255, 255, 255), 3)
    for ($i = -300; $i -lt 1400; $i += 80) {
        $g.DrawLine($pen, $i, 0, $i + 240, 900)
    }

    $circleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 255, 255, 255))
    $g.FillEllipse($circleBrush, 720, 120, 260, 260)

    $badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 17, 24, 39))
    $g.FillEllipse($badgeBrush, 760, 560, 220, 220)
    $checkPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 255), 18)
    $checkPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $checkPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($checkPen, 820, 660, 870, 710)
    $g.DrawLine($checkPen, 870, 710, 930, 620)

    $savePath = Join-Path $root $name
    $bmp.Save($savePath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    Write-Host "created $savePath"

    $g.Dispose()
    $bmp.Dispose()
}
