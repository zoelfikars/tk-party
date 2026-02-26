--[[
    Teleport Tab Module
    Menampilkan daftar lokasi teleport di UI.
]] local requireRemote = _G.TKPartyHub.require
local Locations = requireRemote("config/locations")
local Teleport = requireRemote("features/teleport")
local Services = requireRemote("core/services")

local TeleportTab = {}

function TeleportTab.setup(tabInstance)
    tabInstance:CreateSection("Map Teleport")

    -- Mengambil semua nama lokasi dari config untuk dimasukkan ke Dropdown
    local locationNames = {}
    for name, _ in pairs(Locations) do table.insert(locationNames, name) end
    table.sort(locationNames) -- Urutkan abjad agar rapi

    tabInstance:CreateDropdown({
        Name = "Pilih Lokasi Map",
        Options = locationNames,
        CurrentOption = "",
        MultipleOptions = false,
        Flag = "MapTeleportDropdown",
        Callback = function(Option)
            local targetPos = Locations[Option[1]]
            if targetPos then Teleport.to(targetPos) end
        end
    })

    -- === SECTION PLAYER TELEPORT ===
    tabInstance:CreateSection("Player Teleport")

    -- Fungsi untuk mengambil daftar nama player lain
    local function getPlayerList()
        local list = {}
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player ~= Services.LocalPlayer then
                table.insert(list, player.Name)
            end
        end
        return list
    end

    local playerDropdown = tabInstance:CreateDropdown({
        Name = "Pilih Player",
        Options = getPlayerList(),
        CurrentOption = "",
        MultipleOptions = false,
        Flag = "PlayerTeleportDropdown",
        Callback = function(Option) Teleport.toPlayer(Option[1]) end
    })

    -- Tombol Refresh Daftar Player
    tabInstance:CreateButton({
        Name = "Refresh Player List",
        Callback = function()
            playerDropdown:Refresh(getPlayerList(), true)
        end
    })
end

return TeleportTab
