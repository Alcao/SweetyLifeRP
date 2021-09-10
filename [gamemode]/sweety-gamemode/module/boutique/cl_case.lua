local picture;

RMenu.Add('boutique', 'case', RageUI.CreateMenu("Boutique", "Achetez vos objets", 1100, 0, "menutoutbo", "interaction_bgd", 255, 255, 255, 255))
RMenu:Get('boutique', 'case'):SetSubtitle("Caisse")
RMenu:Get('boutique', 'case').Closed = function()
    picture = nil
end

RegisterNetEvent('tebex:on-open-case')
AddEventHandler('tebex:on-open-case', function(animations, name, message)
    RageUI.Visible(RMenu:Get('boutique', 'case'), true)
    SwLife.newThread(function()
        Citizen.Wait(250)
        for k, v in pairs(animations) do
            picture = v.name
            RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
            if v.time == 5000 then
                RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
                ESX.ShowAdvancedNotification('Boutique', 'Informations', message, 'CHAR_CALIFORNIA', 6, 2)
            end
            Citizen.Wait(v.time)
        end
    end)
end)

SwLife.newThread(function()
    while (true) do
        Citizen.Wait(1.0)

        RageUI.IsVisible(RMenu:Get('boutique', 'case'), function()

        end, function()
            if (picture) then
                RageUI.RenderSprite("case", picture)
            end
        end)


    end
    Citizen.Wait(500)
end)
