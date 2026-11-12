-- Tidal Wave: runs every frame on the wave.
-- Enemies caught in it are carried along at the wave's own speed.

local REACH       = 20    -- how close an enemy must be to be caught, in pixels
local CARRY_SHARE = 0.9   -- share of the wave's speed passed on to what it carries
local LIFT        = 30    -- small upward speed, so enemies are swept over bumps

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
if x == nil then
	return
end

local velocity_comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if velocity_comp == nil then
	return
end
local wave_x, wave_y = ComponentGetValue2( velocity_comp, "mVelocity" )
if wave_x == nil or wave_y == nil then
	return
end

local who_shot = 0
local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp ~= nil then
	who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" ) or 0
end

local enemies = EntityGetInRadiusWithTag( x, y, REACH, "enemy" ) or {}
for _, id in ipairs( enemies ) do
	if id ~= who_shot then
		local char_comp = EntityGetFirstComponent( id, "CharacterDataComponent" )
		if char_comp ~= nil then
			-- Negative y is up.
			ComponentSetValue2( char_comp, "mVelocity", wave_x * CARRY_SHARE, wave_y * CARRY_SHARE - LIFT )
		end
	end
end
