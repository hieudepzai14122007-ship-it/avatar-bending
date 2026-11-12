-- Gale Barrier: runs every frame on the barrier entity while it lasts.
-- Keeps the ring centred on the caster, bounces enemy projectiles back out
-- and pushes enemies away.

dofile_once( "data/scripts/lib/utilities.lua" )

local RADIUS     = 40   -- radius of the ring, in pixels
local ENEMY_PUSH = 26   -- outward speed added to an enemy per frame, at the centre
local MAX_SPEED  = 220  -- enemies are never thrown faster than this

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
if x == nil then
	return
end

-- Follow the caster for as long as they are around.
local who_shot = 0
local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp ~= nil then
	who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" ) or 0
end
if who_shot ~= 0 and EntityGetIsAlive( who_shot ) then
	local sx, sy = EntityGetTransform( who_shot )
	if sx ~= nil and sy ~= nil then
		x, y = sx, sy - 4 -- roughly the caster's chest
		EntitySetTransform( entity_id, x, y )
	end
end

-- Projectiles that are not the player's: mirror any that are flying inwards.
local projectiles = EntityGetInRadiusWithTag( x, y, RADIUS, "projectile" ) or {}
for _, id in ipairs( projectiles ) do
	if id ~= entity_id and not EntityHasTag( id, "projectile_player" ) then
		local is_physics = EntityGetFirstComponent( id, "PhysicsBody2Component" ) or EntityGetFirstComponent( id, "PhysicsBodyComponent" )
		local velocity_comp = EntityGetFirstComponent( id, "VelocityComponent" )
		if is_physics == nil and velocity_comp ~= nil then
			local px, py = EntityGetTransform( id )
			local vel_x, vel_y = ComponentGetValue2( velocity_comp, "mVelocity" )
			if px ~= nil and vel_x ~= nil and vel_y ~= nil then
				-- unit vector pointing from the centre out to the projectile
				local nx, ny = px - x, py - y
				local dist = math.sqrt( nx * nx + ny * ny )
				if dist > 0.5 then
					nx, ny = nx / dist, ny / dist
				else
					nx, ny = 0, -1
				end
				-- speed towards the centre (negative means it is coming in)
				local inward = vel_x * nx + vel_y * ny
				if inward < 0 then
					ComponentSetValue2( velocity_comp, "mVelocity", vel_x - 2 * inward * nx, vel_y - 2 * inward * ny )
				end
			end
		end
	end
end

-- Enemies: pushed outwards, harder the closer they are.
local creatures = EntityGetInRadiusWithTag( x, y, RADIUS, "enemy" ) or {}
for _, id in ipairs( creatures ) do
	if id ~= who_shot then
		local char_comp = EntityGetFirstComponent( id, "CharacterDataComponent" )
		if char_comp ~= nil then
			local cx, cy = EntityGetTransform( id )
			local vel_x, vel_y = ComponentGetValue2( char_comp, "mVelocity" )
			if cx ~= nil and vel_x ~= nil and vel_y ~= nil then
				local nx, ny = cx - x, cy - y
				local dist = math.sqrt( nx * nx + ny * ny )
				if dist > 0.5 then
					nx, ny = nx / dist, ny / dist
				else
					nx, ny = 0, -1
				end
				local strength = 1.0 - math.min( dist / RADIUS, 1.0 )
				vel_x = clamp( vel_x + nx * ENEMY_PUSH * strength, -MAX_SPEED, MAX_SPEED )
				vel_y = clamp( vel_y + ny * ENEMY_PUSH * strength, -MAX_SPEED, MAX_SPEED )
				ComponentSetValue2( char_comp, "mVelocity", vel_x, vel_y )
			end
		end
	end
end
