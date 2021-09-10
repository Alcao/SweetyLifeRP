-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local PersonalMenu = {
	ItemSelected = {},
	ItemIndex = {},
	WeaponData = {},
	WalletIndex = {},
	WalletList = {_U('wallet_option_give'), _U('wallet_option_drop')},
	BillData = nil,
	ClothesButtons = {'torso', 'pants', 'shoes', 'bag', 'bproof'},
	AccessoriesButtons = {'Ears', 'Glasses', 'Helmet', 'Mask'},
	DoorState = {
		FrontLeft = false,
		FrontRight = false,
		BackLeft = false,
		BackRight = false,
		Hood = false,
		Trunk = false
	},
	DoorIndex = 1,
	DoorList = {_U('vehicle_door_frontleft'), _U('vehicle_door_frontright'), _U('vehicle_door_backleft'), _U('vehicle_door_backright')},
	GPSIndex = 1,
	GPSList = {},
	VoiceIndex = 2,
	VoiceList = {}
}

Player = {
	isDead = false,
	inAnim = false,
	ragdoll = false,
	crouched = false,
	handsup = false,
	pointing = false,
	minimap = true,
	ui = true,
	cinema = false,
	noclip = false,
	godmode = false,
	ghostmode = false,
	showCoords = false,
	showName = false,
	gamerTags = {}
}

local societymoney, societymoney2 = nil, nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	if ConfigKRZ.DoubleJob then
		while ESX.GetPlayerData().job2 == nil do
			Citizen.Wait(10)
		end
	end

	ESX.PlayerData = ESX.GetPlayerData()

	while actualSkin == nil do
		TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin) actualSkin = skin end)
		Citizen.Wait(100)
	end

	while PersonalMenu.BillData == nil do
		ESX.TriggerServerCallback('::{razzway.xyz}::KorioZ-PersonalMenu:Bill_getBills', function(bills) PersonalMenu.BillData = bills end)
		Citizen.Wait(100)
	end

	RefreshMoney()

	if ConfigKRZ.DoubleJob then
		RefreshMoney2()
	end

	PersonalMenu.WeaponData = ESX.GetWeaponList()

	for i = 1, #PersonalMenu.WeaponData, 1 do
		if PersonalMenu.WeaponData[i].name == 'WEAPON_UNARMED' then
			PersonalMenu.WeaponData[i] = nil
		else
			PersonalMenu.WeaponData[i].hash = GetHashKey(PersonalMenu.WeaponData[i].name)
		end
	end

	--for i = 1, #ConfigKRZ.GPS, 1 do
		--table.insert(PersonalMenu.GPSList, ConfigKRZ.GPS[i].label)
	--end

	for i = 1, #ConfigKRZ.Voice.items, 1 do
		table.insert(PersonalMenu.VoiceList, ConfigKRZ.Voice.items[i].label)
	end

	RMenu2.Add('RageUI2', 'personal', RageUI2.CreateMenu(ConfigKRZ.MenuTitle, ("Connecté en tant que :~b~ ".. GetPlayerName(PlayerId()) ..""), 0, 0, 'commonmenu', 'interaction_bgd', 255, 255, 255, 255))

	RMenu2.Add('personal', 'inventory', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('inventory_title')))
	RMenu2.Settings('personal', 'inventory', 'ButtonLabel', ('%s [%s / %s]'):format(_U('inventory_title'), GetCurrentWeight() + 0.0, ESX.PlayerData.maxWeight + 0.0))
	RMenu2.Add('personal', 'loadout', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('loadout_title')))
	RMenu2.Add('personal', 'wallet', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('wallet_title')))
	RMenu2.Add('personal', 'billing', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('bills_title')))
	RMenu2.Add('personal', 'clothes', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('clothes_title')))
	RMenu2.Add('personal', 'accessories', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('accessories_title')))
	RMenu2.Add('personal', 'touche', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), ('Touches')))
	--RMenu2.Add('personal', 'animation', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('animation_title')))
	RMenu2.Add('personal', 'vehicle', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('vehicle_title')), function()
		if IsPedSittingInAnyVehicle(plyPed) then
			if (GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed, false), -1) == plyPed) then
				return true
			end
		end

		return false
	end)

	RMenu2.Add('personal', 'boss', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('bossmanagement_title')), function()
		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
			return true
		end

		return false
	end)

	if ConfigKRZ.DoubleJob then
		RMenu2.Add('personal', 'boss2', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('bossmanagement2_title')), function()
			if ConfigKRZ.DoubleJob then
				if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
					return true
				end
			end

			return false
		end)
	end

	RMenu2.Add('personal', 'admin', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), _U('admin_title')), function()
		if ESX.PlayerData.group ~= nil and (ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'owner' or ESX.PlayerData.group == '_dev') then
			return true
		end

		return false
	end)

	RMenu2.Add('personal', 'other', RageUI2.CreateSubMenu(RMenu2.Get('RageUI2', 'personal'), 'Autre'))

	RMenu2.Add('inventory', 'actions', RageUI2.CreateSubMenu(RMenu2.Get('personal', 'inventory'), _U('inventory_actions_title')))
	RMenu2.Get('inventory', 'actions').Closed = function()
		PersonalMenu.ItemSelected = nil
	end

	RMenu2.Add('loadout', 'actions', RageUI2.CreateSubMenu(RMenu2.Get('personal', 'loadout'), _U('loadout_actions_title')))
	RMenu2.Get('loadout', 'actions').Closed = function()
		PersonalMenu.ItemSelected = nil
	end

	--for i = 1, #ConfigKRZ.Animations, 1 do
		--RMenu2.Add('animation', ConfigKRZ.Animations[i].name, RageUI2.CreateSubMenu(RMenu2.Get('personal', 'animation'), ConfigKRZ.Animations[i].label))
	--end
