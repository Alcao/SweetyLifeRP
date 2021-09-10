local isInJail, unjail = false, false
local jailTime, fastTimer = 0, 0
ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx_jail:jailPlayer')
AddEventHandler('::{razzway.xyz}::esx_jail:jailPlayer', function(_jailTime)
	jailTime = _jailTime

	local playerPed = PlayerPedId()

	TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skin, cfg_jail.Uniforms.prison_wear.male)
		else
			TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skin, cfg_jail.Uniforms.prison_wear.female)
		end
	end)

	SetPedArmour(playerPed, 0)
	ESX.Game.Teleport(playerPed, cfg_jail.JailLocation)
	isInJail, unjail = true, false

	while not unjail do
		playerPed = PlayerPedId()

		RemoveAllPedWeapons(playerPed, true)
		if IsPedInAnyVehicle(playerPed, false) then
			ClearPedTasksImmediately(playerPed)
		end

		Citizen.Wait(0)

		-- Is the player trying to escape?
		if #(GetEntityCoords(playerPed) - cfg_jail.JailLocation) > 10 then
			ESX.Game.Teleport(playerPed, cfg_jail.JailLocation)
			TriggerEvent('::{razzway.xyz}::chat:addMessage', {args = {_U('judge'), _U('escape_attempt')}, color = {147, 196, 109}})
		end
	end

	ESX.Game.Teleport(playerPed, cfg_jail.JailBlip)
	isInJail = false

	ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin)
	end)
end)

SwLife.newThread(function()
	while true do
		Citizen.Wait(0)
		
		if jailTime > 0 and isInJail then
			if fastTimer < 0 then
				fastTimer = jailTime
			end
			
			draw2dText(_U('remaining_msg', ESX.Math.Round(fastTimer)), 0.175, 0.955)

			fastTimer = fastTimer - 0.01
		else
			Citizen.Wait(100)
		end
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx_jail:unjailPlayer')
AddEventHandler('::{razzway.xyz}::esx_jail:unjailPlayer', function()
	unjail, jailTime, fastTimer = true, 0, 0
end)

AddEventHandler('playerSpawned', function(spawn)
	if isInJail then
		ESX.Game.Teleport(PlayerPedId(), cfg_jail.JailLocation)
	end
end)

function draw2dText(text, x, y)
	SetTextFont(4)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end