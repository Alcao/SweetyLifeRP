-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local playerCars = {}
local KeyFobHash = `p_car_keys_01`

function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

local sMenu = {}
RMenu.Add('smenu', 'main', RageUI.CreateMenu("Clés", "~b~Effectuez vos actions"))
RMenu.Add('smenu', 'donnerv', RageUI.CreateSubMenu(RMenu:Get('smenu', 'main'), "Faites vos actions", "~b~Donner le véhicule"))
RMenu.Add('smenu', 'preterk', RageUI.CreateSubMenu(RMenu:Get('smenu', 'main'), "Faites vos actions", "~b~Prêter les clées"))
RMenu.Add('smenu', 'jeterc', RageUI.CreateSubMenu(RMenu:Get('smenu', 'main'), "Faites vos actions", "~b~Jeter les clées"))
RMenu:Get('smenu', 'main').EnableMouse = false
RMenu:Get('smenu', 'main').Closed = function() sMenu.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function ShowSerrurierMenu()
	ESX.TriggerServerCallback('::{razzway.xyz}::esx_vehiclelock:allkey', function(mykey)
		local elements = {}
		if sMenu.Menu then
			sMenu.Menu = false
		else
			sMenu.Menu = true
			RageUI.Visible(RMenu:Get('smenu', 'main'), true)
			--FreezeEntityPosition(GetPlayerPed(-1), true)
			Citizen.CreateThread(function()
				while sMenu.Menu do
					RageUI.IsVisible(RMenu:Get('smenu', 'main'), true, true, true, function()
						RageUI.ButtonWithStyle("Donner les clées", nil, {RightLabel = "→"}, true, function(h,a,s)
						end,RMenu:Get("smenu","donnerv"))
						RageUI.ButtonWithStyle("Prêter les clées", nil, {RightLabel = "→"}, true, function(h,a,s)
						end,RMenu:Get("smenu","preterk"))
						RageUI.ButtonWithStyle("Jeter les clées", nil, {RightLabel = "→"}, true, function(h,a,s)
						end,RMenu:Get("smenu","jeterc"))
					end)

					RageUI.IsVisible(RMenu:Get('smenu', 'donnerv'), true, true, true, function()
						for i = 1, #mykey, 1 do
							local player, distance = ESX.Game.GetClosestPlayer()
							local playerPed = PlayerPedId()
							local plyCoords = GetEntityCoords(playerPed, false)
							local vehicle = GetClosestVehicle(plyCoords, 7.0, 0, 71)
							local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
							local vehPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
							local value = mykey[i].plate
							if mykey[i].NB == 1 then
								RageUI.ButtonWithStyle("Clée du véhicule:"..mykey[i].plate, nil, {RightLabel = "Donner"}, true, function(h,a,s)
									if s then
										if vehicle ~= nil and vehPlate == value then
											if distance ~= -1 and distance <= 3.0 then
												_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:changeowner', GetPlayerServerId(player), vehPlate, vehicleProps)
												--RageUI.CloseAll()
												--FreezeEntityPosition(GetPlayerPed(-1), false)
											else
												ESX.ShowNotification("Aucun joueur à proximité")
											end
										else
											ESX.ShowNotification("~b~Véhicule~s~ \nAucun véhicule étant attribué à ces clés à proximité.")
										end
									end
								end)
							elseif mykey[i].NB == 2 then
								RageUI.ButtonWithStyle("[DOUBLE] Clée du véhicule:"..mykey[i].plate, nil, {RightLabel = "Donner"}, true, function(h,a,s)
									if s then
										if vehicle ~= nil and vehPlate == value then
											if distance ~= -1 and distance <= 3.0 then
												_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:changeowner', GetPlayerServerId(player), vehPlate, vehicleProps)
												--RageUI.CloseAll()
											--	FreezeEntityPosition(GetPlayerPed(-1), false)
											else
												ESX.ShowNotification("Aucun joueur à proximité")
											end
										else
											ESX.ShowNotification("~b~Véhicule~s~ \nAucun véhicule étant attribué à ces clés à proximité.")
										end
									end
								end)
							end
						end
					end)

					RageUI.IsVisible(RMenu:Get('smenu', 'preterk'), true, true, true, function()
						for i = 1, #mykey, 1 do
							local player, distance = ESX.Game.GetClosestPlayer()
							local playerPed = PlayerPedId()
							local plyCoords = GetEntityCoords(playerPed, false)
							local vehicle = GetClosestVehicle(plyCoords, 7.0, 0, 71)
							local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
							local vehPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
							local value = mykey[i].plate
							if mykey[i].NB == 1 then
								RageUI.ButtonWithStyle("Clée du véhicule:"..mykey[i].plate, nil, {RightLabel = "Prêter"}, true, function(h,a,s)
									if s then
										--if vehicle ~= nil and vehPlate == value then
											if distance ~= -1 and distance <= 3.0 then
												_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:preterkey', GetPlayerServerId(player), value)
											--	RageUI.CloseAll()
											--	FreezeEntityPosition(GetPlayerPed(-1), false)
											else
												ESX.ShowNotification("Aucun joueur à proximité")
											end
										--else
										--	ESX.ShowNotification("~b~Véhicule~s~ \nAucun véhicule étant attribué à ces clés à proximité.")
										--end
									end
								end)
							elseif mykey[i].NB == 2 then
								RageUI.ButtonWithStyle("[DOUBLE] Clée du véhicule:"..mykey[i].plate, nil, {RightLabel = "Donner"}, true, function(h,a,s)
									if s then
										--if vehicle ~= nil and vehPlate == value then
											if distance ~= -1 and distance <= 3.0 then
												_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:preterkey', GetPlayerServerId(player), value)
												--RageUI.CloseAll()
												--FreezeEntityPosition(GetPlayerPed(-1), false)
											else
												ESX.ShowNotification("Aucun joueur à proximité")
											end
										--else
										--	ESX.ShowNotification("~b~Véhicule~s~ \nAucun véhicule étant attribué à ces clés à proximité.")
										--end
									end
								end)
							end
						end
					end)

					RageUI.IsVisible(RMenu:Get('smenu', 'jeterc'), true, true, true, function()
						for i = 1, #mykey, 1 do
							local player, distance = ESX.Game.GetClosestPlayer()
							local playerPed = PlayerPedId()
							local plyCoords = GetEntityCoords(playerPed, false)
							local vehicle = GetClosestVehicle(plyCoords, 7.0, 0, 71)
							local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
							local vehPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
							local value = mykey[i].plate
							if mykey[i].NB == 1 then
								RageUI.ButtonWithStyle("Clée du véhicule:"..mykey[i].plate, nil, {RightLabel = "Jeter"}, true, function(h,a,s)
									if s then
										--if vehicle ~= nil and vehPlate == value then
											--if distance ~= -1 and distance <= 3.0 then
												_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:deletekey', value)
												RageUI.CloseAll()
												FreezeEntityPosition(GetPlayerPed(-1), false)
											--else
											--	ESX.ShowNotification("Aucun joueur à proximité")
											--end
										--else
											--ESX.ShowNotification("~b~Véhicule~s~ \nAucun véhicule étant attribué à ces clés à proximité.")
										--end
									end
								end)
							elseif mykey[i].NB == 2 then
								RageUI.ButtonWithStyle("[DOUBLE] Clée du véhicule:"..mykey[i].plate, nil, {RightLabel = "Donner"}, true, function(h,a,s)
									if s then
										--if vehicle ~= nil and vehPlate == value then
											--if distance ~= -1 and distance <= 3.0 then
												_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:deletekey', value)
												RageUI.CloseAll()
												FreezeEntityPosition(GetPlayerPed(-1), false)
											--else
											--	ESX.ShowNotification("Aucun joueur à proximité")
											--end
										--else
										--	ESX.ShowNotification("~b~Véhicule~s~ \nAucun véhicule étant attribué à ces clés à proximité.")
										--end
									end
								end)
							end
						end
					end)
					Wait(1)
				end
			end)
		end
	--for i = 1, #mykey, 1 do
		--	if mykey[i].NB == 1 then
		--		table.insert(elements, {label = 'Clés : '.. ' [' .. mykey[i].plate .. ']', value = mykey[i].plate})
		--	elseif mykey[i].NB == 2 then
		--		table.insert(elements, {label = '[DOUBLE] Véhicule : '.. ' [' .. mykey[i].plate .. ']', value = nil})
		--	end
		--end

		--[[ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mykey', {
			title = '~b~Gestion des Clés',
			elements = elements
		}, function(data2, menu2)
			if data2.current.value ~= nil then
				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mykey', {
					title = '~b~Actions des Clés',
					elements = {
						{label = 'Donner le véhicule + Clés', value = 'donnerkey'},
						{label = '~y~Préter les clés', value = 'preterkey'},
						{label = '~r~Jeter les clés', value = 'jeterkey'}
					}
				}, function(data3, menu3)
					local player, distance = ESX.Game.GetClosestPlayer()
					local playerPed = PlayerPedId()
					local plyCoords = GetEntityCoords(playerPed, false)
					local vehicle = GetClosestVehicle(plyCoords, 7.0, 0, 71)
					local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
					local vehPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

					if data3.current.value == 'donnerkey' then
						if vehicle ~= nil and vehPlate == data2.current.value then
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
								title = "DONNER",
								elements = {
									{label = "Non", value = 'no'},
									{label = "Oui", value = 'yes'}
								}
							}, function(data4, menu4)
								if data4.current.value == 'yes' then
									if distance ~= -1 and distance <= 3.0 then
										_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:changeowner', GetPlayerServerId(player), vehPlate, vehicleProps)
										ESX.UI.Menu.CloseAll()
									else
										ESX.ShowNotification("Aucun joueur à proximité")
									end
								end

								menu4.close()
							end, function(data4, menu4)
							end)
						else
							ESX.ShowNotification("~b~Véhicule~s~ \nAucun véhicule étant attribué à ces clés à proximité.")
						end
					end

					if data3.current.value == 'preterkey' then
						if distance ~= -1 and distance <= 3.0 then 
							_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:preterkey', GetPlayerServerId(player), data2.current.value)
							ESX.UI.Menu.CloseAll()
						else
							ESX.ShowNotification("Aucun joueur à proximité")
						end
					end

					if data3.current.value == 'jeterkey' then
						_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:deletekey', data2.current.value)
						ESX.UI.Menu.CloseAll()
					end
				end, function(data3, menu3)
				end)
			end
		end, function(data2, menu2)
		end)]]
	end)
