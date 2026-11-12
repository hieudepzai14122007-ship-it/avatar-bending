-- Forked Lightning: runs once, when the projectile carrying the modifier is removed.
-- Bolts arc from where it ended to the nearest enemies it has a clear line to,
-- skipping whatever it was touching (that one has already been hit).

dofile_once( "data/scripts/lib/utilities.lua" )

local RANGE       = 110  -- how far a bolt can arc, in pixels
local SKIP_WITHIN = 14   -- enemies this close are the one that was just struck
local MAX_BOLTS   = 2
local BOLT_SPEED  = 660  -- pixels per second
local BOLT_FILE   = "mods/elemental_arts/files/entities/projectiles/gathering_storm.xml"

local entity_id = EntityGetRootEntity( GetUpdatedEntityID() )
local x, y = EntityGetTransform( entity_id )
if x == nil then
	return
end

local who_shot = 0
local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp ~= nil then
	who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" ) or 0
end

-- Collect the enemies a bolt could reach, nearest first.
local targets = {}
local enemies = EntityGetInRadiusWithTag( x, y, RANGE, "enemy" ) or {}
for _, id in ipairs( enemies ) do
	if id ~= who_shot then
		local ex, ey = EntityGetTransform( id )
		if ex ~= nil and ey ~= nil then
			ey = ey - 4 -- aim at the body, not the feet
			local dist = math.sqrt( ( ex - x ) * ( ex - x ) + ( ey - y ) * ( ey - y ) )
			if dist > SKIP_WITHIN and not RaytraceSurfacesAndLiquiform( x, y, ex, ey ) then
				targets[ #targets + 1 ] = { x = ex, y = ey, dist = dist }
			end
		end
	end
end
table.sort( targets, function( a, b ) return a.dist < b.dist end )

for i = 1, math.min( MAX_BOLTS, #targets ) do
	local target = targets[i]
	local dir_x = ( target.x - x ) / target.dist
	local dir_y = ( target.y - y ) / target.dist
	-- Start a little way out, clear of whatever the projectile ended on.
	local bolt = shoot_projectile_from_projectile( entity_id, BOLT_FILE, x + dir_x * 8, y + dir_y * 8, dir_x * BOLT_SPEED, dir_y * BOLT_SPEED )
	if bolt ~= nil then
		EntityAddTag( bolt, "projectile_cloned" )
	end
end
