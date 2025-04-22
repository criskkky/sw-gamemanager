local l_RadioCmds = {
    "coverme",
    "takepoint",
    "holdpos",
    "regroup",
    "followme",
    "takingfire",
    "go",
    "fallback",
    "sticktog",
    "getinpos",
    "stormfront",
    "report",
    "roger",
    "enemyspot",
    "needbackup",
    "sectorclear",
    "inposition",
    "reportingin",
    "getout",
    "negative",
    "enemydown",
    "sorry",
    "cheer",
    "compliment",
    "thanks",
    "go_a",
    "go_b",
    "needrop",
    "deathcry"
}

local l_RadioMenu = {
    "radio",
    "radio1",
    "radio2",
    "radio3"
}

local l_RadialRadio = {
    "+radialradio",
    "+radialradio1",
    "+radialradio2",
    "+radialradio3"
}

AddEventHandler("OnClientCommand", function(p_Event, p_PlayerID, p_Command)
    local l_Player = GetPlayer(p_PlayerID)
    if not l_Player then return EventResult.Continue end
    if config:Fetch("gamemanager.disablePlayerRadioCmds") and table.find(l_RadioCmds, p_Command) then
        p_Event:SetReturn(false) 
        return EventResult.Handled
    end
    if config:Fetch("gamemanager.disableRadioMenu") and table.find(l_RadioMenu, p_Command) then
        p_Event:SetReturn(false) 
        return EventResult.Handled
    end
    if config:Fetch("gamemanager.disableChatWheel") and table.find(l_RadialRadio, p_Command) then
        p_Event:SetReturn(false) 
        return EventResult.Handled
    end
    return EventResult.Continue
end)