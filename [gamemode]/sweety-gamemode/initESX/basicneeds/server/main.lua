ESX = nil

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 200000) 
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_bread'))
end)

ESX.RegisterUsableItem('coffe', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('coffe', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:oncoffee', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_coffe')) 
end)

ESX.RegisterUsableItem('bolnoixcajou', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bolnoixcajou', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 300000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:oncoffee', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_bolnoixcajou')) 
end)

ESX.RegisterUsableItem('bolpistache', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bolpistache', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:oncoffee', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_bolpistache')) 
end)

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_water'))
end)

ESX.RegisterUsableItem('chocolat', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chocolat', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 150000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onchocolat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_chocolate'))
end)

ESX.RegisterUsableItem('applepie', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('applepie', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_applepie'))
end)

ESX.RegisterUsableItem('bolchips', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bolchips', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 300000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_bolchips'))
end)

ESX.RegisterUsableItem('bolcacahuetes', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bolcacahuetes', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 350000)-- 
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_bolcacahuetes'))
end)

ESX.RegisterUsableItem('banana', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('banana', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_banana'))
end)

ESX.RegisterUsableItem('beef', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('beef', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_beef'))
end)

ESX.RegisterUsableItem('hamburger', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hamburger', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_hamburger'))
end)

ESX.RegisterUsableItem('cupcake', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cupcake', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_cupcake'))
end)

ESX.RegisterUsableItem('donut', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('donut', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:ondonut', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_donut'))
end)

ESX.RegisterUsableItem('soda', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('soda', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onsoda', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_soda'))
end)

ESX.RegisterUsableItem('caprisun', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('caprisun', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onsoda', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_caprisun'))
end)

ESX.RegisterUsableItem('jusfruit', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('jusfruit', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 290000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_jusfruit'))
end)


ESX.RegisterUsableItem('mixapero', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('mixapero', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_mixapero'))
end)

ESX.RegisterUsableItem('mojito', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('mojito', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 340000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_mojito'))
end)


ESX.RegisterUsableItem('limonade', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('limonade', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 290000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_limonade'))
end)

ESX.RegisterUsableItem('cocacola', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cocacola', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 290000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_cocacola'))
end)

ESX.RegisterUsableItem('cola', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cola', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 290000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_cola'))
 
end)

ESX.RegisterUsableItem('raisin', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('raisin', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 290000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_raisin'))

end)


ESX.RegisterUsableItem('loka', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('loka', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_loka'))

end)

ESX.RegisterUsableItem('pizza', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pizza', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_pizza'))

end)

ESX.RegisterUsableItem('ice', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('ice', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_ice'))

end)

ESX.RegisterUsableItem('icetea', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('icetea', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_icetea'))

end)


ESX.RegisterUsableItem('fish', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('fish', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_fish'))

end)

ESX.RegisterUsableItem('energy', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('energy', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onDrink', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_energy'))

end)

ESX.RegisterUsableItem('chips', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chips', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onEat', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_chips'))

end)

ESX.RegisterUsableItem('sandwich', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sandwich', 1)

	TriggerClientEvent('::{razzway.xyz}::esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:onsandwich', source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('used_sandwich'))

end)

TriggerEvent('es:addGroupCommand', 'heal', 'superadmin', function(source, args, user)
	-- heal another player - don't heal source
	if args[1] then
		local playerId = tonumber(args[1])

		-- is the argument a number?
		if playerId then
			-- is the number a valid player?
			if GetPlayerName(playerId) then
				print(('::{razzway.xyz}::esx_basicneeds: %s healed %s'):format(GetPlayerIdentifier(source, 0), GetPlayerIdentifier(playerId, 0)))
				TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:healPlayer', playerId)
				TriggerClientEvent('::{razzway.xyz}::chat:addMessage', source, { args = { '^5HEAL', 'You have been healed.' } })
			else
				TriggerClientEvent('::{razzway.xyz}::chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
			end
		else
			TriggerClientEvent('::{razzway.xyz}::chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player id.' } })
		end
	else
		print(('::{razzway.xyz}::esx_basicneeds: %s healed self'):format(GetPlayerIdentifier(source, 0)))
		TriggerClientEvent('::{razzway.xyz}::esx_basicneeds:healPlayer', source)
	end
end, function(source, args, user)
	TriggerClientEvent('::{razzway.xyz}::chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', params = {{name = 'playerId', help = '(optional) player id'}}})