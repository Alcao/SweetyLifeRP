local ESX = nil

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

AddEventHandler('chatMessage', function(source, name, message)
	CancelEvent()
end)

-- Location
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

-- BarberShop

RegisterServerEvent('Razzway#1337:barbershop:pay')
AddEventHandler('Razzway#1337:barbershop:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeAccountMoney('cash', 500)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "Vous avez payé ~b~500$")
end)

-- Skinchanger
RegisterServerEvent('::{razzway.xyz}::esx_skin:save')
AddEventHandler('::{razzway.xyz}::esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

ESX.AddGroupCommand('skin', 'admin', function(source, args, user)
	TriggerClientEvent('::{razzway.xyz}::esx_skin:openSaveableMenu', source)
end, {help = _U('skin')})

-- Armour
RegisterServerEvent('::{razzway.xyz}::esx_armour:armorremove')
AddEventHandler('::{razzway.xyz}::esx_armour:armorremove', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('armor', 1)
end)

RegisterServerEvent('::{razzway.xyz}::esx_armour:handcuffremove')
AddEventHandler('::{razzway.xyz}::esx_armour:handcuffremove', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('handcuff', 1)
end)

ESX.RegisterUsableItem('armor', function(source)
	TriggerClientEvent('::{razzway.xyz}::esx_armour:armor', source)
end)

ESX.RegisterUsableItem('handcuff', function(source)
	TriggerClientEvent('::{razzway.xyz}::esx_armour:handcuff', source)
end)

ESX.RegisterUsableItem('cutting_pliers', function(source)
	TriggerClientEvent('::{razzway.xyz}::esx_armour:cutting_pliers', source)
end)

-- Vendeur d'arme illégal
RegisterNetEvent('Razzway#1337:ventearme:achat')
AddEventHandler('Razzway#1337:ventearme:achat', function(arme, ammo, price)
	local souce = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xMoney = xPlayer.getAccount('cash').money
	if xMoney >= price then

		xPlayer.removeAccountMoney('cash', price)
		xPlayer.addWeapon(arme, ammo)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "Vous avez payé" ..price.." $")
	else
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "Vous n'avez pas assez d'argent")
	end
end)

-- XP SYSTEM
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier}, function(result)
        TriggerClientEvent('XNL_NET:XNL_SetInitialXPLevels', source, result[1].xp, true, true)
    end)
end)

RegisterServerEvent("XNL_NET:AddPlayerXP")
AddEventHandler("XNL_NET:AddPlayerXP", function(xp)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    TriggerClientEvent("XNL_NET:AddPlayerXP", src, xp)
    MySQL.Async.execute("UPDATE users SET xp = xp + @xp WHERE identifier = @identifier", {["@xp"] = xp, ["@identifier"] = xPlayer.identifier}, function() end)
end)

-- Shops
RegisterNetEvent('rz-core:itemshops')
AddEventHandler('rz-core:itemshops', function(price, nehcoi, nombre, account)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getAccount('cash').money >= price then
            xPlayer.removeAccountMoney('cash', price)
            xPlayer.addInventoryItem(nehcoi, nombre)
        end
end)

-- Coffre
RegisterServerEvent('::{razzway.xyz}::esx_truck_inventory:putItem')
AddEventHandler('::{razzway.xyz}::esx_truck_inventory:putItem', function(itemName, type, count, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	if plate ~= nil then
		if type == 'item_standard' then
			local playerItem = xPlayer.getInventoryItem(itemName)

			if playerItem.count >= count and count > 0 then
				TriggerEvent('::{razzway.xyz}::esx_addoninventory:getInventory', 'trunk', plate, function(inventory)
					xPlayer.removeInventoryItem(itemName, count)
					inventory.addItem(itemName, count)
					--TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('have_deposited', count, inventory.getItem(itemName).label))
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez déposé ~y~x' .. count .. '~s~ ~b~' .. ESX.GetItem(itemName).label .. '~s~')
				end)
			else
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, '~r~Action Impossible~s~ : Montant invalide !')
			end
		elseif type == 'item_account' then
			local xAccount = xPlayer.getAccount(itemName)

			if xAccount.money >= count and count > 0 then
				TriggerEvent('::{razzway.xyz}::esx_addonaccount:getAccount', 'trunk_' .. itemName, plate, function(account)
					xPlayer.removeAccountMoney(itemName, count)
					account.addMoney(count)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez déposé ~g~' .. count .. '$~s~ ~b~' .. ESX.GetAccountLabel(itemName) .. '~s~')
				end)
			else
				TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, '~r~Action Impossible~s~ : Montant invalide !')
			end
		elseif type == 'item_weapon' then
			local weaponName = string.upper(itemName)

			if xPlayer.hasWeapon(weaponName) then
				TriggerEvent('::{razzway.xyz}::esx_datastore:getDataStore', 'trunk', plate, function(store)
					local weapons = store.get('weapons') or {}

					table.insert(weapons, {
						name = weaponName,
						ammo = count
					})

					store.set('weapons', weapons)
					xPlayer.removeWeapon(weaponName)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez déposé ~y~x' .. count .. '~s~ ~b~' .. ESX.GetWeaponLabel(itemName) .. '~s~')
				end)
			else
				xPlayer.showNotification('~r~Action Impossible~s~ : Vous ne possédez pas cette arme !')
			end
		end
	end
