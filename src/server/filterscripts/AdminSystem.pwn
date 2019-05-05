#include <a_samp>

#include <vg5>
#include <vg5_languages>
#include <vg5_callbacks>

#include <foreach>

/*
TO-DO for Admin Sysetm
LEVEL 0: /admins /cdotaz  --- /vips /vip

LEVEL 1: /goto /spec /specff /slay /var /ahelp /say /event // /dotazy /dotazremove /esok /loadpos
LEVEL 2: /mute /unmute /freeze /unfreeze /esok /get /heal /healr /cc (clearchat)
LEVEL 3: /kick /respawnveh /respawnvehr (radius) /akill /alockr /aunlockr /hban ( max 6 hod�n )
LEVEL 4: /dban (max. 31 dn�) /unban /aveh /crash /saveall /setwl /getwl
LEVEL 5: /ipban /ban /pban /log /svar /gmx /god /setpos /savepos /log
LEVEL 6: /setlvl /setvip /hydra /addvehicle ( to - player )

*/
new MuteTime[MAX_PLAYERS];

enum E_PLAYER_HELP {
	helpName[32],
	helpContent[1024],
	
	bool:secondQOA,
	bool:isCreated,
	bool:showForAdmin,

	adminID
};

new AdminHelp[MAX_PLAYERS][E_PLAYER_HELP];
//ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 1, 1, 1, 0);
CMD:pomoc(playerid, params[])
{
	if(GetAdminLevel(playerid) >= 1 || IsPlayerConnected(playerid)) return SendClientMessage(playerid, COLOR_RED, "Neviem o �o ti ide, ale nesk��aj to u�.");
	if(AdminHelp[playerid][isCreated]) // pokia� bola vytvoren� u� pomoc budu medzi sebou komunikova� t�mto sp�sobom
	{
	    new qoa[256];
	    if(sscanf(params, "s[256]", qoa)) return SendClientMessage(playerid, -1, "Usage: /pomoc <ot�zka/odpove�>");
	  
		format(qoa, sizeof(qoa), "**HELP %s(%d):{FFFFFF} %s",PlayerName(playerid), playerid, qoa);
	    SendClientMessage(AdminHelp[playerid][adminID], COLOR_LIGHTBLUE, qoa);
	    SendClientMessage(playerid, COLOR_LIGHTBLUE, qoa);
	}else{
		new dName[32];
		if(sscanf(params, "s[32]", dName)) return SendClientMessage(playerid, -1, "Usage: /pomoc <n�zov>");
		if(AdminHelp[playerid][isCreated]) return SendClientMessage(playerid, -1, "U� m� jednu vytvoren�, po�kaj k�m sa dorie�� jedna a potom si zalo� nov�!");
		if(!IsAnyAdminConnected()) return SendClientMessage(playerid, -1, "Bohu�ia�, ale �iadni admin nieje online, sk�s pou�i� /help alebo /cmds");

		AdminHelp[playerid][showForAdmin] = false;
		format(AdminHelp[playerid][helpName], 32, "%s", dName);
		Dialog_Close(playerid);
		Dialog_Show(playerid, HelpContentCreate, DIALOG_STYLE_INPUT, "Help od admina", "Pros�m zadaj s ��m chce� pom�c� od adminov na servery.", "Send", "Cancel");
	}
	return 1;
}

CMD:solved(playerid, params[]) // dorobi� pre adminov, alebo hr�� m��e ozna�i� �iados� o pomoc ako vyrie�en�
{
	
	new null[E_PLAYER_HELP]; // nulov� hodnota ktor� dosad�me potom
	if(GetAdminLevel(playerid) >= 1 || IsPlayerConnected(playerid))
	{
	    new pid;
	    if(sscanf(params, "i", pid)) return SendClientMessage(playerid, -1, "Usage: /solved <id>");
	    if(AdminHelp[pid][isCreated])
		{
		    AdminHelp[pid] = null;
		    SendClientMessage(playerid, COLOR_YELLOW, "Ozna�il si odpove� za vyrie�en�!");
	    }else return SendClientMessage(playerid, COLOR_YELLOW, "Hr�� nevytvoril �iadnu odpove� tak�e nem��e� ju ozna�i� za vyrie�en�!");
	}else Dialog_Show(playerid, HelpAgreeSolve, DIALOG_STYLE_MSGBOX, "Pomoc", "Si si ist�, �e chce� ozna�i� tvoju pomoc za vyrie�en� ?", "�no", "Nie");
	return 1;
}

