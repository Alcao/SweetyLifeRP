ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

local safeZones = {
	vector3(298.39889526367,-584.52111816406,43.260845184326), -- Pillbox
	vector3(228.98168945312,-790.67102050781,30.653341293335), -- Parking central
	vector3(438.50491333008,-986.23333740234,30.689577102661), -- MRPD
	vector3(-204.93988037109,-1325.7008056641,30.913440704346), -- Bennys
	vector3(129.5050201416,-1299.4931640625,29.232746124268), -- Unicorn
    vector3(-551.53045654297,-192.8431854248,38.219654083252), -- 
    vector3(1178.8970947266,2642.2531738281,37.797035217285), -- Concessmoto
    vector3(-438.6884765625,-2796.2739257812,7.2960515022278), -- Post OP
}

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local disabledSafeZonesKeys = {
	{group = 2, key = 37, message = "~r~Attention !\n~s~Il est impossible de sortir une arme dans cet endroit."},
	{group = 0, key = 24, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 69, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 92, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 106, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 168, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 160, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 45, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 80, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 140, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 250, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 263, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."},
	{group = 0, key = 310, message = "~r~Attention !\n~s~Il est impossible d'engager un combat dans cet endroit."}
}

local notifIn, notifOut = false, false
local closestZone = 1

SwLife.newThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local minDistance = 100000

		for i = 1, #safeZones, 1 do
			local dist = #(safeZones[i] - plyCoords)

			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end

		Citizen.Wait(15000)
	end
end)

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(0)
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local dist = #(safeZones[closestZone] - plyCoords)
		if ESX.PlayerData.job.name ~= "police" then
			if dist <= 80 then
				if not notifIn then
					NetworkSetFriendlyFireOption(false)
					
					SetCurrentPedWeapon(plyPed, `WEAPON_UNARMED`, true)
					ESX.ShowNotification('~g~Vous êtes désormais en zone sécurisée.')

					notifIn = true
					notifOut = false
				end
			else
				if not notifOut then
					NetworkSetFriendlyFireOption(true)
					ESX.ShowNotification("~r~Vous êtes sorti de la zone sécurisée.")

					notifOut = true
					notifIn = false
				end
			end
		end
		if ESX.PlayerData.job.name ~= "police" or ESX.PlayerData.job.name ~= "ems" then
			if notifIn then
				for vehicle in EnumerateVehicles() do
					if not IsVehicleSeatFree(vehicle, -1) then
						SetEntityNoCollisionEntity(plyPed, vehicle, true)
						SetEntityNoCollisionEntity(vehicle, plyPed, true)
						
					end
				end

				DisablePlayerFiring(player, true)

				for i = 1, #disabledSafeZonesKeys, 1 do
					DisableControlAction(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key, true)

					if IsDisabledControlJustPressed(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key) then
						SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)

						if disabledSafeZonesKeys[i].message then
							ESX.ShowNotification(disabledSafeZonesKeys[i].message)
						end
					end
				end
			end
		end
	end
end)