end)

RegisterServerEvent('::{razzway.xyz}::esx_truck_inventory:getItem')
AddEventHandler('::{razzway.xyz}::esx_truck_inventory:getItem', function(itemName, type, count, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	if plate ~= nil then
		if type == 'item_standard' then
			TriggerEvent('::{razzway.xyz}::esx_addoninventory:getInventory', 'trunk', plate, function(inventory)
				local inventoryItem = inventory.getItem(itemName)

				if inventoryItem.count >= count and count > 0 then
					if xPlayer.canCarryItem(itemName, count) then
						inventory.removeItem(itemName, count)
						xPlayer.addInventoryItem(itemName, count)
						--TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, _U('have_withdrawn', count, inventoryItem.label))
						TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez pris ~y~x' .. count .. '~s~ ~b~' .. inventoryItem.label .. '~s~')
					else
						TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, '~r~Action Impossible~s~ : Vous n\'avez pas assez ~y~de place~s~ dans votre inventaire !')
					end
				else
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, '~r~Action Impossible~s~ : Il n\'y a pas assez de ~r~cet objet~s~ dans votre coffre!')
				end
			end)
		elseif type == 'item_account' then
			TriggerEvent('::{razzway.xyz}::esx_addonaccount:getAccount', 'trunk_' .. itemName, plate, function(account)
				if account.money >= count and count > 0 then
					account.removeMoney(count)
					xPlayer.addAccountMoney(itemName, count)
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez pris ~g~' .. count .. '$~s~ ~b~' .. ESX.GetAccountLabel(itemName) .. '~s~')
				else
					TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, '~r~Action Impossible~s~ : Montant invalide !')
				end
			end)
		elseif type == 'item_weapon' then
			TriggerEvent('::{razzway.xyz}::esx_datastore:getDataStore', 'trunk', plate, function(store)
				local weaponName = string.upper(itemName)

				if not xPlayer.hasWeapon(weaponName) then
					local weapons = store.get('weapons') or {}

					for i = 1, #weapons, 1 do
						if weapons[i].name == weaponName and weapons[i].ammo == count then
							table.remove(weapons, i)

							store.set('weapons', weapons)
							xPlayer.addWeapon(weaponName, count)
							TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez pris ~y~x' .. count .. '~s~ ~b~' .. ESX.GetWeaponLabel(itemName) .. '~s~')
							break
						end
					end
				else
					xPlayer.showNotification('~r~Action Impossible~s~ : Vous possédez déjà cette arme !')
				end
			end)
		end
	end
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_truck_inventory:getTrunkInventory', function(source, cb, plate)
	local dirtycash, items, weapons = 0, {}, {}

	TriggerEvent('::{razzway.xyz}::esx_addonaccount:getAccount', 'trunk_dirtycash', plate, function(account)
		dirtycash = account.money
	end)

	TriggerEvent('::{razzway.xyz}::esx_addoninventory:getInventory', 'trunk', plate, function(inventory)
		items = inventory.items
	end)

	TriggerEvent('::{razzway.xyz}::esx_datastore:getDataStore', 'trunk', plate, function(store)
		weapons = store.get('weapons') or {}
	end)

	cb({
		dirtycash = dirtycash,
		items = items,
		weapons = weapons
	})
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_truck_inventory:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		dirtycash = xPlayer.getAccount('dirtycash').money,
		items = xPlayer.inventory,
		weapons = xPlayer.getLoadout()
	})
end)

-- Tattoo Shop
RegisterServerEvent('Razzway#1337:tattooshop:pay')
AddEventHandler('Razzway#1337:tattooshop:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeAccountMoney('cash', 50)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "Vous avez payé ~b~50$")
end)

RegisterServerEvent("Razzway#1337:tattoos:GetPlayerTattoos_s")
AddEventHandler("Razzway#1337:tattoos:GetPlayerTattoos_s", function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll("SELECT * FROM playersTattoos WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
		if (result[1] ~= nil) then
			local tattoosList = json.decode(result[1].tattoos)
			TriggerClientEvent("::{razzway.xyz}::tattoos:getPlayerTattoos", xPlayer.source, tattoosList)
		else
			local tattooValue = json.encode({})
			MySQL.Async.execute("INSERT INTO playersTattoos (identifier, tattoos) VALUES (@identifier, @tattoo)", {['@identifier'] = xPlayer.identifier, ['@tattoo'] = tattooValue})
			TriggerClientEvent("::{razzway.xyz}::tattoos:getPlayerTattoos", xPlayer.source, {})
		end
	end)
end)

