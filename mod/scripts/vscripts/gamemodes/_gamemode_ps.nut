global function GamemodePs_Init

const bool WHITELIST = false
const bool BLACKLIST = true

//===========================|EDITABLE VARIABLES START|===========================//

const bool FILTER_TYPE = BLACKLIST

const string DEFAULT_WEAPON_PRIMARY = "mp_weapon_wingman_n"
const string DEFAULT_WEAPON_SECONDARY = "mp_weapon_softball"
const string DEFAULT_WEAPON_BACKUP = "mp_weapon_arena3"

const array< string > WEAPONS_LIST = ["mp_weapon_rspn101","mp_weapon_mastiff","mp_weapon_r97","mp_weapon_alternator_smg","mp_weapon_car","mp_weapon_hemlok_smg","mp_weapon_lmg","mp_weapon_lstar","mp_weapon_esaw","mp_weapon_vinson","mp_weapon_hemlok","mp_weapon_g2","mp_weapon_shotgun","mp_weapon_smr","mp_weapon_pulse_lmg","mp_weapon_autopistol","mp_weapon_semipistol","mp_weapon_wingman","mp_weapon_shotgun_pistol","mp_weapon_rocket_launcher","mp_weapon_arc_launcher","mp_weapon_defender","mp_weapon_mgl","mp_weapon_rspn101_og","mp_weapon_smart_pistol","mp_weapon_yh803","mp_weapon_yh803_bullet","mp_weapon_yh803_bullet_overcharged"]

//============================|EDITABLE VARIABLES END|============================//

// SMGs:
// "mp_weapon_car"						 	CAR
// "mp_weapon_alternator_smg"  	Alternator
// "mp_weapon_r97"							R-97
// "mp_weapon_hemlok_smg"				Volt

// Assault rifles:
// "mp_weapon_rspn101"			R-201
// "mp_weapon_rspn101_og"		R-101
// "mp_weapon_vinson"				Flatline
// "mp_weapon_g2"						G2A5
// "mp_weapon_hemlok"				Hemlok

// LMGs:
// "mp_weapon_lmg"			Spitfire
// "mp_weapon_lstar"		L-Star
// "mp_weapon_esaw"			Devotion

// Sniper rifles:
// "mp_weapon_sniper"			Kraber
// "mp_weapon_dmr"				Longbow-DMR
// "mp_weapon_doubletake"	Doubletake

// Shotguns:
// "mp_weapon_mastiff"	Mastiff
// "mp_weapon_shotgun"	Eva-8

// Grenadier:
// "mp_weapon_smr"				Sidewinder SMR
// "mp_weapon_softball"		R-6P Softball
// "mp_weapon_epg"				EPG-1
// "mp_weapon_pulse_lmg"	EM-4 Coldwar

// Pistol:
// "mp_weapon_wingman"				Wingman
// "mp_weapon_wingman_n"			Wingman Elite
// "mp_weapon_semipistol"			P2016
// "mp_weapon_shotgun_pistol"	Mozambique
// "mp_weapon_autopistol"			RE-45

// Anti-titan:
// "mp_weapon_arc_launcher"			LG-97 Thunderbolt
// "mp_weapon_rocket_launcher"	Archer
// "mp_weapon_defender"					Charge Rifle
// "mp_weapon_mgl"							MLG Mag Launcher

// Grenades:
// "mp_weapon_grenade_electric_smoke"
// "mp_weapon_grenade_emp"
// "mp_weapon_grenade_gravity"
// "mp_weapon_frag_grenade"
// "mp_weapon_thermite_grenade"
// "mp_weapon_satchel"

// Other:
// "mp_weapon_deployable_cover"
// "mp_weapon_frag_drone"
// "mp_weapon_smart_pistol"
// "mp_weapon_grenade_sonar"


void function GamemodePs_Init()
{
	ClassicMP_ForceDisableEpilogue( true )
	SetShouldUseRoundWinningKillReplay( true )
	ScoreEvent_SetupEarnMeterValuesForMixedModes()
	Riff_ForceTitanAvailability( eTitanAvailability.Never )

	AddCallback_OnPlayerKilled( OnPlayerKilled )


	AddCallback_OnPlayerRespawned( OnPlayerRespawned )
	AddCallback_OnPlayerGetsNewPilotLoadout( OnPlayerChangeLoadout)
}

void function OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	if ( victim != attacker && victim.IsPlayer() && attacker.IsPlayer() && GetGameState() == eGameState.Playing )
	{
		AddTeamScore( attacker.GetTeam(), 1 )
		// why isn't this PGS_SCORE? odd game
		attacker.AddToPlayerGameStat( PGS_ASSAULT_SCORE, 1 )
	}
}

void function OnPlayerRespawned( entity player )
{
	ForceWeapon( player )
}

void function OnPlayerChangeLoadout( entity player , PilotLoadoutDef p)
{
	ForceWeapon( player )
}

void function ForceWeapon( entity player )
{
	bool hasAllowedWeapon = false

	foreach ( int enum_, entity weapon in player.GetMainWeapons() )
		if ( FILTER_TYPE == IsOnList( weapon.GetWeaponClassName() ) )
		{
			player.TakeWeaponNow( weapon.GetWeaponClassName() )

			SendHudMessage( player, "Thy Shall Fly", -1, 0.4, 255, 0, 0, 0, 0, 3, 0.15 )

			switch ( enum_ ) {
				case 0:
					if (DEFAULT_WEAPON_PRIMARY != "")
						player.GiveWeapon( DEFAULT_WEAPON_PRIMARY )
					break
				case 1:
					if (DEFAULT_WEAPON_SECONDARY != "")
						player.GiveWeapon( DEFAULT_WEAPON_SECONDARY )
					break
				case 2:
					if (DEFAULT_WEAPON_BACKUP != "")
						player.GiveWeapon( DEFAULT_WEAPON_BACKUP )
					break
				default:
					break
			}
		}
}

bool function IsOnList( string w )
{
	foreach ( weapon in WEAPONS_LIST ) {
		if ( weapon == w )	return true
	}
	return false
}