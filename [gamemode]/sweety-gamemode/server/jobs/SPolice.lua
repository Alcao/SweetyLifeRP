ESX = nil

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

TriggerEvent('::{razzway.xyz}::esx_phone:registerNumber', 'police', 'alerte police', true, true)

TriggerEvent('pSociety::registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})


RegisterServerEvent('::{razzway.xyz}::esx_policejob:drag')
AddEventHandler('::{razzway.xyz}::esx_policejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		local xPlayerTarget = ESX.GetPlayerFromId(target)

		if xPlayerTarget.get('cuffState').isCuffed then
			TriggerClientEvent('::{razzway.xyz}::esx_policejob:drag', target, xPlayer.source)
		end
	else
		print(('esx_policejob: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_policejob:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

RegisterNetEvent('rz-police:weapon')
AddEventHandler('rz-police:weapon', function(arme, ammo, price)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(arme, ammo)
	TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, "LSPD", "~b~Armurerie", "Voici votre arme !", 'CHAR_AMMUNATION', 2)
end)


ESX.RegisterServerCallback('::{razzway.xyz}::esx_policejob:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_policejob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:prendreitems')
AddEventHandler('::{razzway.xyz}::esx_policejob:prendreitems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('::{razzway.xyz}::esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		
		if count > 0 and inventoryItem.count >= count then

		
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "quantité invalide")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
			end
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


RegisterNetEvent('::{razzway.xyz}::esx_policejob:stockitem')
AddEventHandler('::{razzway.xyz}::esx_policejob:stockitem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('::{razzway.xyz}::esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "Objet déposé "..count..""..inventoryItem.label.."")
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


ESX.RegisterServerCallback('::{razzway.xyz}::esx_policejob:inventairejoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_policejob:prendreitem', function(source, cb)
	TriggerEvent('::{razzway.xyz}::esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:spawned')
AddEventHandler('::{razzway.xyz}::esx_policejob:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
		Citizen.Wait(5000)
		TriggerClientEvent('::{razzway.xyz}::esx_policejob:updateBlip', -1)
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:forceBlip')
AddEventHandler('::{razzway.xyz}::esx_policejob:forceBlip', function()
	TriggerClientEvent('::{razzway.xyz}::esx_policejob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('::{razzway.xyz}::esx_policejob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('::{razzway.xyz}::esx_phone:removeNumber', 'police')
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:message')
AddEventHandler('::{razzway.xyz}::esx_policejob:message', function(target, msg)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', target, msg)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_policejob:getArmoryWeapons', function(source, cb)
	TriggerEvent('::{razzway.xyz}::esx_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_policejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('::{razzway.xyz}::esx_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons') or {}
		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('::{razzway.xyz}::esx_datastore:getSharedDataStore', 'society_police', function(store)
		local weapons = store.get('weapons') or {}

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)




-- Alerte LSPD


RegisterServerEvent('TireEntenduServeur')
AddEventHandler('TireEntenduServeur', function(gx, gy, gz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' then
			TriggerClientEvent('TireEntendu', xPlayers[i], gx, gy, gz)
		end
	end
end)


RegisterServerEvent('PriseAppelServeur')
AddEventHandler('PriseAppelServeur', function(gx, gy, gz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = xPlayer.getName(source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' then
			TriggerClientEvent('PriseAppel', xPlayers[i], name)
		end
	end
end)

RegisterServerEvent('police:PriseEtFinservice')
AddEventHandler('police:PriseEtFinservice', function(PriseOuFin)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' then
			TriggerClientEvent('police:InfoService', xPlayers[i], _raison, name)
			sendToDiscordPolice('Dynasty - LOGS', '[POLICE-BITE] ' ..xPlayer.getName().. ' viens de prendre sa : ' ..PriseOuFin.. '', 3145658)

		end
	end
end)



RegisterServerEvent('::{razzway.xyz}::esx_policejob:requestarrest')
AddEventHandler('::{razzway.xyz}::esx_policejob:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('::{razzway.xyz}::esx_policejob:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('::{razzway.xyz}::esx_policejob:doarrested', _source)
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:requestrelease')
AddEventHandler('::{razzway.xyz}::esx_policejob:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('::{razzway.xyz}::esx_policejob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('::{razzway.xyz}::esx_policejob:douncuffing', _source)
end)


RegisterServerEvent('renfort')
AddEventHandler('renfort', function(coords, raison)
	local _source = source
	local _raison = raison
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'police' then
			TriggerClientEvent('renfort:setBlip', xPlayers[i], coords, _raison)
		end
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:OutVehicle')
AddEventHandler('::{razzway.xyz}::esx_policejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		local xPlayerTarget = ESX.GetPlayerFromId(target)

		if xPlayerTarget.get('cuffState').isCuffed then
			TriggerClientEvent('::{razzway.xyz}::esx_policejob:OutVehicle', target)
		end
	else
		print(('esx_policejob: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:handcuff')
AddEventHandler('::{razzway.xyz}::esx_policejob:handcuff', function(target)
  TriggerClientEvent('::{razzway.xyz}::esx_policejob:handcuff', target)
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:drag')
AddEventHandler('::{razzway.xyz}::esx_policejob:drag', function(target)
  local _source = source
  TriggerClientEvent('::{razzway.xyz}::esx_policejob:drag', target, _source)
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:putInVehicle')
AddEventHandler('::{razzway.xyz}::esx_policejob:putInVehicle', function(target)
  TriggerClientEvent('::{razzway.xyz}::esx_policejob:putInVehicle', target)
end)

RegisterServerEvent('::{razzway.xyz}::esx_policejob:OutVehicle')
AddEventHandler('::{razzway.xyz}::esx_policejob:OutVehicle', function(target)
    TriggerClientEvent('::{razzway.xyz}::esx_policejob:OutVehicle', target)
end)

RegisterNetEvent('::{razzway.xyz}::esx_policejob:confiscatePlayerItem')
AddEventHandler('::{razzway.xyz}::esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		
		if targetItem.count > 0 and targetItem.count <= amount then

			
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				sourceXPlayer.showNotification(_U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				targetXPlayer.showNotification(_U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			else
				sourceXPlayer.showNotification(_U('quantity_invalid'))
			end
		else
			sourceXPlayer.showNotification(_U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)

		
		if targetAccount.money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney   (itemName, amount)

			sourceXPlayer.showNotification(_U('you_confiscated_account', amount, itemName, targetXPlayer.name))
			targetXPlayer.showNotification(_U('got_confiscated_account', amount, itemName, sourceXPlayer.name))
		else
			sourceXPlayer.showNotification(_U('quantity_invalid'))
		end

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end

		
		if targetXPlayer.hasWeapon(itemName) then
			targetXPlayer.removeWeapon(itemName, amount)
			sourceXPlayer.addWeapon   (itemName, amount)

			sourceXPlayer.showNotification(_U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
			targetXPlayer.showNotification(_U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
		else
			sourceXPlayer.showNotification(_U('quantity_invalid'))
		end
	end
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_policejob:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

	if notify then
		xPlayer.showNotification('being_searched')
	end

	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		
			data.dob = xPlayer.get('dateofbirth')
			data.height = xPlayer.get('height')

			if xPlayer.get('sex') == 'm' then data.sex = 'male' else data.sex = 'female' end
		

		TriggerEvent('::{razzway.xyz}::esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = ESX.Math.Round(status.percent)
			end
		end)

		
			cb(data)
		
	end
end)

function sendToDiscordPolice (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "https://discord.com/api/webhooks/840971308410208267/kjjYsmOxLoZiH8elAcgof3vqTqj8sx2VzxAoxXcJqm7RDXUYwLBsfmewNMPGU_euZoIE"
	-- Modify here your discordWebHook username = name, content = message,embeds = embeds

local embeds = {
	{
		["title"]=message,
		["type"]="rich",
		["color"] =color,
		["footer"]=  {
			["text"]= "Heure: " ..date_local.. "",
		},
	}
}

	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 