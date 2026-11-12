-- Stone Form: runs every frame on the effect attached to the caster.
-- A statue does not walk, fall or fly: all movement is cancelled.

local effect_id = GetUpdatedEntityID()
local caster = EntityGetRootEntity( effect_id )
if caster == nil or caster == 0 or caster == effect_id then
	return
end

local char_comp = EntityGetFirstComponent( caster, "CharacterDataComponent" )
if char_comp == nil then
	return
end

ComponentSetValue2( char_comp, "mVelocity", 0, 0 )
