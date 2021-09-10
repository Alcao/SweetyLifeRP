local instances = {}

function GetInstancedPlayers()
	local players = {}

	for k, v in pairs(instances) do
		for k2, v2 in ipairs(v.players) do
			players[v2] = true
		end
	end

	return players
end

AddEventHandler('playerDropped', function(reason)
	if instances[source] then
		CloseInstance(source)
	end
end)

function CreateInstance(type, player, data)
	TriggerEvent("ratelimit", source, "CreateInstance")
	instances[player] = {
		type = type,
		host = player,
		players = {},
		data = data
	}

	TriggerEvent('::{razzway.xyz}::instance:onCreate', instances[player])
	TriggerClientEvent('::{razzway.xyz}::instance:onCreate', player, instances[player])
	TriggerClientEvent('::{razzway.xyz}::instance:onInstancedPlayersData', -1, GetInstancedPlayers())
end

function CloseInstance(instance)
	if instances[instance] then
		for i = 1, #instances[instance].players do
			TriggerClientEvent('::{razzway.xyz}::instance:onClose', instances[instance].players[i])
		end

		instances[instance] = nil

		TriggerClientEvent('::{razzway.xyz}::instance:onInstancedPlayersData', -1, GetInstancedPlayers())
		TriggerEvent('::{razzway.xyz}::instance:onClose', instance)
	end
end

function AddPlayerToInstance(instance, player)
	TriggerEvent("ratelimit", source, "AddPlayerToInstance")
	local found = false

	for i = 1, #instances[instance].players do
		if instances[instance].players[i] == player then
			found = true
			break
		end
	end

	if not found then
		table.insert(instances[instance].players, player)
	end

	TriggerClientEvent('::{razzway.xyz}::instance:onEnter', player, instances[instance])

	for i = 1, #instances[instance].players do
		if instances[instance].players[i] ~= player then
			TriggerClientEvent('::{razzway.xyz}::instance:onPlayerEntered', instances[instance].players[i], instances[instance], player)
		end
	end

	TriggerClientEvent('::{razzway.xyz}::instance:onInstancedPlayersData', -1, GetInstancedPlayers())
end

function RemovePlayerFromInstance(instance, player)
	TriggerEvent("ratelimit", source, "RemovePlayerFromInstance")

	if instances[instance] then
		TriggerClientEvent('::{razzway.xyz}::instance:onLeave', player, instances[instance])

		if instances[instance].host == player then
			for i = 1, #instances[instance].players do
				if instances[instance].players[i] ~= player then
					TriggerClientEvent('::{razzway.xyz}::instance:onPlayerLeft', instances[instance].players[i], instances[instance], player)
				end
			end

			CloseInstance(instance)
		else
			for i = 1, #instances[instance].players do
				if instances[instance].players[i] == player then
					instances[instance].players[i] = nil
				end
			end

			for i = 1, #instances[instance].players do
				if instances[instance].players[i] ~= player then
					TriggerClientEvent('::{razzway.xyz}::instance:onPlayerLeft', instances[instance].players[i], instances[instance], player)
				end
			end

			TriggerClientEvent('::{razzway.xyz}::instance:onInstancedPlayersData', -1, GetInstancedPlayers())
		end
	end
end

function InvitePlayerToInstance(instance, type, player, data)
	TriggerClientEvent('::{razzway.xyz}::instance:onInvite', player, instance, type, data)
end

RegisterServerEvent('::{razzway.xyz}::instance:create')
AddEventHandler('::{razzway.xyz}::instance:create', function(type, data)
	CreateInstance(type, source, data)
end)

RegisterServerEvent('::{razzway.xyz}::instance:close')
AddEventHandler('::{razzway.xyz}::instance:close', function()
	CloseInstance(source)
end)

RegisterServerEvent('::{razzway.xyz}::instance:enter')
AddEventHandler('::{razzway.xyz}::instance:enter', function(instance)
	AddPlayerToInstance(instance, source)
end)

RegisterServerEvent('::{razzway.xyz}::instance:leave')
AddEventHandler('::{razzway.xyz}::instance:leave', function(instance)
	RemovePlayerFromInstance(instance, source)
end)

RegisterServerEvent('::{razzway.xyz}::instance:invite')
AddEventHandler('::{razzway.xyz}::instance:invite', function(instance, type, player, data)
	InvitePlayerToInstance(instance, type, player, data)
end)