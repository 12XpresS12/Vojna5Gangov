#include <a_samp>

#include <vg5>
#include <vg5_languages>
#include <vg5_callbacks>

#include <foreach>

#define MAX_COMMANDS_TIME 4
#define COMMAND_TIME_LIMIT 60

public OnFilterScriptInit()
{
	return 1;
}

/*
    CommandTime[player id] [ 0 / 1 ]
    0 - Timer
    1 - �as
*/
new CommandTime[MAX_PLAYERS+1][MAX_COMMANDS_TIME];
new VipTimer[MAX_PLAYERS];
// dorobi� aby pri odpojen� sa re�tartovalo...


CMD:vinvisible(playerid)
{
	if(IsPlayerVIP(playerid))
	{
	    if(gettime() >= (CommandTime[MAX_PLAYERS][0] + COMMAND_TIME_LIMIT))
		{
		    if(PlayerInfo[playerid][isInvisible])
		    {
	    		foreach(new i : Player)
				{
	 	 			SetPlayerMarkerForPlayer(i, playerid, COLOR_RED);
				}
				PlayerInfo[playerid][isInvisible] = false;
				SendClientMessage(playerid, COLOR_ORANGE, "Zviditelnil si sa na mape pred ostatn�ma hr��mi!");
			}else{
				foreach(new i : Player)
				{
			        SetPlayerMarkerForPlayer(i, playerid, 0xFFFFFF00);
				}
				PlayerInfo[playerid][isInvisible] = true;
				SendClientMessage(playerid, COLOR_ORANGE, "Zneviditelnil si sa na mape pred ostatn�ma hr��mi!");
			}
			CommandTime[MAX_PLAYERS][0] = gettime();
		}else {
			// ak e�te nepre�iel �as, ko�ko ch�ba aby to mohol pou�i� znova
			new string[128];
			format(string, sizeof(string), "E�te zost�va %i sekund, pre pou�itie pr�kazu!", ((CommandTime[MAX_PLAYERS][0] + COMMAND_TIME_LIMIT)-gettime()));
			SendClientMessage(playerid, COLOR_ORANGE, string);
		}
	}else SendClientMessage(playerid, COLOR_RED, "Nejsi VIP!");
	return 1;
}

CMD:vvr(playerid)
{
	if(IsPlayerVIP(playerid))
	{
		if(gettime() >= (CommandTime[MAX_PLAYERS][1] + COMMAND_TIME_LIMIT))
		{
	 		if(IsPlayerInAnyVehicle(playerid))
	 		{
		    	RepairVehicle(GetPlayerVehicleID(playerid));
		    	SendClientMessage(playerid, -1, "Vozidlo bolo opraven�!");
		    	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    	CommandTime[MAX_PLAYERS][1] = gettime();
		    }
	    }else {
			// ak e�te nepre�iel �as, ko�ko ch�ba aby to mohol pou�i� znova
			new string[128];
			format(string, sizeof(string), "E�te zost�va %i sekund, pre pou�itie pr�kazu!", ((CommandTime[MAX_PLAYERS][1] + COMMAND_TIME_LIMIT)-gettime()));
			SendClientMessage(playerid, COLOR_ORANGE, string);
		}
	}else SendClientMessage(playerid, COLOR_RED, "Nejsi VIP!");
	return 1;
}

CMD:vflip(playerid)
{
	if(IsPlayerVIP(playerid))
	{
		if(gettime() >= (CommandTime[MAX_PLAYERS][2] + COMMAND_TIME_LIMIT))
		{
	        if(IsPlayerInAnyVehicle(playerid))
			{
	  			new currentveh;
			    new Float:angle;
			    currentveh = GetPlayerVehicleID(playerid);
			    GetVehicleZAngle(currentveh, angle);
			    SetVehicleZAngle(currentveh, angle);
			    SendClientMessage(playerid, COLOR_LIMEGREEN, "Oto�il si vozidlo op� na koles�.");
			    CommandTime[MAX_PLAYERS][2] = gettime();
	  		}else SendClientMessage(playerid, COLOR_RED, "Niesi vo vozidle");

  		}else {
			// ak e�te nepre�iel �as, ko�ko ch�ba aby to mohol pou�i� znova
			new string[128];
			format(string, sizeof(string), "E�te zost�va %i sekund, pre pou�itie pr�kazu!", ((CommandTime[MAX_PLAYERS][2] + COMMAND_TIME_LIMIT)-gettime()));
			SendClientMessage(playerid, COLOR_ORANGE, string);
		}
	}else SendClientMessage(playerid, COLOR_RED, "Nejsi VIP!");
	return 1;
}

