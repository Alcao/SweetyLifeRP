Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

local state = false

Citizen.CreateThread(function()
    for k,v in pairs(garagepublic.zone["Sortir"]) do
        local blip = AddBlipForCoord(v.sortie.x, v.sortie.y, v.sortie.z)
        SetBlipSprite(blip, 290)
        SetBlipColour(blip, 3)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("[Public] Garage")
        EndTextCommandSetBlipName(blip)
    end

    for k,v in pairs(garagepublic.fourriere) do
        local blip = AddBlipForCoord(v.sortie.x, v.sortie.y, v.sortie.z)
        SetBlipSprite(blip, 67)
        SetBlipColour(blip, 64)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Fourrière")
        EndTextCommandSetBlipName(blip)
    end
end)

--vehicule fourriere
local publicfourriere = false
RMenu.Add('garagepublicfourriere', 'main', RageUI.CreateMenu("Fourrière", "Récupérer vos véhicules"))
RMenu:Get('garagepublicfourriere', 'main').Closed = function()
    publicfourriere = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function ouvrirpublicfourr()
    FreezeEntityPosition(PlayerPedId(), true)
    ESX.TriggerServerCallback('::{razzway.xyz}::sweety_garage:getOutVehicles', function(vehicles)
    if not publicfourriere then
        publicfourriere = true
        RageUI.Visible(RMenu:Get('garagepublicfourriere', 'main'), true)
    while publicfourriere do
        RageUI.IsVisible(RMenu:Get('garagepublicfourriere', 'main'), true, true, true, function()
        for _,v in pairs(vehicles) do
       -- for i = 1, #alcao.listefourriere, 1 do
            local hashvoiture = v.vehicle.model
            local modelevoiturespawn = v.vehicle
            local nomvoituremodele = GetDisplayNameFromVehicleModel(hashvoiture)
            local nomvoituretexte  = GetLabelText(nomvoituremodele)
            local plaque = v.plate
            --FreezeEntityPosition(PlayerPedId(), true)
            RageUI.ButtonWithStyle(plaque.." | "..nomvoituremodele, "Pour sortir votre véhicule", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                ESX.TriggerServerCallback('::{razzway.xyz}::garage::verifsous', function(suffisantsous)
				if suffisantsous then
					TriggerServerEvent('::{razzway.xyz}::garage::payechacal')
					sortirvoiture(modelevoiturespawn, plaque)
                    ESX.ShowNotification('~b~Garage\n~w~Le véhicule à été sortit de la fourrière | Plaque : ~b~' ..plaque..'')
                    RageUI.CloseAll()
                    publicfourriere = false
				else
					ESX.ShowNotification('Tu n\'as pas assez d argent!')
				end

			end)
            end
            end)
      --  end
        end
        end, function()
        end)
            Citizen.Wait(0)
        end
    else
        --FreezeEntityPosition(PlayerPedId(), false)
        publicfourriere = false
    end
    end)
end

--sortir véhicule
local publicgarage = false
RMenu.Add('garagepublic', 'main', RageUI.CreateMenu("Garage Véhicule", "~b~Liste de vos véhicules"))
RMenu:Get('garagepublic', 'main').Closed = function()
    publicgarage = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function ouvrirpublicgar()
    FreezeEntityPosition(PlayerPedId(), true)
    ESX.TriggerServerCallback('::{razzway.xyz}::sweety_garage:getVehicles', function(ownedCars)
    if not publicgarage then
        publicgarage = true
        RageUI.Visible(RMenu:Get('garagepublic', 'main'), true)
    while publicgarage do
        RageUI.IsVisible(RMenu:Get('garagepublic', 'main'), true, true, true, function()

        --ESX.TriggerServerCallback('::{razzway.xyz}::sweety_garage:getVehicles', function(ownedCars)
            --for k, v in pairs(ownedCars) do
            for k, v in pairs(ownedCars) do
            --for i = 1, #alcao.listevoiture, 1 do
        	    local hashvoiture = v.vehicle.model
        	    local modelevoiturespawn = v.vehicle
        	    local nomvoituremodele = GetDisplayNameFromVehicleModel(hashvoiture)
        	    local nomvoituretexte  = GetLabelText(nomvoituremodele)
        	    local plaque = v.plate

                if v.state then
                    RageUI.ButtonWithStyle(""..nomvoituremodele.." (~b~"..plaque.."~s~)", nil, {RightLabel = "~g~Entrée~s~ →"}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RageUI.CloseAll()
                            sortirvoiture(modelevoiturespawn, plaque)
                            ESX.ShowNotification('~b~Garage\n~w~Ton véhicule ~b~'..nomvoituremodele..'~s~ a été sortit du garage (~b~' ..plaque..'~s~)')
                        end
                    end)
                else
                    RageUI.ButtonWithStyle(""..nomvoituremodele.." (~b~"..plaque.."~s~)", nil, {RightLabel = "~r~Sortie~s~ →"}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                        end
                    end)
                end
            --end
            end
            --end
        --end)

        end, function()
        end)
            Citizen.Wait(0)
        end
    else
        publicgarage = false
        --publicgaragepreview = false
    end
    end)
end

