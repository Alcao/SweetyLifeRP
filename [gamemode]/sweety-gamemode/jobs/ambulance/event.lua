-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
SwLife.InternalToServer = SwLife.InternalToServer
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

ESX = nil

local FirstSpawn, PlayerLoaded = true, false
local isDead, IsBusy = false, false

local HasAlreadyEnteredMarker = false
local LastZone = nil

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	PlayerLoaded = true
end)

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function RespawnPedAmbulance(ped, spawn)
	SetEntityCoordsNoOffset(ped, spawn.coords, false, false, false, true)
	NetworkResurrectLocalPlayer(spawn.coords, spawn.heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', spawn)
	ClearPedBloodDamage(ped)
end

RegisterNetEvent('::{razzway.xyz}::esx_ambulancejob:heal')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:heal', function(_type)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if _type == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth , math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif _type == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	ESX.ShowNotification(_U('healed'))
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = cfg_ambulance.RespawnDelay

		while timer > 0 and isDead do
			Citizen.Wait(0)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.0, 0.5)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextCentre(true)

			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.5, 0.85)

			if IsControlJustReleased(0, 47) then
				SendDistressSignal()
				break
			end
		end
	end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)

	ESX.ShowNotification(_U('distress_sent'))
	SwLife.InternalToServer('::{razzway.xyz}::esx_phone:send', 'ambulance', _U('distress_message'), false, {
		x = coords.x,
		y = coords.y,
		z = coords.z
	})
end

function ShowDeathTimer()
	local respawnTimer = cfg_ambulance.RespawnDelay / 1000
	local allowRespawn = respawnTimer / 2

	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

	BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	BeginTextCommandScaleformString("STRING")
	AddTextComponentSubstringPlayerName("~r~Vous etes dans le coma")
	EndTextCommandScaleformString()
	EndScaleformMovieMethod()

	PlaySoundFrontend(-1, "TextHit", "WastedSounds", true)

	Citizen.CreateThread(function()
		while respawnTimer > 0 and isDead do
			Citizen.Wait(1000)

			if respawnTimer > 0 then
				respawnTimer = respawnTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		while respawnTimer > 0 and isDead do
			Citizen.Wait(0)

			SetTextFont(4)
			SetTextScale(0.0, 0.5)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextCentre(true)

			local text = _U('please_wait', secondsToClock(respawnTimer))

			if respawnTimer <= allowRespawn then
				text = text .. '\n' .. _U('press_respawn')

				if IsControlJustReleased(0, 38) then
					RemoveItemsAfterRPDeath(true)
					break
				end
			end

			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandDisplayText(0.5, 0.8)

			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end

		if respawnTimer <= 0 then
			RemoveItemsAfterRPDeath(true)
		end
	end)
end

function RemoveItemsAfterRPDeath(respawnPed)
	SwLife.InternalToServer('::{razzway.xyz}::esx_ambulancejob:setDeathStatus', 0)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.TriggerServerCallback('::{razzway.xyz}::esx_ambulancejob:removeItemsAfterRPDeath', function()
			ESX.SetPlayerData('loadout', {})
			TriggerEvent('::{razzway.xyz}::esx_status:resetStatus')

			if respawnPed then
				RespawnPedAmbulance(PlayerPedId(), {coords = cfg_ambulance.Zones.HospitalInteriorInside1.Pos, heading = 0.0})
				AnimpostfxStop('DeathFailOut')
				DoScreenFadeIn(800)
			else
				ESX.Game.Teleport(PlayerPedId(), cfg_ambulance.Zones.HospitalInteriorOutside1.Pos, function()
					DoScreenFadeIn(800)
				end)
			end
		end)
	end)
end

function TeleportFadeEffect(entity, coords)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)
	end)
end

function WarpPedInClosestVehicle(ped)
	local coords = GetEntityCoords(ped, false)
	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

	if distance ~= -1 and distance <= 5.0 then
		local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
		local freeSeat = nil

		for i = maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat ~= nil then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end
	else
		ESX.ShowNotification(_U('no_vehicles'))
	end
end

AddEventHandler('playerSpawned', function()
	isDead = false

	if FirstSpawn then
		SwLife.InternalToServer('::{razzway.xyz}::esx_ambulancejob:firstSpawn')
		FirstSpawn = false
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:playerLoaded')
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('::{razzway.xyz}::esx:setJob')
AddEventHandler('::{razzway.xyz}::esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('::{razzway.xyz}::esx_phone:loaded')
AddEventHandler('::{razzway.xyz}::esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name = 'Ambulance',
		number = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('::{razzway.xyz}::esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('::{razzway.xyz}::esx:onPlayerDeath', function()
	isDead = true
	SwLife.InternalToServer('::{razzway.xyz}::esx_ambulancejob:setDeathStatus', 1)

	ShowDeathTimer()
	StartDistressSignal()

	ClearPedTasksImmediately(PlayerPedId())
	AnimpostfxPlay('DeathFailOut', 0, false)
	PlaySoundFrontend(-1, "Bed", "WastedSounds", true)
	ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
end)

RegisterNetEvent('::{razzway.xyz}::esx_ambulancejob:revive')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)
	SwLife.InternalToServer('::{razzway.xyz}::esx_ambulancejob:setDeathStatus', 0)
	TriggerEvent('::{razzway.xyz}::esx_status:resetStatus')

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		RespawnPedAmbulance(playerPed, {coords = coords, heading = 0.0})
		AnimpostfxStop('DeathFailOut')
		DoScreenFadeIn(800)
	end)
end)