end

AddEventHandler('::{razzway.xyz}::esx_vehiclelock:hasEnteredMarker', function(zone)
	CurrentAction = 'Serrurier'
	CurrentActionMsg = 'Serrurier'
	CurrentActionData = {zone = zone}
end)

AddEventHandler('::{razzway.xyz}::esx_vehiclelock:hasExitedMarker', function(zone)
	CurrentAction = nil
	RageUI.CloseAll()
end)

function OpenCloseVehicle()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)
	local vehicle, inveh = nil, false

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
		inveh = true
	else
		vehicle = GetClosestVehicle(coords, 7.0, 0, 71)
	end

	ESX.TriggerServerCallback('::{razzway.xyz}::esx_vehiclelock:mykey', function(gotkey)
		if gotkey then
			local locked = GetVehicleDoorLockStatus(vehicle)

			if not inveh then
				local plyPed = PlayerPedId()

				ESX.Streaming.RequestAnimDict("anim@mp_player_intmenu@key_fob@")

				ESX.Game.SpawnObject(KeyFobHash, vector3(0.0, 0.0, 0.0), function(object)
					SetEntityCollision(object, false, false)
					AttachEntityToEntity(object, plyPed, GetPedBoneIndex(plyPed, 57005), 0.09, 0.03, -0.02, -76.0, 13.0, 28.0, false, true, true, true, 0, true)

					SetCurrentPedWeapon(plyPed, `WEAPON_UNARMED`, true)
					ClearPedTasks(plyPed)
					TaskTurnPedToFaceEntity(plyPed, vehicle, 500)

					TaskPlayAnim(plyPed, "anim@mp_player_intmenu@key_fob@", "fob_click", 3.0, 3.0, 1000, 16)
					RemoveAnimDict("anim@mp_player_intmenu@key_fob@")
					PlaySoundFromEntity(-1, "Remote_Control_Fob", vehicle, "PI_Menu_Sounds", true, 0)
					Citizen.Wait(1250)

					DetachEntity(object, false, false)
					DeleteObject(object)
				end)
			end

			if locked == 1 or locked == 0 then
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
			elseif locked == 2 then
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
			end
		else
			ESX.ShowNotification("~r~Vous ne possédez pas les clés de ce véhicule.")
		end
	end, GetVehicleNumberPlateText(vehicle))
