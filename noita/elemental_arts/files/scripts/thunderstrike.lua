-- Thunderstrike: runs once, when the marker spark is removed.
-- Finds the ceiling above the spark and sends a bolt of lightning down from it.

dofile_once( "data/scripts/lib/utilities.lua" )

local MAX_HEIGHT = 140   -- how far above the spark the bolt may start, in pixels
local BOLT_SPEED = 4000  -- downward speed given to the lightning

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
if x == nil then
	return
end

-- Look for solid ground above. Start a little higher than the spark itself,
-- because the spark usually dies touching (or just inside) what it hit.
local start_y = y - MAX_HEIGHT
local probe_from = y - 6
local did_hit, hit_x, hit_y = RaytraceSurfaces( x, probe_from, x, y - MAX_HEIGHT )
if did_hit and hit_y ~= nil then
	-- Stay just below the ceiling, and never start below the spark.
	start_y = math.min( hit_y + 3, probe_from )
end

shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/lightning.xml", x, start_y, 0, BOLT_SPEED )
