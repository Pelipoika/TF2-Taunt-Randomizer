#include <tf2_stocks>

#pragma newdecls required

// Taunt attack types, some of these are propably wrong
enum
{
	TAUNTATK_NONE,
	TAUNTATK_PYRO_HADOUKEN,
	TAUNTATK_HEAVY_EAT,
	TAUNTATK_HEAVY_RADIAL_BUFF,
	TAUNTATK_HEAVY_HIGH_NOON,
	TAUNTATK_SCOUT_DRINK,
	TAUNTATK_SCOUT_GRAND_SLAM,
	TAUNTATK_MEDIC_INHALE,
	TAUNTATK_SPY_FENCING_SLASH_A,
	TAUNTATK_SPY_FENCING_SLASH_B,
	TAUNTATK_SPY_FENCING_STAB,
	TAUNTATK_RPS_KILL,
	TAUNTATK_SNIPER_ARROW_STAB_IMPALE,
	TAUNTATK_SNIPER_ARROW_STAB_KILL,
	TAUNTATK_SOLDIER_GRENADE_KILL,
	TAUNTATK_DEMOMAN_BARBARIAN_SWING,
	TAUNTATK_MEDIC_UBERSLICE_IMPALE,
	TAUNTATK_MEDIC_UBERSLICE_KILL,
	TAUNTATK_FLIP_LAND_PARTICLE,
	TAUNTATK_RPS_PARTICLE,
	TAUNTATK_HIGHFIVE_PARTICLE,
	TAUNTATK_ENGINEER_GUITAR_SMASH,
	TAUNTATK_ENGINEER_ARM_IMPALE,
	TAUNTATK_ENGINEER_ARM_KILL,
	TAUNTATK_ENGINEER_ARM_BLEND,
	TAUNTATK_SOLDIER_GRENADE_KILL_WORMSIGN,
	TAUNTATK_SHOW_ITEM,
	TAUNTATK_MEDIC_RELEASE_DOVES,
	TAUNTATK_PYRO_ARMAGEDDON,
	TAUNTATK_PYRO_SCORCHSHOT,
	TAUNTATK_ALLCLASS_GUITAR_RIFF,
	TAUNTATK_MEDIC_HEROIC_TAUNT,
	TAUNTATK_PYRO_GASBLAST
}

//Offsets
int g_iTauntAttack;
int g_iTauntAttackTime;

public Plugin myinfo = 
{
	name = "[TF2] Taunt Randomizer",
	author = "Pelipoika",
	description = "Randomizes your taunt when you taunt",
	version = "1.0",
	url = "http://www.sourcemod.net/plugins.php?author=Pelipoika&search=1"
};

public void OnPluginStart()
{
	Handle hConf = LoadGameConfigFile("tf2.randomtaunt");

	if(LookupOffset(g_iTauntAttack,      "CTFPlayer", "m_iSpawnCounter")) g_iTauntAttack     -= GameConfGetOffset(hConf, "m_iTauntAttack");
	if(LookupOffset(g_iTauntAttackTime,  "CTFPlayer", "m_iSpawnCounter")) g_iTauntAttackTime -= GameConfGetOffset(hConf, "m_flTauntAttackTime");
	
	delete hConf;
}

public void TF2_OnConditionAdded(int client, TFCond cond)
{
	if(cond == TFCond_Taunting)
	{
		SetEntData(client, g_iTauntAttack, GetRandomInt(1, 31), _, true);
				
		int   m_iTauntAttack    = GetEntData(client,      g_iTauntAttack);	   //@7924
		float flTaultAttackTime = GetEntDataFloat(client, g_iTauntAttackTime); //@7916
		
		if(flTaultAttackTime == 0.0)
		{
			float flTime = GetGameTime() + GetRandomFloat(0.0, 3.0);
			SetEntDataFloat(client, g_iTauntAttackTime, flTime, true);
			
			flTaultAttackTime = flTime;
		}
		
	//	PrintToChatAll("flTaultAttackTime %f (@%i) m_iTauntAttack %i (@%i)", flTaultAttackTime, g_iTauntAttackTime, m_iTauntAttack, g_iTauntAttack);
	}
}

bool LookupOffset(int &iOffset, const char[] strClass, const char[] strProp)
{
	iOffset = FindSendPropInfo(strClass, strProp);
	if(iOffset <= 0)
	{
		LogMessage("Could not locate offset for %s::%s!", strClass, strProp);
		return false;
	}

	return true;
}