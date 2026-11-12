-- Ember Halo: runs every frame on each ember. Moves it around its caster.

local ORBIT_RADIUS = 24    -- pixels from the caster
local ORBIT_SPEED  = 0.11  -- radians per frame: one full turn in about a second

local entity_id = GetUpdatedEntityID()

local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp == nil then
	return
end

-- Without a caster to circle, the ember goes out.
local who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" )
if who_shot == nil or who_shot == 0 or not EntityGetIsAlive( who_shot ) then
	EntityKill( entity_id )
	return
end
local centre_x, centre_y = EntityGetTransform( who_shot )
if centre_x == nil or centre_y == nil then
	return
end
centre_y = centre_y - 4 -- roughly the caster's chest

local phase = 0
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps ~= nil then
	for _, comp in ipairs( comps ) do
		if ComponentGetValue2( comp, "name" ) == "phase" then
			phase = ComponentGetValue2( comp, "value_float" ) or 0
		end
	end
end

local angle = phase + GameGetFrameNum() * ORBIT_SPEED
EntitySetTransform( entity_id, centre_x + math.cos( angle ) * ORBIT_RADIUS, centre_y + math.sin( angle ) * ORBIT_RADIUS )
