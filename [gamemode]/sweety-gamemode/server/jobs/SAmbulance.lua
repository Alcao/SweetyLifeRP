ESX = nil
local playersHealing, deadPlayers = {}, {}

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
TriggerEvent('::{razzway.xyz}::esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)
TriggerEvent('pSociety::registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

RegisterServerEvent('Ambulance:AppelNotifs')
AddEventHandler('Ambulance:AppelNotifs', function(supprimer)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'ambulance' then
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Information', 'L\'ambulancier ~b~'..name..'~s~ a pris l\'appel ~b~N°'..supprimer, 'CHAR_CALL911', 2)
		end
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_ambulancejob:revive')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:revive', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.job.name ~= 'ambulance' then
		TriggerEvent('::{razzway.xyz}::BanSql:ICheatServer', _source)
		return
	end

	local sourcePed = GetPlayerPed(_source)
	local targetPed = GetPlayerPed(target)

	if #(GetEntityCoords(sourcePed) - GetEntityCoords(targetPed)) < 3.0 and GetEntityHealth(targetPed) <= 0.0 then
		xPlayer.addAccountMoney('cash', cfg_ambulance.ReviveReward)
		TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:revive', target)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:onPlayerDeath')
AddEventHandler('::{razzway.xyz}::esx:onPlayerDeath', function(data)
	deadPlayers[source] = 'dead'
	TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
end)

RegisterNetEvent('::{razzway.xyz}::esx_ambulancejob:onPlayerDistress')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:onPlayerDistress', function()
	if deadPlayers[source] then
		deadPlayers[source] = 'distress'
		TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:onPlayerSpawn')
AddEventHandler('::{razzway.xyz}::esx:onPlayerSpawn', function()
	if deadPlayers[source] then
		deadPlayers[source] = nil
		TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

AddEventHandler('::{razzway.xyz}::esx:playerDropped', function(playerId, reason)
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
		TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx_ambulancejob:heal')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:heal', target, type)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx_ambulancejob:putInVehicle')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:putInVehicle', target)
	end
end)

if cfg_ambulance.EarlyRespawnFine then
	ESX.RegisterServerCallback('::{razzway.xyz}::esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= cfg_ambulance.EarlyRespawnFineAmount)
	end)

	RegisterNetEvent('::{razzway.xyz}::esx_ambulancejob:payFine')
	AddEventHandler('::{razzway.xyz}::esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = cfg_ambulance.EarlyRespawnFineAmount

		TriggerClientEvent("::{razzway.xyz}::esx:showAdvancedNotification", source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount)
	end)
end

ESX.RegisterServerCallback('::{razzway.xyz}::esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_ambulancejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end
end)

function getPriceFromHash(vehicleHash, jobGrade, type)
	local vehicles = cfg_ambulance.AuthorizedVehicles[type][jobGrade]

	for k,v in ipairs(vehicles) do
		if GetHashKey(v.model) == vehicleHash then
			return v.price
		end
	end

	return 0
end

RegisterNetEvent('::{razzway.xyz}::esx_ambulancejob:removeItem')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, '~b~Vous avez utilisé un bandage')
	elseif item == 'medikit' then
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, '~b~Vous avez utilisé un Medikit')
	end
end)

RegisterServerEvent('Pharmacy:giveItem')
AddEventHandler('Pharmacy:giveItem', function(itemName, itemLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local qtty = xPlayer.getInventoryItem(itemName).count

		if qtty < 10 then
			xPlayer.addInventoryItem(itemName, 5)
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, '~g~Ambulance\n~w~Tu as recu des bandages ~o~(10 Maximum)')
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, '~g~Ambulance\n~r~Maximum de bandages Atteints')
		end
	end)

RegisterServerEvent('Pharmacy:giveItemm')
AddEventHandler('Pharmacy:giveItemm', function(itemName, itemLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local qtty = xPlayer.getInventoryItem(itemName).count

		if qtty < 5 then
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, '~g~Ambulance\n~w~Tu as recu des Medikit ~o~(5 Maximum)')
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, '~g~Ambulance\n~r~Maximum de bandages Atteints')
		end
	end)

