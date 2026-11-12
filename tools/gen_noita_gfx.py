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

    bolt = {".": T, "w": (255, 255, 235, 255), "y": (255, 232, 90, 255), "o": (240, 170, 40, 255),
            "c": (150, 160, 176, 255), "d": (96, 104, 122, 255)}
    from_rows([
        "................",
        "....cccccccc....",
        "..ccccccccccdd..",
        ".cccccccccccddd.",
        "..dddcccddddd...",
        "........yy......",
        ".......yww......",
        "......ywwy......",
        ".....ywwwyyy....",
        "....yyyywwy.....",
        ".......wwy......",
        "......ywy.......",
        ".....ywo........",
        ".....yo.........",
        "....oo..........",
        "................",
    ], bolt).save(os.path.join(UI, "thunderstrike.png"))

    # Frost Nova: an eight-pointed snowflake burst.
    img = Image.new("RGBA", (16, 16), T)
    for i in range(1, 8):
        col = (240, 250, 255, 255) if i < 4 else ((160, 220, 255, 255) if i < 6 else (80, 160, 235, 255))
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            for ox, oy in ((0, 0), (-1, 0), (0, -1), (-1, -1)):
                img.putpixel((8 + ox + dx * i - (dx > 0) * 0, 8 + oy + dy * i), col)
        if i < 6:
            for dx, dy in ((1, 1), (-1, 1), (1, -1), (-1, -1)):
                px = 7 + (dx > 0) + dx * (i - 1) if i > 0 else 7
                py = 7 + (dy > 0) + dy * (i - 1) if i > 0 else 7
                img.putpixel((px, py), col)
    img.save(os.path.join(UI, "frost_nova.png"))

    pillar = {".": T, "y": (255, 240, 150, 255), "o": (255, 160, 40, 255), "r": (226, 70, 24, 255),
              "d": (140, 30, 20, 255), "w": (255, 255, 235, 255), "k": (70, 56, 50, 255)}
    from_rows([
        "................",
        ".......r........",
        "......ror..r....",
        "......roor......",
        ".....rooor......",
        ".....royor......",
        "....rroyoor.....",
        "....royyyor.....",
        "....roywyor.....",
        "....roywyor.....",
        "...rroywyorr....",
        "...royywyyor....",
        "...roywwwyor....",
        "..drroywyorrd...",
        ".kkkkkkkkkkkkk..",
        "................",
    ], pillar).save(os.path.join(UI, "fire_pillar.png"))

    # Gale Barrier: a broken ring of wind around a small figure.
    img = Image.new("RGBA", (16, 16), T)
    for a in range(0, 360, 3):
        if (a // 45) % 2 == 1 and a % 45 > 30:
            continue  # gaps make the ring read as moving air
        r = 6.4
        px = int(round(7.5 + math.cos(math.radians(a)) * r))
        py = int(round(7.5 + math.sin(math.radians(a)) * r))
        img.putpixel((px, py), (245, 250, 250, 255) if a % 90 < 50 else (176, 200, 204, 255))
    for px, py in ((7, 5), (8, 5), (7, 6), (8, 6)):
        img.putpixel((px, py), (176, 200, 204, 255))
    for py in range(7, 11):
        for px in (7, 8):
            img.putpixel((px, py), (110, 136, 146, 255))
    img.save(os.path.join(UI, "gale_barrier.png"))

    mud = {".": T, "h": (150, 120, 80, 255), "m": (104, 80, 52, 255), "d": (66, 50, 34, 255),
           "k": (42, 32, 24, 255), "s": (190, 160, 110, 255)}
    from_rows([
        "................",
        "................",
        "......s.........",
        ".....shm....s...",
        ".....hmm........",
        "..s...m...sh....",
        "..........hmm...",
        "...........m....",
        "....hhhhhhhh....",
        "..hhhmmmmmmmhh..",
        ".hhmmmsmmmmmmmh.",
        ".hmmmmmmmdmmmmd.",
        ".mmmdmmmmmmmmdd.",
        ".dmmmmmmddmmddk.",
        "..dddddddddddk..",
        "................",
    ], mud).save(os.path.join(UI, "quagmire.png"))

    stone = {".": T, "h": (214, 196, 150, 255), "m": (150, 130, 96, 255), "d": (92, 78, 60, 255),
             "k": (58, 50, 42, 255), "g": (255, 232, 120, 255), "w": (255, 255, 235, 255)}
    from_rows([
        "................",
        "......g..g......",
        "....g......g....",
        "......hhhh......",
        ".....hhmmmd.....",
        "....hhmmmmdd....",
        "....hmmgwmmd....",
        "....hmgwmwgd....",
        "....hmgwmwgd....",
        "....hmmgwmmd....",
        "....hmmmmmdd....",
        "....mmmmmmdd....",
        "...kmmmmmdddk...",
        "..kkkdddddkkkk..",
        "................",
        "................",
    ], stone).save(os.path.join(UI, "waystone.png"))

    # Avalanche: three snowballs of growing size along an arc.
    img = Image.new("RGBA", (16, 16), T)
    for cx, cy, r in ((2.5, 4.0, 1.4), (6.0, 7.0, 2.3), (11.0, 10.5, 3.9)):
        for y in range(16):
            for x in range(16):
                d = math.hypot(x - cx, y - cy)
                if d <= r:
                    if d > r - 0.9 and (x > cx or y > cy):
                        col = (130, 180, 225, 255)
                    elif x < cx and y < cy:
                        col = (255, 255, 255, 255)
                    else:
                        col = (214, 236, 250, 255)
                    img.putpixel((x, y), col)
    img.save(os.path.join(UI, "avalanche.png"))

    # Crescent Gale: a crescent blade with a curved return path.
    img = Image.new("RGBA", (16, 16), T)
    for y in range(16):
        for x in range(16):
            outer = math.hypot(x - 8.0, y - 7.5)
            inner = math.hypot(x - 5.2, y - 7.5)
            if outer <= 6.2 and inner > 5.4:
                col = (245, 250, 250, 255) if outer > 5.0 else (176, 200, 204, 255)
                img.putpixel((x, y), col)
    for x, y in ((3, 13), (5, 14), (7, 14), (9, 14), (2, 11)):
        img.putpixel((x, y), (110, 136, 146, 255))
    img.save(os.path.join(UI, "crescent_gale.png"))

    # Bubble Prison: a bubble with a small dark figure inside.
    img = Image.new("RGBA", (16, 16), T)
    for y in range(16):
        for x in range(16):
            d = math.hypot(x - 7.5, y - 7.5)
            if 5.6 < d <= 6.9:
                img.putpixel((x, y), (120, 200, 255, 255) if (x + y) > 12 else (210, 240, 255, 255))
            elif d <= 5.6:
                img.putpixel((x, y), (60, 130, 220, 70))
    for x, y in ((4, 4), (5, 3), (4, 5)):
        img.putpixel((x, y), (255, 255, 255, 255))
    for x, y in ((7, 6), (8, 6), (7, 7), (8, 7), (6, 8), (7, 8), (8, 8), (9, 8), (7, 9), (8, 9), (7, 10), (8, 10), (6, 11), (9, 11)):
        img.putpixel((x, y), (40, 50, 80, 255))
    img.save(os.path.join(UI, "bubble_prison.png"))

    storm = {".": T, "w": (255, 255, 255, 255), "l": (170, 215, 255, 255), "b": (80, 150, 240, 255),
             "d": (40, 80, 170, 255), "y": (255, 232, 90, 255)}
    from_rows([
        "................",
        "......dbbd......",
        "....dbllllbd....",
        "...dbllwwllbd...",
        "..dbllwwwwllbd..",
        "..bllwwyywwllb..",
        "..bllwyyyywllb..",
        "..bllwwyywwllb..",
        "..dbllwwwwllbd..",
        "...dbllwwllbd...",
        "....dbllllbd....",
        "......dbbd......",
        ".y....y..y....y.",
        "...y...yy...y...",
        ".....y....y.....",
        "................",
    ], storm).save(os.path.join(UI, "gathering_storm.png"))

    # Ember Halo: three embers on a faint ring around a small figure.
    img = Image.new("RGBA", (16, 16), T)
    for a in range(0, 360, 6):
        px = int(round(7.5 + math.cos(math.radians(a)) * 6.0))
        py = int(round(7.5 + math.sin(math.radians(a)) * 6.0))
        img.putpixel((px, py), (140, 60, 30, 255))
    for a in (-90, 30, 150):
        cx = 7.5 + math.cos(math.radians(a)) * 6.0
        cy = 7.5 + math.sin(math.radians(a)) * 6.0
        for y in range(16):
            for x in range(16):
                d = math.hypot(x - cx, y - cy)
                if d <= 1.0:
                    img.putpixel((x, y), (255, 240, 150, 255))
                elif d <= 2.1:
                    img.putpixel((x, y), (255, 150, 40, 255))
    for px, py in ((7, 6), (8, 6), (7, 7), (8, 7), (7, 8), (8, 8), (7, 9), (8, 9)):
        img.putpixel((px, py), (190, 170, 150, 255))
    img.save(os.path.join(UI, "ember_halo.png"))

    rip = {".": T, "h": (190, 232, 255, 255), "l": (92, 170, 255, 255), "b": (36, 104, 226, 255),
           "d": (20, 62, 160, 255), "k": (150, 130, 96, 255)}
    from_rows([
        "................",
        "................",
        "..........hll...",
        "........hllbbl..",
        "......hllbb..bl.",
        "....hllbb.....b.",
        "..hhlbb.....kkb.",
        ".hllb......kkkb.",
        "..hhlbb.....kkb.",
        "....hllbb.....b.",
        "......hllbb..bd.",
        "........hllbbd..",
        "..........ldd...",
        "................",
        "................",
        "................",
    ], rip).save(os.path.join(UI, "riptide.png"))

    quake = {".": T, "h": (214, 196, 150, 255), "m": (150, 130, 96, 255), "d": (92, 78, 60, 255),
             "k": (58, 50, 42, 255), "y": (255, 232, 120, 255), "w": (255, 255, 235, 255)}
    from_rows([
        "................",
        ".......ww.......",
        ".......ww.......",
        "......wyyw......",
        "......wyyw......",
        ".....hhmmdd.....",
        ".....hmmmdd.....",
        "......mmdd......",
        ".y.....dd.....y.",
        "..y..........y..",
        "y..y.y.yy.y.y..y",
        ".hhhmmm..mmmddd.",
        "hhmmmmm.k.mmmmdd",
        "mmmmmdd.kk.mmddd",
        "ddddddk.kkk.dddk",
        "................",
    ], quake).save(os.path.join(UI, "earthshaker.png"))

    sent = {".": T, "w": (240, 250, 255, 255), "l": (160, 220, 255, 255), "b": (80, 160, 235, 255),
            "d": (40, 96, 180, 255)}
    from_rows([
        "................",
        ".......w........",
        "......wwl.......",
        ".....wwllb......",
        ".....wllbb...l..",
        "....wwllbbd.....",
        "....wllbbbd..w.l",
        "....wllbbbd.....",
        "....wllbbbd..l..",
        ".....llbbd......",
        ".....lbbdd..w...",
        "......bbd.......",
        ".......d......l.",
        "................",
        "....ddddddd.....",
        "................",
    ], sent).save(os.path.join(UI, "frost_sentinel.png"))

    shat = {".": T, "w": (240, 250, 255, 255), "l": (160, 220, 255, 255), "b": (80, 160, 235, 255),
            "d": (40, 96, 180, 255), "k": (20, 40, 90, 255)}
    from_rows([
        "................",
        "..w..........l..",
        "....wwwlll......",
        "...wwwlkllbb....",
        "..wwwllkklbbb.w.",
        "..wwlllkllbbbd..",
        "..wlkkkkkkkbbd..",
        "..wlllkklbkbdd..",
        "..llllklbbbkdd..",
        "..lllkkbbbbddd..",
        "...lbkbbbbddd...",
        "....bkbbdddd....",
        ".l....dddd...b..",
        "...b..........w.",
        "................",
        "................",
    ], shat).save(os.path.join(UI, "shatter.png"))

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


def thunderstrike():
    """A crackling spark pointing right, flickering between two shapes."""
    pal = {".": T, "w": (255, 255, 235, 255), "y": (255, 232, 90, 255), "o": (240, 170, 40, 255)}
    a = from_rows([
        "..o......y...",
        ".oyy..yywwy..",
        "oyywwwwwwwwwy",
        ".oyy..yywwy..",
        "..o......y...",
    ], pal)
    b = from_rows([
        "....y........",
        "..oyy.yywwy.y",
        "oyywwwwwwwwww",
        "..oy..yywwy..",
        ".o......y....",
    ], pal)
    save_sheet("thunderstrike", [a, b], 0.04, 6.5, 2.5)


def fire_pillar():
    """A small flickering ember pointing right."""
    pal = {".": T, "w": (255, 255, 235, 255), "y": (255, 214, 90, 255), "o": (255, 140, 30, 255),
           "r": (220, 60, 20, 255)}
    a = from_rows([
        "....rooo.",
        ".rooyyyyo",
        "rooyywwyo",
        ".rooyyyyo",
        "....rooo.",
    ], pal)
    b = from_rows([
        "..r.rooo.",
        "..royyyyo",
        ".rooywwyo",
        "rrooyyyyo",
        "...rrooo.",
    ], pal)
    save_sheet("fire_pillar", [a, b], 0.06, 5.5, 2.5)


def waystone():
    """A small standing stone with a glowing ring rune."""
    pal = {".": T, "h": (214, 196, 150, 255), "m": (150, 130, 96, 255), "d": (92, 78, 60, 255),
           "g": (255, 232, 120, 255), "w": (255, 255, 235, 255)}
    a = from_rows([
        "..hhhh...",
        ".hhmmmd..",
        "hhmmmmdd.",
        "hmmgwmmd.",
        "hmgwmwgd.",
        "hmgwmwgd.",
        "hmmgwmmd.",
        "hmmmmmdd.",
        "mmmmmmdd.",
        "mmmmmddd.",
        ".ddddddd.",
    ], pal)
    b = a.copy()
    for y in range(b.height):
        for x in range(b.width):
            if b.getpixel((x, y)) == pal["g"]:
                b.putpixel((x, y), pal["w"])
    save_sheet("waystone", [a, b], 0.5, 4.5, 5.5)


def avalanche():
    """A plain snowball. The game scales it up as it grows."""
    s = 7
    img = Image.new("RGBA", (s, s), T)
    for y in range(s):
        for x in range(s):
            d = math.hypot(x - 3, y - 3)
            if d > 3.3:
                continue
            if d > 2.4 and (x > 3 or y > 3):
                col = (130, 180, 225, 255)
            elif x < 3 and y < 3:
                col = (255, 255, 255, 255)
            else:
                col = (214, 236, 250, 255)
            img.putpixel((x, y), col)
    save_sheet("avalanche", [img], 0.2, 3.5, 3.5)


def crescent_gale():
    """A crescent blade, bulging to the right (the flight direction)."""
    w, h = 9, 13
    img = Image.new("RGBA", (w, h), T)
    for y in range(h):
        for x in range(w):
            outer = math.hypot(x - 2.0, y - 6.0)
            inner = math.hypot(x - (-1.2), y - 6.0)
            if outer <= 6.3 and inner > 6.6:
                img.putpixel((x, y), (245, 250, 250, 255) if outer > 5.0 else (176, 200, 204, 220))
    save_sheet("crescent_gale", [img], 0.2, 4.5, 6.5)


def bubble(name, size, wait):
    """A hollow bubble with a highlight that wobbles."""
    frames = []
    c = (size - 1) / 2
    r = size / 2 - 0.3
    for f in range(4):
        img = Image.new("RGBA", (size, size), T)
        wob = math.sin(f * math.pi / 2) * 0.35
        for y in range(size):
            for x in range(size):
                d = math.hypot((x - c) * (1 + wob * 0.06), (y - c) * (1 - wob * 0.06))
                if r - 1.4 < d <= r:
                    img.putpixel((x, y), (120, 200, 255, 255) if (x + y) > size else (210, 240, 255, 255))
                elif d <= r - 1.4:
                    img.putpixel((x, y), (60, 130, 220, 60))
        hx, hy = int(c - r * 0.45), int(c - r * 0.45)
        img.putpixel((hx, hy), (255, 255, 255, 255))
        img.putpixel((hx + 1, hy - 1), (255, 255, 255, 255))
        frames.append(img)
    save_sheet(name, frames, wait, size / 2, size / 2)


def gathering_storm():
    """A blue-white bolt pointing right, flickering between two shapes."""
    pal = {".": T, "w": (255, 255, 255, 255), "l": (170, 215, 255, 255), "b": (80, 150, 240, 255)}
    a = from_rows([
        "...b.....l...",
        ".bll..llwwl..",
        "bllwwwwwwwwwl",
        ".bll..llwwl..",
        "...b.....l...",
    ], pal)
    b = from_rows([
        ".b.....l.....",
        "..bll.llwwl.l",
        "bllwwwwwwwwww",
        ".bl...llwwl..",
        "....b...l....",
    ], pal)
    save_sheet("gathering_storm", [a, b], 0.04, 6.5, 2.5)


def ember_halo():
    """A small round ember that flickers."""
    frames = []
    for f in range(2):
        img = Image.new("RGBA", (7, 7), T)
        for y in range(7):
            for x in range(7):
                d = math.hypot(x - 3, y - 3)
                if d <= 1.1 + 0.4 * f:
                    img.putpixel((x, y), (255, 255, 235, 255))
                elif d <= 2.2:
                    img.putpixel((x, y), (255, 190, 60, 255))
                elif d <= 3.2 and (x + y + f) % 2 == 0:
                    img.putpixel((x, y), (226, 80, 24, 255))
        frames.append(img)
    save_sheet("ember_halo", frames, 0.07, 3.5, 3.5)


def riptide():
    """A hooked bolt of water pointing right."""
    pal = {".": T, "h": (190, 232, 255, 255), "l": (92, 170, 255, 255), "b": (36, 104, 226, 255)}
    img = from_rows([
        ".........lb..",
        "..bbllllhhlb.",
        "bllllhhhhhhlb",
        "..bbllllhhlb.",
        ".........lb..",
    ], pal)
    save_sheet("riptide", [img], 0.2, 6.5, 2.5)


def frost_sentinel():
    """An upright ice crystal that glints."""
    pal = {".": T, "w": (240, 250, 255, 255), "l": (160, 220, 255, 255), "b": (80, 160, 235, 255),
           "d": (40, 96, 180, 255)}
    rows = [
        "...w...",
        "..wwl..",
        ".wwllb.",
        ".wllbb.",
        "wwllbbd",
        "wllbbbd",
        "wllbbbd",
        "wllbbbd",
        ".llbbd.",
        ".lbbdd.",
        "..bbd..",
        "...d...",
    ]
    a = from_rows(rows, pal)
    b = a.copy()
    for x, y in ((1, 3), (2, 2), (1, 5)):
        b.putpixel((x, y), (255, 255, 255, 255))
    save_sheet("frost_sentinel", [a, a, a, b], 0.15, 3.5, 6.0)


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
    thunderstrike()
    fire_pillar()
    waystone()
    avalanche()
    crescent_gale()
    bubble("bubble_prison", 9, 0.1)
    bubble("bubble_prison_big", 23, 0.12)
    gathering_storm()
    ember_halo()
    riptide()
    frost_sentinel()
    print("wrote", sorted(os.listdir(UI)), sorted(os.listdir(GFX)))
