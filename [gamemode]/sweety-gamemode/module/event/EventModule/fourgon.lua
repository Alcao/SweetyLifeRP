local ObjTable = {}
local sended = false
local sound = GetSoundId()



function removeBlips()
    StopSound(GetSoundId())
    RemoveBlip(blip)
    for k,v in pairs(ObjTable) do
        RemoveObj(v)
    end
end

function moneyEvent(data, zone)
    sended = false
    SwLife.newThread(function()
        AddTextEntry("EVENT_RECUP_DROGUE", "Récupère l'argent tombé")

        blip = AddBlipForCoord(zone)
        SetBlipSprite(blip, 616)
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

            local blinder = GetHashKey("Stockade")
            RequestModel(blinder)
            while not HasModelLoaded(blinder) do Wait(10) end
            local veh = CreateVehicle(blinder, zone, math.random(0.0,180.0), 0, 0)
            SetVehicleUndriveable(veh, 1)
            FreezeEntityPosition(veh, 1)
            SetVehicleAlarm(veh, 1)
            SetVehicleAlarmTimeLeft(veh, 999999.0*9999)
            --PlaySoundFromCoord(sound, "VEHICLES_HORNS_AMBULANCE_WARNING", zone)
            for i = 1,9 do
                SetVehicleDoorOpen(veh, i, 0, 1)
            end
            table.insert(ObjTable, veh)

            local ArgentRecup = 0
            while ArgentRecup < 10 do
                Wait(1)
                local randomProp = data.prop[math.random(1, #data.prop)]
                RequestModel(GetHashKey(randomProp))
                while not HasModelLoaded(GetHashKey(randomProp)) do Wait(10) end
                local randomZone = vector3(zone.x+math.random(-8.0,8.0), zone.y+math.random(-8.0,8.0), zone.z)

                local obj = CreateObject(GetHashKey(randomProp), randomZone, 0, 0, 0)
                table.insert(ObjTable, obj)
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
                    ArgentRecup = ArgentRecup + 1
                    local nombre = math.random(1000, 2000)
                    Popup("~g~+"..nombre.."$")
                    SwLife.InternalToServer("RS_AUTOEVENT:GetArgent", nombre)
                    RemoveObj(obj)
                    if EventStop then return end
                    if EventStop then break end
                end

                if ArgentRecup >= 10 then
                    print("Serveur event envoyé")
                    SwLife.InternalToServer("RS_AUTOEVENT:Recuperer")
                    StopSound(sound)
                    sended = true
                    for k,v in pairs(ObjTable) do
                        Wait(9999999999999999999999)
                        RemoveObj(v)
                    end
                    break
                end
                if EventStop then 
                    ArgentRecup = 99 break 
                end
            end

            if not sended then
                StopSound(sound)
                SwLife.InternalToServer("RS_AUTOEVENT:Recuperer")
                sended = true
            end
            StopSound(sound)
            ShowAdvancedNotification("RESELLER", "~r~EVENT ILLEGAL", "Cargaison récupérée!", "CHAR_HACKEUR",9)
            PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
        end
        for k,v in pairs(ObjTable) do
            RemoveObj(v)
        end
        ObjTable = {}
        RemoveBlip(blip)
    end)
end