RegisterNetEvent('::{razzway.xyz}::esx:reviveradius')
AddEventHandler('::{razzway.xyz}::esx:reviveradius', function(radius)
	local playerPed = PlayerPedId()
	local xPlayers = ESX.GetPlayers()
	local coords = GetEntityCoords(xPlayers, false)

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local people = ESX.GetPlayers(GetEntityCoords(playerPed, false), radius)

		for i = 1, #people, 1 do
			local attempt = 0

			SwLife.InternalToServer('::{razzway.xyz}::esx_ambulancejob:setDeathStatus', 0)
			TriggerEvent('::{razzway.xyz}::esx_status:resetStatus')
			
			Citizen.CreateThread(function()
				DoScreenFadeOut(800)
			
				while not IsScreenFadedOut() do
					Citizen.Wait(0)
				end
			
				RespawnPedAmbulance(xPlayers, {coords = coords, heading = 0.0})
				AnimpostfxStop('DeathFailOut')
				DoScreenFadeIn(800)
			end)
		end
	end
end)

AddEventHandler('::{razzway.xyz}::esx_ambulancejob:hasEnteredMarker', function(zone)
	if zone == 'HospitalInteriorEntering1' then
		TeleportFadeEffect(PlayerPedId(), cfg_ambulance.Zones.HospitalInteriorInside1.Pos)
	end

	if zone == 'HospitalInteriorExit1' then
		TeleportFadeEffect(PlayerPedId(), cfg_ambulance.Zones.HospitalInteriorOutside1.Pos)
	end

	if zone == 'HospitalInteriorEntering2' then
		local heli = cfg_ambulance.HelicopterSpawner

		if not IsAnyVehicleNearPoint(heli.SpawnPoint, 3.0) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
			ESX.Game.SpawnVehicle('polmav', {
				x = heli.SpawnPoint.x,
				y = heli.SpawnPoint.y,
				z = heli.SpawnPoint.z
			}, heli.Heading, function(vehicle)
				SetVehicleModKit(vehicle, 0)
				SetVehicleLivery(vehicle, 1)
			end)
		end

		TeleportFadeEffect(PlayerPedId(), cfg_ambulance.Zones.HospitalInteriorInside2.Pos)
	end

	if zone == 'HospitalInteriorExit2' then
		TeleportFadeEffect(PlayerPedId(), cfg_ambulance.Zones.HospitalInteriorOutside2.Pos)
	end

	if zone == 'AmbulanceActions' then
		CurrentAction = 'ambulance_actions_menu'
		CurrentActionMsg = _U('open_bossmenu')
		CurrentActionData = {}
	end

	if zone == 'VehicleSpawner' then
		CurrentAction = 'vehicle_spawner_menu'
		CurrentActionMsg = _U('veh_spawn')
		CurrentActionData = {}
	end

	if zone == 'Pharmacy' then
		CurrentAction = 'pharmacy'
		CurrentActionMsg = _U('open_pharmacy')
		CurrentActionData = {}
	end

	if zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

			if distance ~= -1 and distance <= 1.0 then
				CurrentAction = 'delete_vehicle'
				CurrentActionMsg = _U('store_veh')
				CurrentActionData = {vehicle = vehicle}
			end
		end
	end
end)

function FastTravel(pos)
	TeleportFadeEffect(PlayerPedId(), pos)
end

AddEventHandler('::{razzway.xyz}::esx_ambulancejob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('::{razzway.xyz}::esx_ambulancejob:requestDeath')
AddEventHandler('::{razzway.xyz}::esx_ambulancejob:requestDeath', function()
	if cfg_ambulance.AntiCombatLog then
		while not PlayerLoaded and FirstSpawn do
			Citizen.Wait(1000)
		end

		ESX.ShowNotification(_U('combatlog_message'))
		RemoveItemsAfterRPDeath(false)
	end
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t, i = {}, 1

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end

function revivePlayer(closestPlayer)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer == -1 or closestDistance > 3.0 then
	  ESX.ShowNotification("~r~Aucun joueur à proximité")
	else
	ESX.TriggerServerCallback('::{korioz#0110}::esx_ambulancejob:getItemAmount', function(qtty)
	if qtty > 0 then
	local closestPlayerPed = GetPlayerPed(closestPlayer)
	local health = GetEntityHealth(closestPlayerPed)
	if health == 0 then
	local playerPed = GetPlayerPed(-1)
	Citizen.CreateThread(function()
	ESX.ShowNotification(_U('revive_inprogress'))
	TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
	Wait(10000)
	ClearPedTasks(playerPed)
	if GetEntityHealth(closestPlayerPed) == 0 then
	SwLife.InternalToServer('::{korioz#0110}::esx_ambulancejob:removeItem', 'medikit')
	SwLife.InternalToServer('::{korioz#0110}::esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
	else
	ESX.ShowNotification(_U('isdead'))
	end
   end)
	else
		ESX.ShowNotification(_U('unconscious'))
	end
	 else
	ESX.ShowNotification(_U('not_enough_medikit'))
	end
   end, 'medikit')
end
end