-- Elemental Arts - Spell Expansion
-- This file is appended to data/scripts/gun/gun_actions.lua (see init.lua),
-- so `actions`, `c`, `add_projectile`, `draw_actions` etc. are the vanilla ones.

-- Which element Elemental Attunement applies next:
-- 1 = air, 2 = water, 3 = earth, 4 = fire.
elemental_arts_attunement_step = elemental_arts_attunement_step or 0

local elemental_arts_actions =
{
	-- AIR ----------------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_WHIRLWIND",
		name        = "Whirlwind",
		description = "A slow, bouncing vortex that drags enemies into its cutting core, scatters enemy projectiles and blows gases away",
		sprite      = "mods/elemental_arts/files/ui_gfx/whirlwind.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/air_bullet_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/whirlwind.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4,5",
		spawn_probability = "0.6,0.8,0.8,0.6,0.4",
		price = 180,
		mana = 45,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/whirlwind.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.spread_degrees = c.spread_degrees - 2.0
		end,
	},

	-- WATER --------------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_TIDAL_ORB",
		name        = "Tidal Orb",
		description = "A lobbed sphere of water that bursts into a drenching wave, knocking enemies back and dousing flames",
		sprite      = "mods/elemental_arts/files/ui_gfx/tidal_orb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/material_water_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/tidal_orb.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "0,1,2,3,4",
		spawn_probability = "0.8,1,0.8,0.6,0.4",
		price = 140,
		mana = 30,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/tidal_orb.xml")
			c.fire_rate_wait = c.fire_rate_wait + 22
			c.screenshake = c.screenshake + 1.0
		end,
	},

	-- EARTH --------------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_STONE_LANCE",
		name        = "Stone Lance",
		description = "A spear of living rock that pierces everything and leaves a solid stone beam along its path",
		sprite      = "mods/elemental_arts/files/ui_gfx/stone_lance.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/lance_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/stone_lance.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4,5,6",
		spawn_probability = "0.5,0.7,0.7,0.6,0.5,0.4",
		price = 200,
		mana = 50,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/stone_lance.xml")
			c.fire_rate_wait = c.fire_rate_wait + 35
			c.spread_degrees = c.spread_degrees - 4.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end,
	},

	-- FIRE ---------------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_FLAME_SERPENT",
		name        = "Flame Serpent",
		description = "A slithering tongue of fire that hunts down the nearest enemy, leaving flames in its wake",
		sprite      = "mods/elemental_arts/files/ui_gfx/flame_serpent.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/fireball_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/flame_serpent.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4,5,6",
		spawn_probability = "0.6,0.8,0.8,0.7,0.5,0.4",
		price = 220,
		mana = 35,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/flame_serpent.xml")
			c.fire_rate_wait = c.fire_rate_wait + 18
		end,
	},

	-- ALL FOUR -----------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_ATTUNEMENT",
		name        = "Elemental Attunement",
		description = "Each cast infuses the projectile with the next element in the cycle: air, water, earth, fire",
		sprite      = "mods/elemental_arts/files/ui_gfx/attunement.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		related_extra_entities =
		{
			"data/entities/particles/tinyspark_white.xml",
			"data/entities/particles/tinyspark_blue_large.xml",
			"data/entities/misc/hitfx_critical_water.xml",
			"data/entities/particles/tinyspark_yellow.xml",
			"data/entities/particles/tinyspark_orange.xml",
			"data/entities/misc/burn.xml",
		},
		type        = ACTION_TYPE_MODIFIER,
		spawn_level       = "2,3,4,5,6",
		spawn_probability = "0.5,0.7,0.7,0.6,0.5",
		price = 260,
		mana = 12,
		action = function()
			-- The game also calls actions just to read their stats ("reflecting").
			-- Only a real cast advances the cycle and applies an element.
			if not reflecting then
				elemental_arts_attunement_step = ( elemental_arts_attunement_step % 4 ) + 1
				local element = elemental_arts_attunement_step

				if element == 1 then
					-- Air: fast, accurate, heavy knockback
					c.speed_multiplier = c.speed_multiplier * 1.6
					c.spread_degrees = c.spread_degrees - 6.0
					c.knockback_force = c.knockback_force + 4
					c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_white.xml,"
				elseif element == 2 then
					-- Water: soaks the target and always crits soaked targets
					c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_wet.xml,"
					c.trail_material = c.trail_material .. "water,"
					c.trail_material_amount = c.trail_material_amount + 12
					c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_critical_water.xml,data/entities/particles/tinyspark_blue_large.xml,"
				elseif element == 3 then
					-- Earth: slow but heavy
					c.damage_projectile_add = c.damage_projectile_add + 0.4
					c.damage_critical_chance = c.damage_critical_chance + 15
					c.speed_multiplier = c.speed_multiplier * 0.85
					c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
				else
					-- Fire: burns the target and the ground it flies over
					c.damage_fire_add = c.damage_fire_add + 0.24
					c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_apply_on_fire.xml,"
					c.extra_entities = c.extra_entities .. "data/entities/misc/burn.xml,data/entities/particles/tinyspark_orange.xml,"
				end
			end

			draw_actions( 1, true )
		end,
	},
}

for _, action in ipairs( elemental_arts_actions ) do
	table.insert( actions, action )
end
