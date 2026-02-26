--[[
    Misc Tab Module
    Menampung fitur utilitas seperti Anti-AFK.
]] local requireRemote = _G.TKPartyHub.require
local AntiAFK = requireRemote("features/anti-afk")

local MiscTab = {}

function MiscTab.setup(tabInstance)
    tabInstance:CreateSection("Utility Features")

    tabInstance:CreateToggle({
        Name = "Stealth Anti-AFK",
        CurrentValue = false,
        Flag = "AntiAFK_Toggle",
        Callback = function(Value) AntiAFK.toggle(Value) end
    })

    tabInstance:CreateParagraph({
        Title = "Info",
        Content = "Anti-AFK ini menggunakan simulasi Heartbeat yang aman dari deteksi VirtualUser."
    })
end

return MiscTab
