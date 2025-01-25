function ExecuteCommands()
    if config:Fetch("gamemanager.disableGrenadeRadio") then
        server:Execute("sv_ignoregrenaderadio true")
    end

    if config:Fetch("gamemanager.disableBotRadio") then
        server:Execute("bot_chatter off")
    end

    if config:Fetch("gamemanager.disableRadar") then 
        server:Execute("sv_disable_radar true")
    end

    if config:Fetch("gamemanager.disableFallDmg") then 
        server:Execute("sv_falldamage_scale 0")
    end

    if config:Fetch("gamemanager.disableSvCheats") then 
        server:Execute("sv_cheats 0")
    end

    if config:Fetch("gamemanager.disableC4") then 
        server:Execute("mp_give_player_c4 0")
    end

    if config:Fetch("gamemanager.disableTeammateHeadTag_mode") == 1 then 
        server:Execute("sv_teamid_overhead 1; sv_teamid_overhead_always_prohibit 1")
    end

    if config:Fetch("gamemanager.disableTeammateHeadTag_mode") == 2 then 
        server:Execute("sv_teamid_overhead 0")
    end

end

function DisableDeadBody(mode)

    if not mode then return end

    if mode == 1 then

    end

    if mode == 2 then
    end

end

AddEventHandler("OnPlayerSpawn", function(event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return EventResult.Continue end
    local playerPawn = player:CCSPlayerPawn()
	if not playerPawn:IsValid() then return end

    

    return EventResult.Continue
end)

AddEventHandler("OnRoundStart", function()
    ExecuteCommands()

    return EventResult.Continue
end)

AddEventHandler("OnPlayerRadio", function(event)
    if config:Fetch("gamemanager.disablePlayerRadio") then 
        event:SetReturn(false) 
        return EventResult.Handled
    end
    return EventResult.Continue
end)

AddEventHandler("OnUserMessageSend", function(event, um, isreliable)
    local user = GetUserMessage(um)
    local msgid = user:GetMessageID()

    if (msgid == 400 or msgid == 411) and config:Fetch("gamemanager.disableBloodAndHS") then
        return EventResult.Stop
    end

    if (msgid == 400 or msgid == 411) and 

    return EventResult.Continue
end)

AddEventHandler("OnClientCommand", function(event, playerid, command)
    if config:Fetch("gamemanager.disableChatWheel") and command == "playerchatwheel" then 
        event:SetReturn(false) 
        return EventResult.Handled
    end
    if config:Fetch("gamemanager.disablePing") and command == "player_ping" then 
        event:SetReturn(false) 
        return EventResult.Handled
    end
    return EventResult.Continue
end)

AddEventHandler("OnPlayerDeath", function(event)
    local playerid = event:GetInt("userid")
    local attackerid = event:GetInt("attacker")
    if config:Fetch("gamemanager.disableKillfeed_mode") == 1 then
        event:SetReturn(false)
        return EventResult.Handled
    end
    if config:Fetch("gamemanager.disableKillfeed_mode") == 2 and playerid == attackerid then
        event:FireEventToClient(attacker)
        return EventResult.Handled
    end

    return EventResult.Continue
end)