end)

if ConfigKRZ.Voice.activated then
	Citizen.CreateThread(function()
		local voiceFixing = true
		NetworkSetTalkerProximity(0.1)

		SetTimeout(10000, function()
			voiceFixing = nil
		end)

		while voiceFixing do
			NetworkSetTalkerProximity(ConfigKRZ.Voice.defaultLevel)
			Citizen.Wait(10)
		end
	end)
end

RegisterNetEvent('::{razzway.xyz}::esx:playerLoaded')
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

AddEventHandler('::{razzway.xyz}::esx:onPlayerDeath', function()
	Player.isDead = true
	RageUI2.CloseAll()
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('playerSpawned', function()
	Player.isDead = false
end)

RegisterNetEvent('::{razzway.xyz}::esx:activateMoney')
AddEventHandler('::{razzway.xyz}::esx:activateMoney', function(money)
	ESX.PlayerData.money = money
end)

RegisterNetEvent('::{razzway.xyz}::esx:setAccountMoney')
AddEventHandler('::{razzway.xyz}::esx:setAccountMoney', function(account)
	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:addInventoryItem')
AddEventHandler('::{razzway.xyz}::esx:addInventoryItem', function(item)
	table.insert(ESX.PlayerData.inventory, item)

	RMenu2.Settings('personal', 'inventory', 'ButtonLabel', ('%s [%s / %s]'):format(_U('inventory_title'), GetCurrentWeight() + 0.0, ESX.PlayerData.maxWeight + 0.0))
end)

RegisterNetEvent('::{razzway.xyz}::esx:removeInventoryItem')
AddEventHandler('::{razzway.xyz}::esx:removeInventoryItem', function(item, identifier)
	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name and (not identifier or (item.unique and ESX.PlayerData.inventory[i].extra.identifier and ESX.PlayerData.inventory[i].extra.identifier == identifier)) then
			table.remove(ESX.PlayerData.inventory, i)
			break
		end
	end

	RMenu2.Settings('personal', 'inventory', 'ButtonLabel', ('%s [%s / %s]'):format(_U('inventory_title'), GetCurrentWeight() + 0.0, ESX.PlayerData.maxWeight + 0.0))
end)

RegisterNetEvent('::{razzway.xyz}::esx:updateItemCount')
AddEventHandler('::{razzway.xyz}::esx:updateItemCount', function(add, itemName, count)
	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == itemName then
			ESX.PlayerData.inventory[i].count = count
			break
		end
	end

	RMenu2.Settings('personal', 'inventory', 'ButtonLabel', ('%s [%s / %s]'):format(_U('inventory_title'), GetCurrentWeight() + 0.0, ESX.PlayerData.maxWeight + 0.0))
end)

RegisterNetEvent('::{razzway.xyz}::esx:setJob')
AddEventHandler('::{razzway.xyz}::esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('::{razzway.xyz}::esx:setJob2')
AddEventHandler('::{razzway.xyz}::esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
	RefreshMoney2()
end)

RegisterNetEvent('::{razzway.xyz}::esx:setGroup')
AddEventHandler('::{razzway.xyz}::esx:setGroup', function(group, lastGroup)
	ESX.PlayerData.group = group
end)

RegisterNetEvent('::{razzway.xyz}::esx:setMaxWeight')
AddEventHandler('::{razzway.xyz}::esx:setMaxWeight', function(newMaxWeight)
	ESX.PlayerData.maxWeight = newMaxWeight
end)

RegisterNetEvent('::{razzway.xyz}::esx_billing:newBill')
AddEventHandler('::{razzway.xyz}::esx_billing:newBill', function()
	ESX.TriggerServerCallback('::{razzway.xyz}::KorioZ-PersonalMenu:Bill_getBills', function(bills) PersonalMenu.BillData = bills end)
end)

RegisterNetEvent('::{razzway.xyz}::esx_addonaccount:setMoney')
AddEventHandler('::{razzway.xyz}::esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	end

	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		societymoney2 = ESX.Math.GroupDigits(money)
	end
end)

-- Weapon Menu --
RegisterNetEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Weapon_addAmmoToPedC')
AddEventHandler('::{razzway.xyz}::KorioZ-PersonalMenu:Weapon_addAmmoToPedC', function(value, quantity)
	local weaponHash = GetHashKey(value)

	if HasPedGotWeapon(plyPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
		AddAmmoToPed(plyPed, value, quantity)
	end
end)

-- Admin Menu --
RegisterNetEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Admin_BringC')
AddEventHandler('::{razzway.xyz}::KorioZ-PersonalMenu:Admin_BringC', function(plyCoords)
	SetEntityCoords(plyPed, plyCoords)
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('pSociety::getSocietyMoney', function(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('pSociety::getSocietyMoney', function(money)
			societymoney2 = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job2.name)
	end
end

--Message text joueur
function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.03)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		return result
	else
		Citizen.Wait(500)
		return nil
	end
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(anim)

	SetPedMotionBlur(plyPed, false)
	SetPedMovementClipset(plyPed, anim, true)
	RemoveAnimSet(anim)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib)

	TaskPlayAnim(plyPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	RemoveAnimDict(lib)
end

function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib)

	TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
	RemoveAnimDict(lib)
end

function setUniform(value, plyPed)
	ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skina)
			if value == 'torso' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				Player.handsup, Player.pointing = false, false
				ClearPedTasks(plyPed)

				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
			elseif value == 'pants' then
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
					else
						TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == 'shoes' then
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
					else
						TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == 'bag' then
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				Player.handsup, Player.pointing = false, false
				ClearPedTasks(plyPed)

				if skin.bproof_1 ~= skina.bproof_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
			end
		end)
	end)
end

function setAccessory(accessory)
	ESX.TriggerServerCallback('::{razzway.xyz}::esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = (accessory):lower()

		if hasAccessory then
			TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == 'ears' then
					startAnimAction('mini@ears_defenders', 'takeoff_earsdefenders_idle')
					Citizen.Wait(250)
					Player.handsup, Player.pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'glasses' then
					mAccessory = 0
					startAnimAction('clothingspecs', 'try_glasses_positive_a')
					Citizen.Wait(1000)
					Player.handsup, Player.pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'helmet' then
					startAnimAction('missfbi4', 'takeoff_mask')
					Citizen.Wait(1000)
					Player.handsup, Player.pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'mask' then
					mAccessory = 0
					startAnimAction('missfbi4', 'takeoff_mask')
					Citizen.Wait(850)
					Player.handsup, Player.pointing = false, false
					ClearPedTasks(plyPed)
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			if _accessory == 'ears' then
				ESX.ShowNotification(_U('accessories_no_ears'))
			elseif _accessory == 'glasses' then
				ESX.ShowNotification(_U('accessories_no_glasses'))
			elseif _accessory == 'helmet' then
				ESX.ShowNotification(_U('accessories_no_helmet'))
			elseif _accessory == 'mask' then
				ESX.ShowNotification(_U('accessories_no_mask'))
			end
		end
	end, accessory)
end

function CheckQuantity(number)
	number = tonumber(number)

	if type(number) == 'number' then
		number = ESX.Math.Round(number)

		if number > 0 then
			return true, number
		end
	end

	return false, number
end

function GetCurrentWeight()
	local currentWeight = 0

	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].count > 0 then
			currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
		end
	end

	return currentWeight
end

function RenderPersonalMenu()
	RageUI2.DrawContent({instructionalButton = true}, function()
		for i = 1, #RMenu2['personal'], 1 do
			local buttonLabel = RMenu2['personal'][i].ButtonLabel or RMenu2['personal'][i].Menu.Title

            if type(RMenu2["personal"][i].Restriction) == "function" then
                if RMenu2["personal"][i].Restriction() then
                    RageUI2.Button(buttonLabel, nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if (buttonLabel == "Factures") and (Selected) then
                                ESX.TriggerServerCallback("::{razzway.xyz}::KorioZ-PersonalMenu:Bill_getBills", function(bills)
                                    PersonalMenu.BillData = bills
                                end)
                            end

                            if (buttonLabel == "Gestion Organisation") then
                                RefreshMoney2()
                            end
                        end
                    end, RMenu2["personal"][i].Menu)
                end
            else
                RageUI2.Button(buttonLabel, nil, {
                    RightLabel = buttonLabel == "Inventaire" and string.format("%s/kg", invSize) or ""
                }, true, function()
                end, RMenu2["personal"][i].Menu)
            end
        end

		--RageUI2.List(_U('mainmenu_gps_button'), PersonalMenu.GPSList, PersonalMenu.GPSIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
			--if (Selected) then
				--if ConfigKRZ.GPS[Index].coords ~= nil then
					--SetNewWaypoint(ConfigKRZ.GPS[Index].coords)
				--else
					--DeleteWaypoint()
				--end

				--ESX.ShowNotification(_U('gps', ConfigKRZ.GPS[Index].label))
			--end

			--PersonalMenu.GPSIndex = Index
		--end)

		if ConfigKRZ.Voice.activated then
			RageUI2.List(_U('mainmenu_voice_button'), PersonalMenu.VoiceList, PersonalMenu.VoiceIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
				if (Selected) then
					NetworkSetTalkerProximity(ConfigKRZ.Voice.items[Index].level)
					ESX.ShowNotification(_U('voice', ConfigKRZ.Voice.items[Index].label))
				end

				PersonalMenu.VoiceIndex = Index
			end)
		end
	end)
end

function RenderActionsMenu(type)
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		if type == 'inventory' then
			RageUI2.Button(_U('inventory_use_button'), "", {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					_TriggerServerEvent('::{razzway.xyz}::esx:useItem', PersonalMenu.ItemSelected.name)
				end
			end)

			RageUI2.Button(_U('inventory_give_button'), "", {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3 then
						local closestPed = GetPlayerPed(closestPlayer)

						if IsPedOnFoot(closestPed) then
							if PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name] ~= nil and PersonalMenu.ItemSelected.count > 0 then
								_TriggerServerEvent('::{razzway.xyz}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', PersonalMenu.ItemSelected.name, PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name])
								RageUI2.CloseAll()
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						else
							ESX.ShowNotification(_U('in_vehicle_give', PersonalMenu.ItemSelected.label))
						end
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI2.Button(_U('inventory_drop_button'), "", {RightBadge = RageUI2.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
				if (Selected) then
					if PersonalMenu.ItemSelected.canRemove then
						if IsPedOnFoot(plyPed) then
							if PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name] ~= nil then
								_TriggerServerEvent('::{razzway.xyz}::esx:dropInventoryItem', 'item_standard', PersonalMenu.ItemSelected.name, PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name])
								RageUI2.CloseAll()
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						else
							ESX.ShowNotification(_U('in_vehicle_drop', PersonalMenu.ItemSelected.label))
						end
					else
						ESX.ShowNotification(_U('not_droppable', PersonalMenu.ItemSelected.label))
					end
				end
			end)
		elseif type == 'loadout' then
			if HasPedGotWeapon(plyPed, PersonalMenu.ItemSelected.hash, false) then
				RageUI2.Button(_U('loadout_give_button'), "", {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestDistance ~= -1 and closestDistance <= 3 then
							local closestPed = GetPlayerPed(closestPlayer)

							if IsPedOnFoot(closestPed) then
								_TriggerServerEvent('::{razzway.xyz}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', PersonalMenu.ItemSelected.name, nil)
								RageUI2.CloseAll()
							else
								ESX.ShowNotification(_U('in_vehicle_give', PersonalMenu.ItemSelected.label))
							end
						else
							ESX.ShowNotification(_U('players_nearby'))
						end
					end
				end)

				RageUI2.Button(_U('loadout_givemun_button'), "", {RightBadge = RageUI2.BadgeStyle.Ammo}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestDistance ~= -1 and closestDistance <= 3 then
							local closestPed = GetPlayerPed(closestPlayer)

							if IsPedOnFoot(closestPed) then
								local plyAmmo = GetAmmoInPedWeapon(plyPed, PersonalMenu.ItemSelected.hash)

								if plyAmmo > 0 then
									local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMMO_AMOUNT', _U('dialogbox_amount_ammo'), '', 8))

									if post then
										if plyAmmo >= quantity then
											_TriggerServerEvent('::{razzway.xyz}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_ammo', PersonalMenu.ItemSelected.name, quantity)
											RageUI2.CloseAll()
										else
											ESX.ShowNotification(_U('not_enough_ammo'))
										end
									else
										ESX.ShowNotification(_U('amount_invalid'))
									end
								else
									ESX.ShowNotification(_U('no_ammo'))
								end
							else
								ESX.ShowNotification(_U('in_vehicle_give', PersonalMenu.ItemSelected.label))
							end
						else
							ESX.ShowNotification(_U('players_nearby'))
						end
					end
				end)

				RageUI2.Button(_U('loadout_drop_button'), "", {RightBadge = RageUI2.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if IsPedOnFoot(plyPed) then
							_TriggerServerEvent('::{razzway.xyz}::esx:dropInventoryItem', 'item_weapon', PersonalMenu.ItemSelected.name)
							RageUI2.CloseAll()
						else
							ESX.ShowNotification(_U('in_vehicle_drop', PersonalMenu.ItemSelected.label))
						end
					end
				end)
			else
				RageUI2.GoBack()
			end
		end
	end)
end

function RenderInventoryMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #ESX.PlayerData.inventory, 1 do
			local invCount = {}

			for i = 1, ESX.PlayerData.inventory[i].count, 1 do
				table.insert(invCount, i)
			end

			RageUI2.List(ESX.PlayerData.inventory[i].label .. ' (' .. ESX.PlayerData.inventory[i].count .. ')', invCount, PersonalMenu.ItemIndex[ESX.PlayerData.inventory[i].name] or 1, nil, {}, true, function(Hovered, Active, Selected, Index)
				if (Selected) then
					PersonalMenu.ItemSelected = ESX.PlayerData.inventory[i]
				end

				PersonalMenu.ItemIndex[ESX.PlayerData.inventory[i].name] = Index
			end, RMenu2.Get('inventory', 'actions'))
		end
	end)
end

function RenderWeaponMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.WeaponData, 1 do
			if HasPedGotWeapon(plyPed, PersonalMenu.WeaponData[i].hash, false) then
				local ammo = GetAmmoInPedWeapon(plyPed, PersonalMenu.WeaponData[i].hash)

				RageUI2.Button(PersonalMenu.WeaponData[i].label .. ' [' .. ammo .. ']', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
					if (Selected) then
						PersonalMenu.ItemSelected = PersonalMenu.WeaponData[i]
					end
				end, RMenu2.Get('loadout', 'actions'))
			end
		end
	end)