RegisterServerEvent("::{razzway.xyz}::tattoos:save")
AddEventHandler("::{razzway.xyz}::tattoos:save", function(tattoosList, price, value)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)

		table.insert(tattoosList, value)

		MySQL.Async.execute("UPDATE playersTattoos SET tattoos = @tattoos WHERE identifier = @identifier", {['@tattoos'] = json.encode(tattoosList), ['@identifier'] = xPlayer.identifier})
		
		TriggerClientEvent("::{razzway.xyz}::tattoo:buySuccess", xPlayer.source, value)
		TriggerClientEvent("::{razzway.xyz}::esx:showNotification", xPlayer.source, "~g~You just bought this tattoo.")
	else
		TriggerClientEvent("::{razzway.xyz}::esx:showNotification", xPlayer.source, "~r~You don't have enought money.")
	end
end)

-- ClotheShop
RegisterServerEvent('Razzway#1337:clotheshop:pay')
AddEventHandler('Razzway#1337:clotheshop:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeAccountMoney('cash', 500)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "Vous avez payé ~b~500$")
end)

RegisterServerEvent('::{razzway.xyz}::esx_clotheshop:saveOutfit')
AddEventHandler('::{razzway.xyz}::esx_clotheshop:saveOutfit', function(label, skin)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('::{razzway.xyz}::esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin = skin
		})

		store.set('dressing', dressing)
	end)
end)

RegisterServerEvent('::{razzway.xyz}::esx_clotheshop:deleteOutfit')
AddEventHandler('::{razzway.xyz}::esx_clotheshop:deleteOutfit', function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('::{razzway.xyz}::esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		label = label
		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::esx_clotheshop:saveOutfitName', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('::{razzway.xyz}::esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count = store.count('dressing')
		local labels = {}

		for i = 1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

-- Interact
ESX.AddGroupCommand('bring', 'superadmin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand('bring'), plyGroup) or isAuthorized(getAdminCommand('goto'), plyGroup) then
		local targetCoords = GetEntityCoords(GetPlayerPed(source))
		TriggerClientEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Admin_BringC', args[1], targetCoords)
	end
end, {help = "C'est la commands pour tp sur toi", params = {
	{name = "playerId", help = "id du mec"},
}})

ESX.AddGroupCommand('goto', 'superadmin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand('bring'), plyGroup) or isAuthorized(getAdminCommand('goto'), plyGroup) then
		local targetCoords = GetEntityCoords(GetPlayerPed(args[1]))
		TriggerClientEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Admin_BringC', source, targetCoords)
	end
end, {help = "C'est la commands pour tp sur toi", params = {
	{name = "playerId", help = "id du mec"},
}})

function getMaximumGrade(jobname)
	local queryDone, queryResult = false, nil

	MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {
		['@jobname'] = jobname
	}, function(result)
		queryDone, queryResult = true, result
	end)

	while not queryDone do
		Citizen.Wait(10)
	end

	if queryResult[1] then
		return queryResult[1].grade
	end

	return nil
end

function getAdminCommand(name)
	for i = 1, #Config.Admin, 1 do
		if Config.Admin[i].name == name then
			return i
		end
	end

	return false
end

function isAuthorized(index, group)
	for i = 1, #Config.Admin[index].groups, 1 do
		if Config.Admin[index].groups[i] == group then
			return true
		end
	end

	return false
end

ESX.RegisterServerCallback('Razzway#1337:GetBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('::{razzway.xyz}::KorioZ-PersonalMenu:Admin_getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if plyGroup ~= nil then 
		cb(plyGroup)
	else
		cb('user')
	end
end)

-- Weapon Menu --
RegisterServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Weapon_addAmmoToPedS')
AddEventHandler('::{razzway.xyz}::KorioZ-PersonalMenu:Weapon_addAmmoToPedS', function(plyId, value, quantity)
	if #(GetEntityCoords(source, false) - GetEntityCoords(plyId, false)) <= 3.0 then
		TriggerClientEvent('G39klmyzgdzud:(1441-lmp)', plyId, value, quantity)
	end
end)

-- Admin Menu --
RegisterServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Admin_BringS')
AddEventHandler('::{razzway.xyz}::KorioZ-PersonalMenu:Admin_BringS', function(plyId, targetId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand('bring'), plyGroup) or isAuthorized(getAdminCommand('goto'), plyGroup) then
		local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
		TriggerClientEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Admin_BringC', plyId, targetCoords)
	end
end)

-- Grade Menu --
RegisterServerEvent('c26bgdtoklmtbr:{-pp}')
AddEventHandler('c26bgdtoklmtbr:{-pp}', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1) then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
	else
		if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) + 1)

			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~promu ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', target, 'Vous avez été ~g~promu par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('f45bgdtj78ql:[tl-yu]')
