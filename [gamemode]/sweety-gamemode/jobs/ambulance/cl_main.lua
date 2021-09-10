ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

local AmbulanceMain = {}
local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTaska, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}

function OpenMenuAmbulance()

    if AmbulanceMain.Menu then 
        AmbulanceMain.Menu = false 
        RageUI.Visible(RMenu:Get('rz-ambulance', 'main'), false)
        return
    else
        RMenu.Add('rz-ambulance', 'main', RageUI.CreateMenu("Ambulance", "Test"))
        RMenu.Add('rz-ambulance', 'actions', RageUI.CreateSubMenu(RMenu:Get("rz-ambulance", "main"),"Ambulance", "~b~Actions Menu"))
        RMenu.Add('rz-ambulance', 'interaction', RageUI.CreateSubMenu(RMenu:Get("rz-ambulance", "main"),"Ambulance", "~b~Intéraction Menu"))
        RMenu.Add('rz-ambulance', 'interactionveh', RageUI.CreateSubMenu(RMenu:Get("rz-ambulance", "main"),"Ambulance", "~b~Intéraction Menu"))
        RMenu.Add('rz-ambulance', 'fouille', RageUI.CreateSubMenu(RMenu:Get("rz-ambulance", "main"),"Ambulance", "~b~Fouille Menu"))
        RMenu.Add('rz-ambulance', 'renfort', RageUI.CreateSubMenu(RMenu:Get("rz-ambulance", "main"),"Ambulance", "~b~Renfort Menu"))
        RMenu:Get('rz-ambulance', 'main'):SetSubtitle("~b~Actions disponibles :")
        RMenu:Get('rz-ambulance', 'main').EnableMouse = false
        RMenu:Get('rz-ambulance', 'main').Closed = function()
            AmbulanceMain.Menu = false
        end
        AmbulanceMain.Menu = true 
        RageUI.Visible(RMenu:Get('rz-ambulance', 'main'), true)
        Citizen.CreateThread(function()
			while AmbulanceMain.Menu do
                RageUI.IsVisible(RMenu:Get('rz-ambulance', 'main'), true, true, true, function()
                    RageUI.Checkbox("Prendre/Quitter son service",nil, service,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            service = Checked
                            if Checked then
                                onservice = true
                            else
                                onservice = false
                            end
                        end
                    end)
                    if onservice then
                        RageUI.ButtonWithStyle("Intéraction sur personne", nil, {RightLabel = "→→"},true, function()
                        end, RMenu:Get('rz-ambulance', 'interaction'))
                        RageUI.ButtonWithStyle("Intéraction sur véhicule", nil, {RightLabel = "→→"},true, function()
                        end, RMenu:Get('rz-ambulance', 'interactionveh'))
                        RageUI.ButtonWithStyle("Demande de renfort", nil, {RightLabel = "→→"},true, function()
                        end, RMenu:Get('rz-ambulance', 'renfort'))
                    end
                    
                end)

                RageUI.IsVisible(RMenu:Get('rz-ambulance', 'interaction'), true, true, true, function()

                    RageUI.ButtonWithStyle("Réanimer la personne", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(h,a,s)
                        if s then
                            revivePlayer(closestPlayer) 
                        end
                    end)

                    RageUI.ButtonWithStyle("Soigner une petite blessure", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(h,a,s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 1.0 then
								ESX.ShowNotification('~r~Aucune personne à proximité')
							else
								ESX.TriggerServerCallback('::{razzway.xyz}::esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
		
										if health > 0 then
											local playerPed = PlayerPedId()
		
											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
		
											SwLife.InternalToServer('::{razzway.xyz}::esx_ambulancejob:removeItem', 'bandage')
											SwLife.InternalToServer('::{razzway.xyz}::esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_bandage'))
									end
								end, 'bandage')
							end
						end
					end)

                    RageUI.ButtonWithStyle("Soigner une grosse blessure", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(h,a,s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 1.0 then
								ESX.ShowNotification('~r~Aucune personne à proximité')
							else
								ESX.TriggerServerCallback('::{razzway.xyz}::esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
		
										if health > 0 then
											local playerPed = PlayerPedId()
		
											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
		
											SwLife.InternalToServer('::{razzway.xyz}::esx_ambulancejob:removeItem', 'medikit')
											SwLife.InternalToServer('::{razzway.xyz}::esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_medikit'))
									end
								end, 'medikit')
							end
						end
					end)

                    RageUI.ButtonWithStyle("Mettre dans le véhicule", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local player, distance = ESX.Game.GetClosestPlayer()
                            if distance ~= -1 and distance <= 3.0 then
                                SwLife.InternalToServer('::{razzway.xyz}::esx_policejob:putInVehicle', GetPlayerServerId(player))
                            else
                                ESX.ShowNotification('~r~Personne autour de vous')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Sortir du véhicule", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local player, distance = ESX.Game.GetClosestPlayer()
                            if distance ~= -1 and distance <= 3.0 then
                                SwLife.InternalToServer('::{razzway.xyz}::esx_policejob:OutVehicle', GetPlayerServerId(player))
                            else
                                ESX.ShowNotification('~r~Personne autour de vous')
                            end
                        end
                    end)
                end)

                
                RageUI.IsVisible(RMenu:Get('rz-ambulance', 'interactionveh'), true, true, true, function()
                    local coords  = GetEntityCoords(PlayerPedId())
                    local vehicle = ESX.Game.GetVehicleInDirection()
                    
                    RageUI.ButtonWithStyle("Crocheter le véhicule", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            if DoesEntityExist(vehicle) then
                                local plyPed = PlayerPedId()
            
                                TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_WELDING', 0, true)
                                Citizen.Wait(20000)
                                ClearPedTasksImmediately(plyPed)
            
                                SetVehicleDoorsLocked(vehicle, 1)
                                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                                ESX.ShowNotification("~g~Véhicule dévérouillé")
                            else
                                ESX.ShowNotification("~r~Aucun véhicule à proximité")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre en Fourrière", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

                            currentTaska.busy = true
                            currentTaska.task = ESX.SetTimeout(10000, function()
                                ClearPedTasks(playerPed)
                                ESX.Game.DeleteVehicle(vehicle)
                                ESX.ShowNotification("~b~Mise en fourrière effectuée.")
                                currentTaska.busy = false
                                Citizen.Wait(100) 
                            end)
        
                        
                            Citizen.CreateThread(function()
                                while currentTaska.busy do
                                    Citizen.Wait(1000)
        
                                    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                    if not DoesEntityExist(vehicle) and currentTaska.busy then
                                        ESX.ShowNotification("~r~Mise en Fourrière (Erreur) \n~s~Il n'y a pas de véhicule dans les environs !")
                                        ESX.ClearTimeout(currentTaska.task)
                                        ClearPedTasks(playerPed)
                                        currentTaska.busy = false
                                        break
                                    end
                                end
                            end)
                        end
                    end)
                end)
                    
                RageUI.IsVisible(RMenu:Get('rz-ambulance', 'renfort'), true, true, true, function()
                    RageUI.ButtonWithStyle("Petite Demande", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local raison = 'petit'
                            local elements  = {}
                            local playerPed = PlayerPedId()
                            local coords  = GetEntityCoords(playerPed)
                            local name = GetPlayerName(PlayerId())
                            SwLife.InternalToServer('renfort', coords, raison)
                        end
                    end)
                    RageUI.ButtonWithStyle("Moyenne Demande", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local raison = 'importante'
                            local elements  = {}
                            local playerPed = PlayerPedId()
                            local coords  = GetEntityCoords(playerPed)
                            local name = GetPlayerName(PlayerId())
                            SwLife.InternalToServer('renfort', coords, raison)
                        end
                    end)
                    RageUI.ButtonWithStyle("Grosse Demande", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local raison = 'omgad'
                            local elements  = {}
                            local playerPed = PlayerPedId()
                            local coords  = GetEntityCoords(playerPed)
                            local name = GetPlayerName(PlayerId())
                            SwLife.InternalToServer('renfort', coords, raison)
                        end
                    end)
                end)
                Wait(0)
            end
        end)
    end
