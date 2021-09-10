local DoorInfo = {}

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

RegisterServerEvent('::{razzway.xyz}::lockedDoors:updateState')
AddEventHandler('::{razzway.xyz}::lockedDoors:updateState', function(doorID, state, doorJob)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent("ratelimit", source, "::{razzway.xyz}::lockedDoors:updateState")

	if xPlayer.job.name ~= doorJob and xPlayer.job2.name ~= doorJob then
		print('lockedDoors: ' .. xPlayer.identifier .. ' attempted to open a locked door using an injector!')
		return
	end

	DoorInfo[doorID] = {}
	DoorInfo[doorID].state = state
	DoorInfo[doorID].doorID = doorID

	TriggerClientEvent('::{razzway.xyz}::lockedDoors:setState', -1, doorID, state)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::lockedDoors:getDoorInfo', function(source, cb)
	local amount = 0

	for i = 1, #ConfigLockedDoors.DoorList, 1 do
		amount = amount + 1
	end

	cb(DoorInfo, amount)
end)