AddEventHandler('f45bgdtj78ql:[tl-yu]', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 0) then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
	else
		if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) - 1)

			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('rRazzway:recrutejoueur')
AddEventHandler('rRazzway:recrutejoueur', function(target, job, grade)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' then
		targetXPlayer.setJob(job, grade)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
	end
end)

RegisterServerEvent('rRazzway:virerjoueur')
AddEventHandler('rRazzway:virerjoueur', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
		targetXPlayer.setJob('unemployed', 0)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
	else
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end)

RegisterServerEvent('rRazzway:promouvoirjoueur2')
AddEventHandler('rRazzway:promouvoirjoueur2', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job2.grade == tonumber(getMaximumGrade(sourceXPlayer.job2.name)) - 1) then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
	else
		if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
			targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) + 1)

			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~promu ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', target, 'Vous avez été ~g~promu par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('rRazzway:destituerjoueur2')
AddEventHandler('rRazzway:destituerjoueur2', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job2.grade == 0) then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
	else
		if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
			targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) - 1)

			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('rRazzway:recrutejoueur2')
AddEventHandler('rRazzway:recrutejoueur2', function(target, job2, grade2)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job2.grade_name == 'boss' then
		targetXPlayer.setJob2(job2, grade2)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
	end
end)

RegisterServerEvent('rRazzway:virerjoueur2')
AddEventHandler('rRazzway:virerjoueur2', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
		targetXPlayer.setJob2('unemployed2', 0)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
	else
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end)

-- Ammunation
RegisterNetEvent('rz-ammu:achatweapon')
AddEventHandler('rz-ammu:achatweapon', function(arme, ammo, price)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getAccount('cash').money
    if xMoney >= price then

        xPlayer.removeAccountMoney('cash', price)
		xPlayer.addWeapon(arme, ammo)
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, "Armurerie", "~r~Message", "Merci pour votre achat ! Voici votre arme !", 'CHAR_AMMUNATION', 2)
		sendToDiscordAchat('Cardinal', '[ARMURIE] ' ..xPlayer.getName().. ' vient d\'acheter une arme | NOM : ' ..arme..' au prix de : ' ..price.. '', 2061822)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "~r~Vous n'avez pas assez d'argent")
    end
end)


RegisterServerEvent('rz-weapon:removeClip')
AddEventHandler('rz-weapon:removeClip', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('clip', 1)
end)

ESX.RegisterUsableItem('clip', function(source)
	TriggerClientEvent('rz-weapon:useClip', source)
end)

RegisterNetEvent('rz-ammu:achatItems')
AddEventHandler('rz-ammu:achatItems', function(item, price)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getAccount('cash').money
    if xMoney >= price then

        xPlayer.removeAccountMoney('cash', price)
		xPlayer.addInventoryItem(item, 1)
		TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, "Armurerie", "~r~Message", "Merci pour votre achat ! Voici votre accessoire !", 'CHAR_AMMUNATION', 2)
		sendToDiscordAchat('Cardinal', '[ARMURIE] ' ..xPlayer.getName().. ' vient d\'acheter une accessoire | NOM : ' ..item..' au prix de : ' ..price.. '', 2061822)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "~r~Vous n'avez pas assez d'argent")
    end
end)