end


local PharmacieAmbulance = {}

RMenu.Add('rz-ambulance', 'pharmacie', RageUI.CreateMenu("Pharmacie", "~b~Pharmacie - SwLife"))
RMenu:Get('rz-ambulance', 'pharmacie').EnableMouse = false
RMenu:Get('rz-ambulance', 'pharmacie').Closed = function() PharmacieAmbulance.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function PharmacieAmbulanceMenu()

    if PharmacieAmbulance.Menu then
        PharmacieAmbulance.Menu = false
    else
        PharmacieAmbulance.Menu = true
        RageUI.Visible(RMenu:Get('rz-ambulance', 'pharmacie'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while PharmacieAmbulance.Menu do
                RageUI.IsVisible(RMenu:Get('rz-ambulance', 'pharmacie'), true, true, true, function()

                    RageUI.ButtonWithStyle("Bandage",nil, { RightLabel = "~b~Prendre" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwLife.InternalToServer('Pharmacy:giveItemm', 'bandage')
                        end
                    end)

                    RageUI.ButtonWithStyle("Médikit", nil, { RightLabel = "~b~Prendre" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwLife.InternalToServer('Pharmacy:giveItemm', 'medikit')
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

local ambulancepharmacieposition = {
    {x = 306.14, y = -600.97, z = 42.28}
}

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
    while true do
        razzou = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(ambulancepharmacieposition) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, ambulancepharmacieposition[k].x, ambulancepharmacieposition[k].y, ambulancepharmacieposition[k].z)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not PharmacieAmbulance.Menu then
                    if distance <= 4.0 then
                        Draw3DText(ambulancepharmacieposition[k].x, ambulancepharmacieposition[k].y, 43.28, "Appuyez sur ~r~E~s~ pour accéder à la ~r~pharmacie")
                        DrawMarker(6, ambulancepharmacieposition[k].x, ambulancepharmacieposition[k].y, ambulancepharmacieposition[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255, 0, 62, 170, 0, 0, 0, 1, nil, nil, 0)
                        razzou = 1
                        if distance <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour accéder à la ~b~pharmacie")
                            if IsControlJustPressed(0, 51) then
                                PharmacieAmbulanceMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)

local VestiaireAmbulance = {}

RMenu.Add('rz-ambulance', 'vambulance', RageUI.CreateMenu("Vestaire", "~b~Vestiaire Ambulance - SwLife"))
RMenu:Get('rz-ambulance', 'vambulance').EnableMouse = false
RMenu:Get('rz-ambulance', 'vambulance').Closed = function() VestiaireAmbulance.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function VestiaireAmbulanceMenu()

    if VestiaireAmbulance.Menu then
        VestiaireAmbulance.Menu = false
    else
        VestiaireAmbulance.Menu = true
        RageUI.Visible(RMenu:Get('rz-ambulance', 'vambulance'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while VestiaireAmbulance.Menu do
                RageUI.IsVisible(RMenu:Get('rz-ambulance', 'vambulance'), true, true, true, function()

                    RageUI.ButtonWithStyle("Reprendre sa tenue civile",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin)
                            TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    RageUI.Separator("")

                    RageUI.ButtonWithStyle("Tenue de Service",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 15, 0)       --T-shirt
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 180, 0)     --Torse 
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 0, 0)        --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 48, 1)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 32, 0)       --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Tenue de Chirurgie",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 59, 0)       --T-shirt
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 287, 0)     --Torse  
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 1, 0)        --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 19, 0)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 11, 0)       --Kevlar
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

