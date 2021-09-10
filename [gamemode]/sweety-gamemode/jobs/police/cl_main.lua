ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

local PoliceMain = {}
local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}

function OpenMenuPolice()

    if PoliceMain.Menu then 
        PoliceMain.Menu = false 
        RageUI.Visible(RMenu:Get('rz-police', 'main'), false)
        return
    else
        RMenu.Add('rz-police', 'main', RageUI.CreateMenu("Police", "Test"))
        RMenu.Add('rz-police', 'actions', RageUI.CreateSubMenu(RMenu:Get("rz-police", "main"),"Police", "~b~Actions Menu"))
        RMenu.Add('rz-police', 'interaction', RageUI.CreateSubMenu(RMenu:Get("rz-police", "main"),"Police", "~b~Intéraction Menu"))
        RMenu.Add('rz-police', 'interactionveh', RageUI.CreateSubMenu(RMenu:Get("rz-police", "main"),"Police", "~b~Intéraction Menu"))
        RMenu.Add('rz-police', 'fouille', RageUI.CreateSubMenu(RMenu:Get("rz-police", "main"),"Police", "~b~Fouille Menu"))
        RMenu.Add('rz-police', 'renfort', RageUI.CreateSubMenu(RMenu:Get("rz-police", "main"),"Police", "~b~Renfort Menu"))
        RMenu:Get('rz-police', 'main'):SetSubtitle("~b~Actions disponibles :")
        RMenu:Get('rz-police', 'main').EnableMouse = false
        RMenu:Get('rz-police', 'main').Closed = function()
            PoliceMain.Menu = false
        end
        PoliceMain.Menu = true 
        RageUI.Visible(RMenu:Get('rz-police', 'main'), true)
        Citizen.CreateThread(function()
			while PoliceMain.Menu do
                RageUI.IsVisible(RMenu:Get('rz-police', 'main'), true, true, true, function()
                    RageUI.Checkbox("Prendre/Quitter son service",nil, service,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            service = Checked
                            if Checked then
                                onservice = true
                                local info = 'prise'
                                SwLife.InternalToServer('police:PriseEtFinservice', info)
                            else
                                onservice = false
                                local info = 'fin'
                                SwLife.InternalToServer('police:PriseEtFinservice', info)
                            end
                        end
                    end)
                    if onservice then
                        RageUI.ButtonWithStyle("Intéraction sur personne", nil, {RightLabel = "→→"},true, function()
                        end, RMenu:Get('rz-police', 'interaction'))
                        RageUI.ButtonWithStyle("Intéraction sur véhicule", nil, {RightLabel = "→→"},true, function()
                        end, RMenu:Get('rz-police', 'interactionveh'))
                        RageUI.ButtonWithStyle("Demande de renfort", nil, {RightLabel = "→→"},true, function()
                        end, RMenu:Get('rz-police', 'renfort'))
                        RageUI.ButtonWithStyle("Gestion des objets", false, {RightLabel = "→→"}, true, function(h,a,s)
                        end,RMenu:Get("rz-police","actions"))
                    end
                    
                end)
                
                RageUI.IsVisible(RMenu:Get('rz-police', 'actions'), true, true, true, function()
                    RageUI.ButtonWithStyle("Plot", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            spawnObject('prop_roadcone02a')
                        end
                    end)

                    RageUI.ButtonWithStyle("Barrière", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            spawnObject('prop_barrier_work05')
                        end
                    end)

                    RageUI.ButtonWithStyle("Herse", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            spawnObject('p_ld_stinger_s')
                        end
                    end)
                end)

                RageUI.IsVisible(RMenu:Get('rz-police', 'interaction'), true, true, true, function()

                    RageUI.ButtonWithStyle("Mettre une amende", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('rz-ammu:achatweapon', "weapon_knuckle", 250, 5000)
                        end
                    end)

                    RageUI.ButtonWithStyle("Prendre Carte d'identité", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local player, distance = ESX.Game.GetClosestPlayer()
                            if distance ~= -1 and distance <= 3.0 then
                                RageUI.CloseAll()
                                SwLife.InternalToServer('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(player), GetPlayerServerId(PlayerId()))
                            else
                                ESX.ShowNotification('~r~Personne autour de vous')
                            end
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Fouiller", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local player, distance = ESX.Game.GetClosestPlayer()
                            searchedPly = player
                            if distance ~= -1 and distance <= 3.0 then
                                refreshFouille(player)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_policejob:message', GetPlayerServerId(player), _U('being_searched'))
                            else
                                ESX.ShowNotification('Personne autour de vous')
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Menotter/Démenotter", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('rz-ammu:achatweapon', "weapon_knuckle", 250, 5000)
                        end
                    end)

                    RageUI.ButtonWithStyle("Escorter", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local player, distance = ESX.Game.GetClosestPlayer()
                            if distance ~= -1 and distance <= 3.0 then
                                SwLife.InternalToServer('::{razzway.xyz}::esx_policejob:drag', GetPlayerServerId(player))
                            else
                                ESX.ShowNotification('~r~Personne autour de vous')
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
            
                RageUI.IsVisible(RMenu:Get('rz-police', 'interactionveh'), true, true, true, function()
                    local coords  = GetEntityCoords(PlayerPedId())
                    local vehicle = ESX.Game.GetVehicleInDirection()
                    RageUI.ButtonWithStyle("Rechercher une plaque", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('rz-ammu:achatweapon', "weapon_knuckle", 250, 5000)
                        end
                    end)
                    
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

                            currentTask.busy = true
                            currentTask.task = ESX.SetTimeout(10000, function()
                                ClearPedTasks(playerPed)
                                ESX.Game.DeleteVehicle(vehicle)
                                ESX.ShowNotification("~b~Mise en fourrière effectuée.")
                                currentTask.busy = false
                                Citizen.Wait(100) 
                            end)
        
                        
                            Citizen.CreateThread(function()
                                while currentTask.busy do
                                    Citizen.Wait(1000)
        
                                    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                    if not DoesEntityExist(vehicle) and currentTask.busy then
                                        ESX.ShowNotification("~r~Mise en Fourrière (Erreur) \n~s~Il n'y a pas de véhicule dans les environs !")
                                        ESX.ClearTimeout(currentTask.task)
                                        ClearPedTasks(playerPed)
                                        currentTask.busy = false
                                        break
                                    end
                                end
                            end)
                        end
                    end)
                end)

                RageUI.IsVisible(RMenu:Get('rz-police', 'fouille'), true, true, true, function()
                    while fouilleElements == nil do
                        Citizen.Wait(0)
                    end
        
                    for i = 1, #fouilleElements, 1 do
                        if WarMenu.Button(fouilleElements[i].label) then
                            SwLife.InternalToServer('::{razzway.xyz}::GangsBuilder:confiscatePlayerItem', GetPlayerServerId(searchedPly), fouilleElements[i].itemType, fouilleElements[i].value, fouilleElements[i].amount)
                            refreshFouille(searchedPly)
                        end
                    end
                end)

                RageUI.IsVisible(RMenu:Get('rz-police', 'renfort'), true, true, true, function()
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

function spawnObject(name)
	local plyPed = PlayerPedId()
	local coords = GetEntityCoords(plyPed, false) + (GetEntityForwardVector(plyPed) * 1.0)

	ESX.Game.SpawnObject(name, coords, function(obj)
		SetEntityHeading(obj, GetEntityPhysicsHeading(plyPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end

local PoliceGarage = {}

RMenu.Add('rz-police', 'garage', RageUI.CreateMenu("Garage", "Menu Garage"))
RMenu:Get('rz-police', 'garage').EnableMouse = false
RMenu:Get('rz-police', 'garage').Closed = function() PoliceGarage.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function OpenPoliceGarage()

    if PoliceGarage.Menu then
        PoliceGarage.Menu = false
    else
        PoliceGarage.Menu = true
        RageUI.Visible(RMenu:Get('rz-police', 'garage'), true)
        LocaVehicleSpawnPoint = vector3(450.62, -981.19, 25.7)
        local playerPed = GetPlayerPed(-1)

        Citizen.CreateThread(function()
			while PoliceGarage.Menu do
                RageUI.IsVisible(RMenu:Get('rz-police', 'garage'), true, true, true, function() 

                    RageUI.ButtonWithStyle("Police Cruiser",nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            ESX.Game.SpawnVehicle('11caprice', LocaVehicleSpawnPoint, 91.4, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSPD')
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)                     
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Police Ford",nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            ESX.Game.SpawnVehicle('16taurus', LocaVehicleSpawnPoint, 91.4, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSPD')
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)                        
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Police 4x4",nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            ESX.Game.SpawnVehicle('16explorer', LocaVehicleSpawnPoint, 91.4, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSPD')
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)                        
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Police Intercept 1",nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            ESX.Game.SpawnVehicle('14charger', LocaVehicleSpawnPoint, 91.4, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSPD')
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)                        
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Police Dodge",nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            ESX.Game.SpawnVehicle('18charger', LocaVehicleSpawnPoint, 91.4, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSPD')
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)                        
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Moto de Police",nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            ESX.Game.SpawnVehicle('policeb', LocaVehicleSpawnPoint, 91.4, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSPD')
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)                        
                            end)
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("R.I.O.T",nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            ESX.Game.SpawnVehicle('riot', LocaVehicleSpawnPoint, 91.4, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LSPD')
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

local garageposition = {
    {x = 458.82, y = -986.72, z = 24.7}
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
        for k,v in pairs(garageposition) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, garageposition[k].x, garageposition[k].y, garageposition[k].z)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' then
                if not PoliceGarage.Menu then
                    if distance <= 9.0 then
                        Draw3DText(garageposition[k].x, garageposition[k].y, 25.7, "Appuyez sur ~b~E~s~ pour accéder au ~b~garage")
                        DrawMarker(6, garageposition[k].x, garageposition[k].y, garageposition[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                        razzou = 1
                        if distance <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour accéder au garage")
                            if IsControlJustPressed(0, 51) then
                                OpenPoliceGarage()
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
    local plaque = "LSPD"..math.random(1,9)
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

local VestiairePolice = {}

RMenu.Add('rz-police', 'vpolice', RageUI.CreateMenu("Vestaire", "~b~Vestiaire"))
RMenu:Get('rz-police', 'vpolice').EnableMouse = false
RMenu:Get('rz-police', 'vpolice').Closed = function() VestiairePolice.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function VestiairePoliceMenu()

    if VestiairePolice.Menu then
        VestiairePolice.Menu = false
    else
        VestiairePolice.Menu = true
        RageUI.Visible(RMenu:Get('rz-police', 'vpolice'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while VestiairePolice.Menu do
                RageUI.IsVisible(RMenu:Get('rz-police', 'vpolice'), true, true, true, function()

                    RageUI.ButtonWithStyle("Reprendre sa tenue civile",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin)
                            TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    RageUI.Separator("")

                    RageUI.ButtonWithStyle("Tenue Cadet",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 15, 0)       --T-shirt
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 180, 0)     --Torse 
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 0, 0)        --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 48, 1)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 32, 0)       --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Tenue Officier",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 59, 0)       --T-shirt
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 287, 0)     --Torse  
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 1, 0)        --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 19, 0)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 11, 0)       --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Tenue Lieutenant",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 60, 0)       --T-Shirt
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 287, 0)     --Torse
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 26, 0)       --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 19, 0)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 13, 0)       --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Tenue Sergent",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 58, 0)       --T-Shirt 
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 287, 0)     --Torse
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 28, 0)       --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 19, 0)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 11, 0)       --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Tenue Commandant",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 58, 0)       --T-Shirt
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 287, 0)     --Torse
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 26, 0)       --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 19, 0)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 18, 0)       --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Tenue S.W.A.T",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 15, 0)       --T-Shirt 
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 188, 0)     --Torse
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 26, 0)       --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 19, 3)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 61, 5)       --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre Gilet par balle",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 1, 0)   --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Enlever Gilet par balle",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 0, 0)   --Kevlar
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

