local rob = false
local robbers = {}

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('::{razzway.xyz}::esx_holdupbank:toofar')
AddEventHandler('::{razzway.xyz}::esx_holdupbank:toofar', function(robb)
	local source = source
	TriggerEvent("ratelimit", source, "::{razzway.xyz}::esx_holdupbank:toofar")

	local xPlayers = ESX.GetPlayers()
	rob = false

	for i = 1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

 		if xPlayer and xPlayer.job.name == 'police' then
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Banks[robb].nameofbank)
			TriggerClientEvent('::{razzway.xyz}::esx_holdupbank:killblip', xPlayers[i])
		end
	end

	if (robbers[source]) then
		TriggerClientEvent('::{razzway.xyz}::esx_holdupbank:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('robbery_has_cancelled') .. Banks[robb].nameofbank)
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_holdupbank:rob')
AddEventHandler('::{razzway.xyz}::esx_holdupbank:rob', function(robb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	
	if Banks[robb] then
		if (os.time() - Banks[robb].lastrobbed) < 600 and Banks[robb].lastrobbed ~= 0 then
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, _U('already_robbed') .. (1800 - (os.time() - Banks[robb].lastrobbed)) .. _U('seconds'))
			return
		end

		local cops = 0

		for i = 1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer and xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= ConfigBraco.NumberOfCopsRequired then
				rob = true

				for i = 1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer and xPlayer.job.name == 'police' then
						TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayers[i], _U('rob_in_prog') .. Banks[robb].nameofbank)
						TriggerClientEvent('::{razzway.xyz}::esx_holdupbank:setblip', xPlayers[i], Banks[robb].position)
					end
				end

				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, _U('started_to_rob') .. Banks[robb].nameofbank .. _U('do_not_move'))
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, _U('alarm_triggered'))
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, _U('hold_pos'))
				TriggerClientEvent('::{razzway.xyz}::esx_holdupbank:currentlyrobbing', _source, robb)
				Banks[robb].lastrobbed = os.time()
				robbers[_source] = robb

				SetTimeout(300000, function()
					if robbers[_source] then
						rob = false
						TriggerClientEvent('::{razzway.xyz}::esx_holdupbank:robberycomplete', _source, job)

						if xPlayer then
							xPlayer.addAccountMoney('dirtycash', Banks[robb].reward)
							local xPlayers = ESX.GetPlayers()

							for i = 1, #xPlayers, 1 do
								local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

								if xPlayer and xPlayer.job.name == 'police' then
									TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayers[i], _U('robbery_complete_at') .. Banks[robb].nameofbank)
									TriggerClientEvent('::{razzway.xyz}::esx_holdupbank:killblip', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, _U('min_two_police') .. ConfigBraco.NumberOfCopsRequired .. _U('min_two_police2'))
			end
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, _U('robbery_already'))
		end
	end
end)

--Bijouterie
PlayersCrafting    = {}
local CopsConnected  = 0

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

RegisterServerEvent('::{razzway.xyz}::esx_vangelico_robbery:toofar')
AddEventHandler('::{razzway.xyz}::esx_vangelico_robbery:toofar', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Stores[robb].nameofstore)
			TriggerClientEvent('::{razzway.xyz}::esx_vangelico_robbery:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('::{razzway.xyz}::esx_vangelico_robbery:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('robbery_has_cancelled') .. Stores[robb].nameofstore)
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_vangelico_robbery:endrob')
AddEventHandler('::{razzway.xyz}::esx_vangelico_robbery:endrob', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayers[i], _U('end'))
			TriggerClientEvent('::{razzway.xyz}::esx_vangelico_robbery:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('::{razzway.xyz}::esx_vangelico_robbery:robberycomplete', source)
		robbers[source] = nil
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('robbery_has_ended') .. Stores[robb].nameofstore)
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_vangelico_robbery:rob')
AddEventHandler('::{razzway.xyz}::esx_vangelico_robbery:rob', function(robb)

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < ConfigBraco.SecBetwNextRob and store.lastrobbed ~= 0 then

            TriggerClientEvent('::{razzway.xyz}::esx_vangelico_robbery:togliblip', source)
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('already_robbed2') .. (ConfigBraco.SecBetwNextRob - (os.time() - store.lastrobbed)) .. _U('seconds'))
			return
		end

		if rob == false then

			rob = true
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				if xPlayer.job.name == 'police' then
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayers[i], _U('rob_in_prog2') .. store.nameofstore)
					TriggerClientEvent('::{razzway.xyz}::esx_vangelico_robbery:setblip', xPlayers[i], Stores[robb].position)
				end
			end

			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('started_to_rob') .. store.nameofstore .. _U('do_not_move2'))
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('alarm_triggered'))
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('hold_pos2'))
			TriggerClientEvent('::{razzway.xyz}::esx_vangelico_robbery:currentlyrobbing', source, robb)
            CancelEvent()
			Stores[robb].lastrobbed = os.time()
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('robbery_already'))
		end
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_vangelico_robbery:gioielli')
AddEventHandler('::{razzway.xyz}::esx_vangelico_robbery:gioielli', function()

	local xPlayer = ESX.GetPlayerFromId(source)
	local coords = GetEntityCoords(GetPlayerPed(source))
	RobBijoux = vector3(-629.99, -236.542, 38.05)
	ZoneSize = 250
	if rob == true then
		if #(coords - RobBijoux) < ZoneSize / 2 then
			xPlayer.addInventoryItem('jewels', math.random(ConfigBraco.MinJewels, ConfigBraco.MaxJewels))
		else
			TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "Moi aussi jveux des diamants :p")
		end
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "Moi aussi jveux des diamants :p")
	end
end)

RegisterServerEvent('::{razzway.xyz}::lester:vendita')
AddEventHandler('::{razzway.xyz}::lester:vendita', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local reward = math.floor(ConfigBraco.PriceForOneJewel * ConfigBraco.MaxJewelsSell)
	SellBijoux = vector3(706.669, -966.898, 30.413)
	ZoneSize2 = 30

	if #(coords - SellBijoux) < ZoneSize2 / 2 then
		xPlayer.removeInventoryItem('jewels', ConfigBraco.MaxJewelsSell)
		xPlayer.addAccountMoney('cash', reward)
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "Moi aussi jveux des diamants :p")
	end
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_vangelico_robbery:conteggio', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(CopsConnected)
end)