local ambulancevestiaireposition = {
    {x = 301.59, y = -599.22, z = 42.28}
}

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
    while true do
        razzou = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(ambulancevestiaireposition) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, ambulancevestiaireposition[k].x, ambulancevestiaireposition[k].y, ambulancevestiaireposition[k].z)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not VestiaireAmbulance.Menu then
                    if distance <= 4.0 then
                        Draw3DText(ambulancevestiaireposition[k].x, ambulancevestiaireposition[k].y, 43.28, "Appuyez sur ~r~E~s~ pour accéder au ~r~vestiaire")
                        DrawMarker(6, ambulancevestiaireposition[k].x, ambulancevestiaireposition[k].y, ambulancevestiaireposition[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255, 0, 62, 170, 0, 0, 0, 1, nil, nil, 0)
                        razzou = 1
                        if distance <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour accéder au ~b~vestiaire")
                            if IsControlJustPressed(0, 51) then
                                VestiaireAmbulanceMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)

local AmbulanceGarage = {}

RMenu.Add('rz-ambulance', 'garage', RageUI.CreateMenu("Garage", "Menu Garage"))
RMenu:Get('rz-ambulance', 'garage').EnableMouse = false
RMenu:Get('rz-ambulance', 'garage').Closed = function() AmbulanceGarage.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function OpenAmbulanceGarage()

    if AmbulanceGarage.Menu then
        AmbulanceGarage.Menu = false
    else
        AmbulanceGarage.Menu = true
        RageUI.Visible(RMenu:Get('rz-ambulance', 'garage'), true)
        AmbulanceVehSpawn = vector3(295.06, -609.16, 43.34)
        local playerPed = GetPlayerPed(-1)

        Citizen.CreateThread(function()
			while AmbulanceGarage.Menu do
                RageUI.IsVisible(RMenu:Get('rz-ambulance', 'garage'), true, true, true, function() 

                    RageUI.ButtonWithStyle("Ambulance", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.Game.SpawnVehicle('ambulance', AmbulanceVehSpawn, 73.54, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('EMS')
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)                     
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Dodge EMS",nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.Game.SpawnVehicle('dodgeems', AmbulanceVehSpawn, 73.54, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('EMS')
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)                        
                            end)
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

local ambulancegarageposition = {
    {x = 295.24, y = -602.54, z = 42.3}
}

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
    while true do
        razzou = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(ambulancegarageposition) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, ambulancegarageposition[k].x, ambulancegarageposition[k].y, ambulancegarageposition[k].z)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not AmbulanceGarage.Menu then
                    if distance <= 7.0 then
                        Draw3DText(ambulancegarageposition[k].x, ambulancegarageposition[k].y, 43.3, "Appuyez sur ~r~E~s~ pour accéder au ~r~garage")
                        DrawMarker(6, ambulancegarageposition[k].x, ambulancegarageposition[k].y, ambulancegarageposition[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255, 0, 62, 170, 0, 0, 0, 1, nil, nil, 0)
                        razzou = 1
                        if distance <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour accéder au garage")
                            if IsControlJustPressed(0, 51) then
                                OpenAmbulanceGarage()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)

function spawnuniCar(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Config.spawn.spawnvoiture.position.x, Config.spawn.spawnvoiture.position.y, Config.spawn.spawnvoiture.position.z, Config.spawn.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "EMS"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleMaxMods(vehicle)
end

function SetVehicleMaxMods(vehicle)
    local props = {
      modEngine       = 2,
      modBrakes       = 2,
      modTransmission = 2,
      modSuspension   = 3,
      modTurbo        = true,
    }
    ESX.Game.SetVehicleProperties(vehicle, props)
end

Keys.Register('F6','InteractionsJobAmbulance', 'Menu job Ambulance', function()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
        OpenMenuAmbulance()
    end
end)
        