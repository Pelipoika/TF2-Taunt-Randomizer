#include <tf2_stocks>

#pragma newdecls required

// Taunt attack types, some of these are propably wrong
enum
{
	TF_TAUNT_NONE,
	TF_TAUNT_PYRO,				//1
	TF_TAUNT_SANDVICH,			//2
	TF_TAUNT_DALOKOHS,			//3
	TF_TAUNT_SHOWDOWN,			//4
	TF_TAUNT_SPY2,				//5
	TF_TAUNT_GRAND_SLAM,		//6
	TF_TAUNT_UNKNOWN1,			//7
	TF_TAUNT_SNIPER_KILL,		//8
	TF_TAUNT_FENCING1,			//9
	TF_TAUNT_FENCING2,			//10
	TF_TAUNT_UNKNOWN2,			//11
	TF_TAUNT_ARROW_STAB,   		//12
	TF_TAUNT_ARROW_STAB_PULL,	//13
	TF_TAUNT_HAND_GRENADE,		//14
	TF_TAUNT_EYELANDER,			//15
	TF_TAUNT_UBERSAW,			//16
	TF_TAUNT_UBERSAW_PULL,		//17
	TF_TAUNT_UNKNOWN3,			//18
	TF_TAUNT_UNKNOWN4,			//19
	TF_TAUNT_UNKNOWN5,			//20
	TF_TAUNT_GUITAR_SMASH,		//21
	TF_TAUNT_ARM_DRILL,			//22
	TF_TAUNT_ARM_DRILL_PULL,	//23
	TF_TAUNT_ARM_DRILL2,		//24
	TF_TAUNT_HOLY_HAND_GRENADE,	//25
	TF_TAUNT_UNKNOWN6,			//26
	TF_TAUNT_DOVES,				//27 / TF_TAUNT_HEROIC
	TF_TAUNT_ARMAGEDDON,		//28
	TF_TAUNT_UNKNOWN7,			//29
	TF_TAUNT_SHRED_ALERT,		//30
	TF_TAUNT_MEET_THE_MEDIC,	//31
};

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