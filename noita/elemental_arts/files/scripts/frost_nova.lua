-- Frost Nova: runs once, on the first frame of the burst.
-- Freezes every enemy within reach. The caster is never frozen.

local RADIUS = 72 -- pixels

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

local enemies = EntityGetInRadiusWithTag( x, y, RADIUS, "enemy" ) or {}
for _, id in ipairs( enemies ) do
	if id ~= who_shot then
		LoadGameEffectEntityTo( id, "data/entities/misc/effect_frozen.xml" )
	end
end
