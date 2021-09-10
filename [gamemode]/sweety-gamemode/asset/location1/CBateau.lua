ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

local _Razzourson = SwLife.InternalToServer

RMenu.Add('razzlocacayo', 'menulocacayo', RageUI.CreateMenu("~b~Location", "~b~Voici nos bateaux"))

CreateThread(function()
    while true do
        Wait(1)
        LocaBateauVehicleSpawnPoint = vector3(3790.05, -4664.41, 1.20)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), 3832.62, -4690.87, 2.19)
        if Distance < 500.0 then
            if Distance < 1 then
                AddTextEntry("HELP", "Appuyer sur ~INPUT_PICKUP~ pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzlocacayo', 'menulocacayo'), true)
                    local IsLocBateauMenuOpen = true
                    while IsLocBateauMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzlocacayo', 'menulocacayo')) then
                            IsLocBateauMenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzlocacayo', 'menulocacayo'), true, true, true, function()

                            RageUI.ButtonWithStyle("Jetski", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('seashark', LocaBateauVehicleSpawnPoint, 33.43, function(vehicle)
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

DecorRegister("Bateau", 4)
pedHash4 = "s_m_m_security_01"
zone4 = vector3(3833.83, -4691.43, 1.19)
Heading4 = 55.13
Ped4 = nil
HeadingSpawn4 = 315.00

SwLife.newThread(function()
    LoadModel(pedHash4)
    Ped4 = CreatePed(2, GetHashKey(pedHash4), zone4, Heading4, 0, 0)
    DecorSetInt(Ped4, "Bateau", 5431)
    FreezeEntityPosition(Ped4, 1)
    TaskStartScenarioInPlace(Ped4, "WORLD_HUMAN_CLIPBOARD", 0, false)
    SetEntityInvincible(Ped4, true)
    SetBlockingOfNonTemporaryEvents(Ped4, 1)

    local blip4 = AddBlipForCoord(zone4)
    SetBlipSprite(blip4, 171)
    SetBlipScale(blip4, 0.6)
    SetBlipShrink(blip4, true)
    SetBlipColour(blip4, 3)
    SetBlipAsShortRange(blip4, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Location de Bateau")
    EndTextCommandSetBlipName(blip4)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end