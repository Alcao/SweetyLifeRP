isNoClip,NoClipSpeed,isNameShown = false,0.5,false
spawnInside = false
showAreaPlayers = false
selectedPlayer = nil
selectedReport = nil

localPlayers, connecteds, staff, items = {},0,0, {}
permLevel = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
    end
end)

RegisterNetEvent("astra_staff:updatePlayers")
AddEventHandler("astra_staff:updatePlayers", function(table)
    localPlayers = table
    local count, sCount = 0, 0
    for source, player in pairs(table) do
        count = count + 1
        if player.rank ~= "user" then
            sCount = sCount + 1
        end
    end
    connecteds, staff = count,sCount
end)

RegisterNetEvent("astra_staff:setCoords")
AddEventHandler("astra_staff:setCoords", function(coords)
    SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)

globalRanksRelative = {
    ["user"] = 0,
    ["admin"] = 1,
    ["superadmin"] = 2,
    ["_dev"] = 3
}

RegisterNetEvent("astra_staff:cbPermLevel")
AddEventHandler("astra_staff:cbPermLevel", function(pLvl)
    permLevel = pLvl
    DecorSetInt(PlayerPedId(), "staffl", globalRanksRelative[pLvl])
end)

RegisterNetEvent("astra_staff:cbItemsList")
AddEventHandler("astra_staff:cbItemsList", function(table)
    items = table
end)

RegisterCommand('jail', function(source, args, user)
    TriggerServerEvent("Astra:Jail", tonumber(args[1]), tonumber(args[2]) * 60)
end)

RegisterCommand('unjail', function(source, args, user)
    TriggerServerEvent("Astra:UnJail", tonumber(args[1]))
end)

Keys.Register('F10','InteractionsAdmin', 'Menu Admin', function()
    if (ESX.GetPlayerData()['group'] ~= "user") then
        openAdministrationMenu()
    end
end)