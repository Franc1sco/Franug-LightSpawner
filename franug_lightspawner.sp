/*  SM Franug Lights Spawner
 *
 *  Copyright (C) 2020 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>
#include <sdktools>
#include <devzones>


// maybe soon or with a configurable file
char g_ColorNames[][] = {
	{"white", "255 255 255 255"},
	{"red", "255 0 0 255"},
	{"blue", "0 0 255 255"},
	{"green", "0 255 0 255"},
};

char g_ColorValues[][] = {
	{"255 255 255 255"},
	{"255 0 0 255"},
	{"0 0 255 255"},
	{"0 255 0 255"},
};

#define DATA "1.0"

public Plugin myinfo =
{
    name = "SM Franug Lights Spawner",
    author = "Franc1sco franug",
    description = "",
    version = DATA,
    url = "https://steamcommunity.com/id/franug"
};

public void OnPluginStart()
{
	CreateConVar("sm_lightsspawner_version", DATA, "Version",FCVAR_NOTIFY);
}

public void Zone_OnCreated(char[] zone)
{
	if (StrContains(zone, "light", false) != 0)return;
	
	char temp[124];
	strcopy(temp, 124, zone);
	
	
	ReplaceString(temp, 124, "light", "", false);
	
	float Position[3];
	
	Zone_GetZonePosition(zone, false, Position);
	
	int index = 0;
	
	for (int i = 0; i < sizeof(g_ColorNames); i++) {
		if(ReplaceString(temp, 124, g_ColorNames[i], "", false) > 0)
		{
			index = i;
			break;
		}
	}
	
	LightCreate(Position, StringToFloat(temp), index);
}

void LightCreate(float pos[3], float size, int colorindex)   
{  
	int iEntity = CreateEntityByName("light_dynamic");
	DispatchKeyValue(iEntity, "inner_cone", "0");
	DispatchKeyValue(iEntity, "cone", "80");
	DispatchKeyValue(iEntity, "brightness", "1");
	DispatchKeyValueFloat(iEntity, "spotlight_radius", 150.0);
	DispatchKeyValue(iEntity, "pitch", "90");
	DispatchKeyValue(iEntity, "style", "1");

	DispatchKeyValue(iEntity, "_light", g_ColorValues[colorindex]);
	DispatchKeyValueFloat(iEntity, "distance", size);
	
	DispatchSpawn(iEntity);
	TeleportEntity(iEntity, pos, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(iEntity, "TurnOn");
}