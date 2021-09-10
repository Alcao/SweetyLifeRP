
AddEventHandler('playerSpawned', function()
    SwLife.InternalToServer('vSync:requestSync')
end)

CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather

local names = {
    ["EXTRASUNNY"] = "Le soleil est maintenant très fort et les températures très hautes.",
    ["CLEAR"] = "Une brume vient de se former, attention sur la route.",
    ["NEUTRAL"] = "Le ciel est maintenant bien dégagé, les températures sont normals.",
    ["SMOG"] = "Une très légère brume s'est levée.",
    ["FOGGY"] = "Une ambiance brumeuse vient de se lever.",
    ["OVERCAST"] = "Le ciel est maintenant assez couvert.",
    ["CLOUDS"] = "Le ciel est maintenant un peu nuageux.",
    ["CLEARING"] = "Le ciel se dégage.",
    ["RAIN"] = "La pluie commence à tomber.",
    ["THUNDER"] = "L'orage est de sortie !",
    ["SNOW"] = "Une légère neige commence à tomber.",
    ["BLIZZARD"] = "Un blizzard vient de se lever, sortez couvert!",
    ["SNOWLIGHT"] = "Une ambiance neigeuse c'est lever, attention à vous.",
    ["XMAS"] = "La neige recouvre maintenant le sol, attention à votre conduite et sortez couvert!",
    ["HALLOWEEN"] = "Une ambiance sinistre s'installe sur la ville ....",
}

RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(NewWeather)
    CurrentWeather = NewWeather

    while ESX == nil do
        Wait(50)
    end

    while not ESX.IsPlayerLoaded() do
        Wait(50)
    end

    ESX.ShowAdvancedNotification("Méteo", "~g~Annonce", ""..names[NewWeather], "CHAR_LS_TOURIST_BOARD", 1)
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(1850)
        end
        Citizen.Wait(1500)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)