ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RMenu.Add('razzkart', 'menukart', RageUI.CreateMenu("~b~Karting", "~b~Voici nos différents kart"))

CreateThread(function()
    while true do
        Wait(1)
        KartSpawn = vector3(-157.18, -2137.34, 16.71)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), -160.65, -2130.33, 16.71)
        if Distance < 500.0 then
            if Distance < 1 then
                AddTextEntry("HELP", "Appuyer sur ~INPUT_PICKUP~ pour parler avec le gérant.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzkart', 'menukart'), true)
                    local IsKartMenuOpen = true
                    while IsKartMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzkart', 'menukart')) then
                            IsKartMenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzkart', 'menukart'), true, true, true, function()

                            RageUI.ButtonWithStyle("Karting - Débutant", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('kart', KartSpawn, 201.106, function(vehicle)
                                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                            end)
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
                                        end
                                    end)
                                end
                            end)

                            RageUI.ButtonWithStyle("Karting - Professionel", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('kart3', KartSpawn, 201.106, function(vehicle)
                                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                            end)
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
                                        end
                                    end)
                                end
                            end)

                            RageUI.ButtonWithStyle("Karting - Expert I", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('kart20', KartSpawn, 201.106, function(vehicle)
                                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                            end)
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
                                        end
                                    end)
                                end
                            end)

                            RageUI.ButtonWithStyle("Karting - Expert II", nil, { RightLabel = "~b~500$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouloca:buy', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            ESX.Game.SpawnVehicle('Shifter_kart', KartSpawn, 201.106, function(vehicle)
                                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
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

DecorRegister("Karting", 4)
pedHash5 = "a_m_m_og_boss_01"
zone5 = vector3(-160.91, -2129.58, 15.71)
Heading5 = 200.36
Ped5 = nil
HeadingSpawn5 = 315.00

SwLife.newThread(function()
    LoadModel(pedHash5)
    Ped5 = CreatePed(2, GetHashKey(pedHash5), zone5, Heading5, 0, 0)
    DecorSetInt(Ped5, "Karting", 5431)
    FreezeEntityPosition(Ped5, 1)
    TaskStartScenarioInPlace(Ped5, "WORLD_HUMAN_AA_COFFEE", 0, false)
    SetEntityInvincible(Ped5, true)
    SetBlockingOfNonTemporaryEvents(Ped5, 1)

    local blip5 = AddBlipForCoord(zone5)
    SetBlipSprite(blip5, 147)
    SetBlipScale(blip5, 0.6)
    SetBlipShrink(blip5, true)
    SetBlipColour(blip5, 5)
    SetBlipAsShortRange(blip5, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Karting Race")
    EndTextCommandSetBlipName(blip5)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end