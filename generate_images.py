from PIL import Image, ImageDraw, ImageColor
import os

root = 'img'
os.makedirs(root, exist_ok=True)

configs = [
    (('#0f172a', '#1d4ed8', '#38bdf8'), 'generated_1.jpg'),
    (('#0b1020', '#10b981', '#a7f3d0'), 'generated_2.jpg'),
]

for colors, name in configs:
    img = Image.new('RGB', (1200, 900), colors[0])
    draw = ImageDraw.Draw(img)

    for y in range(img.height):
        ratio = y / img.height
        r1, g1, b1 = ImageColor.getrgb(colors[0])
        r2, g2, b2 = ImageColor.getrgb(colors[1])
        r = int(r1 + (r2 - r1) * ratio)
        g = int(g1 + (g2 - g1) * ratio)
        b = int(b1 + (b2 - b1) * ratio)
        draw.line((0, y, img.width, y), fill=(r, g, b))

    for i in range(8):
        x = 100 + i * 120
        y = 120 + (i % 3) * 150
        w = 180 + (i % 4) * 30
        h = 140 + ((i + 1) % 5) * 25
        color = colors[2] if i % 2 == 0 else '#ffffff'
        overlay = Image.new('RGBA', img.size, (0, 0, 0, 0))
        odraw = ImageDraw.Draw(overlay)
        odraw.rounded_rectangle((x, y, x + w, y + h), radius=30, fill=color + (60 if i % 2 == 0 else 30,))
        img = Image.alpha_composite(img.convert('RGBA'), overlay).convert('RGB')

    glow = Image.new('RGBA', img.size, (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(glow)
    for radius in range(400, 20, -20):
        gdraw.ellipse((300 - radius, 180 - radius, 900 + radius, 720 + radius), outline=(255, 255, 255, 10))
    img = Image.alpha_composite(img.convert('RGBA'), glow).convert('RGB')

    stripe = Image.new('RGBA', img.size, (0, 0, 0, 0))
    sdraw = ImageDraw.Draw(stripe)
    for i in range(-300, 1400, 80):
        sdraw.polygon([(i, 0), (i + 200, 0), (i - 100, img.height), (i - 300, img.height)], fill=(255, 255, 255, 20))
    img = Image.alpha_composite(img.convert('RGBA'), stripe).convert('RGB')

    panel = Image.new('RGBA', (500, 300), (255, 255, 255, 40))
    pdraw = ImageDraw.Draw(panel)
    pdraw.rounded_rectangle((0, 0, 500, 300), radius=30, outline=(255, 255, 255, 110), width=3)
    img.paste(panel.convert('RGB'), (350, 280), panel)

    path = os.path.join(root, name)
    img.save(path, 'JPEG', quality=92)
    print('created', path)
