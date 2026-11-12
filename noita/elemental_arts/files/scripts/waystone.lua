-- Waystone: runs once per cast.
-- First cast: leaves a waystone where the caster stands.
-- Next cast: brings the caster back to that waystone and uses it up.

local WAYSTONE_TAG  = "elemental_arts_waystone"
local WAYSTONE_FILE = "mods/elemental_arts/files/entities/misc/waystone.xml"
local POOF_FILE     = "data/entities/particles/poof_blue.xml"

local entity_id = GetUpdatedEntityID()

local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if projectile_comp == nil then
	return
end

local who_shot = ComponentGetValue2( projectile_comp, "mWhoShot" )
if who_shot == nil or who_shot == 0 or not EntityGetIsAlive( who_shot ) then
	return
end

local caster_x, caster_y = EntityGetTransform( who_shot )
if caster_x == nil or caster_y == nil then
	return
end

-- The player keeps the same key across saving and loading, when entity ids change.
local owner_key = tostring( who_shot )
if EntityHasTag( who_shot, "player_unit" ) then
	owner_key = "player"
end

-- Returns the component that stores a waystone's owner.
local function get_owner_comp( stone )
	local comps = EntityGetComponent( stone, "VariableStorageComponent" )
	if comps ~= nil then
		for _, comp in ipairs( comps ) do
			if ComponentGetValue2( comp, "name" ) == "owner" then
				return comp
			end
		end
	end
	return nil
end

-- Is there a waystone of this caster's already?
local my_stone = nil
local stones = EntityGetWithTag( WAYSTONE_TAG ) or {}
for _, stone in ipairs( stones ) do
	local owner_comp = get_owner_comp( stone )
	if owner_comp ~= nil and ComponentGetValue2( owner_comp, "value_string" ) == owner_key then
		my_stone = stone
		break
	end
end

if my_stone == nil then
	-- Place a new waystone.
	local stone = EntityLoad( WAYSTONE_FILE, caster_x, caster_y )
	if stone ~= nil then
		local owner_comp = get_owner_comp( stone )
		if owner_comp ~= nil then
			ComponentSetValue2( owner_comp, "value_string", owner_key )
		end
	end
	return
end

-- Return to the waystone.
local stone_x, stone_y = EntityGetTransform( my_stone )
if stone_x == nil or stone_y == nil then
	return
end

EntityLoad( POOF_FILE, caster_x, caster_y )
EntitySetTransform( who_shot, stone_x, stone_y )
EntityApplyTransform( who_shot, stone_x, stone_y )

-- Arrive standing still, not with whatever speed the caster had.
local char_comp = EntityGetFirstComponent( who_shot, "CharacterDataComponent" )
if char_comp ~= nil then
	ComponentSetValue2( char_comp, "mVelocity", 0, 0 )
end

EntityLoad( POOF_FILE, stone_x, stone_y )
EntityKill( my_stone )
