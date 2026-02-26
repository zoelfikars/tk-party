--[[
    Teleport Feature Module
    Logika untuk memindahkan karakter ke lokasi tertentu.
]] local requireRemote = _G.TKPartyHub.require
local Services = requireRemote("core/services")

local Teleport = {}

-- Fungsi utama teleport ke Vector3
function Teleport.to(targetPos)
    local player = Services.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Menggunakan CFrame agar orientasi karakter tetap terjaga
        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
        print("[TKPartyHub] Teleported to: " .. tostring(targetPos))
    end
end

-- Tambahkan ini di bawah fungsi Teleport.to yang sudah ada
function Teleport.toPlayer(targetPlayerName)
    local Players = game:GetService("Players")
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    local localPlayer = Players.LocalPlayer

    if targetPlayer and targetPlayer.Character and
        targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetHRP = targetPlayer.Character.HumanoidRootPart
        if localPlayer.Character and
            localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Teleport tepat ke posisi pemain target
            localPlayer.Character.HumanoidRootPart.CFrame = targetHRP.CFrame
            print("[TKPartyHub] Teleported to player: " .. targetPlayerName)
        end
    else
        warn("[TKPartyHub] Player tidak ditemukan atau karakter belum load")
    end
end

return Teleport
