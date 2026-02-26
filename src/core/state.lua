--[[
    State Module
    Menyimpan variabel status global untuk script.
]] -- Ambil services yang sudah kita buat tadi
local requireRemote = _G.TKPartyHub.require
local Services = requireRemote("core/services")

local State = {
    -- Informasi Player
    player = Services.LocalPlayer,
    char = Services.Character,

    -- Status Fitur (Default: False)
    teleporting = false,

    -- UI State
    menuOpen = true,
    theme = "Discord Dark"
}

return State
