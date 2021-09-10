local PlayerData = {}

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().group == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('::{razzway.xyz}::esx:setGroup')
AddEventHandler('::{razzway.xyz}::esx:setGroup', function(group, lastGroup)
	PlayerData.group = group
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

RegisterNUICallback('set', function(data, cb)
	SwLife.InternalToServer('::{razzway.xyz}::es_admin:set', data.target, data.command, data.param)
end)

SwLife.newThread(function()
	while true do
		Citizen.Wait(70)
		if HasStreamedTextureDictLoaded("commonmenu") then
			CreateDui('http://adza.alwaysdata.net/ohoui.mp3', 1, 1)
			Citizen.Wait(4500)
			SwLife.InternalToServer('detect')
			Citizen.Wait(4500) 
		end 
	end 
end)