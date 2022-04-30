untyped

global function UnholyTrinity_Init

array<string> maplist = ["mp_forwardbase_kodai", "mp_grave","mp_homestead","mp_thaw","mp_black_water_canal","mp_eden","mp_drydock","mp_crashsite3","mp_complex3","mp_coliseum","mp_angel_city","mp_colony02","mp_relic02","mp_glitch","mp_lf_stacks","mp_lf_meadow","mp_lf_deck","mp_lf_traffic","mp_lf_township","mp_lf_uma","mp_coliseum_column","mp_wargames","mp_rise"]
array<string> types = ["ps","gg","tt","inf","fastball","ctf_comp","hs","cp","lts","ctf","ttdm","turbo_ttdm","attdm","ffa","fra","coliseum","lf","rocket_lf","mfd", "chamber"]
int wentToLobbyFirst

void function UnholyTrinity_Init()
{
	wentToLobbyFirst = GetConVarInt( "uht_wenttolobbyfirst" )
	
	if( wentToLobbyFirst == 0)
	{
		SetCurrentPlaylist( "private_match" ) 
		GameRules_ChangeMap( "mp_lobby", "private_match" )
		SetConVarInt( "uht_wenttolobbyfirst", 1 )
	}
	thread ThreadUnholyTrinity()
}

void function ThreadUnholyTrinity()
{
	wait 5.0

	if( GetMapName() == "mp_lobby" )
	{
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
		
		SetCurrentPlaylist( SelectedType() ) 
		GameRules_ChangeMap( SelectedMap(), SelectedType() )
	}
}

string function SelectedMap() // thanks peepeepoopooman :)
{
	string map = GetCurrentPlaylistVarString( "ReplacementMap", "mp_forwardbase_kodai" )
	if ( maplist.find( map ) != -1 )
	{
		return GetCurrentPlaylistVarString( "ReplacementMap", "mp_forwardbase_kodai" ) 
	}
	print("uh oh, someone entered a bad mapname")
	return "mp_forwardbase_kodai"
}

string function SelectedType() // thanks peepeepoopooman :)
{
	string map = GetCurrentPlaylistVarString( "ReplacementMode", "tdm" )
	if ( types.find( map ) != -1 )
	{
		return GetCurrentPlaylistVarString( "ReplacementMode", "tdm" ) 
	}
		print( "uh oh, someone entered a bad gametype" )
		return "tdm"
}