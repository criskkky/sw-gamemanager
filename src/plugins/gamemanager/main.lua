AddEventHandler("OnPlayerSpawn", function(p_Event)
    local l_PlayerID = p_Event:GetInt("userid")
    local l_Player = GetPlayer(l_PlayerID)
    if not l_Player then return EventResult.Continue end
    NextTick(function()
        local l_PlayerPawn = l_Player:CCSPlayerPawn()
        if not l_PlayerPawn:IsValid() then return end

        local l_PlayerModelEntity = CBaseModelEntity(l_PlayerPawn)
        if not l_PlayerModelEntity:IsValid() then return end

        local l_ExpectedColor = config:Fetch("gamemanager.disableLegs")
        and Color(l_PlayerModelEntity.Render.r, l_PlayerModelEntity.Render.g, l_PlayerModelEntity.Render.b, 254)
        or Color(l_PlayerModelEntity.Render.r, l_PlayerModelEntity.Render.g, l_PlayerModelEntity.Render.b, 255)

        if l_PlayerModelEntity.Render.r ~= l_ExpectedColor.r or l_PlayerModelEntity.Render.g ~= l_ExpectedColor.g or l_PlayerModelEntity.Render.b ~= l_ExpectedColor.b or l_PlayerModelEntity.Render.a ~= l_ExpectedColor.a then
            l_PlayerModelEntity.Render = l_ExpectedColor
            StateUpdate(l_PlayerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")
        end
    end)
    return EventResult.Continue
end)

AddEventHandler("OnUserMessageSend", function(p_Event, p_UserMessage, p_IsReliable)
    local l_User = GetUserMessage(p_UserMessage)
    local l_MsgID = l_User:GetMessageID()
    if (l_MsgID == 411) and config:Fetch("gamemanager.disableBlood") then
        return EventResult.Stop
    end
    if (l_MsgID == 400) and config:Fetch("gamemanager.disableHSSparks") then
        return EventResult.Stop
    end
    return EventResult.Continue
end)

AddEventHandler("OnClientCommand", function(p_Event, l_PlayerID, command)
    local l_Player = GetPlayer(l_PlayerID)
    if not l_Player then return EventResult.Continue end
    if config:Fetch("gamemanager.disablePing") and command == "player_ping" then
        p_Event:SetReturn(false)
        return EventResult.Handled
    end
    return EventResult.Continue
end)

AddEventHandler("OnPlayerDeath", function(p_Event)
    local l_PlayerID = p_Event:GetInt("userid")
    local l_Player = GetPlayer(l_PlayerID)
    if not l_Player then return EventResult.Continue end
    local l_PlayerPawn = l_Player:CCSPlayerPawn()
    if not l_PlayerPawn:IsValid() then return EventResult.Continue end
    local l_PlayerModelEntity = CBaseModelEntity(l_PlayerPawn)
    if not l_PlayerModelEntity:IsValid() then return EventResult.Continue end

    -- Disable Dead Body
    if config:Fetch("gamemanager.disableDeadBody_mode") == 1 then
        NextTick(function()
            if config:Fetch("gamemanager.disableLegs") then
                if l_PlayerModelEntity.Render.a ~= 0 then
                    l_PlayerModelEntity.Render = Color(l_PlayerModelEntity.Render.r, l_PlayerModelEntity.Render.g, l_PlayerModelEntity.Render.b, 0)
                    StateUpdate(l_PlayerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")
                end
            end
        end)
    end

    -- Disable Dead Body After X Seconds (using spec_freeze_deathanim_time)
    if config:Fetch("gamemanager.disableDeadBody_mode") == 2 then
        NextTick(function()
            local l_DeathAnim = convar:Get("spec_freeze_deathanim_time") * 1000  -- Eg: 0.8s → 800ms

            local l_Duration = l_DeathAnim

            SetTimeout(l_Duration, function()
                if l_PlayerModelEntity.Render.a ~= 0 then
                    l_PlayerModelEntity.Render = Color(l_PlayerModelEntity.Render.r, l_PlayerModelEntity.Render.g, l_PlayerModelEntity.Render.b, 0)
                    StateUpdate(l_PlayerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")
                end
            end)
        end)
    end

    -- Disable Dead Body with Fade Out Effect (ngl this is my favorite ~ criskkky)
    if config:Fetch("gamemanager.disableDeadBody_mode") == 3 then
        NextTick(function()
            local l_DeathAnim = convar:Get("spec_freeze_deathanim_time") * 1000  -- Eg: 0.8s → 800ms

            local l_Duration = l_DeathAnim

            local l_Interval = 100 -- Step each 100ms
            local l_Steps = math.ceil(l_Duration / l_Interval)  -- 900ms / 100ms = 9 l_Steps

            local l_Step = 0

            local function l_fadeOut()
                if l_Step >= l_Steps then
                    l_PlayerModelEntity.Render = Color(l_PlayerModelEntity.Render.r, l_PlayerModelEntity.Render.g, l_PlayerModelEntity.Render.b, 0)
                    StateUpdate(l_PlayerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")
                    return
                end

                -- Alpha decrease from 255 to 0 in X l_Steps
                local l_Alpha = math.floor(255 - (255 * (l_Step / l_Steps)))
                l_PlayerModelEntity.Render = Color(l_PlayerModelEntity.Render.r, l_PlayerModelEntity.Render.g, l_PlayerModelEntity.Render.b, l_Alpha)
                StateUpdate(l_PlayerPawn:ToPtr(), "CBaseModelEntity", "m_clrRender")

                l_Step = l_Step + 1
                SetTimeout(l_Interval, l_fadeOut)
            end

            l_fadeOut()
        end)
    end
    return EventResult.Continue
end)

AddEventHandler("OnPlayerDeath", function(p_Event)
    if config:Fetch("gamemanager.disableKillfeed_mode") == 1 then
        p_Event:SetReturn(false)
        return EventResult.Handled
    end
    -- More modes will be added in the future (maybe, idk)
    return EventResult.Continue
end)
