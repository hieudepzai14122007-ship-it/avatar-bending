-- Stone Form: runs once per cast. Turns the caster to living stone for a moment:
-- nothing can hurt them, and they cannot move.

local PROTECTION_FILE = "data/entities/misc/effect_protection_all_short.xml"
local STONE_FILE      = "mods/elemental_arts/files/entities/misc/stone_form_effect.xml"

local entity_id = GetUpdatedEntityID()

local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp == nil then
	return
end
local who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" )
if who_shot == nil or who_shot == 0 or not EntityGetIsAlive( who_shot ) then
	return
end

LoadGameEffectEntityTo( who_shot, PROTECTION_FILE )
LoadGameEffectEntityTo( who_shot, STONE_FILE )
