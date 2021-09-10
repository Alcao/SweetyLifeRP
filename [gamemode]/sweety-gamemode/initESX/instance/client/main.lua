-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
SwLife.InternalToServer = SwLife.InternalToServer
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local instance, instancedPlayers, registeredInstanceTypes, playersToHide = {}, {}, {}, {}
local instanceInvite, insideInstance
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

function CreateInstance(type, data)
	SwLife.InternalToServer('::{razzway.xyz}::instance:create', type, data)
end

function CloseInstance()
	instance = {}
	SwLife.InternalToServer('::{razzway.xyz}::instance:close')
	insideInstance = false
end

function EnterInstance(instance)
	insideInstance = true
	SwLife.InternalToServer('::{razzway.xyz}::instance:enter', instance.host)

	if registeredInstanceTypes[instance.type].enter then
		registeredInstanceTypes[instance.type].enter(instance)
	end
end

function LeaveInstance()
	if instance.host then
		if #instance.players > 1 then
			ESX.ShowNotification(_U('left_instance'))
		end

		if registeredInstanceTypes[instance.type].exit then
			registeredInstanceTypes[instance.type].exit(instance)
		end

		SwLife.InternalToServer('::{razzway.xyz}::instance:leave', instance.host)
	end

	insideInstance = false
end

function InviteToInstance(type, player, data)
	SwLife.InternalToServer('::{razzway.xyz}::instance:invite', instance.host, type, player, data)
end

function RegisterInstanceType(type, enter, exit)
	registeredInstanceTypes[type] = {
		enter = enter,
		exit = exit
	}
end

AddEventHandler('::{razzway.xyz}::instance:get', function(cb)
	cb(instance)
end)

AddEventHandler('::{razzway.xyz}::instance:create', function(type, data)
	CreateInstance(type, data)
end)

AddEventHandler('::{razzway.xyz}::instance:close', function()
	CloseInstance()
end)

AddEventHandler('::{razzway.xyz}::instance:enter', function(_instance)
	EnterInstance(_instance)
end)

AddEventHandler('::{razzway.xyz}::instance:leave', function()
	LeaveInstance()
end)

AddEventHandler('::{razzway.xyz}::instance:invite', function(type, player, data)
	InviteToInstance(type, player, data)
end)

AddEventHandler('::{razzway.xyz}::instance:registerType', function(name, enter, exit)
	RegisterInstanceType(name, enter, exit)
end)

RegisterNetEvent('::{razzway.xyz}::instance:onInstancedPlayersData')
AddEventHandler('::{razzway.xyz}::instance:onInstancedPlayersData', function(_instancedPlayers)
	instancedPlayers = _instancedPlayers
end)

RegisterNetEvent('::{razzway.xyz}::instance:onCreate')
AddEventHandler('::{razzway.xyz}::instance:onCreate', function(_instance)
	instance = {}
end)

RegisterNetEvent('::{razzway.xyz}::instance:onEnter')
AddEventHandler('::{razzway.xyz}::instance:onEnter', function(_instance)
	instance = _instance
end)

RegisterNetEvent('::{razzway.xyz}::instance:onLeave')
AddEventHandler('::{razzway.xyz}::instance:onLeave', function(_instance)
	instance = {}
end)

RegisterNetEvent('::{razzway.xyz}::instance:onClose')
AddEventHandler('::{razzway.xyz}::instance:onClose', function(_instance)
	instance = {}
end)

RegisterNetEvent('::{razzway.xyz}::instance:onPlayerEntered')
AddEventHandler('::{razzway.xyz}::instance:onPlayerEntered', function(_instance, player)
	instance = _instance
	ESX.ShowNotification(_('entered_into', GetPlayerName(GetPlayerFromServerId(player))))
end)

RegisterNetEvent('::{razzway.xyz}::instance:onPlayerLeft')
AddEventHandler('::{razzway.xyz}::instance:onPlayerLeft', function(_instance, player)
	instance = _instance
	ESX.ShowNotification(_('left_out', GetPlayerName(GetPlayerFromServerId(player))))
end)

RegisterNetEvent('::{razzway.xyz}::instance:onInvite')
AddEventHandler('::{razzway.xyz}::instance:onInvite', function(_instance, type, data)
	instanceInvite = {
		type = type,
		host = _instance,
		data = data
	}

	Citizen.CreateThread(function()
		Citizen.Wait(10000)

		if instanceInvite then
			ESX.ShowNotification(_U('invite_expired'))
			instanceInvite = nil
		end
	end)
end)

RegisterInstanceType('default')

-- Controls for invite
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if instanceInvite then
			ESX.ShowHelpNotification(_U('press_to_enter'))

			if IsControlJustReleased(0, 38) then
				EnterInstance(instanceInvite)
				ESX.ShowNotification(_U('entered_instance'))
				instanceInvite = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Instance players
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		playersToHide = {}

		if instance.host then
			for k, v in ipairs(GetActivePlayers()) do
				playersToHide[GetPlayerServerId(v)] = true
			end

			for k, v in ipairs(instance.players) do
				playersToHide[v] = nil
			end
		else
			for k, v in pairs(instancedPlayers) do
				playersToHide[k] = true
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()

		for k, v in pairs(playersToHide) do
			local player = GetPlayerFromServerId(k)

			if NetworkIsPlayerActive(player) then
				local otherPlayerPed = GetPlayerPed(player)
				SetEntityVisible(otherPlayerPed, false, false)
				SetEntityNoCollisionEntity(playerPed, otherPlayerPed, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	TriggerEvent('::{razzway.xyz}::instance:loaded')
end)