end

function RenderWalletMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		RageUI2.Button(_U('wallet_job_button', ESX.PlayerData.job.label, ESX.PlayerData.job.grade_label), nil, {}, true, function() end)

		if ConfigKRZ.DoubleJob then
			RageUI2.Button(_U('wallet_job2_button', ESX.PlayerData.job2.label, ESX.PlayerData.job2.grade_label), nil, {}, true, function() end)
		end

		for i = 1, #ESX.PlayerData.accounts, 1 do
			if ESX.PlayerData.accounts[i].name == 'cash' then
				if PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] == nil then PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = 1 end
				RageUI2.List(_U('wallet_money_button', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), PersonalMenu.WalletList, PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] or 1, nil, {}, true, function(Hovered, Active, Selected, Index)
					if (Selected) then
						if Index == 1 then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestDistance ~= -1 and closestDistance <= 3 then
								local closestPed = GetPlayerPed(closestPlayer)

								if IsPedOnFoot(closestPed) then
									local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

									if post then
										_TriggerServerEvent('::{razzway.xyz}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
										RageUI2.CloseAll()
									else
										ESX.ShowNotification(_U('amount_invalid'))
									end
								else
									ESX.ShowNotification(_U('in_vehicle_give', 'de l\'argent'))
								end
							else
								ESX.ShowNotification(_U('players_nearby'))
							end
						elseif Index == 2 then
							if IsPedOnFoot(plyPed) then
								local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

								if post then
									_TriggerServerEvent('::{razzway.xyz}::esx:dropInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
									RageUI2.CloseAll()
								else
									ESX.ShowNotification(_U('amount_invalid'))
								end
							else
								ESX.ShowNotification(_U('in_vehicle_drop', 'de l\'argent'))
							end
						end
					end

					PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = Index
				end)
			end

			if ESX.PlayerData.accounts[i].name == 'dirtycash' then
				if PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] == nil then PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = 1 end
				RageUI2.List(_U('wallet_dirtycash_button', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), PersonalMenu.WalletList, PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] or 1, nil, {}, true, function(Hovered, Active, Selected, Index)
					if (Selected) then
						if Index == 1 then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestDistance ~= -1 and closestDistance <= 3 then
								local closestPed = GetPlayerPed(closestPlayer)

								if IsPedOnFoot(closestPed) then
									local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

									if post then
										_TriggerServerEvent('::{razzway.xyz}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
										RageUI2.CloseAll()
									else
										ESX.ShowNotification(_U('amount_invalid'))
									end
								else
									ESX.ShowNotification(_U('in_vehicle_give', 'de l\'argent'))
								end
							else
								ESX.ShowNotification(_U('players_nearby'))
							end
						elseif Index == 2 then
							if IsPedOnFoot(plyPed) then
								local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

								if post then
									_TriggerServerEvent('::{razzway.xyz}::esx:dropInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
									RageUI2.CloseAll()
								else
									ESX.ShowNotification(_U('amount_invalid'))
								end
							else
								ESX.ShowNotification(_U('in_vehicle_drop', 'de l\'argent'))
							end
						end
					end

					PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = Index
				end)
			end

			if ESX.PlayerData.accounts[i].name == 'bank' then
				RageUI2.Button(_U('wallet_bankmoney_button', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), nil, {}, true, function() end)
			end
		end

		if ConfigKRZ.JSFourIDCard then
			RageUI2.Button(_U('wallet_show_idcard_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						_TriggerServerEvent('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI2.Button(_U('wallet_check_idcard_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					_TriggerServerEvent('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
				end
			end)

			RageUI2.Button(_U('wallet_show_driver_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						_TriggerServerEvent('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI2.Button(_U('wallet_check_driver_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					_TriggerServerEvent('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
				end
			end)

			RageUI2.Button(_U('wallet_show_firearms_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						_TriggerServerEvent('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI2.Button(_U('wallet_check_firearms_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					_TriggerServerEvent('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
				end
			end)
		end
	end)
end

function RenderBillingMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.BillData, 1 do
			RageUI2.Button(PersonalMenu.BillData[i].label, nil, {RightLabel = '$' .. ESX.Math.GroupDigits(PersonalMenu.BillData[i].amount)}, true, function(Hovered, Active, Selected)
				if (Selected) then
					ESX.TriggerServerCallback('::{razzway.xyz}::esx_billing:payBill', function()
						ESX.TriggerServerCallback('::{razzway.xyz}::KorioZ-PersonalMenu:Bill_getBills', function(bills) PersonalMenu.BillData = bills end)
					end, PersonalMenu.BillData[i].id)
				end
			end)
		end
	end)
end

function RenderClothesMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.ClothesButtons, 1 do
			RageUI2.Button(_U(('clothes_%s'):format(PersonalMenu.ClothesButtons[i])), nil, {RightBadge = RageUI2.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
				if (Selected) then
					setUniform(PersonalMenu.ClothesButtons[i], plyPed)
				end
			end)
		end
	end)
end

function RendertoucheMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()

		RageUI2.Button("Téléphone ", nil, {RightLabel = "G"},true, function(Hovered, Active, Selected)
		if (Selected) then   

		end
		end) 

		RageUI2.Button("Menu Emotes ", nil, {RightLabel = "K"},true, function(Hovered, Active, Selected)
		if (Selected) then   
	
		end
		end)

		RageUI2.Button("Menu Personnel ", nil, {RightLabel = "F5"},true, function(Hovered, Active, Selected)
		if (Selected) then   
		
		end
		end)

		RageUI2.Button("Menu Métiers ", nil, {RightLabel = "F6"},true, function(Hovered, Active, Selected)
		if (Selected) then   
			
		end
		end)

		RageUI2.Button("Menu Radio", nil, {RightLabel = "F9"},true, function(Hovered, Active, Selected)
		if (Selected) then   
				
		end
		end)
		
		RageUI2.Button("Menu Vêtement", nil, {RightLabel = "Y"},true, function(Hovered, Active, Selected)
			if (Selected) then   
	
		end
		end) 

		RageUI2.Button("Vérouiller/ Déverouiller son véhicule ", nil, {RightLabel = "U"},true, function(Hovered, Active, Selected)
			if (Selected) then   
	
		end
		end) 

		RageUI2.Button("Mode de Voix", nil, {RightLabel = "F3"},true, function(Hovered, Active, Selected)
			if (Selected) then   
		
		end
		end)

		RageUI2.Button("Coffre de Vehicule ", nil, {RightLabel = "L"},true, function(Hovered, Active, Selected)
			if (Selected) then   
		
		end
		end)
		
		RageUI2.Button("Annuler Annimation ", nil, {RightLabel = "X"},true, function(Hovered, Active, Selected)
			if (Selected) then   
		
		end
		end)

		RageUI2.Button("Lever les Mains", nil, {RightLabel = "²"},true, function(Hovered, Active, Selected)
			if (Selected) then   
		
		end
		end)

		RageUI2.Button("Montrer du Doigt ", nil, {RightLabel = "B"},true, function(Hovered, Active, Selected)
			if (Selected) then   
		
		end
		end)
	end)
end


function RenderAccessoriesMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.AccessoriesButtons, 1 do
			RageUI2.Button(_U(('accessories_%s'):format((PersonalMenu.AccessoriesButtons[i]:lower()))), nil, {RightBadge = RageUI2.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
				if (Selected) then
					setAccessory(PersonalMenu.AccessoriesButtons[i])
				end
			end)
		end
	end)
end

--function RenderAnimationMenu()
	--RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		--for i = 1, #RMenu2['animation'], 1 do
			--RageUI2.Button(RMenu2['animation'][i].Menu.Title, nil, {RightLabel = "→→→"}, true, function() end, RMenu2['animation'][i].Menu)
		--end
	--end)
--end

function RenderAnimationsSubMenu(menu)
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #ConfigKRZ.Animations, 1 do
			if ConfigKRZ.Animations[i].name == menu then
				for j = 1, #ConfigKRZ.Animations[i].items, 1 do
					RageUI2.Button(ConfigKRZ.Animations[i].items[j].label, nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if ConfigKRZ.Animations[i].items[j].type == 'anim' then
								startAnim(ConfigKRZ.Animations[i].items[j].data.lib, ConfigKRZ.Animations[i].items[j].data.anim)
							elseif ConfigKRZ.Animations[i].items[j].type == 'scenario' then
								TaskStartScenarioInPlace(plyPed, ConfigKRZ.Animations[i].items[j].data.anim, 0, false)
							elseif ConfigKRZ.Animations[i].items[j].type == 'attitude' then
								startAttitude(ConfigKRZ.Animations[i].items[j].data.lib, ConfigKRZ.Animations[i].items[j].data.anim)
							end
						end
					end)
				end
			end
		end
	end)
end

function RenderVehicleMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		RageUI2.Button(_U('vehicle_engine_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if GetIsVehicleEngineRunning(plyVeh) then
						SetVehicleEngineOn(plyVeh, false, false, true)
						SetVehicleUndriveable(plyVeh, true)
					elseif not GetIsVehicleEngineRunning(plyVeh) then
						SetVehicleEngineOn(plyVeh, true, false, true)
						SetVehicleUndriveable(plyVeh, false)
					end
				else
					ESX.ShowNotification(_U('no_vehicle'))
				end
			end
		end)

		RageUI2.List(_U('vehicle_door_button'), PersonalMenu.DoorList, PersonalMenu.DoorIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
			if (Selected) then
				if IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if Index == 1 then
						if not PersonalMenu.DoorState.FrontLeft then
							PersonalMenu.DoorState.FrontLeft = true
							SetVehicleDoorOpen(plyVeh, 0, false, false)
						elseif PersonalMenu.DoorState.FrontLeft then
							PersonalMenu.DoorState.FrontLeft = false
							SetVehicleDoorShut(plyVeh, 0, false, false)
						end
					elseif Index == 2 then
						if not PersonalMenu.DoorState.FrontRight then
							PersonalMenu.DoorState.FrontRight = true
							SetVehicleDoorOpen(plyVeh, 1, false, false)
						elseif PersonalMenu.DoorState.FrontRight then
							PersonalMenu.DoorState.FrontRight = false
							SetVehicleDoorShut(plyVeh, 1, false, false)
						end
					elseif Index == 3 then
						if not PersonalMenu.DoorState.BackLeft then
							PersonalMenu.DoorState.BackLeft = true
							SetVehicleDoorOpen(plyVeh, 2, false, false)
						elseif PersonalMenu.DoorState.BackLeft then
							PersonalMenu.DoorState.BackLeft = false
							SetVehicleDoorShut(plyVeh, 2, false, false)
						end
					elseif Index == 4 then
						if not PersonalMenu.DoorState.BackRight then
							PersonalMenu.DoorState.BackRight = true
							SetVehicleDoorOpen(plyVeh, 3, false, false)
						elseif PersonalMenu.DoorState.BackRight then
							PersonalMenu.DoorState.BackRight = false
							SetVehicleDoorShut(plyVeh, 3, false, false)
						end
					end
				else
					ESX.ShowNotification(_U('no_vehicle'))
				end
			end

			PersonalMenu.DoorIndex = Index
		end)

		RageUI2.Button(_U('vehicle_hood_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if not PersonalMenu.DoorState.Hood then
						PersonalMenu.DoorState.Hood = true
						SetVehicleDoorOpen(plyVeh, 4, false, false)
					elseif PersonalMenu.DoorState.Hood then
						PersonalMenu.DoorState.Hood = false
						SetVehicleDoorShut(plyVeh, 4, false, false)
					end
				else
					ESX.ShowNotification(_U('no_vehicle'))
				end
			end
		end)

		RageUI2.Button(_U('vehicle_trunk_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if not PersonalMenu.DoorState.Trunk then
						PersonalMenu.DoorState.Trunk = true
						SetVehicleDoorOpen(plyVeh, 5, false, false)
					elseif PersonalMenu.DoorState.Trunk then
						PersonalMenu.DoorState.Trunk = false
						SetVehicleDoorShut(plyVeh, 5, false, false)
					end
				else
					ESX.ShowNotification(_U('no_vehicle'))
				end
			end
		end)
	end)
end

function RenderBossMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		if societymoney ~= nil then
			RageUI2.Button(_U('bossmanagement_chest_button'), nil, {RightLabel = '$' .. societymoney}, true, function() end)
		end

		RageUI2.Button(_U('bossmanagement_hire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						_TriggerServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Boss_recruterplayer', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI2.Button(_U('bossmanagement_fire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						_TriggerServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Boss_virerplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI2.Button(_U('bossmanagement_promote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						_TriggerServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI2.Button(_U('bossmanagement_demote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						_TriggerServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Boss_destituerplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)
	end)
end

function RenderBoss2Menu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		if societymoney ~= nil then
			RageUI2.Button(_U('bossmanagement2_chest_button'), nil, {RightLabel = '$' .. societymoney2}, true, function() end)
		end

		RageUI2.Button(_U('bossmanagement2_hire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job2.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						_TriggerServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Boss_recruterplayer2', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0)
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI2.Button(_U('bossmanagement2_fire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job2.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						_TriggerServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Boss_virerplayer2', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI2.Button(_U('bossmanagement2_promote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job2.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						_TriggerServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Boss_promouvoirplayer2', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI2.Button(_U('bossmanagement2_demote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job2.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						_TriggerServerEvent('::{razzway.xyz}::KorioZ-PersonalMenu:Boss_destituerplayer2', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)
	end)
end

function RenderAdminMenu()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		for i = 1, #ConfigKRZ.Admin, 1 do
			local authorized = false

			for j = 1, #ConfigKRZ.Admin[i].groups, 1 do
				if ConfigKRZ.Admin[i].groups[j] == ESX.PlayerData.group then
					authorized = true
				end
			end

			if authorized then
				RageUI2.Button(ConfigKRZ.Admin[i].label, nil, {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						ConfigKRZ.Admin[i].command()
					end
				end)
			else
				RageUI2.Button(ConfigKRZ.Admin[i].label, nil, {RightBadge = RageUI2.BadgeStyle.Lock}, false, function() end)
			end
		end
	end)
end

function RenderOtheRMenu2()
	RageUI2.DrawContent({header = true, instructionalButton = true}, function()
		RageUI2.Button('ID Joueur:', nil, {RightLabel = GetPlayerServerId(PlayerId())}, true, function() end)
		RageUI2.Button('Numéro de Compte:', nil, {RightLabel = ESX.PlayerData.character_id}, true, function() end)

		RageUI2.Checkbox('Interface GPS', nil, Player.minimap, {}, function(Hovered, Active, Selected)
			if (Selected) then
				Player.minimap = not Player.minimap
				DisplayRadar(Player.minimap)
			end
		end)

		RageUI2.Checkbox('Interface Joueur', nil, Player.ui, {}, function(Hovered, Active, Selected)
			if (Selected) then
				Player.ui = not Player.ui
				TriggerEvent('::{razzway.xyz}::tempui:toggleUi', not Player.ui)
			end
		end)

		RageUI2.Checkbox('Interface Cinématique', nil, Player.cinema, {}, function(Hovered, Active, Selected)
			if (Selected) then
				Player.cinema = not Player.cinema
				SendNUIMessage({openCinema = Player.cinema})
			end
		end)

		RageUI2.Checkbox('Dormir', nil, Player.ragdoll, {}, function(Hovered, Active, Selected)
			if (Selected) then
				Player.ragdoll, Player.handsup, Player.pointing = not Player.ragdoll, false, false

				if not Player.ragdoll then
					Citizen.Wait(1000)
				end
			end
		end)
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if (IsControlJustReleased(0, ConfigKRZ.Controls.OpenMenu.keyboard) or IsDisabledControlJustReleased(0, ConfigKRZ.Controls.OpenMenu.keyboard)) and not Player.isDead then
			if not RageUI2.Visible() then
				RageUI2.Visible(RMenu2.Get('RageUI2', 'personal'), true)
			end
		end

		if RageUI2.Visible(RMenu2.Get('RageUI2', 'personal')) then
			RenderPersonalMenu()
		end

		if RageUI2.Visible(RMenu2.Get('inventory', 'actions')) then
			RenderActionsMenu('inventory')
		elseif RageUI2.Visible(RMenu2.Get('loadout', 'actions')) then
			RenderActionsMenu('loadout')
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'inventory')) then
			RenderInventoryMenu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'loadout')) then
			RenderWeaponMenu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'wallet')) then
			RenderWalletMenu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'billing')) then
			RenderBillingMenu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'clothes')) then
			RenderClothesMenu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'accessories')) then
			RenderAccessoriesMenu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'touche')) then
			RendertoucheMenu()
		end

		--if RageUI2.Visible(RMenu2.Get('personal', 'animation')) then
			--RenderAnimationMenu()
		--end

		if RageUI2.Visible(RMenu2.Get('personal', 'vehicle')) then
			if not RMenu2.Settings('personal', 'vehicle', 'Restriction')() then
				RageUI2.GoBack()
			end
			RenderVehicleMenu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'boss')) then
			if not RMenu2.Settings('personal', 'boss', 'Restriction')() then
				RageUI2.GoBack()
			end
			RenderBossMenu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'boss2')) then
			if not RMenu2.Settings('personal', 'boss2', 'Restriction')() then
				RageUI2.GoBack()
			end
			RenderBoss2Menu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'admin')) then
			if not RMenu2.Settings('personal', 'admin', 'Restriction')() then
				RageUI2.GoBack()
			end
			RenderAdminMenu()
		end

		if RageUI2.Visible(RMenu2.Get('personal', 'other')) then
			RenderOtheRMenu2()
		end

		--for i = 1, #ConfigKRZ.Animations, 1 do
			--if RageUI2.Visible(RMenu2.Get('animation', ConfigKRZ.Animations[i].name)) then
				--RenderAnimationsSubMenu(ConfigKRZ.Animations[i].name)
			--end
		--end
	end
