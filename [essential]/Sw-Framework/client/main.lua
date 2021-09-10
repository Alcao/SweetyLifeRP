local isLoadoutLoaded, isPaused, disableUi, isPlayerSpawned, isDead, pickups = false, false, false, false, false, {}

RegisterNetEvent('::{razzway.xyz}::esx:playerLoaded')
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('::{razzway.xyz}::esx:setMaxWeight')
AddEventHandler('::{razzway.xyz}::esx:setMaxWeight', function(newMaxWeight)
	ESX.PlayerData.maxWeight = newMaxWeight
end)

AddEventHandler('playerSpawned', function(spawn, isFirstSpawn)
	while not ESX.PlayerLoaded do
		Citizen.Wait(10)
	end

	TriggerEvent('::{razzway.xyz}::esx:restoreLoadout')

	if isFirstSpawn then
		_TriggerServerEvent('::{razzway.xyz}::esx:positionSaveReady')
	end

	isLoadoutLoaded, isPlayerSpawned, isDead = true, true, false
	SetCanAttackFriendly(PlayerPedId(), true, true)
	NetworkSetFriendlyFireOption(true)
end)

AddEventHandler('::{razzway.xyz}::esx:onPlayerDeath', function() isDead = true end)
AddEventHandler('::{razzway.xyz}::skinchanger:loadDefaultModel', function() isLoadoutLoaded = false end)

AddEventHandler('::{razzway.xyz}::skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	TriggerEvent('::{razzway.xyz}::esx:restoreLoadout')
end)

AddEventHandler('::{razzway.xyz}::esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(playerPed, true)

	for i = 1, #ESX.PlayerData.loadout, 1 do
		local weaponName = ESX.PlayerData.loadout[i].name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for j = 1, #ESX.PlayerData.loadout[i].components, 1 do
			local weaponComponent = ESX.PlayerData.loadout[i].components[j]
			local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, ESX.PlayerData.loadout[i].ammo)
			ammoTypes[ammoType] = true
		end
	end

	isLoadoutLoaded = true
end)

RegisterNetEvent('::{razzway.xyz}::esx:setAccountMoney')
AddEventHandler('::{razzway.xyz}::esx:setAccountMoney', function(account)
	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end

	ESX.UI.HUD.UpdateElement('account_' .. account.name, {
		money = ESX.Math.GroupDigits(account.money)
	})
end)

RegisterNetEvent('::{razzway.xyz}::esx:addInventoryItem')
AddEventHandler('::{razzway.xyz}::esx:addInventoryItem', function(item)
	ESX.UI.ShowInventoryItemNotification(true, item.label, item.count)
	table.insert(ESX.PlayerData.inventory, item)
end)

