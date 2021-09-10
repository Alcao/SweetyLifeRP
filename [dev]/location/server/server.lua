ESX = nil

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('razzouloca:buy', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local priceAvailable = false
	price = 500

	if price == price then
		priceAvailable = true
	end

	if priceAvailable and xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez payez ~b~' .. price .. '$~s~, Bonne route à vous !')
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('razzouvoyage:givemoney', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local priceAvailable = false
	price = 10000

	if price == price then
		priceAvailable = true
	end

	if priceAvailable and xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez payez ~b~' .. price .. '$~s~, Bon voyage à vous !')
		cb(true)
	else
		cb(false)
	end
end)