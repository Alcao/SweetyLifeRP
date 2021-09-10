ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

local _Razzourson = SwLife.InternalToServer

RMenu.Add('razzlocacayo', 'menulocacayo', RageUI.CreateMenu("~b~Location", "~b~Voici nos véhicules"))

CreateThread(function()
    while true do
        Wait(1)
        LocaCayoVehicleSpawnPoint = vector3(4509.99, -4512.47, 4.11)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), 4514.71, -4506.73, 4.12)
        if Distance < 500.0 then
            if Distance < 1 then
                AddTextEntry("HELP", "Appuyer sur ~INPUT_PICKUP~ pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzlocacayo', 'menulocacayo'), true)
                    local IsLocCayoMenuOpen = true
                    while IsLocCayoMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzlocacayo', 'menulocacayo')) then
                            IsLocCayoMenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzlocacayo', 'menulocacayo'), true, true, true, function()

                            RageUI.ButtonWithStyle("Manchez", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('manchez2', LocaCayoVehicleSpawnPoint, 22.07, function(vehicle)
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

                            RageUI.ButtonWithStyle("Winky", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('winky', LocaCayoVehicleSpawnPoint, 22.07, function(vehicle)
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

                            RageUI.ButtonWithStyle("Verus", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('verus', LocaCayoVehicleSpawnPoint, 22.07, function(vehicle)
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

DecorRegister("Cayo", 4)
pedHash3 = "s_m_m_security_01"
zone3 = vector3(4515.7, -4507.02, 3.13)
Heading3 = 69.0
Ped3 = nil
HeadingSpawn3 = 315.00

SwLife.newThread(function()
    LoadModel(pedHash3)
    Ped3 = CreatePed(2, GetHashKey(pedHash3), zone3, Heading3, 0, 0)
    DecorSetInt(Ped3, "Cayo", 5431)
    FreezeEntityPosition(Ped3, 1)
    TaskStartScenarioInPlace(Ped3, "WORLD_HUMAN_CLIPBOARD", 0, false)
    SetEntityInvincible(Ped3, true)
    SetBlockingOfNonTemporaryEvents(Ped3, 1)

    local blip3 = AddBlipForCoord(zone3)
    SetBlipSprite(blip3, 171)
    SetBlipScale(blip3, 0.6)
    SetBlipShrink(blip3, true)
    SetBlipColour(blip3, 5)
    SetBlipAsShortRange(blip3, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Location de Voiture")
    EndTextCommandSetBlipName(blip3)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end