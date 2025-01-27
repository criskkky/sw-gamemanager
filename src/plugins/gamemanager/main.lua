function ExecuteCommands()
    if config:Fetch("gamemanager.disableGrenadeRadio") then
        server:Execute("sv_ignoregrenaderadio true")
    end

    if config:Fetch("gamemanager.disableBotRadio") then
        server:Execute("bot_chatter off")
    end

    if config:Fetch("gamemanager.disableRadar") then
        server:Execute("sv_disable_radar 1")
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

AddEventHandler("OnPluginStart", function(event)
    ExecuteCommands()
    return EventResult.Continue
end)

AddEventHandler("OnPlayerSpawn", function(event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return EventResult.Continue end
    NextTick(function()
        local playerPawn = player:CCSPlayerPawn()
        if not playerPawn:IsValid() then return end

        local playerModelEntity = CBaseModelEntity(playerPawn)
        if not playerModelEntity:IsValid() then return end

        local currentColor = playerModelEntity.Render:__tostring()
        local expectedColor = config:Fetch("gamemanager.disableLegs")
        and Color(254, 254, 254, 254)
        or Color(255, 255, 255, 255)

        if currentColor ~= expectedColor then
            playerModelEntity.Render = expectedColor
            StateUpdate(playerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")
        end
    end)
    return EventResult.Continue
end)

AddEventHandler("OnRoundStart", function()
    ExecuteCommands()
    return EventResult.Continue
end)

AddEventHandler("OnUserMessageSend", function(event, um, isreliable)
    local user = GetUserMessage(um)
    local msgid = user:GetMessageID()
    if (msgid == 411) and config:Fetch("gamemanager.disableBlood") then
        return EventResult.Stop
    end
    if (msgid == 400) and config:Fetch("gamemanager.disableHSSparks") then
        return EventResult.Stop
    end
    return EventResult.Continue
end)

AddEventHandler("OnClientCommand", function(event, playerid, command)
    local player = GetPlayer(playerid)
    if not player then return EventResult.Continue end
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
    local player = GetPlayer(playerid)
    if not player then return EventResult.Continue end
    local playerPawn = player:CCSPlayerPawn()
    if not playerPawn:IsValid() then return EventResult.Continue end
    local playerModelEntity = CBaseModelEntity(playerPawn)
    if not playerModelEntity:IsValid() then return EventResult.Continue end

    if config:Fetch("gamemanager.disableKillfeed_mode") == 1 then
        event:SetReturn(false)
        return EventResult.Handled
    end
    if config:Fetch("gamemanager.disableKillfeed_mode") == 2 and playerid == attackerid then
        event:FireEventToClient(attackerid)
        return EventResult.Handled
    end

    -- Disable Dead Body
    if config:Fetch("gamemanager.disableDeadBody_mode") == 1 then
        NextTick(function()
            if config:Fetch("gamemanager.disableLegs") then
                playerModelEntity.Render = Color(254, 254, 254, 0)
            else
                playerModelEntity.Render = Color(255, 255, 255, 0)
            end
            StateUpdate(playerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")
        end)
    end

    -- Disable Dead Body After X Seconds (using spec_freeze_deathanim_time)
    if config:Fetch("gamemanager.disableDeadBody_mode") == 2 then
        NextTick(function()
            local deathanim = convar:Get("spec_freeze_deathanim_time") * 1000  -- Eg: 0.8s → 800ms
            
            local duration = deathanim
            
            SetTimeout(duration, function()
                local baseColor = config:Fetch("gamemanager.disableLegs") and 254 or 255
                playerModelEntity.Render = Color(baseColor, baseColor, baseColor, 0)
                StateUpdate(playerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")
            end)
        end)
    end

    -- Disable Dead Body with Fade Out Effect (ngl this is my favorite --> criskkky)
    if config:Fetch("gamemanager.disableDeadBody_mode") == 3 then
        NextTick(function()
            local baseColor = config:Fetch("gamemanager.disableLegs") and 254 or 255
            
            local deathanim = convar:Get("spec_freeze_deathanim_time") * 1000  -- Eg: 0.8s → 800ms
            
            local duration = deathanim
            
            local interval = 100 -- Step each 100ms
            local steps = math.ceil(duration / interval)  -- 900ms / 100ms = 9 steps
            
            local step = 0
    
            local function fadeOut()
                if step >= steps then
                    playerModelEntity.Render = Color(baseColor, baseColor, baseColor, 0)
                    StateUpdate(playerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")
                    return
                end
    
                -- Alpha decrease from 255 to 0 in X steps
                local alpha = math.floor(255 - (255 * (step / steps)))
                playerModelEntity.Render = Color(baseColor, baseColor, baseColor, alpha)
                StateUpdate(playerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")
    
                step = step + 1
                SetTimeout(interval, fadeOut)
            end
    
            fadeOut()
        end)
    end
    return EventResult.Continue
end)
