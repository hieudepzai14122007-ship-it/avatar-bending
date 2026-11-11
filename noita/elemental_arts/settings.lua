dofile( "data/scripts/lib/mod_settings.lua" )

local mod_id = "elemental_arts"
mod_settings_version = 1

mod_settings =
{
	{
		id = "starter_spells",
		ui_name = "Start with the new spells",
		ui_description = "Drops one copy of each Elemental Arts spell next to you\nat the start of a new run.",
		value_default = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id )
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
