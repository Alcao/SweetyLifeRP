ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
    end
end)

local Razzway = {}

function OpenLocation()

    if Razzway.Visible then
        Razzway.Visible = false
        RageUI.Visible(RMenu:Get('rz-location', 'main'), false)
        return
    else
        RMenu.Add('rz-location', 'main', RageUI.CreateMenu("Location", "~b~Voici nos véhicules."))
        RMenu:Get('rz-location', 'main').EnableMouse = false
        RMenu.Add('rz-location', 'panto', RageUI.CreateSubMenu(RMenu:Get('rz-location', 'main'), "Confirmation", "~b~Voici nos armes blanches."))
        RMenu.Add('rz-location', 'armesletales', RageUI.CreateSubMenu(RMenu:Get('rz-location', 'main'), "Armurerie", "~b~Voici nos armes létales."))
        RMenu.Add('rz-location', 'accessories', RageUI.CreateSubMenu(RMenu:Get('rz-location', 'main'), "Armurerie", "~b~Voici nos accessoires."))
        RMenu:Get('rz-location', 'main').Closed = function() Razzway.Visible = false FreezeEntityPosition(GetPlayerPed(-1), false) end
        Razzway.Visible = true
        RageUI.Visible(RMenu:Get('rz-location', 'main'), true)
        local LocaVehicleSpawnPoint = vector3(-413.93, 1178.89, 325.64)
        local playerPed = GetPlayerPed(-1)

        Citizen.CreateThread(function()
			while Razzway.Visible do

                RageUI.IsVisible(RMenu:Get('rz-location', 'main'), true, true, true, function()
                    RageUI.Separator("Voici ce que nous avons")
                    RageUI.ButtonWithStyle("Panto", nil, {RightLabel = "→→"}, true, function(h,a,s)
                    end,RMenu:Get("rz-location","panto"))
                    RageUI.ButtonWithStyle("Faggio", nil, {RightLabel = "→→"}, true, function(h,a,s)
                    end,RMenu:Get("rz-location","armesletales"))
                    RageUI.ButtonWithStyle("VIP ~y~Gold~s~", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(h,a,s)
                        if s then
                        end
                    end)
                    RageUI.ButtonWithStyle("VIP ~b~Diamond~s~", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(h,a,s)
                        if s then
                        end
                    end)
                end)
                    
                RageUI.IsVisible(RMenu:Get('rz-location', 'panto'), true, true, true, function()
                    RageUI.ButtonWithStyle("~g~Confirmer", nil, {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                if hasEnoughMoney then
                                    ESX.Game.SpawnVehicle('panto', LocaVehicleSpawnPoint, 252.4, function(vehicle)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                    end)
                                else
                                    ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent sur vous.')
                                end
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~Annuler", nil, {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            RageUI.GoBack()
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('rz-location', 'armesletales'), true, true, true, function()
                    RageUI.ButtonWithStyle("~g~Confirmer", nil, {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                if hasEnoughMoney then
                                    ESX.Game.SpawnVehicle('panto', LocaVehicleSpawnPoint, 252.4, function(vehicle)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                    end)
                                else
                                    ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent sur vous.')
                                end
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~Annuler", nil, {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            RageUI.GoBack()
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('rz-location', 'accessories'), true, true, true, function()
                    RageUI.ButtonWithStyle("~g~Confirmer", nil, {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                if hasEnoughMoney then
                                    ESX.Game.SpawnVehicle('panto', LocaVehicleSpawnPoint, 252.4, function(vehicle)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                    end)
                                else
                                    ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent sur vous.')
                                end
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("~r~Annuler", nil, {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            RageUI.GoBack()
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

-- Blips & Marker --
Citizen.CreateThread(function()
    for k,v in pairs(Location.Request["Position"]) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite (blip, 171)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.6)
        SetBlipColour (blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("[Magasin] Location")
        EndTextCommandSetBlipName(blip)                    
    end
    while true do
        local interval = 850
        local PlyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Location.Request["Position"]) do
            local distance = Vdist(PlyCoords.x, PlyCoords.y, PlyCoords.z, v.coords.x, v.coords.y, v.coords.z)
            if not Razzway.Visible then
                if distance <= 8.0 then
                    interval = 1
                    DrawMarker(Location.Marker, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, Location.Size.x, Location.Size.y, Location.Size.z, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                end
                
                if distance <= 1.5 then
                    ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour ouvrir le menu")
                    if IsControlJustPressed(0, 51) then
                        OpenLocation()
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)