-- Auto Ecole
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(source)
	TriggerEvent('::{razzway.xyz}::esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('::{razzway.xyz}::esx_dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('::{razzway.xyz}::esx_dmvschool:addLicense')
AddEventHandler('::{razzway.xyz}::esx_dmvschool:addLicense', function(type)
	local _source = source

	TriggerEvent('::{razzway.xyz}::esx_license:addLicense', _source, type, function()
		TriggerEvent('::{razzway.xyz}::esx_license:getLicenses', _source, function(licenses)
			TriggerClientEvent('::{razzway.xyz}::esx_dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterServerEvent('rz-core:addpermis')
AddEventHandler('rz-core:addpermis', function(permis)
	local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
        ['@type'] = permis,
        ['@owner'] = xPlayer.identifier
    })
end)

RegisterServerEvent('rz-core:buypermis')
AddEventHandler('rz-core:buypermis', function(job)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    xPlayer.removeAccountMoney('cash', 100)
end)

-- Commandes
RegisterServerEvent('::{razzway.xyz}::cmg2_animations:sync')
AddEventHandler('::{razzway.xyz}::cmg2_animations:sync', function(animationLib, animation, animation2, distans, distans2, height, targetSrc, length, spin, controlFlagSrc, controlFlagTarget, animFlagTarget)
	TriggerClientEvent('::{razzway.xyz}::cmg2_animations:syncTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget)
	TriggerClientEvent('::{razzway.xyz}::cmg2_animations:syncMe', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
end)

RegisterServerEvent('::{razzway.xyz}::cmg2_animations:stop')
AddEventHandler('::{razzway.xyz}::cmg2_animations:stop', function(targetSrc)
	TriggerClientEvent('::{razzway.xyz}::cmg2_animations:cl_stop', targetSrc)
end)

RegisterServerEvent('::{razzway.xyz}::cmg3_animations:sync')
AddEventHandler('::{razzway.xyz}::cmg3_animations:sync', function(animationLib, animationLib2, animation, animation2, distans, distans2, height, targetSrc, length, spin, controlFlagSrc, controlFlagTarget, animFlagTarget, attachFlag)
	TriggerClientEvent('::{razzway.xyz}::cmg3_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget, attachFlag)
	TriggerClientEvent('::{razzway.xyz}::cmg3_animations:syncMe', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
end)

RegisterServerEvent('::{razzway.xyz}::cmg3_animations:stop')
AddEventHandler('::{razzway.xyz}::cmg3_animations:stop', function(targetSrc)
	TriggerClientEvent('::{razzway.xyz}::cmg3_animations:cl_stop', targetSrc)
end)

-- Vendeur
ESX.RegisterServerCallback('razzou:buyweedinfo', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local priceAvailable = false
	price = 50000

	if price == price then
		priceAvailable = true
	end

	if priceAvailable and xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez payé ~r~' .. price .. ' $~s~ !')
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('razzou:buyopiuminfo', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local priceAvailable = false
	price = 75000

	if price == price then
		priceAvailable = true
	end

	if priceAvailable and xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez payé ~r~' .. price .. '$~s~ !')
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('razzou:buymoreinfo', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local priceAvailable = false
	price = 100000

	if price == price then
		priceAvailable = true
	end

	if priceAvailable and xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, 'Vous avez payé ~r~' .. price .. '$~s~ !')
		cb(true)
	else
		cb(false)
	end
end)

-- Le bon coin

local function getLicense(source)
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
        return v
        end

    end
    return ""
end

RegisterNetEvent("esx_leboncoin:buyOffer")
AddEventHandler("esx_leboncoin:buyOffer", function(plate, authorLicense)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local currentMoney = xPlayer.getAccount('bank').money

    MySQL.Async.fetchAll("SELECT * FROM esx_leboncoin WHERE license = @a AND plate = @b", {['a'] = authorLicense, ['b'] = plate}, function(result)
        if result[1] then
            local offer = result[1]
            local price = offer.price
            if currentMoney > price then 
                xPlayer.removeAccountMoney("bank", price)
                MySQL.Async.execute("DELETE FROM esx_leboncoin WHERE license = @a AND plate = @b", {['a'] = authorLicense, ['b'] = plate}, function()
                    MySQL.Async.insert("INSERT INTO owned_vehicles (vehicle, owner, stored, plate) VALUES(@a,@b,1,@c)", {
                        ['a'] = offer.model,
                        ['b'] = xPlayer.identifier,
                        ['c'] = offer.plate,
                    }, function(insertId)
                        TriggerClientEvent("esx_leboncoin:serverReturnStatusBuy", source, 1)
                        local xPlayers = ESX.GetPlayers()
                        for i=1, #xPlayers, 1 do
                            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                            if xPlayer.identifier == offer.license then
                                TriggerClientEvent("::{razzway.xyz]::esx:showNotification", xPlayers[i], "~g~Félicitations ! ~s~Vous remportez un total de ~g~"..ESX.Math.GroupDigits(offer.price).."$ ~s~pour la vente de votre véhicule (~b~"..offer.plate.."~s~)")
                                xPlayer.addAccountMoney("bank",offer.price)
                                return
                            end
                        end
                        MySQL.Async.execute("SELECT accounts FROM users WHERE identifier = @a", {['a'] = offer.license}, function(result)
                            if result[1] then
                                local accounts = json.decode(result[1].accounts)
                                accounts.bank = accounts.bank + offer.price
                                MySQL.Async.execute("UPDATE users SET accounts = @a WHERE identifier = @b", {['a'] = json.encode(accounts), ['b'] = offer.license})
                            end
                        end)
                    end)
                end)
            else
                TriggerClientEvent("esx_leboncoin:serverReturnStatusBuy", source, 0)
                TriggerClientEvent("::{razzway.xyz]::esx:showNotification", source, "~r~Vous n'avez pas assez d'argent pour payer ce véhicule")
            end
        else
            TriggerClientEvent("esx_leboncoin:serverReturnStatusBuy", source, 0)
        end
    end)
end)
local function getDate()
    return os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
end

RegisterNetEvent("esx_leboncoin:publishOffer")
AddEventHandler("esx_leboncoin:publishOffer", function(plate, builder)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local steam = xPlayer.identifier
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @a AND plate = @b", {['a'] = steam, ['b'] = plate}, function(result)
        if result[1] then
            local savedData = result[1]
            MySQL.Async.execute("DELETE FROM owned_vehicles WHERE owner = @a AND plate = @b", {['a'] = steam, ['b'] = plate}, function()
                MySQL.Async.insert("INSERT INTO esx_leboncoin (license, name, description, model, price, createdAt, plate) VALUES(@a,@b,@c,@d,@e,@f,@g)", {
                    ['a'] = steam,
                    ['b'] = GetPlayerName(source),
                    ['c'] = builder.description,
                    ['d'] = savedData.vehicle,
                    ['e'] = builder.price,
                    ['f'] = getDate(),
                    ['g'] = savedData.plate
                }, function(insertId)
                    TriggerClientEvent("esx_leboncoin:serverReturnStatus", source, 1)
                    TriggerClientEvent("::{razzway.xyz]::esx:showNotification", source, ("~g~Votre offre porte le numéro unique ~y~%i"):format(insertId))
                end)
            end)
            
        else
            TriggerClientEvent("esx_leboncoin:serverReturnStatus", source, 0)
        end
    end)
end)

RegisterNetEvent("esx_leboncoin:interact")
AddEventHandler("esx_leboncoin:interact", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local source = source
    local busy = true
    local myVehicles = {}
    local availableVehicles = {}
    local function getIdentifier()
        local identifier = ""
        if ConfigLeBonCoin.identifier == 1 then
            -- License Rockstar
            identifier = getLicense(source)
        else
        end
        return identifier
    end
    print(getIdentifier(source))
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @a", {['a'] = getIdentifier(source)}, function(result)
        myVehicles = result
        busy = false
    end)
    while busy do Wait(1) end
    busy = true
    MySQL.Async.fetchAll("SELECT * FROM esx_leboncoin", {}, function(result)
        availableVehicles = result
        busy = false
    end)
    while busy do Wait(1) end
    TriggerClientEvent("esx_leboncoin:cb", source, myVehicles, availableVehicles)
end)

-- Repair Kit
ESX.RegisterUsableItem('repairkit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if ConfigRepair.AllowMecano then
		TriggerClientEvent('::{razzway.xyz}::esx_repairkit:onUse', _source)
	else
		if xPlayer.job.name ~= 'mecano' then
			TriggerClientEvent('::{razzway.xyz}::esx_repairkit:onUse', _source)
		end
	end
end)

-- Cambriolage / Robberies
local housesStates = {}

SwLife.newThread(function()
    for _,house in pairs(robberiesConfiguration.houses) do
        table.insert(housesStates, {state = true, robbedByID = nil})
    end
end)

RegisterNetEvent("::{razzway.xyz}::esx_robberies:houseRobbed")
AddEventHandler("::{razzway.xyz}::esx_robberies:houseRobbed",function(houseID)
    local _src = source
    housesStates[houseID].state = false
    housesStates[houseID].robbedByID = _src
    sendToDiscordFDP("Cambriolages","**"..GetPlayerName(_src).."** cambriole la maison n°"..houseID.." ("..robberiesConfiguration.houses[houseID].name..") !", 16711680)
    Citizen.SetTimeout((1000*60)*robberiesConfiguration.houseRobRegen, function()
        housesStates[houseID].state = true
        housesStates[houseID].robbedByID = nil
    end)
end)

RegisterNetEvent("::{razzway.xyz}::dynastybg_bijouterie:houseRobbed")
AddEventHandler("::{razzway.xyz}::dynastybg_bijouterie:houseRobbed",function(houseID)
    local _src = source
    housesStates[houseID].state = false
    housesStates[houseID].robbedByID = _src
    sendToDiscordFDP("Cambriolages","**"..GetPlayerName(_src).."** cambriole la maison n°"..houseID.." ("..bijouterie.houses[houseID].name..") !", 16711680)
    Citizen.SetTimeout((1000*60)*bijouterie.houseRobRegen, function()
        housesStates[houseID].state = true
        housesStates[houseID].robbedByID = nil
    end)
end)

RegisterNetEvent("::{razzway.xyz}::esx_robberies:callThePolice")
AddEventHandler("::{razzway.xyz}::esx_robberies:callThePolice", function(houseIndex)
    local authority = robberiesConfiguration.houses[houseIndex].authority
    local xPlayers = ESX.GetPlayers()
    print(authority)
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' then
            TriggerClientEvent("dynastybg_braquage:initializePoliceBlip",xPlayers[i], houseIndex, robberiesConfiguration.houses[houseIndex].policeBlipDuration)
        end
    end
end)

RegisterNetEvent("::{razzway.xyz}::dynastybg_bijouterie:callThePolice")
AddEventHandler("::{razzway.xyz}::dynastybg_bijouterie:callThePolice", function(houseIndex)
    local authority = bijouterie.houses[houseIndex].authority
    local xPlayers = ESX.GetPlayers()
    print(authority)
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' then
            TriggerClientEvent("::{razzway.xyz}::esx_robberies:initializePoliceBlipx",xPlayers[i], houseIndex, bijouterie.houses[houseIndex].policeBlipDuration)
        end
    end
end)

RegisterNetEvent("::{razzway.xyz}::esx_robberies:reward") 
AddEventHandler("::{razzway.xyz}::esx_robberies:reward", function(reward)
    local _src = source
    sendToDiscordFDP("Cambriolages","**"..GetPlayerName(_src).."** à reçu __"..reward.."__$ pour son cambriolage.", 16744192)
end)

RegisterNetEvent("::{razzway.xyz}::esx_robberies:money") 
AddEventHandler("::{razzway.xyz}::esx_robberies:money", function(reward)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    
    xPlayer.addAccountMoney('cash', reward)
end)

RegisterNetEvent("::{razzway.xyz}::esx_robberies:getHousesStates")
AddEventHandler("::{razzway.xyz}::esx_robberies:getHousesStates", function()
    local _src = source
    TriggerClientEvent("::{razzway.xyz}::esx_robberies:getHousesStates", _src, housesStates)
end)

RegisterNetEvent("::{razzway.xyz}::esx_robberies:getHousesStatess")
AddEventHandler("::{razzway.xyz}::esx_robberies:getHousesStatess", function()
    local _src = source
    TriggerClientEvent("::{razzway.xyz}::esx_robberies:getHousesStatess", _src, housesStates)
end)


RegisterNetEvent('::{razzway.xyz}::esx_repairkit:removeKit')
AddEventHandler('::{razzway.xyz}::esx_repairkit:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not ConfigRepair.InfiniteRepairs then
		xPlayer.removeInventoryItem('repairkit', 1)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, _U('used_kit'))
	end
end)

-- Parachute
RegisterNetEvent('rz-core:giveparachute')
AddEventHandler('rz-core:giveparachute', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 1000
    local xMoney = xPlayer.getAccount('cash').money

    if xPlayer.hasWeapon('GADGET_PARACHUTE') then
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Vous avez déjà un parachute.")
	else
    if xMoney >= price then

        xPlayer.removeAccountMoney('cash', price)
        xPlayer.addWeapon('GADGET_PARACHUTE', 42)
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "~g~Parachute~w~ obtenu ! ~r~-1000$")
    else
         TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Vous n'avez pas assez ~r~d\'argent")
    end
    end
end)

RegisterServerEvent('rz-core:removeparachute')
AddEventHandler('rz-core:removeparachute', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getAccount('cash').money
    xPlayer.removeWeapon('GADGET_PARACHUTE')
end)

-- Blanchiment
RegisterServerEvent('rz-core:blanchiement')
AddEventHandler('rz-core:blanchiement', function(argent)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local taxe = 0.60    -- Le blanchisseur prend 35% (1-0.65 = 0.35)
	local coords = GetEntityCoords(GetPlayerPed(source))
	blanchi = vector3(1117.88, -3195.69, -40.4)
	ZoneSize = 5.0

	argent = ESX.Math.Round(tonumber(argent))
	pourcentage = argent * taxe
	Total = ESX.Math.Round(tonumber(pourcentage))

	if #(coords - blanchi) < ZoneSize / 2 then

		if argent > 0 and xPlayer.getAccount('dirtycash').money >= argent then
			xPlayer.removeAccountMoney('dirtycash', argent)
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayer.source, 'Roberto', '~y~Blanchiement', 'Patiente ~r~10 secondes', 'CHAR_MP_ROBERTO', 8)
			Citizen.Wait(10000)
		
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayer.source, 'Roberto', '~y~Blanchiement', 'Tu as reçu : ' .. ESX.Math.GroupDigits(Total) .. ' ~g~$', 'CHAR_MP_ROBERTO', 8)
			xPlayer.addAccountMoney('cash', Total)
			sendLogsToDiscord('Cardinal', '' ..xPlayer.getName().. ' vient de blanchir '..argent..'$ d\'argent sale et a reçu '..Total..'$ d\'argent propre', 15158332)
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayer.source, 'Roberto', '~y~Blanchiement', '~r~Montant invalide', 'CHAR_MP_ROBERTO', 8)
		end
	else
		TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "Je code avec le cul :p")
	end
end)

