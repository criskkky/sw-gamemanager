local radioCommands = {
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

local radioMenu = {
    "radio",
    "radio1",
    "radio2",
    "radio3"
}

local radialradio = {
    "+radialradio",
    "+radialradio1",
    "+radialradio2",
    "+radialradio3"
}

AddEventHandler("OnClientCommand", function(event, playerid, command)
    local player = GetPlayer(playerid)
    if not player then return EventResult.Continue end
    if config:Fetch("gamemanager.disablePlayerRadioCmds") and table.find(radioCommands, command) then
        event:SetReturn(false) 
        return EventResult.Handled
    end
    if config:Fetch("gamemanager.disableRadioMenu") and table.find(radioMenu, command) then
        event:SetReturn(false) 
        return EventResult.Handled
    end
    if config:Fetch("gamemanager.disableChatWheel") and table.find(radialradio, command) then
        event:SetReturn(false) 
        return EventResult.Handled
    end
    return EventResult.Continue
end)