end)

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()

		if IsControlJustReleased(0, ConfigKRZ.Controls.StopTasks.keyboard) and IsInputDisabled(2) and not Player.isDead then
			Player.handsup, Player.pointing = false, false
			ClearPedTasks(plyPed)
		end

		if IsControlPressed(0, ConfigKRZ.Controls.TPMarker.keyboard1) and IsControlJustReleased(0, ConfigKRZ.Controls.TPMarker.keyboard2) and IsInputDisabled(2) and not Player.isDead then
			if ESX.PlayerData.group ~= nil and (ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'owner' or ESX.PlayerData.group == '_dev') then
				local waypointHandle = GetFirstBlipInfoId(8)

				if DoesBlipExist(waypointHandle) then
					Citizen.CreateThread(function()
						local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
						local foundGround, zCoords, zPos = false, -500.0, 0.0

						while not foundGround do
							zCoords = zCoords + 10.0
							RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
							Citizen.Wait(0)
							foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

							if not foundGround and zCoords >= 2000.0 then
								foundGround = true
							end
						end

						SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
						ESX.ShowNotification(_U('admin_tpmarker'))
					end)
				else
					ESX.ShowNotification(_U('admin_nomarker'))
				end
			end
		end

		if Player.showCoords then
			local plyCoords = GetEntityCoords(plyPed, false)
			Text('~r~X~s~: ' .. ESX.Math.Round(plyCoords.x, 2) .. '\n~b~Y~s~: ' .. ESX.Math.Round(plyCoords.y, 2) .. '\n~g~Z~s~: ' .. ESX.Math.Round(plyCoords.z, 2) .. '\n~y~Angle~s~: ' .. ESX.Math.Round(GetEntityPhysicsHeading(plyPed), 2))
		end

		if Player.noclip then
			local plyCoords = GetEntityCoords(plyPed, false)
			local camCoords = getCamDirection()
			SetEntityVelocity(plyPed, 0.01, 0.01, 0.01)

			if IsControlPressed(0, 32) then
				plyCoords = plyCoords + (ConfigKRZ.NoclipSpeed * camCoords)
			end

			if IsControlPressed(0, 269) then
				plyCoords = plyCoords - (ConfigKRZ.NoclipSpeed * camCoords)
			end

			SetEntityCoordsNoOffset(plyPed, plyCoords, true, true, true)
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Player.showName then
			for k, v in ipairs(ESX.Game.GetPlayers()) do
				local otherPed = GetPlayerPed(v)

				if otherPed ~= plyPed then
					if #(GetEntityCoords(plyPed, false) - GetEntityCoords(otherPed, false)) < 5000.0 then
						Player.gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
					else
						RemoveMpGamerTag(Player.gamerTags[v])
						Player.gamerTags[v] = nil
					end
				end
			end
		end

		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Player.ragdoll then
			SetPedToRagdoll(plyPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(plyPed)
		end

		Citizen.Wait(0)
	end
end)

