ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

local _Razzourson = SwLife.InternalToServer

RMenu.Add('razzlocaport', 'menuloport', RageUI.CreateMenu("~b~Location", "~b~Voici nos bateaux"))

CreateThread(function()
    while true do
        Wait(1)
        LocaPortSpawnPoint = vector3(1316.69, -3067.63, 1.0)
        local playerPed = GetPlayerPed(-1)
        local Distance6 = Vdist2(GetEntityCoords(GetPlayerPed(-1)), 1296.89, -3066.41, 5.91)
        if Distance6 < 500.0 then
            if Distance6 < 1 then
                AddTextEntry("HELP", "Appuyer sur ~INPUT_PICKUP~ pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzlocaport', 'menuloport'), true)
                    local IsLocPortMenuOpen = true
                    while IsLocPortMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzlocaport', 'menuloport')) then
                            IsLocPortMenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzlocaport', 'menuloport'), true, true, true, function()

                            RageUI.ButtonWithStyle("Jetski", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('seashark', LocaPortSpawnPoint, 33.43, function(vehicle)
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

DecorRegister("Port", 4)
pedHash6 = "a_f_y_beach_01"
zone6 = vector3(1298.11, -3066.49, 4.91)
Heading6 = 90.35
Ped6 = nil
HeadingSpawn6 = 315.00

SwLife.newThread(function()
    LoadModel(pedHash6)
    Ped6 = CreatePed(2, GetHashKey(pedHash6), zone6, Heading6, 0, 0)
    DecorSetInt(Ped6, "Port", 5431)
    FreezeEntityPosition(Ped6, 1)
    TaskStartScenarioInPlace(Ped6, "WORLD_HUMAN_SMOKING_CLUBHOUSE", 0, false)
    SetEntityInvincible(Ped6, true)
    SetBlockingOfNonTemporaryEvents(Ped6, 1)

    local blip6 = AddBlipForCoord(zone6)
    SetBlipSprite(blip6, 171)
    SetBlipScale(blip6, 0.6)
    SetBlipShrink(blip6, true)
    SetBlipColour(blip6, 3)
    SetBlipAsShortRange(blip6, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Location de Bateau")
    EndTextCommandSetBlipName(blip6)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end