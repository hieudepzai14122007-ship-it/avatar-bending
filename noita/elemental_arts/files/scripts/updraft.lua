-- Updraft: runs every frame on the gust entity while it lasts.
-- Blows whoever cast the spell straight up, cancelling any fall.

local LIFT_SPEED = 190 -- upward speed in pixels per second (the player's own limit is 200)

local entity_id = GetUpdatedEntityID()

local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp == nil then
	return
end

local who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" )
if who_shot == nil or who_shot == 0 or not EntityGetIsAlive( who_shot ) then
	return
end

local char_comp = EntityGetFirstComponent( who_shot, "CharacterDataComponent" )
if char_comp == nil then
	return
end

local vel_x, vel_y = ComponentGetValue2( char_comp, "mVelocity" )
if vel_x == nil or vel_y == nil then
	return
end

-- Negative y is up. Never slow down a caster who is already rising faster.
if vel_y > -LIFT_SPEED then
	ComponentSetValue2( char_comp, "mVelocity", vel_x, -LIFT_SPEED )
end
