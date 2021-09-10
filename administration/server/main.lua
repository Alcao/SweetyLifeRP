ESX, players, items = nil, {}, {}
inService = {}

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
        for k, v in pairs(result) do
            items[k] = { label = v.label, name = v.name }
        end
    end)
end)

local function getLicense(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers
        end
        return identifiers
    end
end

local function isStaff(source)
    return players[source].rank ~= "user"
end

local function isWebhookSet(val)
    return val ~= nil and val ~= ""
end

TriggerEvent('SwLife:initObject', function(obj)
    ESX = obj
end)

RegisterServerEvent("Astra:Jail")
AddEventHandler("Astra:Jail", function(id, temps)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("", function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Jail !\n\nJail Info\nName : " .. GetPlayerName(id) .. "\nTime : ".. temps .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerEvent("::{razzway.xyz}::esx_jail:sendToJail", id, temps)
    else
        TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("Astra:UnJail")
AddEventHandler("Astra:UnJail", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("", function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Unjail !\n\nJail Info\nName : " .. GetPlayerName(id) .. "\nAcun : ```" }), { ['Content-Type'] = 'application/json' })
        TriggerEvent("::{razzway.xyz}::esx_jail:unjail", id)
    else
        TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent('::{razzway.xyz}::esx:playerLoaded')
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(source, xPlayer)
    local source = source
    if players[source] then
        return
    end
    TriggerClientEvent("astra_staff:cbPermLevel", source, xPlayer.getGroup())
    print(("^1[Cardinal] ^7Player ^3%s ^7loaded with group ^1%s^7 ! ^7"):format(GetPlayerName(source),xPlayer.getGroup()))
    players[source] = {
        timePlayed = { 0, 0 },
        rank = xPlayer.getGroup(),
        name = GetPlayerName(source),
        license = getLicense(source)["license"],
    }
    if players[source].rank ~= "user" then
        TriggerClientEvent("astra_staff:cbItemsList", source, items)
        TriggerClientEvent("astra_staff:cbReportTable", source, reportsTable)
        TriggerClientEvent("astra_staff:updatePlayers", source, players)
    end
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    players[source] = nil
    reportsTable[source] = nil
    updateReportsForStaff()
end)

RegisterNetEvent("astra_staff:setStaffState")
AddEventHandler("astra_staff:setStaffState", function(newVal, sneaky)
    local source = source
    TriggerClientEvent("astra_staff:cbStaffState", source, newVal)
    local byState = {
        [true] = "~r~[Staff] ~y~%s ~s~a ~g~pris~s~ son service.",
        [false] = "~r~[Staff] ~y~%s ~s~a ~r~quitté ~s~son service."
    }
    if newVal then
        inService[source] = true
    else
        inService[source] = nil
    end
    if not sneaky then
        for k,player in pairs(players) do
            if player.rank ~= "user" and inService[k] ~= nil then
                TriggerClientEvent("::{razzway.xyz}::esx:showNotification", k, byState[newVal]:format(GetPlayerName(source)))
            end
        end
    end
end)

RegisterNetEvent("astra_staff:goto")
AddEventHandler("astra_staff:goto", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("teleport", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local coords = GetEntityCoords(GetPlayerPed(target))
    TriggerClientEvent("astra_staff:setCoords", source, coords)
    if isWebhookSet(Config.webhook.onTeleport) then
        sendWebhook(("L'utilisateur %s s'est téléporté sur %s"):format(GetPlayerName(source), GetPlayerName(target)), "grey", Config.webhook.onItemGive)
    end
end)

RegisterNetEvent("astra_staff:bring")
AddEventHandler("astra_staff:bring", function(target, coords)
    local source = source
    local rank = players[source].rank
    if not canUse("teleport", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("astra_staff:setCoords", target, coords)
    if isWebhookSet(Config.webhook.onTeleport) then
        sendWebhook(("L'utilisateur %s a téléporté %s sur lui"):format(GetPlayerName(source), GetPlayerName(target)), "grey", Config.webhook.onItemGive)
    end
end)

RegisterNetEvent("astra_staff:tppc")
AddEventHandler("astra_staff:tppc", function(target, coords)
    local source = source
    local rank = players[source].rank
    if not canUse("tppc", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("astra_staff:setCoords", target, vector3(215.76, -810.12, 30.73))
    TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, "~g~Téléportation effectuée")
end)

RegisterNetEvent("astra_staff:give")
AddEventHandler("astra_staff:give", function(target, itemName, qty)
    local source = source
    local rank = players[source].rank
    if not canUse("give", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(tonumber(target))
    if xPlayer then
        xPlayer.addInventoryItem(itemName, tonumber(qty))
        TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, ("~g~Give de %sx%s au joueur %s effectué"):format(qty, itemName, GetPlayerName(target)))
        if isWebhookSet(Config.webhook.onItemGive) then
            sendWebhook(("L'utilisateur %s a give %sx%s a %s"):format(GetPlayerName(source), qty, itemName, GetPlayerName(target)), "grey", Config.webhook.onItemGive)
        end
    else
        TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, "~r~Ce joueur n'est plus connecté")
    end
end)

RegisterNetEvent("astra_staff:message")
AddEventHandler("astra_staff:message", function(target, message)
    local source = source
    local rank = players[source].rank
    if not canUse("mess", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, ("~g~Message envoyé à %s"):format(GetPlayerName(target)))
    TriggerClientEvent("::{razzway.xyz}::esx:showNotification", target, ("~r~Message du staff~s~: %s"):format(message))
    if isWebhookSet(Config.webhook.onMessage) then
        sendWebhook(("L'utilisateur %s a envoyé un message à %s:\n\n__%s__"):format(GetPlayerName(source), GetPlayerName(target), message), "grey", Config.webhook.onMessage)
    end
end)

RegisterNetEvent("astra_staff:kick")
AddEventHandler("astra_staff:kick", function(target, message)
    local source = source
    local rank = players[source].rank
    if not canUse("kick", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, ("~g~Expulsion de %s effectuée"):format(GetPlayerName(target)))
    local name = GetPlayerName(target)
    DropPlayer(target, ("[SweetyLife] Expulsé: %s"):format(message))
    if isWebhookSet(Config.webhook.onKick) then
        sendWebhook(("L'utilisateur %s a expulsé %s pour la raison:\n\n__%s__"):format(GetPlayerName(source), name, message), "grey", Config.webhook.onKick)
    end
end)

RegisterNetEvent("astra_staff:revive")
AddEventHandler("astra_staff:revive", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("revive", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, ("~g~Revive de %s effectué"):format(GetPlayerName(target)))
    TriggerClientEvent("::{razzway.xyz}::esx_ambulancejob:revive", target)
    local name = GetPlayerName(target)
    if isWebhookSet(Config.webhook.onRevive) then
        sendWebhook(("L'utilisateur %s a revive %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onRevive)
    end
end)

RegisterNetEvent("astra_staff:heal")
AddEventHandler("astra_staff:heal", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("heal", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, ("~g~Heal de %s effectué"):format(GetPlayerName(target)))
    TriggerClientEvent('::{razzway.xyz}::esx_status:healPlayer', target)
    local name = GetPlayerName(target)
    if isWebhookSet(Config.webhook.onHeal) then
        sendWebhook(("L'utilisateur %s a heal %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onHeal)
    end
end)

RegisterNetEvent("astra_staff:spawnVehicle")
AddEventHandler("astra_staff:spawnVehicle", function(model, target)
    local source = source
    local rank = players[source].rank
    if not canUse("vehicles", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    if target ~= nil then
        TriggerClientEvent("::{razzway.xyz}::esx:spawnVehicle", target, model)
    else
        TriggerClientEvent("::{razzway.xyz}::esx:spawnVehicle", source, model)
    end
end)

RegisterNetEvent("astra_staff:setGroup")
AddEventHandler("astra_staff:setGroup", function(target, group)
    local source = source
    local rank = players[source].rank
    if not canUse("setGroup", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        xPlayer.setGroup(group)
        ESX.SavePlayer(xPlayer, function() end)
        players[source].rank = group
        TriggerClientEvent("astra_staff:cbPermLevel", target, group)
        TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, ("~g~Changement du rang de %s effectué"):format(GetPlayerName(target)))
        for source, player in pairs(players) do
            if isStaff(source) then
                TriggerClientEvent("astra_staff:updatePlayers", source, players)
            end
        end
        local name = GetPlayerName(target)
        if isWebhookSet(Config.webhook.onGroupChange) then
            sendWebhook(("L'utilisateur %s a changé le groupe de %s pour le groupe: __%s__"):format(GetPlayerName(source), name, group), "red", Config.webhook.onGroupChange)
        end
    else
        TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, "~r~Ce joueur n'est plus connecté")
    end
end)

RegisterNetEvent("astra_staff:clearInv")
AddEventHandler("astra_staff:clearInv", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("clearInventory", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    for i = 1, #xPlayer.inventory, 1 do
        if xPlayer.inventory[i].count > 0 then
            xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
        end
    end
    TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, ("~g~Clear inventaire de %s effectuée"):format(GetPlayerName(target)))
    if isWebhookSet(Config.webhook.onClear) then
        sendWebhook(("L'utilisateur %s a clear inventaire %s"):format(GetPlayerName(source), GetPlayerName(target)), "grey", Config.webhook.onClear)
    end
end)


RegisterNetEvent("astra_staff:clearLoadout")
AddEventHandler("astra_staff:clearLoadout", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("clearLoadout", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    for i = #xPlayer.loadout, 1, -1 do
        xPlayer.removeWeapon(xPlayer.loadout[i].name)
    end
    TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, ("~g~Clear des armes de %s effectuée"):format(GetPlayerName(target)))
    if isWebhookSet(Config.webhook.onClear) then
        sendWebhook(("L'utilisateur %s a clear les armes de %s"):format(GetPlayerName(source), GetPlayerName(target)), "grey", Config.webhook.onClear)
    end
end)

RegisterNetEvent("astra_staff:addMoney")
AddEventHandler("astra_staff:addMoney", function(target, ammount)
    local source = source
    local rank = players[source].rank
    if not canUse("giveMoney", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    xPlayer.addAccountMoney("cash", ammount)
    TriggerClientEvent("::{razzway.xyz}::esx:showNotification", source, ("~g~Give d'argent à %s effectuée"):format(GetPlayerName(target)))
    if isWebhookSet(Config.webhook.onMoneyGive) then
        sendWebhook(("L'utilisateur %s a give %s$ à %s"):format(GetPlayerName(source), ammount, GetPlayerName(target)), "grey", Config.webhook.onMoneyGive)
    end
end)

RegisterServerEvent("Razzway:GiveMoney")
AddEventHandler("Razzway:GiveMoney", function(type, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" then
        PerformHttpRequest("https://discord.com/api/webhooks/825784570594721803/gMIY1Jj144qAEBWi-we-sYlEvLtexTjv-noHkwwFYmgOcMQT_Pio-gJvCG2gI7RhTR55", function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Give Money ! " .. "\n\nAmount : " .. money .. "\nType : " .. type .. "```" }), { ['Content-Type'] = 'application/json' })
        PerformHttpRequest("https://discord.com/api/webhooks/825784570594721803/gMIY1Jj144qAEBWi-we-sYlEvLtexTjv-noHkwwFYmgOcMQT_Pio-gJvCG2gI7RhTR55", function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Give Money ! " .. "\n\nAmount : " .. money .. "\nType : " .. type .. "```" }), { ['Content-Type'] = 'application/json' })
        if type == "cash" then
            xPlayer.addAccountMoney('cash', money)
        end
        if type == "bank" then
            xPlayer.addAccountMoney('bank', money)
        end
        if type == "dirtycash" then
            xPlayer.addAccountMoney('dirtycash', money)
        end
    else
        TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "Je code avec le cul :p")
    end
end)


-- Players updaters task
Citizen.CreateThread(function()
    while true do
        Wait(15000)
        for source, player in pairs(players) do
            if isStaff(source) then
                TriggerClientEvent("astra_staff:updatePlayers", source, players)
                TriggerClientEvent("astra_staff:cbReportTable", source, reportsTable)
            end
        end
    end
end)

AddEventHandler("clearPedTasksEvent", function(source, data)
    local _source = source
    TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", _source, "Le cheat ... c'est mal !")
    print("~y~ID: ".._source.." a essayé de truc")
end)

-- Session counter task
-- TODO -> add report time elapsed
Citizen.CreateThread(function()
    while true do
        Wait(1000 * 60)
        for k, v in pairs(players) do
            players[k].timePlayed[1] = players[k].timePlayed[1] + 1
            if players[k].timePlayed[1] > 60 then
                players[k].timePlayed[1] = 0
                players[k].timePlayed[2] = players[k].timePlayed[2] + 1
            end
        end
        for k, v in pairs(reportsTable) do
            reportsTable[k].timeElapsed[1] = reportsTable[k].timeElapsed[1] + 1
            if reportsTable[k].timeElapsed[1] > 60 then
                reportsTable[k].timeElapsed[1] = 0
                reportsTable[k].timeElapsed[2] = reportsTable[k].timeElapsed[2] + 1
            end
        end
    end
end)