RegisterNetEvent('rz-core:blanchiement2')
AddEventHandler('rz-core:blanchiement2', function(Money, BlackMoney)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local GetBlackMoney = xPlayer.getAccount('dirtycash').money
    if Money <= GetBlackMoney then
        xPlayer.removeAccountMoney('dirtycash', BlackMoney)
        xPlayer.addMoney(Money)
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Vous avez blanchis ~r~"..BlackMoney.."$ d'argents sale~w~ pour recevoir ~g~"..Money.."$ d'argents propre")
    end
end)

-- identity
function getIdentity(source, cb)
	local identifier = ESX.GetIdentifierFromId(source)

	MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, dateofbirth, sex, height FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		local data = {}

		data.identifier = identifier

		if result[1] then
			data.firstname = result[1].firstname
			data.lastname = result[1].lastname
			data.dateofbirth = result[1].dateofbirth
			data.sex = result[1].sex
			data.height = result[1].height
		end

		cb(data)
	end)
end

function SetFirstName(identifier, firstname)
	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@firstname']		= firstname
	})
end

function SetLastName(identifier, lastname)
	MySQL.Async.execute('UPDATE `users` SET `lastname` = @lastname WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@lastname']		= lastname
	})
end

function SetDOB(identifier, dateofbirth, callback)
	MySQL.Async.execute('UPDATE `users` SET `dateofbirth` = @dateofbirth WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@dateofbirth']	= dateofbirth
	})
