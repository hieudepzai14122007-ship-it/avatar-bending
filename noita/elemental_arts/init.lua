-- Elemental Arts - Spell Expansion
-- Adds five elemental spells to the spell pool.

local MOD_ID = "elemental_arts"

-- Register the new spells by appending to the vanilla spell list.
ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/elemental_arts/files/actions.lua" )

local STARTER_SPELLS =
{
	"ELEMENTAL_ARTS_WHIRLWIND",
	"ELEMENTAL_ARTS_TIDAL_ORB",
	"ELEMENTAL_ARTS_STONE_LANCE",
	"ELEMENTAL_ARTS_FLAME_SERPENT",
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

	for i, action_id in ipairs( STARTER_SPELLS ) do
		CreateItemActionEntity( action_id, x - 40 + i * 16, y - 12 )
	end
end