CMD:vnitro(playerid)
{
	if(IsPlayerVIP(playerid))
	{
	    if(gettime() >= (CommandTime[MAX_PLAYERS][3] + COMMAND_TIME_LIMIT))
		{
	 		if(IsPlayerInAnyVehicle(playerid))
	 		{
		        new vehicleid = GetPlayerVehicleID(playerid);
	   			AddVehicleComponent(vehicleid, 1010); // x10 nitro
		    	SendClientMessage(playerid, -1, "Do vozidla bolo pridan� Nitro!");
		    	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	            CommandTime[MAX_PLAYERS][3] = gettime();
		    }
	    }else {
			// ak e�te nepre�iel �as, ko�ko ch�ba aby to mohol pou�i� znova
			new string[128];
			format(string, sizeof(string), "E�te zost�va %i sekund, pre pou�itie pr�kazu!", ((CommandTime[MAX_PLAYERS][3] + COMMAND_TIME_LIMIT)-gettime()));
			SendClientMessage(playerid, COLOR_ORANGE, string);
		}
	}else SendClientMessage(playerid, COLOR_RED, "Nejsi VIP!");
	return 1;
}

static VIPType[][] = {
	{"BRONZE"},
	{"SILVER"},
	{"GOLD"}
};

CMD:vips(playerid)
{
	new string[512];
	foreach(new p : Player)
	{
	    if(IsPlayerVIP(p)){
			new tStr[32];
		 	format(tStr, sizeof(tStr), "%s(%d)[%s],", PlayerName(p), p, VIPType[ GetPlayerVIPLevel(p) - 1 ] );
		  	strcat(string, tStr);
	  	}
  	}
  	if(isnull(string)){
		format(string, sizeof(string), "�iadny VIP hr�� moment�lne nieje pripojen�!");
	}
  	Dialog_Show(playerid, viponline, DIALOG_STYLE_MSGBOX, "VIP Online", string, "Cancel", "");

	return 1;
}

CMD:setvip(playerid, params[])
{
	new pid, days, vType;
	if(sscanf(params, "iii", pid, days, vType)) return SendClientMessage(playerid, COLOR_LIGHTRED, "/setvip <playerid> <days> <vip type>");
	// 60*60*24 // 1 de�

	if(!IsPlayerConnected(pid))return SendClientMessage(playerid, COLOR_LIGHTRED, "Hr�� moment�lne nieje pripojen� na servery.");
	if(days <= 0 || days > 60) return SendClientMessage(playerid, COLOR_LIGHTRED, "Rozmedzie dn� ide vybra� iba od 1 a� maxim�lne po 60 dn�.");
	if(vType < 1 || vType > 3) return SendClientMessage(playerid, COLOR_LIGHTRED, "Typ VIP ide vybra� iba v rozmedzi� od 1-3, (BRONZE[1], SILVER[2], GOLD)[3]).");

	PlayerInfo[pid][vip] = vType;
	PlayerInfo[pid][vipTimeto] = (60*60*24*days) + gettime(); // + timestamp now
	new string[128];


	format(string, sizeof(string), "Nastavil si VIP Level %s hr��ovy %s(%d) na %d dn�.", VIPType[ GetPlayerVIPLevel(pid) - 1 ], PlayerName(pid), pid, days );
	SendClientMessage(playerid, COLOR_LIMEGREEN, string);
	if(pid != playerid){
		format(string, sizeof(string), "Administr�tor %s(%d) ti nastavil VIP Level %s, na %d dn�.",PlayerName(playerid), playerid, VIPType[ GetPlayerVIPLevel(pid) - 1 ], days );
		SendClientMessage(pid, COLOR_LIMEGREEN, string);
	}
	return 1;
}