RegisterNetEvent('::{razzway.xyz}::esx:removeInventoryItem')
AddEventHandler('::{razzway.xyz}::esx:removeInventoryItem', function(item, identifier)
	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name and (not identifier or (item.unique and ESX.PlayerData.inventory[i].extra.identifier and ESX.PlayerData.inventory[i].extra.identifier == identifier)) then
			ESX.UI.ShowInventoryItemNotification(false, item.label, item.count)
			table.remove(ESX.PlayerData.inventory, i)
			break
		end
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:updateItemCount')
AddEventHandler('::{razzway.xyz}::esx:updateItemCount', function(add, itemName, count)
	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == itemName then
			ESX.UI.ShowInventoryItemNotification(add, ESX.PlayerData.inventory[i].label, add and (count - ESX.PlayerData.inventory[i].count) or (ESX.PlayerData.inventory[i].count - count))
			ESX.PlayerData.inventory[i].count = count
			break
		end
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:setJob')
AddEventHandler('::{razzway.xyz}::esx:setJob', function(job)
	ESX.PlayerData.job = job

	ESX.UI.HUD.UpdateElement('job', {
		job_label = job.label,
		grade_label = job.grade_label
	})
end)

RegisterNetEvent('::{razzway.xyz}::esx:setJob2')
AddEventHandler('::{razzway.xyz}::esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2

	ESX.UI.HUD.UpdateElement('job2', {
		job2_label = job2.label,
		grade2_label = job2.grade_label
	})
end)

RegisterNetEvent('::{razzway.xyz}::esx:setGroup')
AddEventHandler('::{razzway.xyz}::esx:setGroup', function(group, lastGroup)
	ESX.PlayerData.group = group
end)

RegisterNetEvent('::{razzway.xyz}::esx:addWeapon')
AddEventHandler('::{razzway.xyz}::esx:addWeapon', function(weaponName, weaponAmmo)
	local found = false

	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			found = true
			break
		end
	end

	if not found then
		local playerPed = PlayerPedId()
		local weaponHash = GetHashKey(weaponName)
		local weaponLabel = ESX.GetWeaponLabel(weaponName)
		ESX.UI.ShowInventoryItemNotification(true, weaponLabel, false)

		table.insert(ESX.PlayerData.loadout, {
			name = weaponName,
			ammo = weaponAmmo,
			label = weaponLabel,
			components = {}
		})

		GiveWeaponToPed(playerPed, weaponHash, weaponAmmo, false, false)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:addWeaponComponent')
AddEventHandler('::{razzway.xyz}::esx:addWeaponComponent', function(weaponName, weaponComponent)
	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				local found = false

				for j = 1, #ESX.PlayerData.loadout[i].components, 1 do
					if ESX.PlayerData.loadout[i].components[j] == weaponComponent then
						found = true
						break
					end
				end

				if not found then
					local playerPed = PlayerPedId()
					local weaponHash = GetHashKey(weaponName)

					ESX.UI.ShowInventoryItemNotification(true, component.label, false)
					table.insert(ESX.PlayerData.loadout[i].components, weaponComponent)
					GiveWeaponComponentToPed(playerPed, weaponHash, component.hash)
				end
			end
		end
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:setWeaponAmmo')
AddEventHandler('::{razzway.xyz}::esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			local playerPed = PlayerPedId()
			local weaponHash = GetHashKey(weaponName)

			ESX.PlayerData.loadout[i].ammo = weaponAmmo
			SetPedAmmo(playerPed, weaponHash, weaponAmmo)
			break
		end
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:removeWeapon')
AddEventHandler('::{razzway.xyz}::esx:removeWeapon', function(weaponName, ammo)
	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			local playerPed = PlayerPedId()
			local weaponHash = GetHashKey(weaponName)
			local weaponLabel = ESX.GetWeaponLabel(weaponName)

			ESX.UI.ShowInventoryItemNotification(false, weaponLabel, false)
			table.remove(ESX.PlayerData.loadout, i)
			RemoveWeaponFromPed(playerPed, weaponHash)

			if ammo then
				local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
				local finalAmmo = math.floor(pedAmmo - ammo)
				SetPedAmmo(playerPed, weaponHash, finalAmmo)
			else
				SetPedAmmo(playerPed, weaponHash, 0)
			end

			break
		end
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:removeWeaponComponent')
AddEventHandler('::{razzway.xyz}::esx:removeWeaponComponent', function(weaponName, weaponComponent)
	for i = 1, #ESX.PlayerData.loadout, 1 do
		if ESX.PlayerData.loadout[i].name == weaponName then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				for j = 1, #ESX.PlayerData.loadout[i].components, 1 do
					if ESX.PlayerData.loadout[i].components[j] == weaponComponent then
						local playerPed = PlayerPedId()
						local weaponHash = GetHashKey(weaponName)

						ESX.UI.ShowInventoryItemNotification(false, component.label, false)
						table.insert(ESX.PlayerData.loadout[i].components, j)
						RemoveWeaponComponentFromPed(playerPed, weaponHash, component.hash)
						break
					end
				end
			end
		end
	end
end)

-- Commands
RegisterNetEvent('::{razzway.xyz}::esx:teleport')
AddEventHandler('::{razzway.xyz}::esx:teleport', function(coords)
	ESX.Game.Teleport(PlayerPedId(), coords)
end)

RegisterNetEvent('::{razzway.xyz}::esx:spawnVehicle')
AddEventHandler('::{razzway.xyz}::esx:spawnVehicle', function(model)
	model = (type(model) == 'number' and model or GetHashKey(model))

	if IsModelInCdimage(model) then
		local playerPed = PlayerPedId()
		local plyCoords = GetEntityCoords(playerPed)

		ESX.Game.SpawnVehicle(model, plyCoords, 90.0, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	else
		TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Invalid vehicle model.' } })
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:createPickup')
AddEventHandler('::{razzway.xyz}::esx:createPickup', function(pickupId, label, coords, type, name, components)
	local pickupObject

	ESX.Game.SpawnLocalObject('prop_cs_package_01', coords, function(obj)
		pickupObject = obj
	end)

	while not pickupObject do
		Citizen.Wait(10)
	end

	SetEntityAsMissionEntity(pickupObject, false, false)
	PlaceObjectOnGroundProperly(pickupObject)
	FreezeEntityPosition(pickupObject, true)

	pickups[pickupId] = {
		id = pickupId,
		obj = pickupObject,
		label = label,
		inRange = false,
		coords = coords
	}
end)

RegisterNetEvent('::{razzway.xyz}::esx:createMissingPickups')
AddEventHandler('::{razzway.xyz}::esx:createMissingPickups', function(missingPickups)
	for pickupId, pickup in pairs(missingPickups) do
		local pickupObject = nil

		ESX.Game.SpawnLocalObject('prop_cs_package_01', pickup.coords, function(obj)
			pickupObject = obj
		end)

		while pickupObject == nil do
			Citizen.Wait(10)
		end

		SetEntityAsMissionEntity(pickupObject, false, false)
		PlaceObjectOnGroundProperly(pickupObject)
		FreezeEntityPosition(pickupObject, true)

		pickups[pickupId] = {
			id = pickupId,
			obj = pickupObject,
			label = pickup.label,
			inRange = false,
			coords = pickup.coords
		}
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:removePickup')
AddEventHandler('::{razzway.xyz}::esx:removePickup', function(id)
	ESX.Game.DeleteObject(pickups[id].obj)
	pickups[id] = nil
end)

RegisterNetEvent('::{razzway.xyz}::esx:deleteVehicle')
AddEventHandler('::{razzway.xyz}::esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed, false), radius)

		for i = 1, #vehicles, 1 do
			local attempt = 0

			while not NetworkHasControlOfEntity(vehicles[i]) and attempt < 100 and DoesEntityExist(vehicles[i]) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(vehicles[i])
				attempt = attempt + 1
			end

			if DoesEntityExist(vehicles[i]) and NetworkHasControlOfEntity(vehicles[i]) then
				ESX.Game.DeleteVehicle(vehicles[i])
			end
		end
	else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)

AddEventHandler('::{razzway.xyz}::tempui:toggleUi', function(value)
	disableUi = value
end)

-- Last position
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()

		if ESX.PlayerLoaded and isPlayerSpawned then
			if not IsEntityDead(playerPed) then
				ESX.PlayerData.lastPosition = GetEntityCoords(playerPed, false)
			end
		end

		if IsEntityDead(playerPed) and isPlayerSpawned then
			isPlayerSpawned = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		while not ESX.PlayerLoaded do
			Citizen.Wait(10)
		end

		local playerPed = PlayerPedId()
	
		if playerPed and playerPed ~= -1 then
			while GetResourceState('sweety-gamemode') ~= 'started' do
				Citizen.Wait(10)
			end

			TriggerEvent('spawnmanager:spawnPlayer', {model = `mp_m_freemode_01`, coords = ESX.PlayerData.lastPosition, heading = 0.0})
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			_TriggerServerEvent('::{razzway.xyz}::esx:firstJoinProper')
			return
		end
	end
end)