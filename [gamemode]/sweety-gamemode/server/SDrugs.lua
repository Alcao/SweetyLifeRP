local CopsConnected = 0
local PlayersHarvestingCoke, PlayersTransformingCoke, PlayersSellingCoke = {}, {}, {}
local PlayersHarvestingMeth, PlayersTransformingMeth, PlayersSellingMeth = {}, {}, {}
local PlayersHarvestingWeed, PlayersTransformingWeed, PlayersSellingWeed = {}, {}, {}
local PlayersHarvestingOpium, PlayersTransformingOpium, PlayersSellingOpium = {}, {}, {}
local PlayersHarvestingBillet, PlayersTransformingBillet, PlayersSellingBillet = {}, {}, {}
local isInMarker = false

zoneSizeProtection = 20.0

someRandomGayData = exports['Sw-Framework']:GetData('drugs')

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('::{korioz#0110}::dumpIsForGayDude', function(source, cb)
	cb(someRandomGayData)
end)

AddEventHandler('playerDroppedDrugs', function()
	PlayersHarvestingCoke[source], PlayersTransformingCoke[source], PlayersSellingCoke[source] = nil, nil, nil
	PlayersHarvestingMeth[source], PlayersTransformingMeth[source], PlayersSellingMeth[source] = nil, nil, nil
	PlayersHarvestingWeed[source], PlayersTransformingWeed[source], PlayersSellingWeed[source] = nil, nil, nil
	PlayersHarvestingOpium[source], PlayersTransformingOpium[source], PlayersSellingOpium[source] = nil, nil, nil
	PlayersHarvestingBillet[source], PlayersTransformingBillet[source], PlayersSellingBillet[source] = nil, nil, nil
end)

function CountCops()
	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i = 1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer and xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