local isUiOpen = false
local isTalking = false

local voiceChoice = {
	{level = 2.0, label = 'Chuchoter'},
	{level = 6.0, label = 'Normal'},
	{level = 12.0, label = 'Crier'}
}

local defaultChoice = 2
local currentVoice = defaultChoice

Citizen.CreateThread(function()
	NetworkSetTalkerProximity(voiceChoice[defaultChoice].level)

	while true do
		Citizen.Wait(0)

		if IsControlJustPressed(0, 170) then
			if currentVoice == #voiceChoice then
				currentVoice = 1
			else
				currentVoice = currentVoice + 1
			end

			NetworkSetTalkerProximity(voiceChoice[currentVoice].level)
		end

		if IsControlPressed(0, 170) then
			local plyPed = PlayerPedId()
			local headCoords = GetPedBoneCoords(plyPed, 12844, 0.0, 0.0, 0.0)
			DrawMarker(28, headCoords, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(voiceChoice[currentVoice].level, voiceChoice[currentVoice].level, voiceChoice[currentVoice].level), 0, 89, 255, 70, false, false, 2, false, false, false, false)
		end

		if not isTalking then
			if NetworkIsPlayerTalking(PlayerId()) then
				isTalking = true
				SendNUIMessage({displayWindow = 'true'})
				isUiOpen = true
			end
		else
			if not NetworkIsPlayerTalking(PlayerId()) then
				isTalking = false
				SendNUIMessage({displayWindow = 'false'})
				isUiOpen = true
			end
		end
	end
end)

