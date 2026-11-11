#!/usr/bin/env python3
"""Generates the pixel art for the Noita mod in noita/elemental_arts.

Writes the 16x16 spell icons (files/ui_gfx) and the projectile sprite sheets
with their sprite XML files (files/projectiles_gfx).

Usage: python3 tools/gen_noita_gfx.py
"""
import math
import os

from PIL import Image

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "noita", "elemental_arts", "files")
UI = os.path.join(ROOT, "ui_gfx")
GFX = os.path.join(ROOT, "projectiles_gfx")
MOD_GFX = "mods/elemental_arts/files/projectiles_gfx/"

T = (0, 0, 0, 0)


def from_rows(rows, palette):
    """Builds an image from text rows, one character per pixel."""
    w, h = len(rows[0]), len(rows)
    img = Image.new("RGBA", (w, h), T)
    for y, row in enumerate(rows):
        assert len(row) == w, (y, row)
        for x, ch in enumerate(row):
            img.putpixel((x, y), palette[ch])
    return img


def sprite_xml(name, frame_w, frame_h, frames, frame_wait, offset_x, offset_y):
    return f"""<Sprite
 filename="{MOD_GFX}{name}.png"
 offset_x="{offset_x}"
 offset_y="{offset_y}"
 default_animation="fly" >

 <RectAnimation
  name="fly"
  pos_x="0"
  pos_y="0"
  frame_count="{frames}"
  frame_width="{frame_w}"
  frame_height="{frame_h}"
  frame_wait="{frame_wait}"
  frames_per_row="{frames}"
  loop="1" >
 </RectAnimation>

</Sprite>
"""


def save_sheet(name, frames, frame_wait, offset_x, offset_y):
    w, h = frames[0].size
    sheet = Image.new("RGBA", (w * len(frames), h), T)
    for i, frame in enumerate(frames):
        sheet.paste(frame, (i * w, 0))
    sheet.save(os.path.join(GFX, name + ".png"))
    with open(os.path.join(GFX, name + ".xml"), "w", newline="\n") as f:
        f.write(sprite_xml(name, w, h, len(frames), frame_wait, offset_x, offset_y))


# --------------------------------------------------------------------------
# Spell icons (16x16)
# --------------------------------------------------------------------------