local function HarvestWeed(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsWeed then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsWeed))
		return
	end

	SetTimeout(cfg_drugs.TimeToFarm, function()
		if PlayersHarvestingWeed[xPlayer.source] then
			if xPlayer.canCarryItem('weed', 1) then
				xPlayer.addInventoryItem('weed', 1)
				HarvestWeed(xPlayer)
				sendToDiscord('Cardinal', '[RECOLTE] ' ..xPlayer.getName().. ' vient de récolter x1 weed', 2061822)
			else
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('inv_full_weed'))
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startHarvestWeed')
AddEventHandler('moulamoula:esx_drugs:startHarvestWeed', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	harvestWeed = vector3(1056.49, -3190.65, -39.12)

	if #(coords - harvestWeed) < zoneSizeProtection / 2 then
		PlayersHarvestingWeed[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('pickup_in_prog'))
		HarvestWeed(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopHarvestWeed')
AddEventHandler('moulamoula:esx_drugs:stopHarvestWeed', function()
	PlayersHarvestingWeed[source] = nil
end)

local function TransformWeed(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsWeed then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsWeed))
		return
	end

	SetTimeout(cfg_drugs.TimeToProcess, function()
		if PlayersTransformingWeed[xPlayer.source] then
			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('too_many_pouches'))
			elseif weedQuantity < 5 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('not_enough_weed'))
			else
				xPlayer.removeInventoryItem('weed', 5)
				xPlayer.addInventoryItem('weed_pooch', 1)
				sendToDiscord('Cardinal', '[TRAITEMENT] ' ..xPlayer.getName().. ' vient de traiter x5 weed et à récupérer x1 pochons', 2061822)

				TransformWeed(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startTransformWeed')
AddEventHandler('moulamoula:esx_drugs:startTransformWeed', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	transformWeed = vector3(1040.24, -3204.54, -38.16)

	if #(coords - transformWeed) < zoneSizeProtection / 2 then
		PlayersTransformingWeed[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('packing_in_prog'))
		TransformWeed(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopTransformWeed')
AddEventHandler('moulamoula:esx_drugs:stopTransformWeed', function()
	PlayersTransformingWeed[source] = nil
end)

local function SellWeed(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsWeed then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsWeed))
		return
	end

	SetTimeout(cfg_drugs.TimeToSell, function()
		if PlayersSellingWeed[xPlayer.source] then
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('weed_pooch', 1)

				if CopsConnected == 0 then
					xPlayer.addAccountMoney('dirtycash', 800)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_weed'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('dirtycash', 825)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_weed'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('dirtycash', 850)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_weed'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('dirtycash', 900)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_weed'))
				elseif CopsConnected >= 4 then
					xPlayer.addAccountMoney('dirtycash', 1000)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_weed'))
				end
                
				sendToDiscord('Cardinal', '[VENTE] ' ..xPlayer.getName().. ' vient de vendre x1 pochon de weed (250$)', 2061822)
				SellWeed(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startSellWeed')
AddEventHandler('moulamoula:esx_drugs:startSellWeed', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	sellWeed = vector3(187.14, 6377.54, 32.34)

	if #(coords - sellWeed) < zoneSizeProtection / 2 then
		PlayersSellingWeed[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('sale_in_prog'))
		SellWeed(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopSellWeed')
AddEventHandler('moulamoula:esx_drugs:stopSellWeed', function()
	PlayersSellingWeed[source] = nil
end)

local function HarvestCoke(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsCoke then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsCoke))
		return
	end

	SetTimeout(cfg_drugs.TimeToFarm, function()
		if PlayersHarvestingCoke[xPlayer.source] then
			if xPlayer.canCarryItem('coke', 1) then
				xPlayer.addInventoryItem('coke', 1)
				sendToDiscord('Cardinal', '[RECOLTE] ' ..xPlayer.getName().. ' vient de récolter x1 coke', 2061822)
				HarvestCoke(xPlayer)
			else
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('inv_full_coke'))
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startHarvestCoke')
AddEventHandler('moulamoula:esx_drugs:startHarvestCoke', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	harvestCoke = vector3(1014.47, -2892.66, 15.22)

	if #(coords - harvestCoke) < zoneSizeProtection / 2 then
		PlayersHarvestingCoke[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('pickup_in_prog'))
		HarvestCoke(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopHarvestCoke')
AddEventHandler('moulamoula:esx_drugs:stopHarvestCoke', function()
	PlayersHarvestingCoke[source] = nil
end)

local function TransformCoke(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsCoke then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsCoke))
		return
	end

	SetTimeout(cfg_drugs.TimeToProcess, function()
		if PlayersTransformingCoke[xPlayer.source] then
			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('too_many_pouches'))
			elseif cokeQuantity < 5 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('not_enough_coke'))
			else
				xPlayer.removeInventoryItem('coke', 5)
				xPlayer.addInventoryItem('coke_pooch', 1)
				sendToDiscord('Cardinal', '[TRAITEMENT] ' ..xPlayer.getName().. ' vient de traiter x5 coke et à récupérer x1 pochons', 2061822)

				TransformCoke(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startTransformCoke')
AddEventHandler('moulamoula:esx_drugs:startTransformCoke', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	transformCoke = vector3(1763.95, -1645.87, 112.63)

	if #(coords - transformCoke) < zoneSizeProtection / 2 then
		PlayersTransformingCoke[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('packing_in_prog'))
		TransformCoke(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopTransformCoke')
AddEventHandler('moulamoula:esx_drugs:stopTransformCoke', function()
	PlayersTransformingCoke[source] = nil
end)

local function SellCoke(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsCoke then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsCoke))
		return
	end

	SetTimeout(cfg_drugs.TimeToSell, function()
		if PlayersSellingCoke[xPlayer.source] then
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('no_pouches_sale_coke'))
			else
				xPlayer.removeInventoryItem('coke_pooch', 1)

				if CopsConnected == 0 then
					xPlayer.addAccountMoney('dirtycash', 900)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_coke'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('dirtycash', 925)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_coke'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('dirtycash', 950)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_coke'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('dirtycash', 1000)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_coke'))
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('dirtycash', 1100)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_coke'))
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('dirtycash', 1200)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_coke'))
				end

				sendToDiscord('Cardinal', '[VENTE] ' ..xPlayer.getName().. ' vient de vendre x1 pochon de coke (400$)', 2061822)
				SellCoke(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startSellCoke')
AddEventHandler('moulamoula:esx_drugs:startSellCoke', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	sellCoke = vector3(989.45, -1665.27, 37.14)

	if #(coords - sellCoke) < zoneSizeProtection / 2 then
		PlayersSellingCoke[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('sale_in_prog'))
		SellCoke(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopSellCoke')
AddEventHandler('moulamoula:esx_drugs:stopSellCoke', function()
	PlayersSellingCoke[source] = nil
end)

local function HarvestMeth(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsMeth then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsMeth))
		return
	end

	SetTimeout(cfg_drugs.TimeToFarm, function()
		if PlayersHarvestingMeth[xPlayer.source] then
			if xPlayer.canCarryItem('meth', 1) then
				xPlayer.addInventoryItem('meth', 1)
				sendToDiscord('Cardinal', '[RECOLTE] ' ..xPlayer.getName().. ' vient de récolter x1 meth', 2061822)
				HarvestMeth(xPlayer)
			else
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('inv_full_meth'))
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startHarvestMeth')
AddEventHandler('moulamoula:esx_drugs:startHarvestMeth', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	harvestMeth = vector3(1391.94, 3606.08, 38.94)

	if #(coords - harvestMeth) < zoneSizeProtection / 2 then
		PlayersHarvestingMeth[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('pickup_in_prog'))
		HarvestMeth(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopHarvestMeth')
AddEventHandler('moulamoula:esx_drugs:stopHarvestMeth', function()
	PlayersHarvestingMeth[source] = nil
end)

local function TransformMeth(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsMeth then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsMeth))
		return
	end

	SetTimeout(cfg_drugs.TimeToProcess, function()
		if PlayersTransformingMeth[xPlayer.source] then
			local methQuantity = xPlayer.getInventoryItem('meth').count
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('too_many_pouches'))
			elseif methQuantity < 5 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('not_enough_meth'))
			else
				xPlayer.removeInventoryItem('meth', 5)
				xPlayer.addInventoryItem('meth_pooch', 1)
				sendToDiscord('Cardinal', '[TRAITEMENT] ' ..xPlayer.getName().. ' vient de traiter x5 meth et à récupérer x1 pochons', 2061822)

				TransformMeth(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startTransformMeth')
AddEventHandler('moulamoula:esx_drugs:startTransformMeth', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	transformMeth = vector3(-19.65, 3029.21, 41.65)

	if #(coords - transformMeth) < zoneSizeProtection / 2 then
		PlayersTransformingMeth[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('packing_in_prog'))
		TransformMeth(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopTransformMeth')
AddEventHandler('moulamoula:esx_drugs:stopTransformMeth', function()
	PlayersTransformingMeth[source] = nil
end)

local function SellMeth(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsMeth then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsMeth))
		return
	end

	SetTimeout(cfg_drugs.TimeToSell, function()
		if PlayersSellingMeth[xPlayer.source] then
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('meth_pooch', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('dirtycash', 900)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_meth'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('dirtycash', 925)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_meth'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('dirtycash', 950)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_meth'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('dirtycash', 1000)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_meth'))
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('dirtycash', 1100)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_meth'))
				elseif CopsConnected == 5 then
					xPlayer.addAccountMoney('dirtycash', 1200)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_meth'))
				elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('dirtycash', 1200)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_meth'))
				end

				sendToDiscord('Cardinal', '[VENTE] ' ..xPlayer.getName().. ' vient de vendre x1 pochon meth (450$)', 2061822)
				SellMeth(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startSellMeth')
AddEventHandler('moulamoula:esx_drugs:startSellMeth', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	sellMeth = vector3(-1146.71, 4940.5, 222.27)

	if #(coords - sellMeth) < zoneSizeProtection / 2 then
		PlayersSellingMeth[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('sale_in_prog'))
		SellMeth(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopSellMeth')
AddEventHandler('moulamoula:esx_drugs:stopSellMeth', function()
	PlayersSellingMeth[source] = nil
end)

local function HarvestOpium(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsOpium then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsOpium))
		return
	end

	SetTimeout(cfg_drugs.TimeToFarm, function()
		if PlayersHarvestingOpium[xPlayer.source] then
			if xPlayer.canCarryItem('opium', 1) then
				xPlayer.addInventoryItem('opium', 1)
				sendToDiscord('Cardinal', '[RECOLTE] ' ..xPlayer.getName().. ' vient de récolter x1 opium', 2061822)
				HarvestOpium(xPlayer)
			else
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('inv_full_opium'))
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startHarvestOpium')
AddEventHandler('moulamoula:esx_drugs:startHarvestOpium', function()

	local coords = GetEntityCoords(GetPlayerPed(source))
	harvestOpium = vector3(2435.69, 4966.89, 46.81)

	if #(coords - harvestOpium) < zoneSizeProtection / 2 then
		PlayersHarvestingOpium[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('pickup_in_prog'))
		HarvestOpium(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end

end)

RegisterServerEvent('moulamoula:esx_drugs:stopHarvestOpium')
AddEventHandler('moulamoula:esx_drugs:stopHarvestOpium', function()
	PlayersHarvestingOpium[source] = nil
end)

local function TransformOpium(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsOpium then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsOpium))
		return
	end

	SetTimeout(cfg_drugs.TimeToProcess, function()
		if PlayersTransformingOpium[xPlayer.source] then
			local opiumQuantity = xPlayer.getInventoryItem('opium').count
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity > 35 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('too_many_pouches'))
			elseif opiumQuantity < 5 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('not_enough_opium'))
			else
				xPlayer.removeInventoryItem('opium', 5)
				xPlayer.addInventoryItem('opium_pooch', 1)
				sendToDiscord('Cardinal', '[TRAITEMENT] ' ..xPlayer.getName().. ' vient de traiter x5 opium et à récupérer x1 pochons', 2061822)

				TransformOpium(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startTransformOpium')
AddEventHandler('moulamoula:esx_drugs:startTransformOpium', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	transformOpium = vector3(2440.53, 4976.95, 46.81)

	if #(coords - transformOpium) < zoneSizeProtection / 2 then
		PlayersTransformingOpium[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('packing_in_prog'))
		TransformOpium(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopTransformOpium')
AddEventHandler('moulamoula:esx_drugs:stopTransformOpium', function()
	PlayersTransformingOpium[source] = nil
end)

local function SellOpium(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsOpium then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsOpium))
		return
	end

	SetTimeout(cfg_drugs.TimeToSell, function()
		if PlayersSellingOpium[xPlayer.source] then
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('no_pouches_sale'))
			else
				xPlayer.removeInventoryItem('opium_pooch', 1)

				if CopsConnected == 0 then
					xPlayer.addAccountMoney('dirtycash', 1000)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_opium'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('dirtycash', 1100)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_opium'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('dirtycash', 1200)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_opium'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('dirtycash', 1300)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_opium'))
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('dirtycash', 1400)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_opium'))
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('dirtycash', 1500)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_opium'))
				end

				sendToDiscord('Cardinal', '[VENTE] ' ..xPlayer.getName().. ' vient de vendre x1 pochon opium (500$)', 2061822)
				SellOpium(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startSellOpium')
AddEventHandler('moulamoula:esx_drugs:startSellOpium', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	sellOpium = vector3(3301.4, 5186.79, 18.45)

	if #(coords - sellOpium) < zoneSizeProtection / 2 then
		PlayersSellingOpium[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('sale_in_prog'))
		SellOpium(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end	
end)

RegisterServerEvent('moulamoula:esx_drugs:stopSellOpium')
AddEventHandler('moulamoula:esx_drugs:stopSellOpium', function()
	PlayersSellingOpium[source] = nil
end)

local function HarvestBillet(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsBillet then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsBillet))
		return
	end

	SetTimeout(cfg_drugs.TimeToFarm, function()
		if PlayersHarvestingBillet[xPlayer.source] then
			if xPlayer.canCarryItem('paper', 1) then
				xPlayer.addInventoryItem('paper', 1)
				sendToDiscord('Cardinal', '[RECOLTE] ' ..xPlayer.getName().. ' vient de récolter x1 papier', 2061822)
				HarvestBillet(xPlayer)
			else
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('inv_full_billet'))
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startHarvestBillet')
AddEventHandler('moulamoula:esx_drugs:startHarvestBillet', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	harvestBillet = vector3(152.42, -3210.08, 5.89)

	if #(coords - harvestBillet) < zoneSizeProtection / 2 then
		PlayersHarvestingBillet[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('pickup_in_prog'))
		HarvestBillet(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopHarvestBillet')
AddEventHandler('moulamoula:esx_drugs:stopHarvestBillet', function()
	PlayersHarvestingBillet[source] = nil
end)

local function TransformBillet(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsBillet then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsBillet))
		return
	end

	SetTimeout(cfg_drugs.TimeToProcess, function()
		if PlayersTransformingBillet[xPlayer.source] then
			local BilletQuantity = xPlayer.getInventoryItem('paper').count
			local poochQuantity = xPlayer.getInventoryItem('redmonney').count

			if poochQuantity > 35 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('too_many_billet'))
			elseif BilletQuantity < 5 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('not_enough_billet'))
			else
				xPlayer.removeInventoryItem('paper', 5)
				xPlayer.addInventoryItem('redmonney', 1)
				sendToDiscord('Cardinal', '[TRAITEMENT] ' ..xPlayer.getName().. ' vient de traiter x5 papier et à récupérer x1 faux billet', 2061822)

				TransformBillet(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startTransformBillet')
AddEventHandler('moulamoula:esx_drugs:startTransformBillet', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	transformBillet = vector3(1298.93, -1752.9, 53.88)

	if #(coords - transformBillet) < zoneSizeProtection / 2 then
		PlayersTransformingBillet[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('packing_in_prog'))
		TransformBillet(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopTransformBillet')
AddEventHandler('moulamoula:esx_drugs:stopTransformBillet', function()
	PlayersTransformingBillet[source] = nil
end)

local function SellBillet(xPlayer)
	if CopsConnected < cfg_drugs.RequiredCopsBillet then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('act_imp_police', CopsConnected, cfg_drugs.RequiredCopsBillet))
		return
	end

	SetTimeout(cfg_drugs.TimeToSell, function()
		if PlayersSellingBillet[xPlayer.source] then
			local poochQuantity = xPlayer.getInventoryItem('redmonney').count

			if poochQuantity == 0 then
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('no_billet_sale'))
			else
				xPlayer.removeInventoryItem('redmonney', 1)

				if CopsConnected == 0 then
					xPlayer.addAccountMoney('dirtycash', 1500)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_billet'))
				elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('dirtycash', 1700)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_billet'))
				elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('dirtycash', 1900)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_billet'))
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('dirtycash', 2100)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_billet'))
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('dirtycash', 2500)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_billet'))
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('dirtycash', 3000)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('sold_one_billet'))
				end

				sendToDiscord('Cardinal', '[VENTE] ' ..xPlayer.getName().. ' vient de vendre x1 faux billet (700$)', 2061822)
				SellBillet(xPlayer)
			end
		end
	end)
end

RegisterServerEvent('moulamoula:esx_drugs:startSellBillet')
AddEventHandler('moulamoula:esx_drugs:startSellBillet', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	sellBillet = vector3(297.38, -1776.22, 28.06)

	if #(coords - sellBillet) < zoneSizeProtection / 2 then
		PlayersSellingBillet[source] = true
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, _U('sale_in_prog'))
		SellBillet(ESX.GetPlayerFromId(source))
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "y'a dla moula :p")
	end
end)

RegisterServerEvent('moulamoula:esx_drugs:stopSellBillet')
AddEventHandler('moulamoula:esx_drugs:stopSellBillet', function()
	PlayersSellingBillet[source] = nil
end)

ESX.RegisterUsableItem('weed', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('moulamoula:esx_drugs:onPot', xPlayer.source)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('used_one_weed'))
end)

function sendToDiscord (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "https://discord.com/api/webhooks/834100292080369724/wrGx9QNGeQrfaY302yaSOkPbhgx0iFcgAn5RaZM-y5L9UClbjvUzHfPD_aM_AGN3OBSu"
	-- Modify here your discordWebHook username = name, content = message,embeds = embeds

local embeds = {
	{
		["title"]=message,
		["type"]="rich",
		["color"] =color,
		["footer"]=  {
			["text"]= "Heure: " ..date_local.. "",
		},
	}
}

	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 