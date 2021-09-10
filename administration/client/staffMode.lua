isStaffMode, serverInteraction = false,false

RegisterNetEvent("astra_staff:cbStaffState")
AddEventHandler("astra_staff:cbStaffState", function(isStaff)
    isStaffMode = isStaff
    serverInteraction = false
    DecorSetBool(PlayerPedId(), "isStaffMode", isStaffMode)
    if isStaffMode then
        local cVar1 = "~b~"
        local cVar2 = "/\\"
        Citizen.CreateThread(function()
            while isStaffMode do
                Wait(650)
                if cVar1 == "~b~" then cVar1 = "~s~" else cVar1 = "~b~" end
            end
        end)
        Citizen.CreateThread(function()
            while isStaffMode do
                Wait(1)
                RageUI.Text({message = cVar1.."Administration Active"..cVar1.."\n"..generateReportDisplay()})
            end
        end)
    else
        NoClip(false)
        showNames(false)
    end
end)