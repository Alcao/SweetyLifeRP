ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RMenu.Add('razzloca', 'menuloca', RageUI.CreateMenu("~b~Location", "~b~Voici nos véhicules"))

CreateThread(function()
    while true do
        Wait(1)
        LocaVehicleSpawnPoint = vector3(-413.93, 1178.89, 325.64)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), -415.54, 1171.6, 325.84)
        if Distance < 500.0 then
            if Distance < 1 then
                AddTextEntry("OK", "Appuyer sur ~INPUT_PICKUP~ pour parler avec la personne.")
                DisplayHelpTextThisFrame("OK", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzloca', 'menuloca'), true)
                    local IsLocMenuOpen = true
                    while IsLocMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzloca', 'menuloca')) then
                            IsLocMenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzloca', 'menuloca'), true, true, true, function()

                            RageUI.ButtonWithStyle("Panto", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('panto', LocaVehicleSpawnPoint, 252.4, function(vehicle)
                                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LOCA')
                                                SetVehicleNumberPlateText(vehicle, newPlate)
                                                _Razzourson('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)
                                            end)
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
                                        end
                                    end)
                                end
                            end)

                            RageUI.ButtonWithStyle("Blista", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('blista', LocaVehicleSpawnPoint, 252.4, function(vehicle)
                                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                                local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LOCA')
                                                SetVehicleNumberPlateText(vehicle, newPlate)
                                                _Razzourson('::{razzway.xyz}::esx_vehiclelock:givekey', 'no', newPlate)
                                            end)
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
                                        end
                                    end)
                                end
                            end)
                        end, function()end, 1)
                    end
                end
            end
        else
            Wait(5000)
        end
    end
end)

--------- PED & BLIPS -----------

DecorRegister("Hey", 4)
pedHashloca1 = "cs_fbisuit_01"
zoneloca1 = vector3(-415.93, 1173.47, 324.8)
Headingloca1 = 198.23
Pedloca1 = nil
HeadingSpawnloca1 = 315.00

SwLife.newThread(function()
    LoadModel(pedHashloca1)
    Pedloca1 = CreatePed(2, GetHashKey(pedHashloca1), zoneloca1, Headingloca1, 0, 0)
    DecorSetInt(Pedloca1, "Hey", 5431)
    FreezeEntityPosition(Pedloca1, 1)
    TaskStartScenarioInPlace(Pedloca1, "WORLD_HUMAN_CLIPBOARD", 0, false)
    SetEntityInvincible(Pedloca1, true)
    SetBlockingOfNonTemporaryEvents(Pedloca1, 1)

    local bliploca1 = AddBlipForCoord(zoneloca1)
    SetBlipSprite(bliploca1, 171)
    SetBlipScale(bliploca1, 0.6)
    SetBlipShrink(bliploca1, true)
    SetBlipColour(bliploca1, 5)
    SetBlipAsShortRange(bliploca1, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Location de Voiture")
    EndTextCommandSetBlipName(bliploca1)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end