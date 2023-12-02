--Finished Result
-- Function to apply restrictions to the player
local function ApplyRestrictions(target_ply, time)
    if not IsValid(target_ply) then return end

    -- Ensure time is a valid number
    time = tonumber(time) or 0

    -- Store the original user's settings for restoration
    local originalSettings = {
        ["god"] = target_ply:HasGodMode(),
        ["noclip"] = target_ply:GetMoveType() == MOVETYPE_NOCLIP,
        ["canvoicechat"] = IsValid(target_ply.IsMuted) and not target_ply:IsMuted(),
    }

    -- Apply restrictions
    target_ply:GodEnable(true)
    target_ply:SetNotSolid(true)
    target_ply:DisallowSpawning(true)
    if IsValid(target_ply.SetMuted) then
        target_ply:SetMuted(true)
    end

    -- Restore original settings after a time interval
    timer.Simple(time, function()
        -- Restore original settings
        target_ply:GodEnable(originalSettings["god"])
        target_ply:SetMoveType(originalSettings["noclip"] and MOVETYPE_NOCLIP or MOVETYPE_WALK)
        target_ply:SetNotSolid(false)
		target_ply:KillSilent()
        target_ply:DisallowSpawning(false)
        if IsValid(target_ply.SetMuted) then
            target_ply:SetMuted(not originalSettings["canvoicechat"])
        end

        ULib.tsay(target_ply, "You have been removed from the blacklist.", true)
    end)

    ULib.tsay(target_ply, "You have been blacklisted for " .. time .. " seconds.", true)
end

-- ULX command to blacklist a player
function ulx.Blacklist(calling_ply, target_ply, time)
    if not IsValid(target_ply) then
        ULib.tsayError(calling_ply, "Invalid target player.", true)
        return
    end

    -- Apply restrictions
    ApplyRestrictions(target_ply, time)

    ULib.tsay(calling_ply, target_ply:Nick() .. " has been blacklisted for " .. time .. " seconds.", true)
end

-- Register the ULX command
local blacklistCommand = ulx.command("Fun", "ulx blacklist", ulx.Blacklist, "!blacklist")
blacklistCommand:addParam{type=ULib.cmds.PlayerArg}
blacklistCommand:addParam{type=ULib.cmds.NumArg, hint="time in seconds"}
blacklistCommand:defaultAccess(ULib.ACCESS_ADMIN)
blacklistCommand:help("Blacklist a player with specific restrictions.")

-- Console command to blacklist a player
concommand.Add("blacklist_console", function(calling_ply, cmd, args)
    if not calling_ply:IsValid() or not calling_ply:IsSuperAdmin() then
        print("You do not have permission to use this command.")
        return
    end

    local target_ply = ULib.getUser(args[1])
    local time = tonumber(args[2]) or 0

    ApplyRestrictions(target_ply, time)
    print(target_ply:Nick() .. " has been blacklisted for " .. time .. " seconds.")
end)





------ UnblackList Command

-- Function to remove restrictions from the player
local function RemoveRestrictions(target_ply)
    if not IsValid(target_ply) then return end

    -- Restore original settings
    target_ply:GodEnable(false)
    target_ply:SetMoveType(MOVETYPE_WALK)
    target_ply:SetNotSolid(false)
	target_ply:KillSilent()
    target_ply:DisallowSpawning(false)
    if IsValid(target_ply.SetMuted) then
        target_ply:SetMuted(false)
    end

    ULib.tsay(target_ply, "You have been removed from the blacklist.", true)
end

-- ULX command to unblacklist a player
function ulx.Unblacklist(calling_ply, target_ply)
    if not IsValid(target_ply) then
        ULib.tsayError(calling_ply, "Invalid target player.", true)
        return
    end

    -- Remove restrictions
    RemoveRestrictions(target_ply)

    ULib.tsay(calling_ply, target_ply:Nick() .. " has been removed from the blacklist.", true)
end

-- Register the ULX command
local unblacklistCommand = ulx.command("Fun", "ulx unblacklist", ulx.Unblacklist, "!unblacklist")
unblacklistCommand:addParam{type=ULib.cmds.PlayerArg}
unblacklistCommand:defaultAccess(ULib.ACCESS_ADMIN)
unblacklistCommand:help("Remove a player from the blacklist.")

-- Console command to unblacklist a player
concommand.Add("unblacklist_console", function(calling_ply, cmd, args)
    if not calling_ply:IsValid() or not calling_ply:IsSuperAdmin() then
        print("You do not have permission to use this command.")
        return
    end

    local target_ply = ULib.getUser(args[1])

    RemoveRestrictions(target_ply)
    print(target_ply:Nick() .. " has been removed from the blacklist.")
end)

print(" ____  _                 _        ____  _            _    _ _     _   ")
print("/ ___|(_)_ __ ___  _ __ | | ___  | __ )| | __ _  ___| | _| (_)___| |_ ")
print("//___ //| | '_ ` _ /| '_ /| |/ _ // |  _ //| |/ _` |/ __| |/ / | / __| __|")
print(" ___) | | | | | | | |_) | |  __/ | |_) | | (_| | (__|   <| | //__ / |_ ")
print("|____/|_|_| |_| |_| .__/|_|/___| |____/|_|/__,_|/___|_|/_/_|_|___//__|")
print("                  |_|                                                 ")
print("Simple ULX Commands by lolteam for DarkRP")
print("https://steamcommunity.com/sharedfiles/filedetails/?id=3097618358")
print("jamiez.co.uk")
print("Finished Loading Enjoy :)")
