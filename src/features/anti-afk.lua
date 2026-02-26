--[[
    Anti-AFK Feature Module
    Logika Stealth Anti-AFK untuk mencegah kick idle 20 menit.
]] local AntiAFK = {}
local afkConnection = nil

function AntiAFK.toggle(state)
    local lp = game:GetService("Players").LocalPlayer

    if state then
        -- METODE AMAN: Heartbeat Simulation
        afkConnection = game:GetService("RunService").Heartbeat:Connect(
                            function()
                if lp.Character and
                    lp.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = lp.Character.HumanoidRootPart
                    -- Simulasi micro-movement internal
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 0)
                end
            end)

        -- Bypass CoreGui Idle
        for _, v in pairs(getconnections(lp.Idled)) do
            pcall(function() v:Disable() end)
        end

        print("[TKPartyHub] Anti-AFK Stealth: Enabled")
    else
        if afkConnection then
            afkConnection:Disconnect()
            afkConnection = nil
        end

        -- Re-enable Idle connections
        for _, v in pairs(getconnections(lp.Idled)) do
            pcall(function() v:Enable() end)
        end

        print("[TKPartyHub] Anti-AFK Stealth: Disabled")
    end
end

return AntiAFK