CMD:unsetvip(playerid, params[])
{
	new pid, reason[128];
	if(sscanf(params, "is[61]", pid, reason)) return SendClientMessage(playerid, COLOR_LIGHTRED, "/unsetvip <playerid> <d�vod>");
	// 60*60*24 // 1 de�

	if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Hr�� moment�lne nieje pripojen� na servery.");
	if(!IsPlayerVIP(pid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Hr�� moment�lne nem� zak�pene VIP.");
	if(strlen(reason) <= 6 || strlen(reason) >= 60) return SendClientMessage(playerid, COLOR_LIGHTRED, "Rozmedzie d�vodu mus� ma� velkos� minim�lne 6 a maxim�lne 60.");

	PlayerInfo[pid][vip] = 0;
	PlayerInfo[pid][vipTimeto] =0;

	new string[256];
	format(string, sizeof(string), "Odobral si VIP hr��ovy %s(%d) za %s.", PlayerName(pid), pid, reason);
	SendClientMessage(playerid, COLOR_LIMEGREEN, string);

    if(pid != playerid){
		format(string, sizeof(string), "Administr�tor %s(%d) ti odobral VIP za %s",  PlayerName(playerid), playerid, reason);
		SendClientMessage(pid, COLOR_LIMEGREEN, string);
	}
	return 1;
}

CMD:vip(playerid, params[])
{
    Dialog_Show(playerid, vipvyhody, DIALOG_STYLE_MSGBOX, "VIP V�hody",
	"{00FF00}Bronze v�hody:\n{FFFFFF}- M��e vlastni� a� 5 vozidiel!\n\n{00FF00}Silver v�hody:\n{FFFFFF}- M��e vlastni� a� 6 vozidiel!\n\n{00FF00}Gold v�hody:\n{FFFFFF}- M��e vlastni� a� 7 vozidiel!"
	, "Cancel", "");
	return 1;
}

stock IsPlayerVIP(playerid)
{
	if(PlayerInfo[playerid][vip] >= 1 || PlayerInfo[playerid][adminLevel] > 0)
	{
		return true;
 	}
 	return false;
}

stock IsPlayerVIPLevel(playerid, level)
{
	if(GetPlayerVIPLevel >= level)
	{
		return true;
	}
	return false;
}

stock GetPlayerVIPLevel(playerid)
{
	return PlayerInfo[playerid][vip];
}

stock SendMessageToVIP(Message[]){ // VIP CHAT
	foreach(new p : Player)
	{
        if(PlayerInfo[p][vip] >= 1)
		{
		    new text[256];
		    format(text, sizeof(text), "%s", Message);
			SendClientMessage(p, COLOR_LIMEGREEN, text);
		}
	}
}

public OnPlayerText(playerid, text[])
{
	if (text[0] == '@')
	{
        if(IsPlayerVIP(playerid))
		{
			text[0] = ' ';
			format(text, 256, "@%s(%d):%s", PlayerName(playerid), playerid, text);
	    	SendMessageToVIP(text);
	    	return 0;

	    }
	}
	return 1;
}

forward RemoveVip(playerid);
public RemoveVip(playerid)
{
	PlayerInfo[playerid][vip] = 0;
	PlayerInfo[playerid][vipTimeto] = 0;
	SendClientMessage(playerid, -1, "Pr�ve ti skon�ilo VIP!");
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(IsPlayerVIP(playerid))
	{
	    if(VipTimer[playerid] < 0)
		{
		    if(	gettime()-PlayerInfo[playerid][vipTimeto] <= 0)
			{
			    // kedy m� skon�i� VIP             <= aktu�lny �as - 1hodina
				if((gettime()-PlayerInfo[playerid][vipTimeto]) <= (60*60*5) ) // ak je �as menej or == hodine, d� timer aby mu to odp�salo VIP po hodine
				{
				   VipTimer[playerid] = SetTimerEx("RemoveVip", PlayerInfo[playerid][vipTimeto], false, "i", playerid); // spust� timer ak mu kon�� VIP o 5 hod�n alebo menej
				}
			}else PlayerInfo[playerid][vip] = 0;
		}
	}
	return 1;
}

public OnFilterScriptExit()
{
	for(new pid; pid < MAX_PLAYERS; pid++)
	{
	    if(VipTimer[pid] > 0) KillTimer(VipTimer[pid]);
	    for(new i; i < MAX_COMMANDS_TIME; i++) CommandTime[pid][i] = 0;
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(VipTimer[playerid] > 0) KillTimer(VipTimer[playerid]);
 	for(new i; i < MAX_COMMANDS_TIME; i++) CommandTime[playerid][i] = 0;
	return 1;
}
