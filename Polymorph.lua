--[[
    Polymorph - Smart Polymorph Addon for WoW 1.12

    Usage: /poly

    Behavior:
    1. Scans raid/party for attackable members (mind-controlled players)
    2. If found, polymorphs them and announces to raid/party/say
    3. If no attackable members, casts random polymorph on current target
]]

Polymorph1701 = {}

-- Print feedback message to the player
local function PrintMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF69CCF0[Polymorph]|r " .. msg)
end

-- Creature types that can be polymorphed
local POLYMORPHABLE_TYPES = {
    ["Humanoid"] = true,
    ["Beast"] = true,
    ["Critter"] = true,
}

-- Get list of polymorph spells the player knows
local function GetKnownPolymorphSpells()
    local known = {}
    local i = 1

    -- Scan spellbook for any spell starting with "Polymorph"
    while true do
        local spellName = GetSpellName(i, BOOKTYPE_SPELL)
        if not spellName then
            break
        end

        if string.find(spellName, "^Polymorph") then
            -- Check if we already have this spell (avoid duplicates from different ranks)
            local found = false
            for _, k in ipairs(known) do
                if k == spellName then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(known, spellName)
            end
        end
        i = i + 1
    end

    return known
end

-- Get a random polymorph spell from known spells
local function GetRandomPolymorphSpell()
    local known = GetKnownPolymorphSpells()
    if table.getn(known) == 0 then
        return "Polymorph" -- Fallback to base spell
    end
    return known[math.random(1, table.getn(known))]
end

-- Check if a unit is polymorphable (creature type check)
local function IsPolymorphable(unit)
    if not UnitExists(unit) then
        return false
    end

    -- Dead units can't be polymorphed
    if UnitIsDead(unit) then
        return false
    end

    -- Check creature type
    local creatureType = UnitCreatureType(unit)
    if creatureType and POLYMORPHABLE_TYPES[creatureType] then
        return true
    end

    -- Players (including MC'd players) can be polymorphed
    if UnitIsPlayer(unit) then
        return true
    end

    return false
end

-- Find an attackable raid/party member
local function FindAttackableGroupMember()
    -- Check raid first
    local numRaid = GetNumRaidMembers()
    if numRaid > 0 then
        for i = 1, numRaid do
            local unit = "raid" .. i
            if UnitExists(unit) and UnitCanAttack("player", unit) then
                return unit, UnitName(unit)
            end
        end
    else
        -- Check party if not in raid
        local numParty = GetNumPartyMembers()
        for i = 1, numParty do
            local unit = "party" .. i
            if UnitExists(unit) and UnitCanAttack("player", unit) then
                return unit, UnitName(unit)
            end
        end
    end

    return nil, nil
end

-- Send announcement to appropriate channel (only for MC'd players)
local function AnnouncePolymorph(targetName)
    local message = "Polymorphing " .. targetName .. "! (Mind Controlled)"

    if GetNumRaidMembers() > 0 then
        SendChatMessage(message, "RAID")
    elseif GetNumPartyMembers() > 0 then
        SendChatMessage(message, "PARTY")
    end
end

-- Main polymorph function
local function DoPolymorphMacro()
    -- First, check for attackable raid/party members (MC'd players)
    local unit, name = FindAttackableGroupMember()

    if unit and name then
        -- Found an attackable group member - polymorph them
        AnnouncePolymorph(name)

        -- Target and cast
        TargetUnit(unit)
        CastSpellByName("Polymorph")
        return
    end

    -- No attackable group members - check current target
    if not UnitExists("target") then
        PrintMessage("No target selected.")
        return
    end

    if not UnitCanAttack("player", "target") then
        PrintMessage("Cannot attack " .. UnitName("target") .. ".")
        return
    end

    if not IsPolymorphable("target") then
        local creatureType = UnitCreatureType("target") or "Unknown"
        PrintMessage(UnitName("target") .. " cannot be polymorphed (" .. creatureType .. ").")
        return
    end

    -- Cast random polymorph on target (no announcement)
    local spell = GetRandomPolymorphSpell()
    CastSpellByName(spell)
end

-- Slash command handler
local function SlashCmdHandler(msg)
    DoPolymorphMacro()
end

-- Create addon frame for event handling
local frame = CreateFrame("Frame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", function()
    -- Register slash commands on VARIABLES_LOADED to ensure proper initialization
    SLASH_POLYMORPH17011 = "/poly"
    SlashCmdList["POLYMORPH1701"] = SlashCmdHandler
end)

-- Export for external use
Polymorph1701.Execute = DoPolymorphMacro
Polymorph1701.GetKnownPolymorphSpells = GetKnownPolymorphSpells
Polymorph1701.FindAttackableGroupMember = FindAttackableGroupMember
