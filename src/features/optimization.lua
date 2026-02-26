--[[
    Optimization Feature Module
    Mengurangi lag dengan menyembunyikan elemen visual berat.
]] local requireRemote = _G.TKPartyHub.require
local Services = requireRemote("core/services")

local Optimization = {}
local hiddenPlayers = {}

-- Fungsi untuk menyembunyikan karakter orang lain
function Optimization.toggleOtherPlayers(state)
    if state then
        -- Sembunyikan semua player yang sudah ada
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player ~= Services.LocalPlayer and player.Character then
                player.Character.Parent = Services.ReplicatedStorage -- Pindah ke tempat aman
                table.insert(hiddenPlayers, player)
            end
        end
        -- Sembunyikan player yang baru masuk
        Optimization.playerAddedConn = Services.Players.PlayerAdded:Connect(
                                           function(player)
                player.CharacterAdded:Connect(function(char)
                    task.wait(0.1)
                    char.Parent = Services.ReplicatedStorage
                end)
            end)
    else
        -- Kembalikan semua player ke Workspace
        if Optimization.playerAddedConn then
            Optimization.playerAddedConn:Disconnect()
        end
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player.Character then
                player.Character.Parent = workspace
            end
        end
        hiddenPlayers = {}
    end
end

local heartbeatConn = nil

function Optimization.toggleLagReduce(state)
    local playerGui = Services.PlayerGui
    
    -- Daftar target berdasarkan temuan UI Scanner kamu
    local lagTargets = {
        "Small Notification", -- Tersangka utama notifikasi melayang
        "Text Notifications",
        "XP",
        "!!! Click Effect",
        "ToolTip",
        -- "Backpack",
        "Charge",
        "Indicator",
        "Fishing", -- Kemungkinan besar memegang elemen visual pancingan
        "Events",
        "RarestFish"
    }

    if state then
        -- METODE: Constant Lock
        heartbeatConn = Services.RunService.Heartbeat:Connect(function()
            for _, name in pairs(lagTargets) do
                local ui = playerGui:FindFirstChild(name)
                if ui then
                    -- Matikan ScreenGui
                    if ui:IsA("LayerCollector") then
                        ui.Enabled = false
                    elseif ui:IsA("GuiObject") then
                        ui.Visible = false
                    end
                end
            end
        end)
        print("[TKPartyHub] Optimization: Small Notifications & Fishing UI Blocked")
    else
        if heartbeatConn then 
            heartbeatConn:Disconnect() 
            heartbeatConn = nil 
        end
        -- Kembalikan UI (Relog disarankan)
        print("[TKPartyHub] Optimization: Disabled")
    end
end

return Optimization