-- faire spawn voiture
function sortirvoiture(vehicle, plate)
	x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = x,
		y = y,
		z = z 
	}, GetEntityHeading(PlayerPedId()), function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleFixed(callback_vehicle)
		SetVehicleDeformationFixed(callback_vehicle)
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		--SetVehicleEngineHealth(callback_vehicle, 1000) -- Might not be needed
		--SetVehicleBodyHealth(callback_vehicle, 1000) -- Might not be needed
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
        FreezeEntityPosition(PlayerPedId(), false)
	end)

	TriggerServerEvent('::{razzway.xyz}::sweety_garage:modifystate', vehicle, false)
end

--ranger voiture
function rangervoiture()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed    = GetPlayerPed(-1)
		local coords       = GetEntityCoords(playerPed)
		local vehicle      = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current 	   = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate        = vehicleProps.plate

		ESX.TriggerServerCallback('::{razzway.xyz}::garage::rangervoiture', function(valid)
			if valid then
					etatrangervoiture(vehicle, vehicleProps)
			else
				ESX.ShowNotification("~r~Attention! Il semblerait que ce véhicule ne t'appartienne pas.")
			end
		end, vehicleProps)
	else
		ESX.ShowNotification('Il n y a pas de véhicule à ranger dans le garage.')
	end
end

function etatrangervoiture(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('::{razzway.xyz}::sweety_garage:modifystateRanger', vehicleProps, true)
	ESX.ShowNotification('~b~Garage\n~w~Ton véhicule ~b~'..nomvoituremodele..'~s~ a été rangé dans le garage (~b~' ..plaque..'~s~)')
end

Citizen.CreateThread(function()
    while true do
        local razzou = 850

        for k,v in pairs(garagepublic.zone["Sortir"]) do
        
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.sortie.x, v.sortie.y, v.sortie.z)

            if dist <= 25.0 then
                DrawMarker(garagepublic.Type, v.sortie.x, v.sortie.y, v.sortie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, garagepublic.Size.x, garagepublic.Size.y, garagepublic.Size.z, garagepublic.Color.r, garagepublic.Color.g, garagepublic.Color.b, 100, false, true, 2, false, false, false, false)
                razzou = 1
            end

            if dist <= 5.0 then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    DrawMarker(garagepublic.Type, v.sortie.x, v.sortie.y, v.sortie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, garagepublic.Size.x, garagepublic.Size.y, garagepublic.Size.z, garagepublic.Color.r, garagepublic.Color.g, garagepublic.Color.b, 100, false, true, 2, false, false, false, false)
                    razzou = 1
                    if IsControlJustPressed(1,51) then
                    end
                elseif not IsPedInAnyVehicle(PlayerPedId(), false) then
                    razzou = 1
                    DrawMarker(garagepublic.Type, v.sortie.x, v.sortie.y, v.sortie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, garagepublic.Size.x, garagepublic.Size.y, garagepublic.Size.z, garagepublic.Color.r, garagepublic.Color.g, garagepublic.Color.b, 100, false, true, 2, false, false, false, false)
                    ESX.ShowHelpNotification("Appuyez sur ~b~E~w~ pour sortir un ~b~véhicule")
                    if IsControlJustPressed(1,51) then
                        publicgarage = false
                        ouvrirpublicgar()
                    end
                end
            end
        end

        for k,v in pairs(garagepublic.zone["Ranger"]) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.range.x, v.range.y, v.range.z)

            if dist <= 25.0 then
                DrawMarker(garagepublic.RangeType, v.range.x, v.range.y, v.range.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, garagepublic.RangeSize.x, garagepublic.RangeSize.y, garagepublic.RangeSize.z, garagepublic.Color2.r, garagepublic.Color2.g, garagepublic.Color2.b, 100, false, true, 2, false, false, false, false)
                razzou = 1
            end

            if dist <= 5.0 then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    DrawMarker(garagepublic.RangeType, v.range.x, v.range.y, v.range.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, garagepublic.RangeSize.x, garagepublic.RangeSize.y, garagepublic.RangeSize.z, garagepublic.Color2.r, garagepublic.Color2.g, garagepublic.Color2.b, 100, false, true, 2, false, false, false, false)
                    razzou = 1
                    ESX.ShowHelpNotification("Appuyez sur ~b~E~w~ pour ranger un ~b~véhicule")
                    if IsControlJustPressed(1,51) then
                        rangervoiture()
                    end
                elseif not IsPedInAnyVehicle(PlayerPedId(), false) then
                    razzou = 1
                    DrawMarker(garagepublic.RangeType, v.range.x, v.range.y, v.range.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, garagepublic.RangeSize.x, garagepublic.RangeSize.y, garagepublic.RangeSize.z, garagepublic.Color2.r, garagepublic.Color2.g, garagepublic.Color2.b, 100, false, true, 2, false, false, false, false)
                    if IsControlJustPressed(1,51) then
                        publicgarage = false
                    end
                end
            end
        end

        for k,v in pairs(garagepublic.fourriere) do
        
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.sortie.x, v.sortie.y, v.sortie.z)

            if dist <= 20.0 then
                razzou = 1
                DrawMarker(39, v.sortie.x, v.sortie.y, v.sortie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, garagepublic.Size.x, garagepublic.Size.y, garagepublic.Size.z, 255, 100, garagepublic.Color.b, 100, false, true, 2, false, false, false, false)
                ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour sortir de la fourrière un ~b~véhicule")
                if IsControlJustPressed(1,51) then
                    publicfourriere = false
                    ouvrirpublicfourr()
                end  
            end
        end
        Citizen.Wait(razzou)
    end
end)


