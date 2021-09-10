ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", 10)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

RMenu.Add('razzblanchi', 'menublanchi', RageUI.CreateMenu("~r~Blanchiment", "Pourcentage : ~r~40%"))

CreateThread(function()
    while true do
        Wait(1)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), 1117.88, -3195.69, -40.4)
        if Distance < 500.0 then
            if Distance < 1 then
                AddTextEntry("BLANCHI", "Appuyer sur ~INPUT_PICKUP~ pour parler avec le blanchisseur.")
                DisplayHelpTextThisFrame("BLANCHI", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzblanchi', 'menublanchi'), true)
                    local IsBlanchiMenuOpen = true
                    while IsBlanchiMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzblanchi', 'menublanchi')) then
                            IsBlanchiMenuOpen = false
                        end
                        FreezeEntityPosition(playerPed, true)
                        RageUI.IsVisible(RMenu:Get('razzblanchi', 'menublanchi'), true, true, true, function()

                            RageUI.ButtonWithStyle("Blanchir de l'argent", nil, { RightLabel = "~y~→" }, true, function(h, a, s)
                                if s then
                                    local argent = KeyboardInput("Combien d'agent as-tu ?", '' , '', 8)
                                    SwLife.InternalToServer('rz-core:blanchiement', argent)
                                end
                            end)

                        end, function()end, 1)
                        FreezeEntityPosition(playerPed, false)
                    end
                end
            end
        else
            Wait(5000)
        end
    end
end)

--------- PED & BLIPS -----------

DecorRegister("Blanchiment", 4)
pedHashbl = "ig_ortega"
zonebl = vector3(1116.82, -3195.74, -41.4)
Headingbl = 272.95
Pedbl = nil
HeadingSpawnbl = 315.00

SwLife.newThread(function()
    LoadModel(pedHashbl)
    Pedbl = CreatePed(2, GetHashKey(pedHashbl), zonebl, Headingbl, 0, 0)
    DecorSetInt(Pedbl, "Blanchiment", 5431)
    FreezeEntityPosition(Pedbl, 1)
    TaskStartScenarioInPlace(Pedbl, "WORLD_HUMAN_DRUG_DEALER", 0, false)
    SetEntityInvincible(Pedbl, true)
    SetBlockingOfNonTemporaryEvents(Pedbl, 1)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end