Dialog:HelpAgreeSolve(playerid, response, listitem, inputtext[])
{
	if(!response) Dialog_Close(playerid);
	else {
		if(AdminHelp[playerid][isCreated])
		{
		   	new null[E_PLAYER_HELP];
		   	AdminHelp[playerid] = null;
		   	SendClientMessage(playerid, COLOR_YELLOW, "Tvoja odpove� bola ozna�en� za vyrie�en�.");
 		}else return SendClientMessage(playerid, COLOR_YELLOW, "Nevytvoril si �iadnu odpove� na to aby si ju ozna�il za vyrie�en�!");
 	}
	return 1;
}

Dialog:HelpContentCreate(playerid, response, listitem, inputtext[])
{
	if(!response) Dialog_Close(playerid);
	else {
	    AdminHelp[playerid][isCreated] = true;
	    format(AdminHelp[playerid][helpContent], 128, "%s", inputtext);
 
        SendClientMessage(playerid, -1, AdminHelp[playerid][helpContent]);
 
		Dialog_Close(playerid);
		SetTimerEx("showconfirmdialog", 200, false, "i", playerid);

 	}
	return 1;
}

forward showconfirmdialog(playerid);
public showconfirmdialog(playerid)
{
	if(isnull( AdminHelp[playerid][helpContent]))  return 	Dialog_Show(playerid, HelpContentCreate, DIALOG_STYLE_INPUT, "Help od admina", "Pros�m zadaj s ��m chce� pom�c� od adminov na servery.", "Confirm", "Cancel");
	Dialog_Show(playerid, ConfirmHelpSend, DIALOG_STYLE_MSGBOX, "Potvrdi� odoslanie", AdminHelp[playerid][helpContent], "Confirm", "Cancel");
	return 1;
}

Dialog:ConfirmHelpSend(playerid, response, listitem, inputtext[]) // na potvrdenie pre istotou som mu zobrazil e�te jeden dialog, aby sa uistil, �i s� v�etk� �daje spr�vne
{
	if(!response) Dialog_Close(playerid);
	else {
	    SendClientMessage(playerid, -1, "Ot�zka bola zaslan� online administr�torom, a bude na nu odpovedan� �o len to bude mo�n�!");
 		SendAdminMessage("Hr�� si po�iadal o pomoc, pom�� mu to vyrie�i� pr�kazom /apomoc <id>"); // dopl� ID
		AdminHelp[playerid][showForAdmin] = true;
	}
	return 1;
}

