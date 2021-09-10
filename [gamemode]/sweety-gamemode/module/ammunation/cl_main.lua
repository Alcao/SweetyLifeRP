ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
    end
end)

local Razzway = {}

function OpenAmmunation()

    if Razzway.Visible then
        Razzway.Visible = false
        RageUI.Visible(RMenu:Get('rz-weapon', 'main'), false)
        return
    else
        RMenu.Add('rz-weapon', 'main', RageUI.CreateMenu("Armurerie", "~b~Voici ce que nous vendons."))
        RMenu:Get('rz-weapon', 'main').EnableMouse = false
        RMenu.Add('rz-weapon', 'armesblanches', RageUI.CreateSubMenu(RMenu:Get('rz-weapon', 'main'), "Armurerie", "~b~Voici nos armes blanches."))
        RMenu.Add('rz-weapon', 'armesletales', RageUI.CreateSubMenu(RMenu:Get('rz-weapon', 'main'), "Armurerie", "~b~Voici nos armes létales."))
        RMenu.Add('rz-weapon', 'accessories', RageUI.CreateSubMenu(RMenu:Get('rz-weapon', 'main'), "Armurerie", "~b~Voici nos accessoires."))
        RMenu:Get('rz-weapon', 'main').Closed = function() Razzway.Visible = false FreezeEntityPosition(GetPlayerPed(-1), false) end
        Razzway.Visible = true
        RageUI.Visible(RMenu:Get('rz-weapon', 'main'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while Razzway.Visible do
                RageUI.IsVisible(RMenu:Get('rz-weapon', 'main'), true, true, true, function()
                        RageUI.ButtonWithStyle("Armes blanches", false, {RightLabel = "→→"}, true, function(h,a,s)
                        end,RMenu:Get("rz-weapon","armesblanches"))
                        RageUI.ButtonWithStyle("Armes létales", false, {RightLabel = "→→"}, true, function(h,a,s)
                        end,RMenu:Get("rz-weapon","armesletales"))
                        RageUI.ButtonWithStyle("Accessoires", false, {RightLabel = "→→"}, true, function(h,a,s)
                        end,RMenu:Get("rz-weapon","accessories"))
                    end)
                    
                RageUI.IsVisible(RMenu:Get('rz-weapon', 'armesblanches'), true, true, true, function()
                    RageUI.ButtonWithStyle("Club de golf", "Type : ~b~Club de Golf~s~ | Prix : ~b~2500$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('rz-ammu:achatweapon', "weapon_golfclub", 250, 2500)
                        end
                    end)
                    RageUI.ButtonWithStyle("Couteau à cran d'arrêt", "Type : ~b~Cran d'arrêt~s~ | Prix : ~b~3500$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('rz-ammu:achatweapon', "weapon_switchblade", 250, 3500)
                        end
                    end)
                    RageUI.ButtonWithStyle("Hachette", "Type : ~b~Hachette~s~ | Prix : ~b~4500$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('rz-ammu:achatweapon', "weapon_hatchet", 250, 4500)
                        end
                    end)
                    RageUI.ButtonWithStyle("Poing américain", "Type : ~b~Poing américain~s~ | Prix : ~b~5000$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('rz-ammu:achatweapon', "weapon_knuckle", 250, 5000)
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('rz-weapon', 'armesletales'), true, true, true, function()
                    RageUI.ButtonWithStyle("Pétoire", "Type : ~b~Pétoire~s~ | Prix : ~b~120000$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('rz-ammu:achatweapon', "weapon_snspistol", 250, 120000)
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('rz-weapon', 'accessories'), true, true, true, function()
                    RageUI.ButtonWithStyle("Chargeur", "Type : ~b~Chargeur~s~ | Prix : ~b~500$", {RightLabel = "~y~Acheter~s~ →"}, true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('rz-ammu:achatItems', 'clip', 500)
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

-- Blips & Marker --
Citizen.CreateThread(function()
    for k,v in pairs(Ammunation.Request["Position"]) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite (blip, 110)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.6)
        SetBlipColour (blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("[Magasin] Armurerie")
        EndTextCommandSetBlipName(blip)                    
    end
    while true do
        local interval = 850
        local PlyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Ammunation.Request["Position"]) do
            local distance = Vdist(PlyCoords.x, PlyCoords.y, PlyCoords.z, v.coords.x, v.coords.y, v.coords.z)
            if not Razzway.Visible then
                if distance <= 8.0 then
                    interval = 1
                    DrawMarker(Ammunation.Marker, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Ammunation.Size.x, Ammunation.Size.y, Ammunation.Size.z, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                end
                
                if distance <= 1.5 then
                    ShowHelpNotification("Appuyez sur ~b~E~s~ pour ouvrir le menu")
                    if IsControlJustPressed(0, 51) then
                        OpenAmmunation()
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)

RegisterNetEvent('rz-weapon:useClip')
AddEventHandler('rz-weapon:useClip', function()
	local playerPed = PlayerPedId()

	if IsPedArmed(playerPed, 4) then
		local hash = GetSelectedPedWeapon(playerPed)

		if hash then
			SwLife.InternalToServer('rz-weapon:removeClip')
			AddAmmoToPed(playerPed, hash, 25)
			ESX.ShowNotification("Vous avez ~b~utilisé~s~ 1x chargeur")
		else
			ESX.ShowNotification("~r~Action Impossible~s~ : Vous n'avez pas d'arme en main !")
		end
	else
		ESX.ShowNotification("~r~Action Impossible~s~ : Ce type de munition ne convient pas !")
	end
end)