end

function SetSex(identifier, sex)
	MySQL.Async.execute('UPDATE `users` SET `sex` = @sex WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@sex']		    = sex
	})
end

function SetSex2(identifier, sex2)
	MySQL.Async.execute('UPDATE `users` SET `sex` = @sex WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@sex']		    = sex2
	})
end

function SetHeight(identifier, height)
	MySQL.Async.execute('UPDATE `users` SET `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@height']		    = height
	})
end

RegisterServerEvent('::{razzway.xyz}::esx_identity:SetFirstName')
AddEventHandler('::{razzway.xyz}::esx_identity:SetFirstName', function(ID, firstname)
    local identifier = ESX.GetPlayerFromId(ID).identifier

    SetFirstName(identifier, firstname)
end)

RegisterServerEvent('::{razzway.xyz}::esx_identity:SetLastName')
AddEventHandler('::{razzway.xyz}::esx_identity:SetLastName', function(ID, lastname)
    local identifier = ESX.GetPlayerFromId(ID).identifier

    SetLastName(identifier, lastname)
end)

RegisterServerEvent('::{razzway.xyz}::esx_identity:SetDOB')
AddEventHandler('::{razzway.xyz}::esx_identity:SetDOB', function(ID, dateofbirth)
    local identifier = ESX.GetPlayerFromId(ID).identifier

    SetDOB(identifier, dateofbirth)
end)

