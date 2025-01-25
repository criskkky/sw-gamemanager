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

AddEventHandler("OnClientCommand", function(event, playerid, command)
    local player = GetPlayer(playerid)
    if not player then return EventResult.Continue end
    if config:Fetch("gamemanager.disablePlayerRadio") and table.find(radioCommands, command) then
        event:SetReturn(false) 
        return EventResult.Handled
    end
    return EventResult.Continue
end)