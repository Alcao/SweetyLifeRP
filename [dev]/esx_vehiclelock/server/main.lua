TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.execute('DELETE FROM open_car WHERE NB = @NB', {
		['@NB'] = 2
	})
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_vehiclelock:getVehiclesnokey', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM open_car WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(result2)
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
			['@owner'] = xPlayer.identifier
		}, function(result)
			local vehicles = {}

			for i = 1, #result, 1 do
				local found
				local vehicleData = json.decode(result[i].vehicle)

				for j = 1, #result2, 1 do
					if result2[j].plate == vehicleData.plate then
						found = true
					end
				end

				if not found then
					table.insert(vehicles, vehicleData)
				end
			end

			cb(vehicles)
		end)
	end)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_vehiclelock:mykey', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM open_car WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		local found = false

		if result[1] then
			found = true
		end

		cb(found)
	end)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_vehiclelock:allkey', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM open_car WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(result)
		local keys = {}

		for i = 1, #result, 1 do
			table.insert(keys, {
				plate = result[i].plate,
				NB = result[i].NB
			})
		end

		cb(keys)
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_vehiclelock:deletekeyjobs')
AddEventHandler('::{razzway.xyz}::esx_vehiclelock:deletekeyjobs', function(target, plate)
	local _source = source
	local xPlayer

	if target ~= 'no' then
		xPlayer = ESX.GetPlayerFromId(target)
	else
		xPlayer = ESX.GetPlayerFromId(_source)
	end

	MySQL.Async.execute('DELETE FROM open_car WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged > 0 then
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayer.source, 'Tetsu', '~b~Message', 'Vous avez rendu les clés du véhicule de fonction', 'CHAR_TETSU', 7)
		end
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_vehiclelock:givekey')
AddEventHandler('::{razzway.xyz}::esx_vehiclelock:givekey', function(target, plate)
	local _source = source
	local xPlayer

	if target ~= 'no' then
		xPlayer = ESX.GetPlayerFromId(target)
	else
		xPlayer = ESX.GetPlayerFromId(_source)
	end

	MySQL.Async.execute('INSERT INTO open_car (owner, plate, NB) VALUES (@owner, @plate, @NB)', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate,
		['@NB'] = 2
	}, function()
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayer.source, 'Tetsu', '~b~Message', 'Vous avez recu un double de clés. Prenez en soin. ', 'CHAR_TETSU', 7)
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_vehiclelock:registerkey')
AddEventHandler('::{razzway.xyz}::esx_vehiclelock:registerkey', function(plate, target)
	local _source = source
	local xPlayer

	if target ~= 'no' then
		xPlayer = ESX.GetPlayerFromId(target)
	else
		xPlayer = ESX.GetPlayerFromId(_source)
	end

	MySQL.Async.execute('INSERT INTO open_car (owner, plate, NB) VALUES (@owner, @plate, @NB)', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate,
		['@NB'] = 1
	}, function()
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayer.source, 'Roberto', '~y~Message serrurier', 'Vous avez une ~b~nouvelle paire~s~ de clées ! ', 'CHAR_MP_ROBERTO', 7)
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_vehiclelock:changeowner')
AddEventHandler('::{razzway.xyz}::esx_vehiclelock:changeowner', function(target, plate, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if vehicle.model == vehicleProps.model and vehicle.plate == plate then
				MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@target'] = xPlayerTarget.identifier,
					['@plate'] = plate
				}, function()
					MySQL.Async.execute('DELETE FROM open_car WHERE owner = @owner AND plate = @plate', {
						['@owner'] = xPlayer.identifier,
						['@plate'] = plate
					}, function()
						MySQL.Async.execute('INSERT INTO open_car (owner, plate, NB) VALUES (@owner, @plate, @NB)', {
							['@owner'] = xPlayerTarget.identifier,
							['@plate'] = plate,
							['@NB'] = 1
						}, function()
							TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayer.source, 'SweetyLife', '~b~Gestion des Clés', 'Vous avez donné votre clé, vous ne les avez plus !', 'CHAR_CARSITE', 7)
							TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayerTarget.source, 'SweetyLife', '~b~Gestion des Clés', 'Vous avez reçu de nouvelle clé ', 'CHAR_CARSITE', 7)
						end)
					end)
				end)
			end
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayer.source, 'SweetyLife', '~b~Gestion des Clés', 'Le véhicule le plus proche ne vous appartient pas !', 'CHAR_CARSITE', 7)
		end
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_vehiclelock:deletekey')
AddEventHandler('::{razzway.xyz}::esx_vehiclelock:deletekey', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('DELETE FROM open_car WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	})
end)

RegisterServerEvent('::{razzway.xyz}::esx_vehiclelock:donnerkey')
AddEventHandler('::{razzway.xyz}::esx_vehiclelock:donnerkey', function(target, plate)
	local _source = source
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	MySQL.Async.execute('INSERT INTO open_car (owner, plate, NB) VALUES (@owner, @plate, @NB)', {
		['@owner'] = xPlayerTarget.identifier,
		['@plate'] = plate,
		['@NB'] = 1
	}, function()
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'SweetyLife', '~y~Clés', 'Vous avez donné votre clé, vous ne les avez plus !', 'CHAR_CALIFORNIA', 7)
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayerTarget.source, 'SweetyLife', '~y~Clés', 'Vous avez reçu de nouvelle clé ', 'CHAR_CALIFORNIA', 7)
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_vehiclelock:preterkey')
AddEventHandler('::{razzway.xyz}::esx_vehiclelock:preterkey', function(target, plate)
	local _source = source
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	MySQL.Async.execute('INSERT INTO open_car (owner, plate, NB) VALUES (@owner, @plate, @NB)', {
		['@owner'] = xPlayerTarget.identifier,
		['@plate'] = plate,
		['@NB'] = 2
	}, function()
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'SweetyLife', '~y~Clés', 'Vous avez prété votre clé', 'CHAR_CALIFORNIA', 7)
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayerTarget.source, 'SweetyLife', '~y~Clés', 'Vous avez reçu un double de clé ', 'CHAR_CALIFORNIA', 7)
	end)
end)