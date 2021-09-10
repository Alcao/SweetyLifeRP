ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

ConfPara              = {}
ConfPara.DrawDistance = 100
ConfPara.Size         = {x = 1.5, y = 1.5, z = 1.5}
ConfPara.Color        = {r = 0, g = 128, b = 255}
ConfPara.Type         = 40

RMenu.Add('razzpara1', 'menupara1', RageUI.CreateMenu("~b~Parachute", "~b~Activité Parachute"))

CreateThread(function()
    while true do
        Wait(1)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), -119.17, -977.16, 304.25)
        if Distance < 500.0 then
            if Distance < 2.0 then
                DrawMarker(ConfPara.Type, -119.17, -977.16, 304.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfPara.Size.x, ConfPara.Size.y, ConfPara.Size.z, ConfPara.Color.r, ConfPara.Color.g, ConfPara.Color.b, 100, false, true, 2, false, false, false, false)
                AddTextEntry("HELP", "Appuyer sur ~INPUT_PICKUP~ pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzpara1', 'menupara1'), true)
                    local IsParaMenuOpen = true
                    while IsParaMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzpara1', 'menupara1')) then
                            IsParaMenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzpara1', 'menupara1'), true, true, true, function()

                            RageUI.ButtonWithStyle("Parachute", nil, { RightLabel = "~b~1000$" }, true, function(h, a, s)
                                if s then
                                    SwLife.InternalToServer('rz-core:removeparachute')
                                    SwLife.InternalToServer('rz-core:giveparachute')
                                end
                            end)

                        end, function()end, 1)
                    end
                end
            end
        else
            Wait(5000)
        end
    end
end)

--------- PED & BLIPS -----------

DecorRegister("Parachute1", 4)
zoneP1 = vector3(-119.17, -977.16, 304.25)
HeadingP1 = 279.04
PedP1 = nil
HeadingSpawnP1 = 315.00

SwLife.newThread(function()
    local blipP1 = AddBlipForCoord(zoneP1)
    SetBlipSprite(blipP1, 94)
    SetBlipScale(blipP1, 0.6)
    SetBlipShrink(blipP1, true)
    SetBlipColour(blipP1, 2)
    SetBlipAsShortRange(blipP1, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Saut en Parachute")
    EndTextCommandSetBlipName(blipP1)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end