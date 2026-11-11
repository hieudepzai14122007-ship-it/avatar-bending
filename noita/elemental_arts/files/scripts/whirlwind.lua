-- Whirlwind: runs every other frame on the vortex projectile.
-- Drags creatures towards the core and lifts them, swirls enemy projectiles
-- off course and shoves loose physics objects around.

dofile_once( "data/scripts/lib/utilities.lua" )

local RADIUS          = 56   -- reach of the wind, in pixels
local PULL            = 34   -- inward speed added per update at the core
local SWIRL           = 22   -- sideways (orbiting) speed added per update
local LIFT            = 30   -- upward speed added per update
local MAX_SPEED       = 260  -- creatures are never flung faster than this
local PROJECTILE_PUSH = 28   -- how hard foreign projectiles are swirled
local PHYSICS_PUSH    = 22   -- force on physics bodies, per unit of mass

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
if x == nil then
	return
end

-- Never drag the caster around.
local who_shot = 0
local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp ~= nil then
	who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" ) or 0
end

-- Strength of the wind at a point: 1 at the core, 0 at the edge.
-- Returns the wind velocity (inward pull + orbit + lift) for that point.
local function wind_at( px, py )
	local dx = x - px
	local dy = y - py
	local dist = math.sqrt( dx * dx + dy * dy )
	if dist > RADIUS then
		return 0, 0, 0
	end

	local strength = 1.0 - dist / RADIUS
	local nx, ny = 0, 0
	if dist > 4 then
		nx = dx / dist
		ny = dy / dist
	end

	local wx = ( nx * PULL - ny * SWIRL ) * strength
	local wy = ( ny * PULL + nx * SWIRL - LIFT ) * strength
	return wx, wy, strength
end

-- Creatures -----------------------------------------------------------------
local creatures = EntityGetInRadiusWithTag( x, y, RADIUS, "enemy" ) or {}
for _, id in ipairs( creatures ) do
	if id ~= who_shot then
		local char_comp = EntityGetFirstComponent( id, "CharacterDataComponent" )
		if char_comp ~= nil then
			local cx, cy = EntityGetTransform( id )
			local wx, wy = wind_at( cx, cy )
			local vel_x, vel_y = ComponentGetValue2( char_comp, "mVelocity" )
			if vel_x ~= nil and vel_y ~= nil then
				vel_x = clamp( vel_x + wx, -MAX_SPEED, MAX_SPEED )
				vel_y = clamp( vel_y + wy, -MAX_SPEED, MAX_SPEED )
				ComponentSetValue2( char_comp, "mVelocity", vel_x, vel_y )
			end
		end
	end
end

-- Projectiles that are not the player's ---------------------------------------
local projectiles = EntityGetInRadiusWithTag( x, y, RADIUS, "projectile" ) or {}
for _, id in ipairs( projectiles ) do
	if id ~= entity_id and not EntityHasTag( id, "projectile_player" ) then
		local is_physics = EntityGetFirstComponent( id, "PhysicsBody2Component" ) or EntityGetFirstComponent( id, "PhysicsBodyComponent" )
		local velocity_comp = EntityGetFirstComponent( id, "VelocityComponent" )
		if is_physics == nil and velocity_comp ~= nil then
			local px, py = EntityGetTransform( id )
			local wx, wy, strength = wind_at( px, py )
			if strength > 0 then
				local vel_x, vel_y = ComponentGetValue2( velocity_comp, "mVelocity" )
				if vel_x ~= nil and vel_y ~= nil then
					local scale = PROJECTILE_PUSH / PULL
					ComponentSetValue2( velocity_comp, "mVelocity", vel_x + wx * scale, vel_y + wy * scale )
				end
			end
		end
	end
end

-- Loose physics objects (boxes, minecarts, corpses...) -----------------------
local function force_for_body( body_entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular )
	local wx, wy = wind_at( body_x, body_y )
	local fx = wx / PULL * PHYSICS_PUSH * body_mass
	local fy = wy / PULL * PHYSICS_PUSH * body_mass
	return body_x, body_y, fx, fy, 0 -- force position x/y, force x/y, torque
end

PhysicsApplyForceOnArea( force_for_body, entity_id, x - RADIUS, y - RADIUS, x + RADIUS, y + RADIUS )
