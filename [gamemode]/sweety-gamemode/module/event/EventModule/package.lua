local ObjNetId = 0
local sended = false



function removeBlips()
    RemoveBlip(blip)
end

function packageEvent(data, zone)
    sended = false
    SwLife.newThread(function()
        AddTextEntry("EVENT_RECUP_DROGUE", "Récupère la drogue")

        blip = AddBlipForCoord(zone)
        SetBlipSprite(blip, 615)
        SetBlipColour(blip, 1)
        
        ShowAdvancedNotification("Gary McKinnon", "~r~EVENT ILLEGAL", data.message, "CHAR_HACKEUR",9)
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        local dst = GetDistanceBetweenCoords(pCoords, zone, true)
        while dst > 150 do
            Wait(100)
            pPed = GetPlayerPed(-1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(pCoords, zone, true)
            if EventStop then return end
            if EventStop then break end
        end

        if not EventStop then
            local DrogueRecup = 0
            while DrogueRecup < 10 do
                Wait(1)
                local randomProp = data.prop[math.random(1, #data.prop)]
                RequestModel(GetHashKey(randomProp))
                while not HasModelLoaded(GetHashKey(randomProp)) do Wait(10) end
                local randomZone = vector3(zone.x+math.random(-15.0,15.0), zone.y+math.random(-15.0,15.0), zone.z)

                local obj = CreateObject(GetHashKey(randomProp), randomZone, 0, 0, 0)
                ObjNetId = obj
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, 1)

                local oCoords = GetEntityCoords(obj)
                local dst = GetDistanceBetweenCoords(pCoords, oCoords, 0)
                while dst > 2.0 do
                    Wait(1)
                    pPed = GetPlayerPed(-1)
                    oCoords = GetEntityCoords(obj)
                    pCoords = GetEntityCoords(pPed)
                    dst = GetDistanceBetweenCoords(pCoords, oCoords, 0)
                    ShowFloatingHelp("EVENT_RECUP_DROGUE", oCoords)
                    if EventStop then return end
                    if EventStop then break end
                end

                if not EventStop then
                    PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 1)
                    RemoveObj(ObjNetId)
                    DrogueRecup = DrogueRecup + 1
                    print(DrogueRecup)
                    local nombre = math.random(3, 12)
                    local item = data.item[math.random(1,#data.item)]
                    SwLife.InternalToServer("RS_AUTOEVENT:GetItem", item, nombre)
                    if EventStop then return end
                    if EventStop then break end
                end

                if DrogueRecup >= 10 then
                    print("Serveur event envoyé")
                    SwLife.InternalToServer("RS_AUTOEVENT:Recuperer")
                    sended = true
                    break
                end
                if EventStop then 
                    DrogueRecup = 99 break 
                end
            end

            if not sended then
                SwLife.InternalToServer("RS_AUTOEVENT:Recuperer")
                sended = true
            end
            ShowAdvancedNotification("Gary McKinnon", "~r~EVENT ILLEGAL", "Cargaison récupérée!", "CHAR_HACKEUR",9)
            PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
        end

        RemoveBlip(blip)
    end)
end