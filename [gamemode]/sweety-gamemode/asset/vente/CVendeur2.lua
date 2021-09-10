ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RMenu.Add('razzinfo2', 'menuinfo2', RageUI.CreateMenu("~r~Informateur", "~r~Que veux-tu savoir ?"))

CreateThread(function()
    while true do
        Wait(1)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), 793.47, 2162.22, 53.09)
        if Distance < 500.0 then
            if Distance < 1 then
                AddTextEntry("HELP", "Appuyer sur ~INPUT_PICKUP~ pour parler avec l'informateur.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzinfo2', 'menuinfo2'), true)
                    local IsInfo2MenuOpen = true
                    while IsInfo2MenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzinfo2', 'menuinfo2')) then
                            IsInfo2MenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzinfo2', 'menuinfo2'), true, true, true, function()

                            RageUI.ButtonWithStyle("Vente de weed", nil, { RightLabel = "~r~50000$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzou:buyweedinfo', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            if ConfigLocation.GPS then
                                                x, y, z = 3695.71, 4562.25, 25.3
                                                SetNewWaypoint(x, y, z)
                                                local source = GetPlayerServerId()
                                                ESX.ShowAdvancedNotification("Informateur", "~b~Vente Weed", "Va chercher près du point GPS que je t'ai donné", 'CHAR_KIRINSPECTEUR', 7)
                                            end
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
                                        end
                                    end)
                                end
                            end)

                            RageUI.ButtonWithStyle("Vente d'opium", nil, { RightLabel = "~r~75000$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzou:buyopiuminfo', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            if ConfigLocation.GPS then
                                                x, y, z = 2429.27, 4982.15, 45.84
                                                SetNewWaypoint(x, y, z)
                                                local source = GetPlayerServerId()
                                                ESX.ShowAdvancedNotification("Informateur", "~b~Récolte Opium", "Va chercher près du point GPS que je t'ai donné", 'CHAR_KIRINSPECTEUR', 7)
                                            end
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
                                        end
                                    end)
                                end
                            end)

                            RageUI.ButtonWithStyle("Plus d'infos", nil, { RightLabel = "~r~100000$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzou:buyopiuminfo', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            if ConfigLocation.GPS then
                                                x, y, z = 2429.27, 4982.15, 45.84
                                                SetNewWaypoint(x, y, z)
                                                local source = GetPlayerServerId()
                                                ESX.ShowAdvancedNotification("Informateur", "~b~Récolte Opium", "Va chercher près du point GPS que je t'ai donné", 'CHAR_KIRINSPECTEUR', 7)
                                            end
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

DecorRegister("lool", 4)
pedHash65 = "a_m_m_soucent_04"
zone65 = vector3(794.01, 2162.99, 52.09)
Heading65 = 156.01
Ped65 = nil

SwLife.newThread(function()
    LoadModel(pedHash65)
    Ped65 = CreatePed(2, GetHashKey(pedHash65), zone65, Heading65, 0, 0)
    DecorSetInt(Ped65, "lool", 5431)
    FreezeEntityPosition(Ped65, 1)
    TaskStartScenarioInPlace(Ped65, "WORLD_HUMAN_COP_IDLES", 0, false)
    SetEntityInvincible(Ped65, true)
    SetBlockingOfNonTemporaryEvents(Ped65, 1)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end