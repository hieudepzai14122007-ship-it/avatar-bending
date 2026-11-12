-- Frost Sentinel: runs every 18 frames on the crystal.
-- Shoots an icicle at the nearest enemy it has a clear line to.

dofile_once( "data/scripts/lib/utilities.lua" )

local RANGE       = 170  -- how far the sentinel can see, in pixels
local SHARD_SPEED = 600  -- pixels per second
local SHARD_FILE  = "mods/elemental_arts/files/entities/projectiles/glacial_shard.xml"

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
if x == nil then
	return
end

local who_shot = 0
local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp ~= nil then
	who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" ) or 0
end

-- Nearest enemy that is not hidden behind terrain.
local target_x, target_y = nil, nil
local best = nil
local enemies = EntityGetInRadiusWithTag( x, y, RANGE, "enemy" ) or {}
for _, id in ipairs( enemies ) do
	if id ~= who_shot then
		local ex, ey = EntityGetTransform( id )
		if ex ~= nil and ey ~= nil then
			ey = ey - 4 -- aim at the body, not the feet
			local d = ( ex - x ) * ( ex - x ) + ( ey - y ) * ( ey - y )
			if ( best == nil or d < best ) and not RaytraceSurfacesAndLiquiform( x, y, ex, ey ) then
				best = d
				target_x, target_y = ex, ey
			end
		end
	end
end
if target_x == nil then
	return
end

local dx, dy = target_x - x, target_y - y
local dist = math.sqrt( dx * dx + dy * dy )
if dist < 1 then
	dx, dy, dist = 1, 0, 1
end
shoot_projectile_from_projectile( entity_id, SHARD_FILE, x, y, dx / dist * SHARD_SPEED, dy / dist * SHARD_SPEED )
