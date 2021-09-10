ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

local UnicornMain = {}
local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTaska, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}

function OpenMenuUnicorn()

    if UnicornMain.Menu then 
        UnicornMain.Menu = false 
        RageUI.Visible(RMenu:Get('rz-unicorn', 'main'), false)
        return
    else
        RMenu.Add('rz-unicorn', 'main', RageUI.CreateMenu("Unicorn", "Test"))
        RMenu.Add('rz-unicorn', 'actions', RageUI.CreateSubMenu(RMenu:Get("rz-unicorn", "main"),"Unicorn", "~b~Actions Menu"))
        RMenu.Add('rz-unicorn', 'interaction', RageUI.CreateSubMenu(RMenu:Get("rz-unicorn", "main"),"Unicorn", "~b~Intéraction Menu"))
        RMenu.Add('rz-unicorn', 'interactionveh', RageUI.CreateSubMenu(RMenu:Get("rz-unicorn", "main"),"Unicorn", "~b~Intéraction Menu"))
        RMenu.Add('rz-unicorn', 'fouille', RageUI.CreateSubMenu(RMenu:Get("rz-unicorn", "main"),"Unicorn", "~b~Fouille Menu"))
        RMenu:Get('rz-unicorn', 'main'):SetSubtitle("~b~Actions disponibles :")
        RMenu:Get('rz-unicorn', 'main').EnableMouse = false
        RMenu:Get('rz-unicorn', 'main').Closed = function()
            UnicornMain.Menu = false
        end
        UnicornMain.Menu = true 
        RageUI.Visible(RMenu:Get('rz-unicorn', 'main'), true)
        Citizen.CreateThread(function()
			while UnicornMain.Menu do
                RageUI.IsVisible(RMenu:Get('rz-unicorn', 'main'), true, true, true, function()
                    RageUI.ButtonWithStyle("Mettre une Facture", nil, {RightLabel = "→→"},true, function(h, a, s)
                        if s then

                        end
                    end)
                
                    RageUI.ButtonWithStyle("Intéraction sur personne", nil, {RightLabel = "→→"},true, function()
                    end, RMenu:Get('rz-unicorn', 'interaction'))
                    RageUI.ButtonWithStyle("Intéraction sur véhicule", nil, {RightLabel = "→→"},true, function()
                    end, RMenu:Get('rz-unicorn', 'interactionveh'))   
                end)

                RageUI.IsVisible(RMenu:Get('rz-unicorn', 'interaction'), true, true, true, function()

                    RageUI.ButtonWithStyle("Prendre Carte d'identité", nil, { RightLabel = "→" } , true, function(h,a,s)
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

                
                RageUI.IsVisible(RMenu:Get('rz-unicorn', 'interactionveh'), true, true, true, function()
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
                Wait(0)
            end
        end)
    end
end

local VestiaireUnicorn = {}

RMenu.Add('rz-unicorn', 'vunicorn', RageUI.CreateMenu("Vestaire", "~b~Vestiaire Unicorn - SwLife"))
RMenu:Get('rz-unicorn', 'vunicorn').EnableMouse = false
RMenu:Get('rz-unicorn', 'vunicorn').Closed = function() VestiaireUnicorn.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function VestiaireUnicornMenu()

    if VestiaireUnicorn.Menu then
        VestiaireUnicorn.Menu = false
    else
        VestiaireUnicorn.Menu = true
        RageUI.Visible(RMenu:Get('rz-unicorn', 'vunicorn'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while VestiaireUnicorn.Menu do
                RageUI.IsVisible(RMenu:Get('rz-unicorn', 'vunicorn'), true, true, true, function()

                    RageUI.ButtonWithStyle("Reprendre sa tenue civile",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin)
                            TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin)
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Tenue Danse #1",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 15, 0)       --T-shirt
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 180, 0)     --Torse 
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 0, 0)        --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 48, 1)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 32, 0)       --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Tenue Danse #2",nil, {nil}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SetPedComponentVariation(GetPlayerPed(-1) , 8, 59, 0)       --T-shirt
                            SetPedComponentVariation(GetPlayerPed(-1) , 11, 287, 0)     --Torse  
                            SetPedComponentVariation(GetPlayerPed(-1) , 3, 1, 0)        --Bras
                            SetPedComponentVariation(GetPlayerPed(-1) , 4, 19, 0)       --Pantalon
                            SetPedComponentVariation(GetPlayerPed(-1) , 6, 39, 0)       --Chaussure
                            SetPedComponentVariation(GetPlayerPed(-1) , 9, 11, 0)       --Kevlar
                        end
                    end)

                    RageUI.ButtonWithStyle("Tenue de serveur",nil, {nil}, true, function(Hovered, Active, Selected)
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

local unicornvestiaireposition = {
    {x = 105.38, y = -1303.22, z = 27.77}
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
        for k,v in pairs(unicornvestiaireposition) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, unicornvestiaireposition[k].x, unicornvestiaireposition[k].y, unicornvestiaireposition[k].z)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unicorn' then
                if not VestiaireUnicorn.Menu then
                    if distance <= 4.0 then
                        Draw3DText(unicornvestiaireposition[k].x, unicornvestiaireposition[k].y, 28.77, "Appuyez sur ~p~E~s~ pour accéder au ~p~vestiaire")
                        DrawMarker(6, unicornvestiaireposition[k].x, unicornvestiaireposition[k].y, unicornvestiaireposition[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 120, 0, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                        razzou = 1
                        if distance <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour accéder au ~b~vestiaire")
                            if IsControlJustPressed(0, 51) then
                                VestiaireUnicornMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)

local UnicornGarage = {}

RMenu.Add('rz-unicorn', 'garage', RageUI.CreateMenu("Garage", "Menu Garage"))
RMenu:Get('rz-unicorn', 'garage').EnableMouse = false
RMenu:Get('rz-unicorn', 'garage').Closed = function() UnicornGarage.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function OpenUnicornGarage()

    if UnicornGarage.Menu then
        UnicornGarage.Menu = false
    else
        UnicornGarage.Menu = true
        RageUI.Visible(RMenu:Get('rz-unicorn', 'garage'), true)
        UnicornVehSpawn = vector3(150.4, -1282.85, 29.09)
        local playerPed = GetPlayerPed(-1)

        Citizen.CreateThread(function()
			while UnicornGarage.Menu do
                RageUI.IsVisible(RMenu:Get('rz-unicorn', 'garage'), true, true, true, function() 

                    RageUI.ButtonWithStyle("Moonbeam", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.Game.SpawnVehicle('moonbeam', UnicornVehSpawn, 205.89, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('UNC')
                                SetVehicleNumberPlateText(vehicle, newPlate)
                                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)                 
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Baller",nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.Game.SpawnVehicle('Baller3', UnicornVehSpawn, 205.89, function(vehicle)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('UNC')
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

local unicorngarageposition = {
    {x = 145.15, y = -1287.59, z = 28.34}
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
        for k,v in pairs(unicorngarageposition) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, unicorngarageposition[k].x, unicorngarageposition[k].y, unicorngarageposition[k].z)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unicorn' then
                if not UnicornGarage.Menu then
                    if distance <= 7.0 then
                        Draw3DText(unicorngarageposition[k].x, unicorngarageposition[k].y, 29.34, "Appuyez sur ~p~E~s~ pour accéder au ~p~garage")
                        DrawMarker(6, unicorngarageposition[k].x, unicorngarageposition[k].y, unicorngarageposition[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 120, 0, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                        razzou = 1
                        if distance <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour accéder au garage")
                            if IsControlJustPressed(0, 51) then
                                OpenUnicornGarage()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)

local UnicornBlips = {
    {x = 129.2, y = -1299.05, z = 29.23}
}

SwLife.newThread(function()
    for k in pairs(UnicornBlips) do
       local blipUnicornBlips = AddBlipForCoord(UnicornBlips[k].x, UnicornBlips[k].y, UnicornBlips[k].z)
       SetBlipSprite(blipUnicornBlips, 121)
       SetBlipColour(blipUnicornBlips, 7)
       SetBlipScale(blipUnicornBlips, 0.6)
       SetBlipAsShortRange(blipUnicornBlips, true)

       BeginTextCommandSetBlipName('STRING')
       AddTextComponentString("Unicorn")
       EndTextCommandSetBlipName(blipUnicornBlips)
   end
end)

Keys.Register('F6','InteractionsJobUnicorn', 'Menu job Unicorn', function()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unicorn' then
        OpenMenuUnicorn()
    end
end)