ESX = nil

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('::{razzway.xyz}::garage:listevoiturefourriere', function(source, cb)
	local ownedCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type', {
		['@owner'] = ESX.GetIdentifierFromId(source),
		['@type'] = 'car',
	}, function(data)
		for k, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, state = v.state, plate = v.plate})
		end

		cb(ownedCars)
	end)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::garage::listevoiture', function(source, cb)
	local ownedCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type', {
		['@owner'] = ESX.GetIdentifierFromId(source),
		['@type'] = 'car'
	}, function(data)
		for k, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, state = v.state, plate = v.plate})
		end

		cb(ownedCars)
	end)
end)

--état sortie véhicule
ESX.RegisterServerCallback('::{razzway.xyz}::garage::etatvehiculesortie', function(source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match('^%s*(.-)%s*$')
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)

			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
					['@owner'] = ESX.GetIdentifierFromId(source),
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate
				}, function(rowsChanged)
					if rowsChanged == 0 then
						print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(ESX.GetIdentifierFromId(source)))
					end

					cb(true)
				end)
			else
				print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(ESX.GetIdentifierFromId(source)))
				DropPlayer(source, _U('custom_kick'))
				cb(false)
			end
		else
			print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(ESX.GetIdentifierFromId(source)))
			cb(false)
		end
	end)
end)
-- test
RegisterServerEvent('::{razzway.xyz}::sweety_garage:modifystateRanger')
AddEventHandler('::{razzway.xyz}::sweety_garage:modifystateRanger', function(vehicle, state)
	--local _source = source
	--local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(ESX.GetIdentifierFromId(source))
	local state = state
	local plate = vehicle.plate
	print('UPDATING STATE...')
	if plate ~= nil then
		print('plate')
		plate = plate:gsub("^%s*(.-)%s*$", "%1")
		print(plate)
	else
		print('vehicle')
		print(vehicle)
	end
	for _,v in pairs(vehicules) do
		if v.plate == plate then
			MySQL.Sync.execute("UPDATE owned_vehicles SET state =@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
			print('STATE UPDATED...')
			break
		end
	end
end)

ESX.RegisterServerCallback('::{razzway.xyz}::sweety_garage:getVehicles', function(source, cb)
	--local _source = source
	--local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE type='car' AND  owner = @owner",{['@owner'] = ESX.GetIdentifierFromId(source)}, function(data)
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, {vehicle = vehicle, state = v.state, plate = v.plate})
		end
		cb(vehicules)
	end)
end)

RegisterServerEvent('::{razzway.xyz}::sweety_garage:modifystate')
AddEventHandler('::{razzway.xyz}::sweety_garage:modifystate', function(vehicle, state)
	local _source = source
	--local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(ESX.GetIdentifierFromId(source))
	local state = state
	local plate = vehicle.plate
	print('UPDATING STATE...')
	if plate ~= nil then
		print('plate')
		plate = plate:gsub("^%s*(.-)%s*$", "%1")
		print(plate)
	else
		print('vehicle')
		print(vehicle)
	end
	for _,v in pairs(vehicules) do
		if v.plate == plate then
			MySQL.Sync.execute("UPDATE owned_vehicles SET state =@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
			print('STATE UPDATED...')
			break
		end
	end
end)

ESX.RegisterServerCallback('::{razzway.xyz}::sweety_garage:getOutVehicles',function(source, cb)	
	--local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND state=false",{['@identifier'] = ESX.GetIdentifierFromId(source)}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, {vehicle = vehicle, plate = v.plate})
		end
		cb(vehicules)
	end)
end)

function getPlayerVehicles(identifier)
	
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})	
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		table.insert(vehicles, {id = v.id, plate = v.plate})
	end
	return vehicles
end
--ranger véhicule
ESX.RegisterServerCallback('::{razzway.xyz}::garage::rangervoiture', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			--if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('::{razzway.xyz}::garage: : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
					end
					cb(true)
				end)
			--else
				--print(('::{razzway.xyz}::garage:: %s Tentative de chat! Tente de ranger: ' .. vehiclemodel .. '. Voiture d\'origine: '.. originalvehprops.model):format(xPlayer.identifier))
				--cb(false)
			--end
		else
			print(('::{razzway.xyz}::garage: : tente de ranger un véhicule non à lui '):format(xPlayer.identifier))
			cb(false)
		end
	end)
end)

--verif si joueur a les sous pour fourriere
ESX.RegisterServerCallback('::{razzway.xyz}::garage::verifsous', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getAccount('cash').money >= garagepublic.sousfourriere then
		cb(true)
	else
		cb(false)
	end
end)

--fait payer joueur pour fourriere
RegisterServerEvent('::{razzway.xyz}::garage::payechacal')
AddEventHandler('::{razzway.xyz}::garage::payechacal', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('cash', garagepublic.sousfourriere)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Tu as payé $" .. garagepublic.sousfourriere)
end)