ESX.RegisterUsableItem('medikit', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)

		playersHealing[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)

		playersHealing[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:useItem', source, 'bandage')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_ambulancejob:firstSpawn')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:firstSpawn', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchScalar('SELECT isDead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(isDead)
		if isDead == 1 then
			print('esx_ambulancejob: ' .. GetPlayerName(xPlayer.source) .. ' (' .. xPlayer.identifier .. ') attempted combat logging!')
			TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:requestDeath', xPlayer.source)
		end
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_ambulancejob:setDeathStatus')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:setDeathStatus', function(isDead)
	local _source = source

	MySQL.Async.execute('UPDATE users SET isDead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = ESX.GetIdentifierFromId(_source),
		['@isDead'] = isDead
	})
end)

RegisterServerEvent('EMS:Ouvert')
AddEventHandler('EMS:Ouvert', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Annonce EMS', 'Un ~g~EMS~s~ est en service ! Votre santé avant tout !', 'CHAR_CALL911', 7)
    end
end)

RegisterServerEvent('EMS:Fermer')
AddEventHandler('EMS:Fermer', function()
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Annonce EMS', 'Il n\'y a plus ~r~d\'EMS~s~ en service ! ', 'CHAR_CALL911', 7)
    end
end)


ESX.RegisterServerCallback('ems:afficheappels', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys = {}

    MySQL.Async.fetchAll('SELECT * FROM appels_ems', {}, 
        function(result)
        for numreport = 1, #result, 1 do
            table.insert(keys, {
                id = result[numreport].id,
                type = result[numreport].type,
                reporteur = result[numreport].reporteur,
                nomreporter = result[numreport].nomreporter,
                raison = result[numreport].raison
            })
        end
        cb(keys)

    end)
end)

RegisterServerEvent('ems:ajoutappels')
AddEventHandler('ems:ajoutappels', function(typereport, reporteur, nomreporter, raison)
    MySQL.Async.execute('INSERT INTO appels_ems (type, reporteur, nomreporter, raison) VALUES (@type, @reporteur, @nomreporter, @raison)', {
        ['@type'] = typereport,
        ['@reporteur'] = reporteur,
        ['@nomreporter'] = nomreporter,
        ['@raison'] = raison
    })
end)

RegisterServerEvent('ems:supprimeappels')
AddEventHandler('ems:supprimeappels', function(supprimer)
    MySQL.Async.execute('DELETE FROM appels_ems WHERE id = @id', {
            ['@id'] = supprimer
    })
end)


RegisterServerEvent("Server:emsAppel")
AddEventHandler("Server:emsAppel", function(coords, id)

	local _id = id
	local _coords = coords
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'ambulance' then
			TriggerClientEvent("AppelemsTropBien", xPlayers[i], _coords, _id)
		end
end
end)
RegisterServerEvent('EMS:PriseAppelServeur')
AddEventHandler('EMS:PriseAppelServeur', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = xPlayer.getName(source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('EMS:AppelDejaPris', xPlayers[i], name)
    end
end)
ESX.RegisterServerCallback('EMS:GetID', function(source, cb)
	local idJoueur = source
	cb(idJoueur)
end)

local AppelTotal = 0
RegisterServerEvent('EMS:AjoutAppelTotalServeur')
AddEventHandler('EMS:AjoutAppelTotalServeur', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = xPlayer.getName(source)
	local xPlayers = ESX.GetPlayers()
	AppelTotal = AppelTotal + 1

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('EMS:AjoutUnAppel', xPlayers[i], AppelTotal)
	end
end)
RegisterServerEvent('emssapl:deleteallappels')
AddEventHandler('emssapl:deleteallappels', function()
    MySQL.Async.execute('DELETE FROM appels_ems', {
    })
end)

ESX.AddGroupCommand('revive', 'admin', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:revive', tonumber(args[1]))
		end
	else
		TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:revive', source)
	end
end, {help = _U('revive_help'), params = { {name = 'id'} }})

ESX.AddGroupCommand('reviveall', 'superadmin', function(source, args, user)
	TriggerClientEvent('::{razzway.xyz}::esx_ambulancejob:reviveradius', -1)
end, {help = _U('revive_help')})

