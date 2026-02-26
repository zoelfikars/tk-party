--[[
    Services Module (Safe Version)
    Menyediakan akses ke layanan dasar Roblox.
]] local Services = {}

-- Standard Services
Services.Players = game:GetService("Players")
Services.RunService = game:GetService("RunService")
Services.HttpService = game:GetService("HttpService")
Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
Services.TweenService = game:GetService("TweenService")

-- Shortcuts
Services.LocalPlayer = Services.Players.LocalPlayer
Services.PlayerGui = Services.LocalPlayer:WaitForChild("PlayerGui")
Services.Character = Services.LocalPlayer.Character or Services.LocalPlayer.CharacterAdded:Wait()

-- Fungsi untuk load module game (Hanya jika dibutuhkan nanti)
function Services.getGameModule(path)
    local success, result = pcall(function() return require(path) end)
    return success and result or nil
end

return Services