def icons():
    air = {".": T, "w": (245, 250, 250, 255), "g": (176, 200, 204, 255), "d": (110, 136, 146, 255)}
    from_rows([
        "................",
        "...dggggggggd...",
        "..gwwwwwwwwwwg..",
        "...dggggggggd...",
        "................",
        "....dgggggggd...",
        "...gwwwwwwwwg...",
        "....dggggggd....",
        "................",
        ".....dggggd.....",
        "....gwwwwwg.....",
        ".....dgggd......",
        "................",
        "......dgd.......",
        "......gwg.......",
        ".......d........",
    ], air).save(os.path.join(UI, "whirlwind.png"))

    water = {".": T, "h": (190, 232, 255, 255), "l": (92, 170, 255, 255), "b": (36, 104, 226, 255),
             "d": (20, 62, 160, 255), "s": (140, 205, 255, 255)}
    from_rows([
        "................",
        "..s..........s..",
        "......bbbb......",
        ".s..bblllbbb....",
        "...blhhllbbbb...",
        "..blhhlllbbbbd..",
        "..blhllbbbbbbd..",
        "..bllbbbbbbbdd..",
        "..bbbbbbbbbbdd..",
        "..bbbbbbbbbddd..",
        "...bbbbbbbddd...",
        "....bbbbdddd..s.",
        "......dddd......",
        ".s..............",
        "....s.....s.....",
        "................",
    ], water).save(os.path.join(UI, "tidal_orb.png"))

    earth = {".": T, "h": (214, 196, 150, 255), "m": (150, 130, 96, 255), "d": (92, 78, 60, 255),
             "k": (58, 50, 42, 255)}
    from_rows([
        "................",
        "............hh..",
        "...........hhm..",
        "..........hhmd..",
        ".........hhmd...",
        "........hmmd....",
        ".......hmmd.....",
        "......hmmd..k...",
        ".....hmmd.......",
        "....hmmd........",
        "...hmmd....k....",
        "..mmmd..........",
        ".kmdd...k.......",
        ".kkd............",
        "................",
        "................",
    ], earth).save(os.path.join(UI, "stone_lance.png"))

    fire = {".": T, "y": (255, 240, 150, 255), "o": (255, 160, 40, 255), "r": (226, 70, 24, 255),
            "d": (140, 30, 20, 255), "w": (255, 255, 235, 255)}
    from_rows([
        "................",
        "..........ooo...",
        ".........oyyyo..",
        "........oywyyo..",
        "........oyyyor..",
        ".........oooor..",
        "......rooor.....",
        ".....royor......",
        "....royor.......",
        "....royor.......",
        ".....royoor.....",
        "......rroyor....",
        "........royor...",
        ".......droor....",
        ".....ddrrr......",
        "................",
    ], fire).save(os.path.join(UI, "flame_serpent.png"))

    ice = {".": T, "w": (240, 250, 255, 255), "l": (160, 220, 255, 255), "b": (80, 160, 235, 255),
           "d": (40, 96, 180, 255)}
    from_rows([
        "................",
        "..........w.....",
        ".........wl.....",
        "........wlb..w..",
        ".......wlbd.wl..",
        "......wlbd.wlb..",
        ".....wlbd.wlbd..",
        "....wlbd.wlbd...",
        "...wlbd.wlbd....",
        "..wlbd.wlbd.....",
        "..lbd.wlbd..w...",
        "..bd.wlbd..wl...",
        "....wlbd..wlb...",
        "....lbd..wlbd...",
        "....bd...lbd....",
        "................",
    ], ice).save(os.path.join(UI, "glacial_shards.png"))

    up = {".": T, "w": (245, 250, 250, 255), "g": (176, 200, 204, 255), "d": (110, 136, 146, 255)}
    from_rows([
        "................",
        ".......ww.......",
        "......wwww......",
        ".....wwwwww.....",
        "....wwgwwgww....",
        "...ww.gwwg.ww...",
        "......gwwg......",
        "..d...gwwg...d..",
        "..g...gwwg...g..",
        "..g...gwwg...g..",
        "..d...dggd...d..",
        "................",
        "....d......d....",
        "....g..dd..g....",
        "....d..gg..d....",
        "................",
    ], up).save(os.path.join(UI, "updraft.png"))

    magma = {".": T, "k": (52, 40, 38, 255), "m": (96, 70, 60, 255), "r": (226, 70, 24, 255),
             "o": (255, 160, 40, 255), "y": (255, 240, 150, 255)}
    from_rows([
        "................",
        "..........o.....",
        ".....o...oy.....",
        "......mmmmo.....",
        "....mmmmrmmm....",
        "...mmmrromkmm...",
        "...mmrroymmkk...",
        "..mmmmroyormkk..",
        "..mmrmmoyrrmkk..",
        "..mrrommormkkk..",
        "..mmroyrmmkkkk..",
        "...mmoormkkkk...",
        "...mkmrmkkkkk...",
        "....kkkkkkkk....",
        "......kkkk......",
        "................",
    ], magma).save(os.path.join(UI, "magma_bomb.png"))

    # Elemental Attunement: four quadrants around a bright core.
    img = Image.new("RGBA", (16, 16), T)
    quads = {
        (0, 0): (236, 244, 244, 255),   # air
        (1, 0): (70, 150, 255, 255),    # water
        (0, 1): (150, 130, 96, 255),    # earth
        (1, 1): (240, 100, 30, 255),    # fire
    }
    for y in range(16):
        for x in range(16):
            dx, dy = x - 7.5, y - 7.5
            d = math.hypot(dx, dy)
            if abs(dx) < 1 or abs(dy) < 1:
                continue  # gap between the quadrants
            if 3.0 <= d <= 6.6:
                img.putpixel((x, y), quads[(int(dx > 0), int(dy > 0))])
            elif d < 1.6:
                img.putpixel((x, y), (255, 255, 255, 255))
    for x, y in ((7, 7), (8, 7), (7, 8), (8, 8)):
        img.putpixel((x, y), (255, 255, 255, 255))
    img.save(os.path.join(UI, "attunement.png"))


# --------------------------------------------------------------------------
# Projectile sprites
# --------------------------------------------------------------------------

def whirlwind():
    """A funnel, wide at the top, whose bands slide sideways frame by frame."""
    w, h, n = 19, 29, 4
    frames = []
    for f in range(n):
        img = Image.new("RGBA", (w, h), T)
        for y in range(h):
            half = 1.5 + 7.0 * (1.0 - y / (h - 1)) ** 0.8
            sway = math.sin(y * 0.45 + f * math.pi / 2) * 1.2
            cx = (w - 1) / 2 + sway * (y / h)
            for x in range(w):
                if abs(x - cx) > half:
                    continue
                band = math.sin((x - cx) * 0.9 + y * 0.9 - f * math.pi / 2)
                if band > 0.45:
                    col = (250, 252, 252, 235)
                elif band > -0.25:
                    col = (186, 208, 212, 170)
                else:
                    col = (120, 146, 156, 95)
                img.putpixel((x, y), col)
        frames.append(img)
    save_sheet("whirlwind", frames, 0.06, 9.5, 14.5)


