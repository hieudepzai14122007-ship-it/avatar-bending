# Elemental Arts: a spell expansion for Noita

A mod for [Noita](https://noitagame.com/) that adds eight new elemental spells to the spell pool. They turn up in wands, shops and Holy Mountains like any vanilla spell, and one copy of each is dropped next to you at the start of a new run so you can try them straight away.

![Whirlwind](elemental_arts/files/ui_gfx/whirlwind.png) ![Tidal Orb](elemental_arts/files/ui_gfx/tidal_orb.png) ![Stone Lance](elemental_arts/files/ui_gfx/stone_lance.png) ![Flame Serpent](elemental_arts/files/ui_gfx/flame_serpent.png) ![Glacial Shards](elemental_arts/files/ui_gfx/glacial_shards.png) ![Updraft](elemental_arts/files/ui_gfx/updraft.png) ![Magma Bomb](elemental_arts/files/ui_gfx/magma_bomb.png) ![Elemental Attunement](elemental_arts/files/ui_gfx/attunement.png)

## The spells

| Spell | Type | Mana | What it does |
|---|---|---|---|
| **Whirlwind** | Projectile | 45 | A slow vortex that bounces around the cave for about 3 seconds. It drags enemies into its core and lifts them off the ground, cuts whatever reaches the core (3.5 slice damage per hit), knocks enemy projectiles off course, flings loose objects, fans flames and blows away gases such as smoke, steam and toxic fumes. |
| **Tidal Orb** | Projectile | 30 | A lobbed sphere of water. It deals 10 damage on a direct hit, then bursts for 15 more with heavy knockback and a fountain of real water. Soaks enemies and puts out fires. The burst does not dig into terrain. |
| **Stone Lance** | Projectile | 50 | A spear of rock that flies through creatures and terrain for a short distance and leaves a solid stone beam along its path. Use it to build bridges, walls and stairs, to plug a hole, or to skewer a row of enemies (15 damage per hit). |
| **Flame Serpent** | Projectile | 35 | A slithering tongue of fire that homes in on the nearest enemy. It deals 13.75 fire damage, sets the target alight, flares up on impact and leaves a trail of real fire behind it. |
| **Glacial Shards** | Projectile | 30 | A fan of three fast icicles. Each deals 7.5 ice damage, freezes the enemy it hits for a moment, and turns any water it touches to ice. |
| **Updraft** | Utility | 35 | A column of rising air that launches you straight up for a quarter of a second and cancels any fall. Good for reaching ledges and for getting out of trouble. It also lifts an enemy that casts it. |
| **Magma Bomb** | Projectile | 70 | A lobbed chunk of molten rock, 12 uses. It deals 20 damage on a direct hit, explodes for 30 more, breaks soft terrain and spills a small pool of real lava. The lava hurts you as much as anything else. |
| **Elemental Attunement** | Modifier | 12 | Each cast infuses the projectile with the next element in a fixed cycle: **air** (60% faster, more accurate, strong knockback), **water** (soaks the target, always crits soaked targets, leaves a water trail), **earth** (+10 damage, +15% crit chance, 15% slower), **fire** (+6 fire damage, ignites the target, leaves a fire trail). |

For reference, the starting Spark Bolt deals 3 damage.

Stone Lance and Flame Serpent start their stone and fire a short distance from the wand, so they do not form on top of you. Fire and lava still burn you if you walk into them.

## Install

1. Download [`release/ElementalArts-1.1.0-Noita.zip`](../release/ElementalArts-1.1.0-Noita.zip) and unzip it.
2. Copy the `elemental_arts` folder into the `mods` folder of your Noita install. On Steam: right-click Noita → **Manage → Browse local files**, then open `mods`.
   The folder must keep the name `elemental_arts`, because the mod loads its files by that path.
3. Start Noita, open **Mods**, and enable **Elemental Arts - Spell Expansion**.
4. Start a **new game**. The mod needs no unsafe mode.

## Settings

In **Mods → Mod settings**:

- **Start with the new spells** (on by default): drops one copy of each new spell next to you at the start of a new run. Turn it off to find the spells only through normal play. The change applies from the next new game.

## Compatibility

- Made for the current release version of Noita (1.0 and later).
- Adds spells only. It does not change any vanilla spell, enemy or material, so it should sit alongside other spell mods.
- Spell IDs all start with `ELEMENTAL_ARTS_`.

## Status

The mod has not been run inside Noita yet. It was built against Noita's own data files, and these checks pass: every XML component and attribute it uses also appears in the vanilla files; every vanilla file, material and sound it refers to exists; and all of the mod's Lua (the spell definitions, the Whirlwind and Updraft scripts, the settings and the start-up code) runs under LuaJIT against a stand-in for the game's functions. Balance numbers are a first pass and may need tuning after play.

## Files

```
elemental_arts/
  mod.xml                       mod name and description
  init.lua                      registers the spells, drops the starter spells
  settings.lua                  the mod setting
  files/
    actions.lua                 the eight spell definitions
    entities/projectiles/       one projectile per spell, plus the water and lava splashes
    scripts/whirlwind.lua       the vortex pull
    scripts/updraft.lua         the upward launch
    ui_gfx/                     spell icons
    projectiles_gfx/            projectile sprites
```

The icons and sprites are generated by [`tools/gen_noita_gfx.py`](../tools/gen_noita_gfx.py).
