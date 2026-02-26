local requireRemote = _G.TKPartyHub.require
local Services = requireRemote("core/services")

local Detective = {}
local connections = {}
local allLogs = ""

function Detective.start(onUpdate)
    Detective.stop()
    allLogs = "--- START UI SCANNER LOG ---\n\n[EXISTING SCREEN GUIS]:\n"

    -- 1. Scan semua ScreenGui yang sudah ada saat ini
    for _, child in pairs(Services.PlayerGui:GetChildren()) do
        if child:IsA("ScreenGui") then
            allLogs = allLogs .. string.format("- %s (Enabled: %s)\n", child.Name, tostring(child.Enabled))
        end
    end
    allLogs = allLogs .. "\n[REAL-TIME CHANGES]:\n"

    local function monitor(obj)
        if obj:IsA("GuiObject") or obj:IsA("LayerCollector") then
            local prop = obj:IsA("LayerCollector") and "Enabled" or "Visible"
            local conn = obj:GetPropertyChangedSignal(prop):Connect(function()
                -- Hanya log jika berubah jadi aktif/kelihatan
                local isActive = obj:IsA("LayerCollector") and obj.Enabled or obj.Visible
                if isActive then
                    local path = obj:GetFullName()
                    allLogs = allLogs .. string.format("\n[CHANGED] %s", path)
                    if onUpdate then onUpdate(allLogs) end
                end
            end)
            table.insert(connections, conn)
        end
    end

    -- 2. Pantau semua keturunan yang sudah ada
    for _, desc in pairs(Services.PlayerGui:GetDescendants()) do
        monitor(desc)
    end

    -- 3. Pantau jika ada objek baru masuk
    local newConn = Services.PlayerGui.DescendantAdded:Connect(monitor)
    table.insert(connections, newConn)
    
    if onUpdate then onUpdate(allLogs) end
end

function Detective.stop()
    for _, c in pairs(connections) do c:Disconnect() end
    connections = {}
end

function Detective.getLogs() return allLogs end
function Detective.clear() allLogs = "--- LOGS CLEARED ---" end

return Detective