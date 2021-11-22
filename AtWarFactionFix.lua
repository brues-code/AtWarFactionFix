local addonName = ...
local f = CreateFrame("FRAME")

local GetFactionInfoByID, GetNumFactions, GetFactionInfo, FactionToggleAtWar =
    GetFactionInfoByID, GetNumFactions, GetFactionInfo, FactionToggleAtWar

local PROTECTED_FACTIONS = {
    529,  -- Argent Dawn
    589,  -- Wintersaber Trainers
    1119, -- Sons of Hodir
    576, -- Timbermaw Hold
}

function f:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        self:OnLoad()
    elseif event == "UNIT_FACTION" then
        self:UNIT_FACTION(arg1)
    end
end

function f:OnLoad()
	self:RegisterEvent("UNIT_FACTION")
    self:SetProtectedFactionNames()
	self:UNIT_FACTION("player")
    self:UnregisterEvent("ADDON_LOADED")
end

function f:SetProtectedFactionNames()
    self.protectedFactionNames = {}
    for k, v in pairs(PROTECTED_FACTIONS) do
        local name = GetFactionInfoByID(v)
        if name then
            self.protectedFactionNames[name] = true
        end
    end
end

function f:UNIT_FACTION(unit)
    if unit ~= "player" then return end
    for factionIndex = 1, GetNumFactions() do
        local name, _, _, _, _, _, atWarWith, canToggleAtWar = GetFactionInfo(factionIndex)
        if atWarWith and canToggleAtWar and self.protectedFactionNames[name] then
            FactionToggleAtWar(factionIndex)
        end
    end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)