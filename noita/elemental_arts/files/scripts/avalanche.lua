-- Avalanche: runs every 4 frames on the snowball.
-- Each run the snowball grows a little: more damage, bigger sprite.

local MAX_GROWTH      = 40    -- growth steps (40 steps of 4 frames = about 2.7 seconds)
local DAMAGE_PER_STEP = 0.05  -- 1.25 hit points per step, so +50 when fully grown
local MAX_EXTRA_SCALE = 2.0   -- fully grown it is drawn three times as large

local entity_id = GetUpdatedEntityID()
local x, y, rotation = EntityGetTransform( entity_id )
if x == nil then
	return
end

-- Find the growth counter.
local growth_comp = nil
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps ~= nil then
	for _, comp in ipairs( comps ) do
		if ComponentGetValue2( comp, "name" ) == "growth" then
			growth_comp = comp
			break
		end
	end
end
if growth_comp == nil then
	return
end

local growth = ComponentGetValue2( growth_comp, "value_int" ) or 0
if growth >= MAX_GROWTH then
	return
end
growth = growth + 1
ComponentSetValue2( growth_comp, "value_int", growth )

local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp ~= nil then
	local damage = ComponentGetValue2( projectile_comp, "damage" ) or 0
	ComponentSetValue2( projectile_comp, "damage", damage + DAMAGE_PER_STEP )
end

local scale = 1.0 + MAX_EXTRA_SCALE * growth / MAX_GROWTH
EntitySetTransform( entity_id, x, y, rotation or 0, scale, scale )