CMD:apomoc(playerid, params[])
{
	if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid)){
		new pid, qoa[256];
		if(sscanf(params, "is[256]", pid, qoa))// return SendClientMessage(playerid, -1, "Usage /apomoc <playerid> <text>");
		{
		    // ak sa nezhoduje form�t /apomoc, vyhod� mu to dialog so v�etk�mi hr��mi ktor� po�iadali o pomoc
		    new string[512];

			new tempStr2[128] = "NAME\tPLAYER\tASSIGNED ADMIN\n";
	    
		    strcat(string, tempStr2);
		    foreach(new p : Player)
			{
				if(AdminHelp[p][isCreated])
				{
				    // N�zov - PlayerName - [AdminName]
				    new tempStr[128];
				    format(tempStr, sizeof(tempStr), "%s\t%s(%d)\t%s\n",AdminHelp[p][helpName],PlayerName(p),p, AdminHelp[p][adminID]);
				    strcat(string, tempStr);
				}
			}
		    
		    Dialog_Show(playerid, AdminHelpList, DIALOG_STYLE_TABLIST_HEADERS, "Ot�zky hr��ov", string, "Prideli�", "Cancel");
		}else{
			if(pid == playerid) return SendClientMessage(playerid, -1, "Neviem, �o si sk��al ale nep�jde ti to!");

			if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, -1, "Hr�� nieje online alebo sa odpojil!");
			if(!AdminHelp[pid][isCreated]) return SendClientMessage(playerid, -1, "Hr�� si nepo�iadal o pomoc!");
			if(!AdminHelp[pid][showForAdmin]) return SendClientMessage(playerid, -1, "Zatia� to nieje mo�n� zobrazi�!");

	        AdminHelp[pid][adminID] = playerid;

			new string[128];
			if(AdminHelp[pid][secondQOA])
			{
				format(string, sizeof(string), "Administr�tor %s(%d) odpovedal na va�u ot�zku. Pre �al�ie komunikovanie pou�i /pomoc <ot�zka/odpove�>",PlayerName(playerid),playerid);
	        	SendClientMessage(pid, COLOR_YELLOW, string);


	     	 	format(string, sizeof(string), "Odpovedal si na ot�zku hr��a, pre �al�ie komunikovanie pouzi /apomoc %d <text>", pid);
	        	SendClientMessage(playerid, COLOR_YELLOW, string);
	        }else{
	            AdminHelp[pid][secondQOA] = true;
			}
	        format(qoa, sizeof(qoa), "**AHELP %s(%d):{FFFFFF} %s",PlayerName(playerid), playerid, qoa);
	        SendClientMessage(pid, COLOR_LIGHTBLUE, qoa);
	        SendClientMessage(playerid, COLOR_LIGHTBLUE, qoa);
        }
	}
	return 1;
}

CMD:admins(playerid)
{
	new string[512], x;
	foreach(new p : Player)
	{
		if(GetAdminLevel(p) > 0 && !AdminInfo[playerid][aVisible])
		{
		    new tStr[70];
		    format(tStr, sizeof(tStr), "%s(%i) - Level(%d)", PlayerName(p),p,GetAdminLevel(p));
			strcat(string, tStr);
           	if(IsPlayerAdmin(p)) // ak m� RCON prid�me +RCON k Admin levelu
			{
		    	format(tStr, sizeof(tStr), "+[RCON]", PlayerName(p),p);
				strcat(string, tStr);
			}
			strcat(string, ", ");
		}

		if(x >= 2) // ak su dvaja ved�a seba vlo��me \n aby u� dal�� i�li  do �al�ieho riadku
		{
			x = 0;
			strcat(string, "\n");
		}
		x++;
	}
	if(isnull(string)) strcat(string, "Moment�lne nieje online �iadny administr�tor");
	Dialog_Show(playerid, AdminList, DIALOG_STYLE_MSGBOX, "Online Administratori", string, "Cancel", ""); // vyp�e online adminov do DIALOGU a zobraz� ich

	return 1;
}

CMD:ahelp(playerid)
{
    if(GetAdminLevel(playerid) >= 0 || IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "/admins /cdotaz /help /commands(cmds)");
    if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "================================ ADMIN-HELP ================================");
	if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "/goto /spec /specff /slay /var /ahelp /say /event // /dotazy /dotazremove /esok /loadpos");
    if(GetAdminLevel(playerid) >= 2 || IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "/mute /unmute /freeze /unfreeze /esok /get /heal /healr /cc (clearchat)");
    if(GetAdminLevel(playerid) >= 3 || IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "/kick /respawnveh /respawnvehr (radius) /akill /alockr /aunlockr /hban ( max 6 hod�n )");
    if(GetAdminLevel(playerid) >= 4 || IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "/dban (max. 31 dn�) /unban /aveh /crash /saveall /setwl /getwl");
    if(GetAdminLevel(playerid) >= 5 || IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "/ipban /ban /pban /log /svar /gmx /god /setpos /savepos /log");
    if(GetAdminLevel(playerid) >= 6 || IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "/setlvl /setvip /hydra /addvehicle ( to - player )");
    if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_LIGHTBLUE, "================================ ADMIN-HELP ================================");
	return 1;
}

forward clearAnim(playerid);
public clearAnim(playerid)
{
	if(IsPlayerConnected(playerid)) ClearAnimations(playerid);
	return 1;
}

