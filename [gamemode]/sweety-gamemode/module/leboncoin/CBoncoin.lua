ESX = nil
canInteract = true


SwLife.newThread(function()
    TriggerEvent("SwLife:initObject", function(obj)
        ESX = obj
    end)
    while ESX == nil do Wait(1) end
    -- Initialisation du blip
    local blip = AddBlipForCoord(ConfigLeBonCoin.position.x, ConfigLeBonCoin.position.y, ConfigLeBonCoin.position.z)
    SetBlipSprite(blip, 478)
    SetBlipColour(blip, 28)
    SetBlipScale(blip, 0.6)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Leboncoin")
    EndTextCommandSetBlipName(blip)
    -- Initialisation de la zone d'interaction
    while true do
        local interval = 250
        local playerPos = GetEntityCoords(PlayerPedId())
        local zone = ConfigLeBonCoin.position
        local distance = #(playerPos - zone)
        if distance <= ConfigLeBonCoin.drawDist then
            interval = 0
            if distance <= 1.0 then
                if canInteract then
                    AddTextEntry("LBC", "Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~y~bon coin~s~")
                    DisplayHelpTextThisFrame("LBC", 0)
                    if IsControlJustPressed(0, 51) then
                        canInteract = false
                        SwLife.InternalToServer("esx_leboncoin:interact")
                    end
                end
            end
        end
        Wait(interval)
    end
end)

DecorRegister("LeBonCoin", 4)
pedHashb = "a_m_y_bevhills_01"
zoneb = vector3(370.14, -771.9, 28.28)
Headingb = 356.26
Pedb = nil
HeadingSpawnb = 315.00

SwLife.newThread(function()
    LoadModel(pedHashb)
    Pedb = CreatePed(2, GetHashKey(pedHashb), zoneb, Headingb, 0, 0)
    DecorSetInt(Pedb, "LeBonCoin", 5431)
    FreezeEntityPosition(Pedb, 1)
    TaskStartScenarioInPlace(Pedb, "WORLD_HUMAN_STAND_MOBILE", 0, false)
    SetEntityInvincible(Pedb, true)
    SetBlockingOfNonTemporaryEvents(Pedb, 1)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end