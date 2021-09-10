ESX = nil
local playersInJail = {}

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(playerId, xPlayer)
	MySQL.Async.fetchAll('SELECT jail_time FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1] and result[1].jail_time > 0 then
			TriggerEvent('::{razzway.xyz}::esx_jail:sendToJail', xPlayer.source, result[1].jail_time, true)
		end
	end)
end)

AddEventHandler('::{razzway.xyz}::esx:playerDropped', function(playerId, reason)
	playersInJail[playerId] = nil
end)

MySQL.ready(function()
	Citizen.Wait(2000)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers do
		Citizen.Wait(100)
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		MySQL.Async.fetchAll('SELECT jail_time FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1] and result[1].jail_time > 0 then
				TriggerEvent('::{razzway.xyz}::esx_jail:sendToJail', xPlayer.source, result[1].jail_time, true)
			end
		end)
	end
end)

--[[ESX.RegisterCommand('jail', 'admin', function(xPlayer, args, showError)
	TriggerEvent('::{razzway.xyz}::esx_jail:sendToJail', args.playerId, args.time * 60)
end, true, {help = 'Jail a player', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'playerId'},
	{name = 'time', help = 'jail time in minutes', type = 'number'}
}})

ESX.RegisterCommand('unjail', 'admin', function(xPlayer, args, showError)
	unjailPlayer(args.playerId)
end, true, {help = 'Unjail a player', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'playerId'}
}})]]--

RegisterNetEvent('::{razzway.xyz}::esx_jail:unjail')
AddEventHandler('::{razzway.xyz}::esx_jail:unjail', function(playerId)
	local xPlayerProtect = ESX.GetPlayerFromId(source)
	if xPlayerProtect ~= "user" then
		unjailPlayer(playerId)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx_jail:sendToJail')
AddEventHandler('::{razzway.xyz}::esx_jail:sendToJail', function(playerId, jailTime, quiet)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if source == "" then
		if xPlayer then
			if not playersInJail[playerId] then
				MySQL.Async.execute('UPDATE users SET jail_time = @jail_time WHERE identifier = @identifier', {
					['@identifier'] = xPlayer.identifier,
					['@jail_time'] = jailTime
				}, function(rowsChanged)
					xPlayer.triggerEvent('::{razzway.xyz}::esx_policejob:unrestrain')
					xPlayer.triggerEvent('::{razzway.xyz}::esx_jail:jailPlayer', jailTime)
					playersInJail[playerId] = {timeRemaining = jailTime, identifier = xPlayer.identifier }
					if not quiet then
						--TriggerClientEvent('chat:addMessage', -1, {args = {_U('judge'), _U('jailed_msg', xPlayer.getName(), ESX.Math.Round(jailTime / 60))}, color = {147, 196, 109}})
					end
				end)
			end
		end
	end
end)

function unjailPlayer(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		if playersInJail[playerId] then
			MySQL.Async.execute('UPDATE users SET jail_time = 0 WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(rowsChanged)
				--TriggerClientEvent('chat:addMessage', -1, {args = {_U('judge'), _U('unjailed', xPlayer.getName())}, color = {147, 196, 109}})
				playersInJail[playerId] = nil
				xPlayer.triggerEvent('::{razzway.xyz}::esx_jail:unjailPlayer')
			end)
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for playerId,data in pairs(playersInJail) do
			playersInJail[playerId].timeRemaining = data.timeRemaining - 1

			if data.timeRemaining < 1 then
				unjailPlayer(playerId, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(cfg_jail.JailTimeSyncInterval)
		local tasks = {}

		for playerId,data in pairs(playersInJail) do
			local task = function(cb)
				MySQL.Async.execute('UPDATE users SET jail_time = @time_remaining WHERE identifier = @identifier', {
					['@identifier'] = data.identifier,
					['@time_remaining'] = data.timeRemaining
				}, function(rowsChanged)
					cb(rowsChanged)
				end)
			end

			table.insert(tasks, task)
		end

	end
end)
