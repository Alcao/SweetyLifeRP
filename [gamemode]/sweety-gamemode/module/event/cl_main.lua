EventStop = false


RegisterNetEvent("RS_AutoEvents_SendEvent")
AddEventHandler("RS_AutoEvents_SendEvent", function(data, zone)
    EventStop = false
    if data.type == "package" then
        packageEvent(data, zone)
    elseif data.type == "money" then
        moneyEvent(data, zone)
    end
end)


RegisterNetEvent("RS_AutoEvents_StopEvent")
AddEventHandler("RS_AutoEvents_StopEvent", function(data, zone)
    PlaySoundFrontend(-1, "Criminal_Damage_High_Value", "Criminal_Damage_High_Value", 1)
    PlaySoundFrontend(-1, "Criminal_Damage_High_Value", "Criminal_Damage_High_Value", 1)
    PlaySoundFrontend(-1, "Criminal_Damage_High_Value", "Criminal_Damage_High_Value", 1)
    PlaySoundFrontend(-1, "Checkpoint_Cash_Hit", "GTAO_FM_Events_Soundset", 1)
    ShowAdvancedNotification("Gary McKinnon", "~r~Événement Illégal", "Terminé! Tu n'étais pas encore arrivé? Ramène toi plus vite la prochaine fois!", "CHAR_HACKEUR",9)
    EventStop = true
    removeBlips()
end)

function RemoveObj(id)
    local entity = id
    SetEntityAsMissionEntity(entity, true, true)
    
    local timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
    
    if (DoesEntityExist(entity)) then 
        DeleteEntity(entity)
    end 
end

function Popup(txt)
    ClearPrints()
    SetNotificationBackgroundColor(140)
    SetNotificationTextEntry("Auto_event_popup")
    AddTextEntry('Auto_event_popup', txt)
    DrawNotification(false, true)
end

function ShowHelp(text, n)
    BeginTextCommandDisplayHelp(text)
    EndTextCommandDisplayHelp(n or 0, false, true, -1)
end

function ShowFloatingHelp(text, pos)
    SetFloatingHelpTextWorldPosition(1, pos)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    ShowHelp(text, 2)
end

function ShowAdvancedNotification(sender, subject, msg, textureDict, iconType)
    SetAudioFlag("LoadMPData", 1)
    PlaySoundFrontend(-1, "Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset", 1)
	AddTextEntry('AutoEventAdvNotif', msg)
	BeginTextCommandThefeedPost('AutoEventAdvNotif')
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	--EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end