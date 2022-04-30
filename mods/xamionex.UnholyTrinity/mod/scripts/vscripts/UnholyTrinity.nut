untyped

global function UnholyTrinity_Init

int uht_wenttolobbyfirst
string uht_map
string uht_gamemode

void function UnholyTrinity_Init()
{
	uht_wenttolobbyfirst = GetConVarInt( "uht_wenttolobbyfirst" )

	if( uht_wenttolobbyfirst == 0)
	{
		if( GetMapName() == "mp_lobby" )
		{
			//SetConVarString ( "uht_map", "mp_forwardbase_kodai" )
			SetConVarInt( "uht_wenttolobbyfirst", 1 )
			SetConVarString ( "uht_map", GetConVarString( "ns_private_match_last_map" ) )
			SetConVarString ( "uht_gamemode", GetConVarString( "ns_private_match_last_mode" ) )
			return
		}
		else
		{
			SetConVarString ( "uht_map", GetMapName() )
			SetConVarString( "uht_gamemode", GetConVarString( "mp_gamemode" ) )
		}

		SetCurrentPlaylist( "private_match" )
		GameRules_ChangeMap( "mp_lobby", "private_match" )
		SetConVarInt( "uht_wenttolobbyfirst", 1 )
	}
	thread ThreadUnholyTrinity()
}

void function ThreadUnholyTrinity()
{
	wait 2.0

	if( GetMapName() == "mp_lobby" )
	{
		uht_gamemode = GetConVarString( "uht_gamemode" )
		uht_map = GetConVarString( "uht_map" )

		SetPlaylistVarOverride( "custom_air_accel_pilot", "9000" )
		SetPlaylistVarOverride( "featured_mode_amped_tacticals", "1" )
		SetPlaylistVarOverride( "fp_embark_enabled", "1" )
		SetPlaylistVarOverride( "pilot_health_multiplier", "1.01" )
		SetPlaylistVarOverride( "oob_timer_enabled", "0" )
		SetPlaylistVarOverride( "no_pilot_collision", "1" )
		SetPlaylistVarOverride( "run_epilogue", "0" )
		SetPlaylistVarOverride( "classic_mp", "0" )
		SetPlaylistVarOverride( "scorelimit", "200" )
		SetPlaylistVarOverride( "timelimit", "30" )
		ServerCommand( "slide_step_velocity_reduction -45" )

		SetCurrentPlaylist( uht_gamemode )
		GameRules_ChangeMap( uht_map , uht_gamemode )
	}
}