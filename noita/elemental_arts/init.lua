-- Elemental Arts - Spell Expansion
-- Adds thirteen elemental spells to the spell pool.

local MOD_ID = "elemental_arts"

-- Register the new spells by appending to the vanilla spell list.
ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/elemental_arts/files/actions.lua" )

local STARTER_SPELLS =
{
	"ELEMENTAL_ARTS_WHIRLWIND",
	"ELEMENTAL_ARTS_TIDAL_ORB",
	"ELEMENTAL_ARTS_STONE_LANCE",
	"ELEMENTAL_ARTS_FLAME_SERPENT",
	"ELEMENTAL_ARTS_GLACIAL_SHARDS",
	"ELEMENTAL_ARTS_UPDRAFT",
	"ELEMENTAL_ARTS_MAGMA_BOMB",
	"ELEMENTAL_ARTS_THUNDERSTRIKE",
	"ELEMENTAL_ARTS_FROST_NOVA",
	"ELEMENTAL_ARTS_FIRE_PILLAR",
	"ELEMENTAL_ARTS_GALE_BARRIER",
	"ELEMENTAL_ARTS_QUAGMIRE",
	"ELEMENTAL_ARTS_ATTUNEMENT",
}

local STARTER_FLAG = "elemental_arts_starter_spells_given"

-- Optionally drop one copy of every new spell next to the player at the
-- start of a new run, so the spells can be tried without hunting for them.
function OnPlayerSpawned( player_entity )
	if GameHasFlagRun( STARTER_FLAG ) then
		return
	end
	GameAddFlagRun( STARTER_FLAG )

	-- ModSettingGet returns nil until the setting has been saved once,
	-- so only an explicit "false" turns the starter spells off.
	if ModSettingGet( MOD_ID .. ".starter_spells" ) == false then
		return
	end

	local x, y = EntityGetTransform( player_entity )
	if x == nil then
		return
	end

	-- Lay the spells out in rows centred on the player, so that a long list
	-- does not end up inside the walls on either side.
	local per_row = 7
	local spacing = 14
	local count = #STARTER_SPELLS
	for i, action_id in ipairs( STARTER_SPELLS ) do
		local row = math.floor( ( i - 1 ) / per_row )
		local column = ( i - 1 ) % per_row
		local in_this_row = math.min( per_row, count - row * per_row )
		local first_x = x - ( in_this_row - 1 ) * spacing * 0.5
		CreateItemActionEntity( action_id, first_x + column * spacing, y - 12 - row * 16 )
	end
end
