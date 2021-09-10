ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

local _Razzourson = SwLife.InternalToServer

RMenu.Add('razzlocaprison', 'menulocaprison', RageUI.CreateMenu("~b~Location", "~b~Voici nos véhicules"))

CreateThread(function()
    while true do
        Wait(1)
        LocaPrisonVehicleSpawnPoint = vector3(1860.14, 2639.85, 45.67)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), 1853.82, 2646.43, 45.67)
        if Distance < 500.0 then
            if Distance < 1 then
                AddTextEntry("HELP", "Appuyer sur ~INPUT_PICKUP~ pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzlocaprison', 'menulocaprison'), true)
                    local IsLocPrisonMenuOpen = true
                    while IsLocPrisonMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzlocaprison', 'menulocaprison')) then
                            IsLocPrisonMenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzlocaprison', 'menulocaprison'), true, true, true, function()

                            RageUI.ButtonWithStyle("Panto", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('panto', LocaPrisonVehicleSpawnPoint, 177.7, function(vehicle)
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
                                            ESX.Game.SpawnVehicle('blista', LocaPrisonVehicleSpawnPoint, 177.7, function(vehicle)
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

DecorRegister("Yay", 4)
pedHashp = "s_m_m_security_01"
zonep = vector3(1852.35, 2646.33, 44.67)
Headingp = 272.21
Pedp = nil
HeadingSpawnp = 315.00

SwLife.newThread(function()
    LoadModel(pedHashp)
    Pedp = CreatePed(2, GetHashKey(pedHashp), zonep, Headingp, 0, 0)
    DecorSetInt(Pedp, "Yay", 5431)
    FreezeEntityPosition(Pedp, 1)
    TaskStartScenarioInPlace(Pedp, "WORLD_HUMAN_CLIPBOARD", 0, false)
    SetEntityInvincible(Pedp, true)
    SetBlockingOfNonTemporaryEvents(Pedp, 1)

    local blipp = AddBlipForCoord(zonep)
    SetBlipSprite(blipp, 171)
    SetBlipScale(blipp, 0.6)
    SetBlipShrink(blipp, true)
    SetBlipColour(blipp, 5)
    SetBlipAsShortRange(blipp, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Location de Voiture")
    EndTextCommandSetBlipName(blipp)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end