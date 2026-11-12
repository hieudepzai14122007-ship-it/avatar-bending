-- Elemental Arts - Spell Expansion
-- This file is appended to data/scripts/gun/gun_actions.lua (see init.lua),
-- so `actions`, `c`, `add_projectile`, `draw_actions` etc. are the vanilla ones.

-- Which element Elemental Attunement applies next:
-- 1 = air, 2 = water, 3 = earth, 4 = fire.
elemental_arts_attunement_step = elemental_arts_attunement_step or 0

-- Frame on which Gathering Storm was last cast, to work out how long it has charged.
elemental_arts_storm_last_cast = elemental_arts_storm_last_cast or nil

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

	-- ICE ----------------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_GLACIAL_SHARDS",
		name        = "Glacial Shards",
		description = "A fan of three razor-sharp icicles that freeze enemies solid and turn water to ice",
		sprite      = "mods/elemental_arts/files/ui_gfx/glacial_shards.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/glacial_shard.xml",3},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4,5",
		spawn_probability = "0.7,0.9,0.8,0.6,0.4",
		price = 170,
		mana = 30,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/glacial_shard.xml")
			add_projectile("mods/elemental_arts/files/entities/projectiles/glacial_shard.xml")
			add_projectile("mods/elemental_arts/files/entities/projectiles/glacial_shard.xml")
			c.fire_rate_wait = c.fire_rate_wait + 14
			c.spread_degrees = c.spread_degrees + 10.0
		end,
	},

	-- WIND (utility) -----------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_UPDRAFT",
		name        = "Updraft",
		description = "A sudden column of rising air that launches you upwards and breaks your fall",
		sprite      = "mods/elemental_arts/files/ui_gfx/updraft.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/levitation_field_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/updraft.xml"},
		type        = ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5",
		spawn_probability = "0.4,0.6,0.6,0.5,0.4,0.3",
		price = 150,
		mana = 35,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/updraft.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
		end,
	},

	-- MAGMA (earth + fire) -----------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_MAGMA_BOMB",
		name        = "Magma Bomb",
		description = "A lobbed chunk of molten rock that explodes and spills a pool of lava. Keep your distance",
		sprite      = "mods/elemental_arts/files/ui_gfx/magma_bomb.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/grenade_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/magma_bomb.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "2,3,4,5,6",
		spawn_probability = "0.5,0.7,0.7,0.6,0.5",
		price = 240,
		mana = 70,
		max_uses = 12,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/magma_bomb.xml")
			c.fire_rate_wait = c.fire_rate_wait + 45
			c.screenshake = c.screenshake + 3.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 40.0
		end,
	},

	-- LIGHTNING ----------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_THUNDERSTRIKE",
		name        = "Thunderstrike",
		description = "A fast spark that calls a bolt of lightning down from above onto whatever it hits",
		sprite      = "mods/elemental_arts/files/ui_gfx/thunderstrike.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/lightning_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/thunderstrike.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "2,3,4,5,6",
		spawn_probability = "0.5,0.7,0.7,0.6,0.5",
		price = 250,
		mana = 80,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/thunderstrike.xml")
			c.fire_rate_wait = c.fire_rate_wait + 40
			c.spread_degrees = c.spread_degrees - 3.0
		end,
	},

	-- ICE (burst) --------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_FROST_NOVA",
		name        = "Frost Nova",
		description = "A burst of cold around you that freezes nearby enemies, turns water to ice and hardens lava",
		sprite      = "mods/elemental_arts/files/ui_gfx/frost_nova.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/freeze_field_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/frost_nova.xml"},
		type        = ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level       = "1,2,3,4,5",
		spawn_probability = "0.4,0.6,0.6,0.5,0.4",
		price = 210,
		mana = 60,
		max_uses = 15,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/frost_nova.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},

	-- FIRE (area) --------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_FIRE_PILLAR",
		name        = "Fire Pillar",
		description = "An ember that erupts into a tall column of fire where it lands",
		sprite      = "mods/elemental_arts/files/ui_gfx/fire_pillar.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/fire_blast_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/fire_pillar.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4,5",
		spawn_probability = "0.6,0.8,0.7,0.6,0.4",
		price = 190,
		mana = 40,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/fire_pillar.xml")
			c.fire_rate_wait = c.fire_rate_wait + 28
		end,
	},

	-- WIND (shield) ------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_GALE_BARRIER",
		name        = "Gale Barrier",
		description = "A ring of wind that follows you for a few seconds, throwing back enemy projectiles and pushing enemies away",
		sprite      = "mods/elemental_arts/files/ui_gfx/gale_barrier.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/gale_barrier.xml"},
		type        = ACTION_TYPE_UTILITY,
		spawn_level       = "1,2,3,4,5,6",
		spawn_probability = "0.3,0.5,0.6,0.6,0.5,0.4",
		price = 230,
		mana = 60,
		max_uses = 12,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/gale_barrier.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},

	-- EARTH (modifier) ---------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_QUAGMIRE",
		name        = "Quagmire",
		description = "The projectile trails mud and bogs down whatever it hits, slowing it to a crawl",
		sprite      = "mods/elemental_arts/files/ui_gfx/quagmire.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/slimeball_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_yellow.xml" },
		type        = ACTION_TYPE_MODIFIER,
		spawn_level       = "1,2,3,4,5",
		spawn_probability = "0.5,0.6,0.6,0.5,0.4",
		price = 130,
		mana = 8,
		action = function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_movement_slower_2x.xml,"
			c.trail_material = c.trail_material .. "mud,"
			c.trail_material_amount = c.trail_material_amount + 10
			c.damage_projectile_add = c.damage_projectile_add + 0.1
			c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			draw_actions( 1, true )
		end,
	},

	-- EARTH (travel) -----------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_WAYSTONE",
		name        = "Waystone",
		description = "Cast once to leave a waystone where you stand. Cast again to return to it instantly",
		sprite      = "mods/elemental_arts/files/ui_gfx/waystone.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/teleport_projectile_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/waystone_cast.xml"},
		type        = ACTION_TYPE_UTILITY,
		spawn_level       = "1,2,3,4,5,6",
		spawn_probability = "0.3,0.5,0.5,0.5,0.4,0.4",
		price = 260,
		mana = 50,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/waystone_cast.xml")
			c.fire_rate_wait = c.fire_rate_wait + 30
		end,
	},

	-- ICE (growing) ------------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_AVALANCHE",
		name        = "Avalanche",
		description = "A bouncing snowball that grows as it travels. The farther it rolls, the harder it hits",
		sprite      = "mods/elemental_arts/files/ui_gfx/avalanche.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/rubber_ball_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/avalanche.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "0,1,2,3,4",
		spawn_probability = "0.6,0.8,0.8,0.6,0.4",
		price = 160,
		mana = 25,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/avalanche.xml")
			c.fire_rate_wait = c.fire_rate_wait + 16
		end,
	},

	-- WIND (returning) ---------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_CRESCENT_GALE",
		name        = "Crescent Gale",
		description = "A blade of wind that cuts through enemies, then curves around and flies back to you, cutting them again",
		sprite      = "mods/elemental_arts/files/ui_gfx/crescent_gale.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/crescent_gale.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4,5",
		spawn_probability = "0.6,0.8,0.8,0.6,0.5",
		price = 190,
		mana = 30,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/crescent_gale.xml")
			c.fire_rate_wait = c.fire_rate_wait + 20
		end,
	},

	-- WATER (control) ----------------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_BUBBLE_PRISON",
		name        = "Bubble Prison",
		description = "Traps an enemy in a bubble that lifts it helplessly into the air for a few seconds",
		sprite      = "mods/elemental_arts/files/ui_gfx/bubble_prison.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bubbleshot_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/bubble_prison.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4,5",
		spawn_probability = "0.5,0.7,0.7,0.6,0.4",
		price = 180,
		mana = 30,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/bubble_prison.xml")
			c.fire_rate_wait = c.fire_rate_wait + 18
		end,
	},

	-- LIGHTNING (charging) -----------------------------------------------
	{
		id          = "ELEMENTAL_ARTS_GATHERING_STORM",
		name        = "Gathering Storm",
		description = "A bolt that charges while the spell rests. The longer since you last cast it, up to four seconds, the harder it hits",
		sprite      = "mods/elemental_arts/files/ui_gfx/gathering_storm.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_projectiles = {"mods/elemental_arts/files/entities/projectiles/gathering_storm.xml"},
		type        = ACTION_TYPE_PROJECTILE,
		spawn_level       = "1,2,3,4,5,6",
		spawn_probability = "0.5,0.7,0.7,0.6,0.5,0.4",
		price = 220,
		mana = 35,
		action = function()
			add_projectile("mods/elemental_arts/files/entities/projectiles/gathering_storm.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10

			-- The game also calls actions just to read their stats ("reflecting").
			-- Only a real cast uses up the charge.
			if not reflecting then
				local now = GameGetFrameNum()
				local charge = 1.0 -- the first cast of a session counts as fully charged
				if elemental_arts_storm_last_cast ~= nil and now >= elemental_arts_storm_last_cast then
					-- nothing for the first third of a second, full after four seconds (240 frames)
					local rested = now - elemental_arts_storm_last_cast
					charge = math.max( 0.0, math.min( 1.0, ( rested - 20 ) / 220 ) )
				end
				elemental_arts_storm_last_cast = now

				-- up to +45 electric damage on top of the bolt's own 7.5
				c.damage_electricity_add = c.damage_electricity_add + 1.8 * charge
				c.screenshake = c.screenshake + 5.0 * charge
				if charge >= 0.5 then
					c.extra_entities = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
				end
			end
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
