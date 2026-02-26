--[[
    Misc Tab Module
    Menampung fitur utilitas seperti Anti-AFK.
]] local requireRemote = _G.TKPartyHub.require

local AntiAFK = requireRemote("features/anti-afk")
local Optimization = requireRemote("features/optimization")
local Detective = requireRemote("features/detective")

local MiscTab = {}

function MiscTab.setup(tabInstance)
    tabInstance:CreateSection("Utility Features")

    tabInstance:CreateToggle({
        Name = "Stealth Anti-AFK",
        CurrentValue = false,
        Flag = "AntiAFK_Toggle",
        Callback = function(Value) AntiAFK.toggle(Value) end
    })

    tabInstance:CreateSection("Performance Boost (Reduce Lag)")

    tabInstance:CreateToggle({
        Name = "Hide Other Players",
        CurrentValue = false,
        Callback = function(Value) Optimization.toggleOtherPlayers(Value) end
    })

    tabInstance:CreateToggle({
        Name = "Hide Fish Notifications",
        CurrentValue = false,
        Callback = function(Value)
            Optimization.toggleLagReduce(Value)
        end
    })

    tabInstance:CreateSection("UI Detective (All-in-One)")

    -- Textbox/Paragraph buat nampung semua log
    local logDisplay = tabInstance:CreateParagraph({
        Title = "Full UI Path Logs",
        Content = "Nyalakan Spy lalu dapatkan ikan..."
    })

    tabInstance:CreateToggle({
        Name = "Enable UI Spy",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                Detective.start(function(fullText)
                    logDisplay:Set({
                        Title = "Full UI Path Logs",
                        Content = fullText
                    })
                end)
            else
                Detective.stop()
            end
        end
    })

    -- SATU TOMBOL UNTUK SEMUA: Copy seluruh isi log
    tabInstance:CreateButton({
        Name = "📋 Copy All Logs to Clipboard",
        Callback = function()
            local logs = Detective.getLogs()
            setclipboard(logs) --
            print("[TKPartyHub] All logs copied!")
        end
    })

    tabInstance:CreateButton({
        Name = "🗑️ Clear Logs",
        Callback = function()
            Detective.clear()
            logDisplay:Set({
                Title = "Full UI Path Logs",
                Content = "Logs Cleared."
            })
        end
    })
end

return MiscTab
