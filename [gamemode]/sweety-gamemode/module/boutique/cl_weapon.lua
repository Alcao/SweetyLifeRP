local selected = nil;

SwLife.newThread(function()
    while (true) do
        Citizen.Wait(1000)
        local weapon = GetSelectedPedWeapon(PlayerPedId());
        if (weapon ~= GetHashKey("weapon_unarmed")) and (weapon ~= 966099553) and (weapon ~= 0) then
            if (selected ~= nil) and (weapon == GetHashKey("weapon_unarmed")) and (weapon == 966099553) and (weapon == 0) then
                selected = nil;
            end
            for i, v in pairs(ESX.GetWeaponList()) do
                if (GetHashKey(v.name) == weapon) then
                    selected = v
                end
            end
        else
            selected = nil;
        end

    end
end)

RMenu:Get('tebex', 'weapon').Closed = function()
    TriggerEvent('::{razzway.xyz}::esx:restoreLoadout')
end

RMenu:Get('tebex', 'weapon').onIndexChange = function(index)
    if (selected ~= nil) then
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(selected.name), selected.components[index].hash)
        if (selected.components[index - 1] ~= nil) and (selected.components[index - 1].hash ~= nil) then
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(selected.name), selected.components[index - 1].hash)
        end
        if (index == 1) then
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(selected.name), selected.components[#selected.components].hash)
        end
    end
end

SwLife.newThread(function()
    while (true) do
        Citizen.Wait(1.0)

        RageUI.IsVisible(RMenu:Get('tebex', 'weapon'), function()
            if (selected) then
                if (ESX.Table.SizeOf(selected) > 0) then
                    for i, v in pairs(selected.components) do
                        RageUI.Button(v.label, nil, { RightLabel = v.point }, true, {
                            onSelected = function()
                                SwLife.InternalToServer('tebex:on-process-checkout-weapon-custom', selected.name, v.hash)
                            end,
                        })
                    end
                else
                    RageUI.Separator("Aucune personnalisation disponible")
                end
            else
                RageUI.Separator("Vous n'avez pas d'arme dans vos main")
            end
        end, function()

        end)


    end
end)