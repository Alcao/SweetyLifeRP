ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RMenu.Add('razzinfo', 'menuinfo', RageUI.CreateMenu("~r~Renseignement", "~r~Que veux-tu savoir ?"))

CreateThread(function()
    while true do
        Wait(1)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), -1203.79, -1309.21, 4.88)
        if Distance < 500.0 then
            if Distance < 1 then
                AddTextEntry("HELP", "Appuyer sur ~INPUT_PICKUP~ pour parler avec l'informateur.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzinfo', 'menuinfo'), true)
                    local IsInfoMenuOpen = true
                    while IsInfoMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzinfo', 'menuinfo')) then
                            IsInfoMenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzinfo', 'menuinfo'), true, true, true, function()

                            RageUI.ButtonWithStyle("Récolte Weed", nil, { RightLabel = "~r~50000$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzou:buyweedinfo', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            if ConfigLocation.GPS then
                                                x, y, z = 3695.71, 4562.25, 25.3
                                                SetNewWaypoint(x, y, z)
                                                local source = GetPlayerServerId()
                                                ESX.ShowAdvancedNotification("Informateur", "~b~Récolte Weed", "Va chercher près du point GPS que je t'ai donné", 'CHAR_KIRINSPECTEUR', 7)
                                            end
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
                                        end
                                    end)
                                end
                            end)

                            RageUI.ButtonWithStyle("Récolte Opium", nil, { RightLabel = "~r~75000$" }, true, function(h, a, s)
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
                                    ESX.TriggerServerCallback('razzou:buymoreinfo', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            if ConfigLocation.GPS then
                                                x, y, z = 792.11, 2159.15, 53.09
                                                SetNewWaypoint(x, y, z)
                                                local source = GetPlayerServerId()
                                                ESX.ShowAdvancedNotification("Informateur", "~b~Plus d'informations", "Va chercher près du point GPS que je t'ai donné", 'CHAR_KIRINSPECTEUR', 7)
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

DecorRegister("lol", 4)
pedHashV = "a_m_m_soucent_04"
zoneV = vector3(-1202.55, -1308.7, 3.9)
HeadingV = 112.55
PedV = nil

SwLife.newThread(function()
    LoadModel(pedHashV)
    PedV = CreatePed(2, GetHashKey(pedHashV), zoneV, HeadingV, 0, 0)
    DecorSetInt(PedV, "lol", 5431)
    FreezeEntityPosition(PedV, 1)
    TaskStartScenarioInPlace(PedV, "WORLD_HUMAN_COP_IDLES", 0, false)
    SetEntityInvincible(PedV, true)
    SetBlockingOfNonTemporaryEvents(PedV, 1)

    local blipV = AddBlipForCoord(zoneV)
    SetBlipSprite(blipV, 205)
    SetBlipScale(blipV, 0.6)
    SetBlipShrink(blipV, true)
    SetBlipColour(blipV, 0)
    SetBlipAsShortRange(blipV, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Blablabla")
    EndTextCommandSetBlipName(blipV)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end