CMD:say(playerid, params[])
{
    if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid))
    {
        new text[256];
		if(sscanf(params, "s[256]", text)) return SendClientMessage(playerid, -1, "/say <text>");

		format(text, sizeof(text), "**Admin %s(%d): %s", PlayerName(playerid), playerid, text);
		SendClientMessageToAll(COLOR_LIGHTBLUE, text);
	}
	return 1;
}

CMD:esok(playerid, params[])
{
    if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid))
    {
        new pid,text[128];
		if(sscanf(params, "is[128]",pid, text)) return SendClientMessage(playerid, COLOR_RED, "Usage: /esok <playerid> <reason>");
		if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_RED, "Hr�� moment�lne nieje online!");

		new Float:pos[3];
		GetPlayerPos(pid, pos[0], pos[1], pos[2]);
        if(IsPlayerInAnyVehicle(pid)) SetPlayerPos(pid, pos[0], pos[1], pos[2]+0.6);

        SetTimerEx("clearAnim", 1000*6, false, "i", pid);
        ApplyAnimation(pid, "CRACK", "crckdeth2", 4.0, 1, 1, 1, 1, 0);

		format(text, sizeof(text), "Hr�� %s(%i) dostal elektrick� �ok od administr�tora %s(%d) za %s.",PlayerName(pid), pid,PlayerName(playerid), playerid, text);
		SendClientMessageToAll(COLOR_LIGHTBLUE, text);
	}
	return 1;
}

CMD:slay(playerid, params[])
{
    if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid))
    {
        new pid,text[128];
		if(sscanf(params, "is[128]",pid, text)) return SendClientMessage(playerid, COLOR_RED, "Usage: /slay <playerid> <reason>");
		if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_RED, "Hr�� moment�lne nieje online!");

		new Float:pos[3];
		GetPlayerPos(pid, pos[0], pos[1], pos[2]);
        if(IsPlayerInAnyVehicle(pid)) SetPlayerPos(pid, pos[0], pos[1], pos[2]+0.6);

        SetTimerEx("clearAnim", 1000*3, false, "i", pid);
        ApplyAnimation(pid, "CRACK", "crckdeth2", 4.0, 1, 1, 1, 1, 0);

		format(text, sizeof(text), "Hr�� %s(%i) dostal facku od administr�tora %s(%d) za %s.", PlayerName(pid), pid,PlayerName(playerid), playerid, text);
		SendClientMessageToAll(COLOR_LIGHTBLUE, text);
	}
	return 1;
}

CMD:warn(playerid, params[])
{
    if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid))
    {
        new pid,text[128];
		if(sscanf(params, "is[128]",pid, text)) return SendClientMessage(playerid, COLOR_RED, "Usage: /warn <playerid> <reason>");
		if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_RED, "Hr�� moment�lne nieje online!");
		AdminInfo[pid][varns]++;

		format(text, sizeof(text), "[%i/3] Hr�� %s(%i) dostal varovanie od administr�tora %s(%d) za %s.",AdminInfo[pid][varns], PlayerName(pid), pid,PlayerName(playerid), playerid, text);

		if(AdminInfo[pid][varns] >= 3)
		{
			KickEx(playerid, text);
	 	}


		SendClientMessageToAll(COLOR_LIGHTBLUE, text);
	}
	return 1;
}

CMD:mute(playerid, params[])
{
    if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid))
    {
        new pid,time, reason[128];
		if(sscanf(params, "iis[128]",pid,time, reason)) return SendClientMessage(playerid, -1, "/mute <playerid> <min�ty> <reason>");
		if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_RED, "Hr�� moment�lne nieje online!");

		AdminInfo[pid][isMuted] = true;
        MuteTime[pid] = (gettime() + (60*time));

		format(reason, sizeof(reason), "Administr�tor %s(%d) uml�al hr��a %s(%i) na %i min�t, za %s.",PlayerName(playerid), playerid,PlayerName(pid), pid, time,reason);
		SendClientMessageToAll(COLOR_LIGHTBLUE, reason);
	}
	return 1;
}

