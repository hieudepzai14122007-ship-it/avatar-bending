-- Ember Halo: runs once per cast. Lights three embers, evenly spaced on a circle.

dofile_once( "data/scripts/lib/utilities.lua" )

local EMBER_FILE  = "mods/elemental_arts/files/entities/projectiles/ember_halo_ember.xml"
local EMBER_COUNT = 3

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
if x == nil then
	return
end

for i = 1, EMBER_COUNT do
	local ember = shoot_projectile_from_projectile( entity_id, EMBER_FILE, x, y, 0, 0 )
	if ember ~= nil then
		local comps = EntityGetComponent( ember, "VariableStorageComponent" )
		if comps ~= nil then
			for _, comp in ipairs( comps ) do
				if ComponentGetValue2( comp, "name" ) == "phase" then
					ComponentSetValue2( comp, "value_float", ( i - 1 ) * 2 * math.pi / EMBER_COUNT )
				end
			end
		end
	end
end
