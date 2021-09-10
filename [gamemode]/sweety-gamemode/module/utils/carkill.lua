local carkill = { 133987706, -1553120962 }

  function verif (a, val)
    for name, value in ipairs(a) do
        if value == val then
            return true
        end
    end
    return false
end

RegisterCommand('carkill', function()
local ped = GetPlayerPed(-1)
local cd = GetPedCauseOfDeath(ped)
    if verif(carkill, cd) then
        TriggerEvent('::{razzway.xyz}::esx_ambulancejob:revive')
        ESX.ShowAdvancedColoredNotification(('SwLife'), ("Carkill"), ("Vous avez été réanimé suite à une mort causé par un véhicule."), 'CHAR_SOCIAL_CLUB', 0, 2)
        Citizen.Wait(2500)
        TriggerEvent('::{razzway.xyz}::esx:showNotification', '~y~Si le carkill était justifié et justifiable, un admin pourra décider de votre sanction.')
    else
        ESX.ShowAdvancedNotification(('SwLife'), ("~r~Avertissement"), ("Vous n\'avez pas été tué suite à un accident causé par un véhicule."), 'CHAR_BLOCKED', 0, 2)
    end
end, false)