CMD:goto(playerid, params[])
{
    if(GetAdminLevel(playerid) >= 1 || IsPlayerAdmin(playerid))
    {
        new pid;
		if(sscanf(params, "i",pid)) return SendClientMessage(playerid, -1, "/goto <playerid>");
		if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_RED, "Hr�� moment�lne nieje online!");
		if(pid == playerid) return SendClientMessage(playerid, COLOR_RED, "Nem��e� sa portnu� s�m na seba!");

		new str[128];
		format(str, sizeof(str), "Administr�tor %s(%d) sa na teba portol.",PlayerName(playerid), playerid);
		SendClientMessage(pid, COLOR_LIGHTBLUE, str);
		new Float:pos[3];
		GetPlayerPos(pid, pos[0],pos[1],pos[2]);

  		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT || PLAYER_STATE_DRIVER)  {
       		new getv = GetPlayerVehicleID(playerid);
       		SetVehiclePos(getv,pos[0],pos[1],pos[2]);
       		PutPlayerInVehicle(playerid,getv,0);
       		SetVehicleVirtualWorld(getv, GetPlayerVirtualWorld(pid));
       	}

       	SetPlayerVirtualWorld(playerid,  GetPlayerVirtualWorld(pid));
       	SetPlayerPos(playerid, pos[0],pos[1],pos[2]);
	}
	return 1;
}

CMD:ahide(playerid)
{
    if(GetAdminLevel(playerid) >= 5 || IsPlayerAdmin(playerid))
	{
		if(AdminInfo[playerid][aVisible])
		{ // ak je schovan�
		    AdminInfo[playerid][aVisible] = false;
		}else{
		    //ak nieje schovan�, schov� ho
            AdminInfo[playerid][aVisible] = true;
		}
		CallRemoteFunction("cmd_vinvisible", "i", playerid);
	}else return false;
	return 1;
}

CMD:setlevel(playerid, params[])
{
	if(GetAdminLevel(playerid) >= 5 || IsPlayerAdmin(playerid))
	{
	    new pid, level;
		if(sscanf(params, "ui", pid, level)) return SendClientMessage(playerid, COLOR_LIGHTRED, "/setlevel <playerid/name> <level>");
		if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Hr�� moment�lne nieje na servery.");
		if(level < 0 || level > 5) return SendClientMessage(playerid, COLOR_LIGHTRED, "Rozmedzie Admin Levela, ktor� m��e� nastavi� je 1-5.");

		new string[128];
		if(level == 0) 	format(string, sizeof(string), "Administr�tor %s(%d) odobral hr��ovy %s(%d) admin level.", PlayerName(playerid), playerid, PlayerName(pid),pid);
		else format(string, sizeof(string), "Administr�tor %s(%d) nastavil hr��ovy %s(%d) admin level %d.", PlayerName(playerid), playerid, PlayerName(pid),pid, level);
		SendClientMessageToAll(COLOR_LIMEGREEN, string);
		SetAdminLevel(pid, level);
	}else return false;
	return 1;
}

public OnFilterScriptInit()
{
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

public OnPlayerText(playerid)
{
	if(AdminInfo[playerid][isMuted])
	{
        if(gettime() < (MuteTime[playerid]))
		{
		    new string[128];
		    format(string, sizeof(string), "Nem��e� p�sa�, si uml�an� e�te po dobu %02d min�t a %02d sekund.", ((MuteTime[playerid]-gettime())/60), ((MuteTime[playerid]-gettime()) % 60));
			SendClientMessage(playerid, COLOR_BLUE, string);
			return 0;
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    AdminInfo[playerid][varns] = 0;
    SetAdminLevel(playerid, 0);
	return 1;
}

stock SendAdminMessage(msg[])
{
	foreach(new p : Player)
	{
	    if(GetAdminLevel(p) >= 1) SendClientMessage(p, -1, msg);
	}
}

stock IsAnyAdminConnected()
{
	foreach(new p : Player)
	{
		if(IsAdminConnected(p)) return true;
	}
	return false;
}

stock IsAdminConnected(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(GetAdminLevel(playerid) >= 1)
		{
			return true;
		}
	}
	return false;
}

stock IsPlayerALevel(playerid, level)
{
	if(GetAdminLevel(playerid) >= level) return true;
	else return false
}

stock GetAdminLevel(playerid)
{
	return PlayerInfo[playerid][adminLevel];
}

stock SetAdminLevel(playerid, level)
{
	PlayerInfo[playerid][adminLevel] = level;
}

