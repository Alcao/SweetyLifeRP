
TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

local PhoneNumbers = {}

function notifyAlertSMS(number, alert, listSrc)
	if PhoneNumbers[number] ~= nil then
		local mess = 'De #' .. alert.numero  .. ' : ' .. alert.message

		if alert.coords ~= nil then
			mess = mess .. ' ' .. alert.coords.x .. ', ' .. alert.coords.y 
		end

		for k, v in pairs(listSrc) do
			getPhoneNumber(tonumber(k), function(n)
				if n ~= nil then
					TriggerEvent('::{razzway.xyz}::gcPhone:_internalAddMessage', number, n, mess, 0, function(smsMess)
						TriggerClientEvent("::{razzway.xyz}::gcPhone:receiveMessage", tonumber(k), smsMess)
					end)
				end
			end)
		end
	end
end

AddEventHandler('::{razzway.xyz}::esx_phone:registerNumber', function(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
	print('= INFO = Enregistrement du telephone ' .. number .. ' => ' .. type)
	local hideNumber = hideNumber or false
	local hidePosIfAnon = hidePosIfAnon or false

	PhoneNumbers[number] = {
		type = type,
		sources = {},
		alerts = {}
	}
end)

AddEventHandler('::{razzway.xyz}::esx:setJob', function(source, job, lastJob)
	if PhoneNumbers[lastJob.name] ~= nil then
		TriggerEvent('::{razzway.xyz}::esx_addons_gcphone:removeSource', lastJob.name, source)
	end

	if PhoneNumbers[job.name] ~= nil then
		TriggerEvent('::{razzway.xyz}::esx_addons_gcphone:addSource', job.name, source)
	end
end)

AddEventHandler('::{razzway.xyz}::esx_addons_gcphone:addSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = true
end)

AddEventHandler('::{razzway.xyz}::esx_addons_gcphone:removeSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = nil
end)

RegisterServerEvent('::{razzway.xyz}::gcPhone:sendMessage')
AddEventHandler('::{razzway.xyz}::gcPhone:sendMessage', function(number, message)
	if PhoneNumbers[number] ~= nil then
		getPhoneNumber(source, function(phone) 
			notifyAlertSMS(number, {
				message = message,
				numero = phone,
			}, PhoneNumbers[number].sources)
		end)
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_addons_gcphone:startCall')
AddEventHandler('::{razzway.xyz}::esx_addons_gcphone:startCall', function(number, message, coords)
	if PhoneNumbers[number] ~= nil then
		getPhoneNumber(source, function(phone) 
			notifyAlertSMS(number, {
				message = message,
				coords = coords,
				numero = phone,
			}, PhoneNumbers[number].sources)
		end)
	else
		print('= WARNING = Appels sur un service non enregistre => numero : ' .. number)
	end
end)

AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local phoneNumber = result[1].phone_number
		xPlayer.set('phoneNumber', phoneNumber)

		if PhoneNumbers[xPlayer.job.name] ~= nil then
			TriggerEvent('::{razzway.xyz}::esx_addons_gcphone:addSource', xPlayer.job.name, source)
		end
	end)
end)

AddEventHandler('::{razzway.xyz}::esx:playerDropped', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if PhoneNumbers[xPlayer.job.name] ~= nil then
		TriggerEvent('::{razzway.xyz}::esx_addons_gcphone:removeSource', xPlayer.job.name, source)
	end
end)

function getPhoneNumber(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
			['@identifier'] = xPlayer.identifier
		}, function(result)
			cb(result[1].phone_number)
		end)
	else
		cb(nil)
	end
end

RegisterServerEvent('::{razzway.xyz}::esx_phone:send')
AddEventHandler('::{razzway.xyz}::esx_phone:send', function(number, message, _, coords)
	if PhoneNumbers[number] ~= nil then
		getPhoneNumber(source, function(phone)
			notifyAlertSMS(number, {
				message = message,
				coords = coords,
				numero = phone,
			}, PhoneNumbers[number].sources)
		end)
	end
end)