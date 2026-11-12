-- Earthshaker: runs every frame on the dive entity.
-- Pushes the caster straight down. The moment they are standing on something,
-- a shockwave goes off at their feet and the dive ends.

dofile_once( "data/scripts/lib/utilities.lua" )

local DIVE_SPEED     = 340  -- downward speed in pixels per second (the player's own limit is 350)
local MIN_FRAMES     = 3    -- never go off before this, so the push has had time to act
local SHOCKWAVE_FILE = "mods/elemental_arts/files/entities/projectiles/earthshaker_shockwave.xml"

local entity_id = GetUpdatedEntityID()

local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp == nil then
	return
end
local who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" )
if who_shot == nil or who_shot == 0 or not EntityGetIsAlive( who_shot ) then
	EntityKill( entity_id )
	return
end
local char_comp = EntityGetFirstComponent( who_shot, "CharacterDataComponent" )
if char_comp == nil then
	EntityKill( entity_id )
	return
end

-- Count the frames of the dive.
local age = 0
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps ~= nil then
	for _, comp in ipairs( comps ) do
		if ComponentGetValue2( comp, "name" ) == "age" then
			age = ( ComponentGetValue2( comp, "value_int" ) or 0 ) + 1
			ComponentSetValue2( comp, "value_int", age )
		end
	end
end

local vel_x, vel_y = ComponentGetValue2( char_comp, "mVelocity" )
if vel_x == nil or vel_y == nil then
	return
end

-- Landed? Either the game says so, or the downward speed we set last frame is
-- gone again, which only happens when something solid is underfoot.
local on_ground = ComponentGetValue2( char_comp, "is_on_ground" ) == true
local stopped = vel_y < DIVE_SPEED * 0.2
if age >= MIN_FRAMES and ( on_ground or stopped ) then
	local x, y = EntityGetTransform( who_shot )
	if x ~= nil and y ~= nil then
		shoot_projectile_from_projectile( entity_id, SHOCKWAVE_FILE, x, y, 0, 0 )
	end
	EntityKill( entity_id )
	return
end

-- Positive y is down.
ComponentSetValue2( char_comp, "mVelocity", vel_x * 0.5, DIVE_SPEED )
