-- Smoke Veil: runs once per cast. Makes the caster invisible for a few seconds.

local VEIL_FILE = "mods/elemental_arts/files/entities/misc/smoke_veil_effect.xml"

local entity_id = GetUpdatedEntityID()

local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp == nil then
	return
end
local who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" )
if who_shot == nil or who_shot == 0 or not EntityGetIsAlive( who_shot ) then
	return
end

LoadGameEffectEntityTo( who_shot, VEIL_FILE )
