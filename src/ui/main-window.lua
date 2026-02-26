--[[
    Main Window Module
    Mengatur pembuatan window UI utama.
]] local requireRemote = _G.TKPartyHub.require
local Services = requireRemote("core/services")
local State = requireRemote("core/state")
local TeleportTab = requireRemote("ui/tabs/teleport-tab")
local MiscTab = requireRemote("ui/tabs/misc-tab")

local MainWindow = {}
local Window = nil -- Simpan instance window secara lokal

function MainWindow.create()

    -- Load Library Rayfield (External)
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    -- Inisialisasi Window
    Window = Rayfield:CreateWindow({
        Name = "TKPartyHub v2",
        LoadingTitle = "Mengunduh Konfigurasi...",
        LoadingText = "User: " .. Services.LocalPlayer.Name,
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "TKPartyHub_Configs",
            FileName = "MainConfig"
        },
        KeySystem = false -- Matikan key system agar cepat
    })

    -- Perbaikan Line 14: Pastikan Window sukses dibuat sebelum CreateTab
    if Window then
        -- Tab Utama (Home)
        local MainTab = Window:CreateTab("Main", 4483362458)

        MainTab:CreateSection("Player Info")
        MainTab:CreateParagraph({
            Title = "Selamat Datang!",
            Content = "Halo " .. Services.LocalPlayer.Name ..
                ", TKPartyHub Modular siap digunakan."
        })

        -- Perbaikan Line 41: Memuat Tab Teleport
        local TPTab = Window:CreateTab("Teleport", "map")
        local Misc = Window:CreateTab("Misc", 4483362458)

        if TeleportTab and TeleportTab.setup then
            TeleportTab.setup(TPTab)
        end
        if MiscTab and MiscTab.setup then MiscTab.setup(Misc) end

        Rayfield:Notify({
            Title = "TKPartyHub Loaded",
            Content = "Sistem Modular Berhasil Dijalankan.",
            Duration = 5
        })

    else
        warn("❌ Gagal membuat Window Rayfield!")
    end

    return Window
end

return MainWindow
