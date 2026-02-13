#include <sourcemod>
#include <sdktools>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "1.2.0"
#define REFUND_AMOUNT 200

public Plugin myinfo =
{
    name = "M4A4 to M4A1-S Replacer",
    author = "RATING3PRO",
    description = "Replaces purchased M4A4 with M4A1-S and refunds price difference",
    version = PLUGIN_VERSION
};

/* =========================================================
   Plugin Start
   ========================================================= */

public void OnPluginStart()
{
    HookEvent("item_purchase", Event_ItemPurchase, EventHookMode_Post);
}

/* =========================================================
   Purchase Event
   ========================================================= */

public Action Event_ItemPurchase(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));

    if (!IsValidClient(client))
        return Plugin_Continue;

    if (GetClientTeam(client) != CS_TEAM_CT)
        return Plugin_Continue;

    char weapon[64];
    event.GetString("weapon", weapon, sizeof(weapon));

    // CSGO 返回 weapon_m4a1 表示 M4A4
    if (StrEqual(weapon, "weapon_m4a1", false))
    {
        // 延迟确保武器给到玩家
        CreateTimer(0.15, Timer_SwapWeapon, GetClientUserId(client));
    }

    return Plugin_Continue;
}

/* =========================================================
   Swap Logic
   ========================================================= */

public Action Timer_SwapWeapon(Handle timer, any userid)
{
    int client = GetClientOfUserId(userid);

    if (!IsValidClient(client) || !IsPlayerAlive(client))
        return Plugin_Stop;

    int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);

    if (weapon == -1)
        return Plugin_Stop;

    char classname[64];
    GetEntityClassname(weapon, classname, sizeof(classname));

    // 防止误替换或已经是A1
    if (StrContains(classname, "m4a1", false) == -1 ||
        StrContains(classname, "silencer", false) != -1)
    {
        return Plugin_Stop;
    }

    /* ---- 移除 M4A4 ---- */

    RemovePlayerItem(client, weapon);
    AcceptEntityInput(weapon, "Kill");

    /* ---- 给 M4A1-S ---- */

    int newWeapon = GivePlayerItem(client, "weapon_m4a1_silencer");

    if (newWeapon != -1)
        EquipPlayerWeapon(client, newWeapon);

    /* ---- 退款 ---- */

    int money = GetEntProp(client, Prop_Send, "m_iAccount");
    money += REFUND_AMOUNT;

    if (money > 16000)
        money = 16000;

    SetEntProp(client, Prop_Send, "m_iAccount", money);

    PrintToChat(client,
        " \x04[Server]\x01 已将 \x03M4A4\x01 替换为 \x03M4A1-S\x01 并退还 \x04$%d",
        REFUND_AMOUNT);

    return Plugin_Stop;
}

/* =========================================================
   Helpers
   ========================================================= */

bool IsValidClient(int client)
{
    return (client > 0 &&
            client <= MaxClients &&
            IsClientInGame(client));
}
