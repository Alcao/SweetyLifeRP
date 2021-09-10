local HasAlreadyEnteredMarker = false
local LastZone                = nil

CurrentAction     = nil
CurrentActionMsg  = ''
CurrentActionData = {}

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'boat_shop' then
					if not ConfigBoat.LicenseEnable then
						OpenBoatShop(ConfigBoat.Zones.BoatShops[CurrentActionData.zoneNum])
					else -- check for license

						ESX.TriggerServerCallback('::{razzway.xyz}::esx_license:checkLicense', function(hasBoatLicense)
							if hasBoatLicense then
								OpenBoatShop(ConfigBoat.Zones.BoatShops[CurrentActionData.zoneNum])
							else
								OpenLicenceMenu(ConfigBoat.Zones.BoatShops[CurrentActionData.zoneNum])
							end
						end, GetPlayerServerId(PlayerId()), 'boat')
					end
				elseif CurrentAction == 'garage_out' then
					OpenBoatGarage(ConfigBoat.Zones.Garages[CurrentActionData.zoneNum])
				elseif CurrentAction == 'garage_in' then
					StoreBoatInGarage(CurrentActionData.vehicle, ConfigBoat.Zones.Garages[CurrentActionData.zoneNum].StoreTP)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('::{razzway.xyz}::esx_boat:hasEnteredMarker', function(zone, zoneNum)
	if zone == 'boat_shop' then
		CurrentAction     = 'boat_shop'
		CurrentActionMsg  = _U('boat_shop_open')
		CurrentActionData = { zoneNum = zoneNum }
	elseif zone == 'garage_out' then
		CurrentAction     = 'garage_out'
		CurrentActionMsg  = _U('garage_open')
		CurrentActionData = { zoneNum = zoneNum }
	elseif zone == 'garage_in' then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
	
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
	
			if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
				CurrentAction     = 'garage_in'
				CurrentActionMsg  = _U('garage_store')
				CurrentActionData = { vehicle = vehicle, zoneNum = zoneNum }
			end
		end
	end
end)

AddEventHandler('::{razzway.xyz}::esx_boat:hasExitedMarker', function()
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local isInMarker, hasExited, letSleep = false, false, true
		local currentZone, currentZoneNum

		for i=1, #ConfigBoat.Zones.BoatShops, 1 do
			local distance = GetDistanceBetweenCoords(coords, ConfigBoat.Zones.BoatShops[i].Outside, true)

			--if distance < ConfigBoat.DrawDistance then
				--DrawMarker(ConfigBoat.MarkerType, ConfigBoat.Zones.BoatShops[i].Outside, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfigBoat.Marker.x, ConfigBoat.Marker.y, ConfigBoat.Marker.z, ConfigBoat.Marker.r, ConfigBoat.Marker.g, ConfigBoat.Marker.b, 100, false, true, 2, false, nil, nil, false)
				--letSleep = false
			--end

			if distance < ConfigBoat.Marker.x then
				isInMarker     = true
				currentZone    = 'boat_shop'
				currentZoneNum = i
			end
		end

		for i=1, #ConfigBoat.Zones.Garages, 1 do
			local distance = GetDistanceBetweenCoords(coords, ConfigBoat.Zones.Garages[i].GaragePos, true)

			if distance < ConfigBoat.DrawDistance then
				DrawMarker(ConfigBoat.MarkerType, ConfigBoat.Zones.Garages[i].GaragePos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfigBoat.Marker.x, ConfigBoat.Marker.y, ConfigBoat.Marker.z, ConfigBoat.Marker.r, ConfigBoat.Marker.g, ConfigBoat.Marker.b, 100, false, true, 2, false, nil, nil, false)
				letSleep = false
			end

			if distance < ConfigBoat.Marker.x then
				isInMarker     = true
				currentZone    = 'garage_out'
				currentZoneNum = i
			end

			distance = GetDistanceBetweenCoords(coords, ConfigBoat.Zones.Garages[i].StorePos, true)

			if distance < ConfigBoat.DrawDistance then
				DrawMarker(ConfigBoat.MarkerType, ConfigBoat.Zones.Garages[i].StorePos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfigBoat.StoreMarker.x, ConfigBoat.StoreMarker.y, ConfigBoat.StoreMarker.z, ConfigBoat.StoreMarker.r, ConfigBoat.StoreMarker.g, ConfigBoat.StoreMarker.b, 100, false, true, 2, false, nil, nil, false)
				letSleep = false
			end

			if distance < ConfigBoat.StoreMarker.x then
				isInMarker     = true
				currentZone    = 'garage_in'
				currentZoneNum = i
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastZone ~= currentZone or LastZoneNum ~= currentZoneNum)) then
			if
				(LastZone ~= nil and LastZoneNum ~= nil) and
				(LastZone ~= currentZone or LastZoneNum ~= currentZoneNum)
			then
				TriggerEvent('::{razzway.xyz}::esx_boat:hasExitedMarker', LastZone)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			LastZoneNum = currentZoneNum

			TriggerEvent('::{razzway.xyz}::esx_boat:hasEnteredMarker', currentZone, currentZoneNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('::{razzway.xyz}::esx_boat:hasExitedMarker')
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Blips
Citizen.CreateThread(function()
	local blipList = {}

	for i=1, #ConfigBoat.Zones.Garages, 1 do
		table.insert(blipList, {
			coords = ConfigBoat.Zones.Garages[i].GaragePos,
			text   = _U('blip_garage'),
			sprite = 356,
			color  = 3,
			scale  = 0.6
		})
	end

	for i=1, #ConfigBoat.Zones.BoatShops, 1 do
		table.insert(blipList, {
			coords = ConfigBoat.Zones.BoatShops[i].Outside,
			text   = _U('blip_shop'),
			sprite = 427,
			color  = 3,
			scale  = 0.6
		})
	end

	for i=1, #blipList, 1 do
		CreateBlip(blipList[i].coords, blipList[i].text, blipList[i].sprite, blipList[i].color, blipList[i].scale)
	end
end)

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(coords.x, coords.y)

	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)

	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    local hash = GetHashKey("a_m_y_business_02")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
	end
	ped = CreatePed("PED_TYPE_CIVMALE", "a_m_y_business_02", -760.11, -1490.91, 4.0, 292.6, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
end)

local v1 = vector3(-760.11, -1490.91, 4.0)

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

local distance = 20

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Vdist2(GetEntityCoords(PlayerPedId(), false), v1) < distance then
            Draw3DText(v1.x,v1.y,v1.z, "Parler au vendeur")
        end
	end
end)
