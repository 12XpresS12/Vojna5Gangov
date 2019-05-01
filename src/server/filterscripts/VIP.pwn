#include <a_samp>

#include <vg5>
#include <vg5_languages>

#include <foreach>



public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}



CMD:vinvisible(playerid)
{
	if(PlayerInfo[playerid][vip] >= 1)
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
	}
	return 1;
}

CMD:vvr(playerid)
{
	if(PlayerInfo[playerid][vip] >= 1)
	{
 		if(IsPlayerInAnyVehicle(playerid))
 		{
	    	RepairVehicle(GetPlayerVehicleID(playerid));
	    	SendClientMessage(playerid, -1, "Vozidlo bolo opraven�!");
	    	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    }
	}
	return 1;
}

CMD:vnitro(playerid)
{
	if(PlayerInfo[playerid][vip] >= 1)
	{
 		if(IsPlayerInAnyVehicle(playerid))
 		{
	        new vehicleid = GetPlayerVehicleID(playerid);
   			AddVehicleComponent(vehicleid, 1010); // x10 nitro
	    	SendClientMessage(playerid, -1, "Do vozidla bolo pridan� Nitro!");
	    	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	    	
	    }
	}
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
	if(PlayerInfo[playerid][vip] >= 1)
	{
	    new tStr[32];
	    format(tStr, sizeof(tStr), "%s(%d)[%s]", PlayerName(playerid), playerid, VIPType[ PlayerInfo[playerid][vip] ] );
	    strcat(string, tStr);
	   	Dialog_Show(playerid, WeaponMenu, DIALOG_STYLE_MSGBOX, "VIP Online", "string", "Cancel");
	}
	return 1;
}

stock SendMessageToVIP(Message[]){ // VIP CHAT
	foreach(new p : Player)
	{
        if(PlayerInfo[p][vip] >= 1)
		{
		    new text[256];
		    format(text, sizeof(text), "@: %s", Message);
			SendClientMessage(p, COLOR_LIMEGREEN, text);
		}
	}
}

public OnPlayerText(playerid, text[])
{
	if (strcmp(text[0], "@", true) == 0)
	{
        if(PlayerInfo[playerid][vip] >= 1)
		{
	    	strreplace(text, "@", "");
	    	SendMessageToVIP(text);
	    	return 0;
	    	
	    }
	}
	return 1;
}


public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