end

local sRegister = {}
RMenu.Add('sregister', 'main', RageUI.CreateMenu("Faire ses clés", "~b~Enregitrez une paire de clé"))
RMenu:Get('sregister', 'main').EnableMouse = false
RMenu:Get('sregister', 'main').Closed = function() sRegister.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
function OpenSerrurierMenu()
	ESX.TriggerServerCallback('::{razzway.xyz}::esx_vehiclelock:getVehiclesnokey', function(Vehicles2)
	if sRegister.Menu then
		sRegister.Menu = false
	else
		sRegister.Menu = true
		RageUI.Visible(RMenu:Get('sregister', 'main'), true)
		FreezeEntityPosition(GetPlayerPed(-1), true)

		Citizen.CreateThread(function()
			while sRegister.Menu do
				--ESX.TriggerServerCallback('::{razzway.xyz}::esx_vehiclelock:getVehiclesnokey', function(Vehicles2)
					RageUI.IsVisible(RMenu:Get('sregister', 'main'), true, true, true, function()
						--ESX.TriggerServerCallback('::{razzway.xyz}::esx_vehiclelock:getVehiclesnokey', function(Vehicles2)
							local elements = {}
							if Vehicles2 == nil then
								RageUI.ButtonWithStyle("Aucun véhicule sans clé", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(h,a,s)
									if s then
									end
								end)
							else
								for i = 1, #Vehicles2, 1 do
									--if Vehicles2 == nil then
									--	RageUI.ButtonWithStyle("Aucun véhicule sans clé", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(h,a,s)
										--	if s then
										--	end
										---end)
									--else
									model = Vehicles2[i].model
									modelname = GetDisplayNameFromVehicleModel(model)
									value = GetLabelText(modelname)
									label = Vehicles2[i].model
									value = Vehicles2[i].plate
									RageUI.ButtonWithStyle("Véhicule: "..modelname, nil, {RightLabel = "→"}, true, function(h,a,s)
										if s then
											_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:registerkey', value, 'no')
											FreezeEntityPosition(GetPlayerPed(-1), false)
											RageUI.CloseAll()
										end
									end)
								end
							--for i = 1, #Vehicles2, 1 do
							--end
							--if Vehicles2 == nil then
							--else
								--RageUI.ButtonWithStyle("Véhicule: "..modelname, nil, {RightLabel = "→"}, true, function(h,a,s)
								--	if s then
								--		_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:registerkey', value, 'no')
								--		FreezeEntityPosition(GetPlayerPed(-1), false)
							--			RageUI.CloseAll()
							------		end
							--	end)
							end
						--end)
					end)
				--end)
				Wait(1)
			end
		end)
	end
end)
	--[[ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'GetKey', {
		title = '~b~Bienvenue chez le serrurier',
		elements = {
			{label = ('Enregistrer une nouvelle paire de clé'), value = 'registerkey'}
		}
	}, function(data, menu)
		if data.current.value == 'registerkey' then
			ESX.TriggerServerCallback('::{razzway.xyz}::esx_vehiclelock:getVehiclesnokey', function(Vehicles2)
				local elements = {}

				if Vehicles2 == nil then
					table.insert(elements, {label = 'Aucun véhicule sans clés ', value = nil})
				else
					for i = 1, #Vehicles2, 1 do
						model = Vehicles2[i].model
						modelname = GetDisplayNameFromVehicleModel(model)
						Vehicles2[i].model = GetLabelText(modelname)
					end

					for i = 1, #Vehicles2, 1 do
						table.insert(elements, {label = Vehicles2[i].model .. ' [' .. Vehicles2[i].plate .. ']', value = Vehicles2[i].plate})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'backey', {
						title = 'Nouvelle clés',
						elements = elements
					}, function(data2, menu2)
						menu2.close()
						_TriggerServerEvent('::{razzway.xyz}::esx_vehiclelock:registerkey', data2.current.value, 'no')
					end, function(data2, menu2)
					end)
				end
			end)
		end
	end, function(data, menu)
	end)]]
end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(ConfigVehicleLock.Zones.place.Pos.x, ConfigVehicleLock.Zones.place.Pos.y, ConfigVehicleLock.Zones.place.Pos.z)

	SetBlipSprite(blip, 134)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipColour(blip, 3)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName('Serrurier')
	EndTextCommandSetBlipName(blip)
end)

local SerruR = {
    {x = 170.28, y = -1799.53, z = 28.34}
}  

Citizen.CreateThread(function()
    while true do
        local razzou = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(SerruR) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, SerruR[k].x, SerruR[k].y, SerruR[k].z)
            if not sRegister.Menu then
                if distance <= 10.0 then
                    razzou = 1
                    Draw3DText(SerruR[k].x, SerruR[k].y, 29.8, "Appuyez sur ~b~E~s~ pour accéder au ~b~serrurier")
                    DrawMarker(6, SerruR[k].x, SerruR[k].y, SerruR[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                
                    if distance <= 1.5 then
                        ShowHelpNotification("Appuyez sur ~b~E~s~ pour ouvrir le menu")
                        if IsControlJustPressed(0, 51) then
                            OpenSerrurierMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)


Keys.Register('F2','F2', 'Gestion des clés', function()
    ShowSerrurierMenu()
end)