RegisterServerEvent('::{razzway.xyz}::esx_identity:SetSex')
AddEventHandler('::{razzway.xyz}::esx_identity:SetSex', function(ID, sex)
    local identifier = ESX.GetPlayerFromId(ID).identifier

    SetSex(identifier, sex)  
end)

RegisterServerEvent('::{razzway.xyz}::esx_identity:SetSex2')
AddEventHandler('::{razzway.xyz}::esx_identity:SetSex2', function(ID, sex2)
    local identifier = ESX.GetPlayerFromId(ID).identifier

    SetSex2(identifier, sex2)  
end)

RegisterServerEvent('::{razzway.xyz}::esx_identity:SetHeight')
AddEventHandler('::{razzway.xyz}::esx_identity:SetHeight', function(ID, height)
    local identifier = ESX.GetPlayerFromId(ID).identifier

    SetHeight(identifier, height)
end)

AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(source)
	getIdentity(source, function(data)
		if data.firstname == nil or data.firstname == '' then
			TriggerClientEvent('::{razzway.xyz}::esx_identity:identityCheck', source, false)
			TriggerClientEvent('::{razzway.xyz}::esx_identity:showRegisterIdentity', source)
		else
			TriggerClientEvent('::{razzway.xyz}::esx_identity:identityCheck', source, true)
		end
	end)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(1000)
		local xPlayers = ESX.GetPlayers()

		for i = 1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer then
				getIdentity(xPlayer.source, function(data)
					if data.firstname == nil or data.firstname == '' then
						TriggerClientEvent('::{razzway.xyz}::esx_identity:identityCheck', xPlayer.source, false)
						TriggerClientEvent('::{razzway.xyz}::esx_identity:showRegisterIdentity', xPlayer.source)
					else
						TriggerClientEvent('::{razzway.xyz}::esx_identity:identityCheck', xPlayer.source, true)
					end
				end)
			end
		end
	end
end)

-- Discord Send Logs
function sendLogsToDiscord(name,message,color)
    date_local1 = os.date('%H:%M:%S', os.time())
    local date_local = date_local1
    local DiscordWebHook = "https://discord.com/api/webhooks/834108066214707200/cFT2nPeZ6xBM0Aeunu5D3WyOMyTnweZwRR8haYrSk24H7jR9U8SKt-Z1MzbxevTRNoW5"
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

-- Discord Logs Achat
function sendToDiscordAchat (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "https://discord.com/api/webhooks/821839420675326054/lvNNw7aTqIYda6kCHUnAGrp7NXuRYmUUVvUS5VRU9No_-OyyQTT2rxX1263ZzqX7k-j-"
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