local vestiaireposition = {
    {x = 458.29, y = -998.75, z = 29.69}
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
        for k,v in pairs(vestiaireposition) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, vestiaireposition[k].x, vestiaireposition[k].y, vestiaireposition[k].z)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' then
                if not VestiairePolice.Menu then
                    if distance <= 5.0 then
                        Draw3DText(vestiaireposition[k].x, vestiaireposition[k].y, 30.69, "Appuyez sur ~b~E~s~ pour accéder au ~b~vestiaire")
                        DrawMarker(6, vestiaireposition[k].x, vestiaireposition[k].y, vestiaireposition[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                        razzou = 1
                        if distance <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour accéder au ~b~vestiaire")
                            if IsControlJustPressed(0, 51) then
                                VestiairePoliceMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)

local ArmureriePolice = {}

RMenu.Add('rz-police', 'armurerie', RageUI.CreateMenu("Vestaire", "~b~Vestiaire"))
RMenu:Get('rz-police', 'armurerie').EnableMouse = false
RMenu:Get('rz-police', 'armurerie').Closed = function() ArmureriePolice.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function ArmureriePoliceMenu()

    if ArmureriePolice.Menu then
        ArmureriePolice.Menu = false
    else
        ArmureriePolice.Menu = true
        RageUI.Visible(RMenu:Get('rz-police', 'armurerie'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while ArmureriePolice.Menu do
                RageUI.IsVisible(RMenu:Get('rz-police', 'armurerie'), true, true, true, function()

                    RageUI.ButtonWithStyle("Matraque", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwLife.InternalToServer('rz-police:weapon', "weapon_nightstick", 250)
                        end
                    end)

                    RageUI.ButtonWithStyle("Tazer", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwLife.InternalToServer('rz-police:weapon', "weapon_stungun", 250)
                        end
                    end)

                    RageUI.ButtonWithStyle("Pistolet de combat", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwLife.InternalToServer('rz-police:weapon', "weapon_combatpistol", 250)
                        end
                    end)

                    RageUI.ButtonWithStyle("Tazer", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwLife.InternalToServer('rz-police:weapon', "weapon_stungun", 250)
                        end
                    end)

                    RageUI.ButtonWithStyle("Fusil à pompe", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwLife.InternalToServer('rz-police:weapon', "weapon_pumpshotgun", 250)
                        end
                    end)

                    RageUI.ButtonWithStyle("Carabine d'assault", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SwLife.InternalToServer('rz-police:weapon', "weapon_carbinerifle", 250)
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

local armurerieposition = {
    {x = 479.18, y = -996.75, z = 29.69}
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
        for k,v in pairs(armurerieposition) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, armurerieposition[k].x, armurerieposition[k].y, armurerieposition[k].z)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' then
                if not ArmureriePolice.Menu then
                    if distance <= 5.0 then
                        Draw3DText(armurerieposition[k].x, armurerieposition[k].y, 30.69, "Appuyez sur ~b~E~s~ pour accéder à ~b~l'armurerie")
                        DrawMarker(6, armurerieposition[k].x, armurerieposition[k].y, armurerieposition[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                        razzou = 1
                        if distance <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour accéder à ~b~l'armurerie")
                            if IsControlJustPressed(0, 51) then
                                ArmureriePoliceMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)

Keys.Register('F6','InteractionsJobPolice', 'Menu job Police', function()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' then
        OpenMenuPolice()
    end
end)