def tidal_orb():
    """A water sphere with a highlight that wobbles."""
    s, n = 11, 4
    frames = []
    for f in range(n):
        img = Image.new("RGBA", (s, s), T)
        hx = 3.4 + math.cos(f * math.pi / 2) * 0.6
        hy = 3.2 + math.sin(f * math.pi / 2) * 0.6
        for y in range(s):
            for x in range(s):
                d = math.hypot(x - 5, y - 5)
                if d > 5.2:
                    continue
                hd = math.hypot(x - hx, y - hy)
                if d > 4.3:
                    col = (22, 66, 170, 255)
                elif hd < 1.3:
                    col = (210, 240, 255, 255)
                elif hd < 2.7:
                    col = (104, 180, 255, 255)
                else:
                    col = (40, 112, 230, 255)
                img.putpixel((x, y), col)
        frames.append(img)
    save_sheet("tidal_orb", frames, 0.08, 5.5, 5.5)


def stone_lance():
    """A chunky stone spearhead pointing right (the flight direction)."""
    pal = {".": T, "h": (214, 196, 150, 255), "m": (150, 130, 96, 255), "d": (92, 78, 60, 255)}
    img = from_rows([
        "...dmmmmmhh....",
        ".dmmmmmmmhhhh..",
        "dmmmmmmmmmhhhhh",
        ".dddmmmmmmmmh..",
        "...dddddmmm....",
    ], pal)
    save_sheet("stone_lance", [img], 0.2, 7.5, 2.5)


def flame_serpent():
    """A flickering flame head pointing right."""
    w, h, n = 14, 9, 4
    frames = []
    for f in range(n):
        img = Image.new("RGBA", (w, h), T)
        for y in range(h):
            for x in range(w):
                # teardrop: round at the right, tapering to a flickering tail
                t = x / (w - 1)
                half = 0.6 + 3.6 * t ** 0.7
                if x > w - 4:
                    half = math.sqrt(max(0.0, 3.6 ** 2 - (x - (w - 4.2)) ** 2))
                wave = math.sin(x * 0.9 + f * math.pi / 2) * (1.0 - t) * 1.3
                dy = abs(y - 4 - wave)
                if dy > half:
                    continue
                k = dy / max(half, 0.001)
                if t > 0.55 and k < 0.35:
                    col = (255, 255, 230, 255)
                elif k < 0.6:
                    col = (255, 214, 90, 255)
                elif k < 0.85:
                    col = (255, 140, 30, 255)
                else:
                    col = (220, 60, 20, 255)
                img.putpixel((x, y), col)
        frames.append(img)
    save_sheet("flame_serpent", frames, 0.05, 9.0, 4.5)


def glacial_shard():
    """A slim icicle pointing right (the flight direction)."""
    pal = {".": T, "w": (240, 250, 255, 255), "l": (160, 220, 255, 255), "b": (80, 160, 235, 255)}
    img = from_rows([
        "..bllllww....",
        "bllllwwwwwwww",
        "..bbblll.....",
    ], pal)
    save_sheet("glacial_shard", [img], 0.2, 6.5, 1.5)


def magma_bomb():
    """A dark rock whose glowing cracks pulse."""
    s, n = 11, 4
    frames = []
    for f in range(n):
        img = Image.new("RGBA", (s, s), T)
        glow = 0.5 + 0.5 * math.sin(f * math.pi / 2)
        for y in range(s):
            for x in range(s):
                d = math.hypot(x - 5, y - 5)
                if d > 5.2:
                    continue
                crack = math.sin(x * 1.7 + y * 0.6) * math.cos(y * 1.3 - x * 0.4)
                if d < 1.8 + glow:
                    col = (255, 240, 150, 255)
                elif crack > 0.45:
                    col = (255, int(120 + 70 * glow), 30, 255)
                elif crack > 0.2:
                    col = (226, 70, 24, 255)
                elif d > 4.2:
                    col = (52, 40, 38, 255)
                else:
                    col = (96, 70, 60, 255)
                img.putpixel((x, y), col)
        frames.append(img)
    save_sheet("magma_bomb", frames, 0.08, 5.5, 5.5)


if __name__ == "__main__":
    os.makedirs(UI, exist_ok=True)
    os.makedirs(GFX, exist_ok=True)
    icons()
    whirlwind()
    tidal_orb()
    stone_lance()
    flame_serpent()
    glacial_shard()
    magma_bomb()
    print("wrote", sorted(os.listdir(UI)), sorted(os.listdir(GFX)))
