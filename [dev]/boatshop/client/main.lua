ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local sBoat = {}

RMenu.Add('boatshop', 'main', RageUI.CreateMenu("Boutique de Bateaux", "~b~Achetez vos bateaux"))
RMenu.Add('boatshop', 'listevehicule', RageUI.CreateSubMenu(RMenu:Get('boatshop', 'main'), "Catalogue", "~b~Voici la liste de nos bateaux"))
RMenu:Get('boatshop', 'main').EnableMouse = false
RMenu:Get('boatshop', 'main').Closed = function() sBoat.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function OpenBoatShopMenu()

	if sBoat.Menu then
        sBoat.Menu = false
    else
        sBoat.Menu = true
        RageUI.Visible(RMenu:Get('boatshop', 'main'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while sBoat.Menu do
                RageUI.IsVisible(RMenu:Get('boatshop', 'main'), true, true, true, function()
					RageUI.ButtonWithStyle("Clique", nil, {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                    end,RMenu:Get("boatshop","listevehicule"))
                end)
                RageUI.IsVisible(RMenu:Get('boatshop', 'listevehicule'), true, false, true, function()
                    RageUI.ButtonWithStyle("Jetski", "Type : ~b~Jetski~s~ | Prix : ~b~100000$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            TriggerServerEvent("Plustard") 
                        end
                    end)

                    RageUI.ButtonWithStyle("Jetski", "Type : ~b~Jetski~s~ | Prix : ~b~100000$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            TriggerServerEvent("Plustard") 
                        end
                    end)

                    RageUI.ButtonWithStyle("Jetski", "Type : ~b~Jetski~s~ | Prix : ~b~100000$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            TriggerServerEvent("Plustard") 
                        end
                    end)

                    RageUI.ButtonWithStyle("Jetski", "Type : ~b~Jetski~s~ | Prix : ~b~100000$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            TriggerServerEvent("Plustard") 
                        end
                    end)

                    RageUI.ButtonWithStyle("Jetski", "Type : ~b~Jetski~s~ | Prix : ~b~100000$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            TriggerServerEvent("Plustard") 
                        end
                    end)

                    RageUI.ButtonWithStyle("Jetski", "Type : ~b~Jetski~s~ | Prix : ~b~100000$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            TriggerServerEvent("Plustard") 
                        end
                    end)

                    RageUI.ButtonWithStyle("Jetski", "Type : ~b~Jetski~s~ | Prix : ~b~100000$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            TriggerServerEvent("Plustard") 
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

local BoatLoca = {
    {x = -756.85, y = -1489.81, z = 5.0}
}  

Citizen.CreateThread(function()
    for k in pairs(BoatLoca) do
       local blipBoatLoca = AddBlipForCoord(BoatLoca[k].x, BoatLoca[k].y, BoatLoca[k].z)
       SetBlipSprite(blipBoatLoca, 110)
       SetBlipColour(blipBoatLoca, 1)
       SetBlipScale(blipBoatLoca, 0.6)
       SetBlipAsShortRange(blipBoatLoca, true)

       BeginTextCommandSetBlipName('STRING')
       AddTextComponentString("Bite")
       EndTextCommandSetBlipName(blipBoatLoca)
   end
end)

Citizen.CreateThread(function()
    while true do
        local razzou = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(BoatLoca) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, BoatLoca[k].x, BoatLoca[k].y, BoatLoca[k].z)
            if not sBoat.Menu then
                if distance <= 10.0 then
                    razzou = 1
                    Draw3DText(BoatLoca[k].x, BoatLoca[k].y, 29.8, "Appuyez sur ~b~E~s~ pour accéder à ~b~au boat shop")
                    DrawMarker(6, BoatLoca[k].x, BoatLoca[k].y, BoatLoca[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                
                    if distance <= 1.5 then
                        ShowHelpNotification("Appuyez sur ~b~E~s~ pour ouvrir le menu")
                        if IsControlJustPressed(0, 51) then
                            OpenBoatShopMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)	
