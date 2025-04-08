function g_ExecuteCommands()
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

AddEventHandler("OnPluginStart", function()
    g_ExecuteCommands()
    return EventResult.Continue
end)

AddEventHandler("OnRoundStart", function()
    g_ExecuteCommands()
    return EventResult.Continue
end)