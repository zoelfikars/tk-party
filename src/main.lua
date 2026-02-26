-- ============================================
-- TKPartyHub Modular v2.0 (Clean Remake)
-- ============================================
local baseUrl = "https://raw.githubusercontent.com/zoelfikars/tk-party/main/src/"

_G.TKPartyHub = _G.TKPartyHub or {}

_G.TKPartyHub.require = function(path)
    local finalPath = path
    if not path:find("%.lua$") then finalPath = path .. ".lua" end
    
    -- Mengambil file langsung dari branch main GitHub kamu
    local url = baseUrl .. finalPath .. "?cache=" .. math.random(1, 999999)
    local success, content = pcall(function() return game:HttpGet(url) end)

    if success and content ~= "" and not content:find("404") then
        local module, err = loadstring(content)
        if module then 
            return module() 
        else
            warn("❌ Syntax Error: " .. finalPath .. " | " .. tostring(err))
        end
    end
    warn("⚠️ Gagal Load Modul dari GitHub: " .. finalPath)
    return nil
end

local requireRemote = _G.TKPartyHub.require
-- Shortcut agar ngetiknya tidak panjang
local requireRemote = _G.TKPartyHub.require

-- LOADING CORE (Hanya fondasi utama)
print("🔄 Loading TKPartyHub Core...")
local Services = requireRemote("core/services")
local State = requireRemote("core/state")

-- LOADING UI
if Services and State then
    local MainWindow = requireRemote("ui/main-window")
    if MainWindow then
        MainWindow.create()
        print("✅ TKPartyHub Berhasil Dimuat!")
    end
end
