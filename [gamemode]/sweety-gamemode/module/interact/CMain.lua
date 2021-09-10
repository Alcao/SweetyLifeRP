ESX = nil

SwLife.newThread(function()
    while ESX == nil do
        TriggerEvent('SwLife:initObject', function(obj)
            ESX = obj
        end)
        ESX.PlayerData = ESX.GetPlayerData()
        Citizen.Wait(10)
    end

    RefreshMoney()
    RefreshMoney2()

    WeaponData = ESX.GetWeaponList()

    for i = 1, #WeaponData, 1 do
        if WeaponData[i].name == 'WEAPON_UNARMED' then
            WeaponData[i] = nil
        else
            WeaponData[i].hash = GetHashKey(WeaponData[i].name)
        end
    end


end)

Player = {
	isDead = false,
	inAnim = false,
	ragdoll = false,
	crouched = false,
	handsup = false,
	pointing = false,
	minimap = true,
	ui = true,
	noclip = false,
	godmode = false,
	ghostmode = false,
	showCoords = false,
	showName = false,
	gamerTags = {}
}

object = {}
local inventaire = false
local status = true

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local PersonalMenu = {
    billing = {},
    engineActionList = {
        "Allumer",
        "Éteindre",
    },
    engineActionIndex = 1,
}

local ItemSelected = {}
local engineCoolDown = false
local bank = nil
local sale = nil
local extraList = {"n°1","n°2","n°3","n°4","n°5","n°6","n°7","n°8","n°9","n°10","n°11","n°12","n°13","n°14","n°15"}
local extraIndex = 1
local extraCooldown = false
local extraStateIndex = 1
local doorActionIndex = 1

function GetCurrentWeight()
	local currentWeight = 0

	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].count > 0 then
			currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
		end
	end

	return currentWeight
end

function getvehicleskey()
    getplayerkeys = {}
    ESX.TriggerServerCallback('::{razzway.xyz}::esx_vehiclelock:allkey', function(mykey)
        for i = 1, #mykey, 1 do
			if mykey[i].NB == 1 then
				table.insert(getplayerkeys, {label = 'Clés : '.. ' [' .. mykey[i].plate .. ']', value = mykey[i].plate})
			elseif mykey[i].NB == 2 then
				table.insert(getplayerkeys, {label = '[DOUBLE] Véhicule : '.. ' [' .. mykey[i].plate .. ']', value = nil})
			end
		end
    end)
end

function OpenRzInteract()

    if PersonalMenu.Menu then 
        PersonalMenu.Menu = false 
        RageUI.Visible(RMenu:Get('personalmenu', 'main'), false)
        return
    else
        RMenu.Add('personalmenu', 'main', RageUI.CreateMenu("Inventaire", "Test"))
        RMenu.Add('personalmenu', 'inventory', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'inventory_use', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "inventory"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'wallet', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'weapon', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'gestion', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'keys', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "gestion"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'keysmanagement', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "keys"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'gestionveh', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'clothes', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'boss', RageUI.CreateSubMenu(RMenu:Get('personalmenu', 'gestion'),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'boss2', RageUI.CreateSubMenu(RMenu:Get('personalmenu', 'gestion'),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'touches', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'portefeuille_money', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "wallet"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'portefeuille_blackmoney', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "wallet"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'portefeuille_work', RageUI.CreateSubMenu(RMenu:Get('personalmenu', 'wallet'), "Emplois", " "))
        RMenu.Add('personalmenu', 'papers', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "wallet"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'billing', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "wallet"),"Inventaire", "Menu d'intéraction"))
        RMenu.Add('personalmenu', 'autres', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"Inventaire", "Menu d'intéraction"))
        RMenu:Get('personalmenu', 'main'):SetSubtitle("Menu d'intéraction")
        RMenu:Get('personalmenu', 'main').EnableMouse = false
        RMenu:Get('personalmenu', 'main').Closed = function()
            PersonalMenu.Menu = false
            refresh()
        end
        PersonalMenu.Menu = true 
        RageUI.Visible(RMenu:Get('personalmenu', 'main'), true)
        SwLife.newThread(function()
			while PersonalMenu.Menu do
                RageUI.IsVisible(RMenu:Get('personalmenu', 'main'), true, true, true, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    pGrade = ESX.GetPlayerData().job.grade_name
                    pGrade2 = ESX.GetPlayerData().job2.grade_name
                    RageUI.Separator("[  Joueur : ~b~".. GetPlayerName(PlayerId()) .."~s~ | ID : ~b~"..GetPlayerServerId(PlayerId()).."~s~  ]")
                    RageUI.ButtonWithStyle("Mes poches", nil, { RightLabel = "→→" },true, function()
                    end, RMenu:Get('personalmenu', 'inventory'))
                    RageUI.ButtonWithStyle("Vêtement", nil, { RightLabel = "→→" },true, function()
                    end, RMenu:Get('personalmenu', 'clothes'))
                    RageUI.ButtonWithStyle("Informations", nil, { RightLabel = "→→" },true, function()
                    end, RMenu:Get('personalmenu', 'wallet'))
                    RageUI.ButtonWithStyle("Touches", nil, { RightLabel = "→→" },true, function()
                    end, RMenu:Get('personalmenu', 'touches'))
                    RageUI.ButtonWithStyle("Armes", nil, { RightLabel = "→→" },true, function(h,a,s)
                    end, RMenu:Get('personalmenu', 'weapon'))
                    RageUI.ButtonWithStyle("Gestions", nil, { RightLabel = "→→" },true, function(h,a,s)
                    end, RMenu:Get('personalmenu', 'gestion'))
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
						RageUI.ButtonWithStyle("Véhicule", nil, {RightLabel = "→→"},true, function()
						end, RMenu:Get('personalmenu', 'gestionveh'))
					else
						
					end
                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→" },true, function(h,a,s)
                    end, RMenu:Get('personalmenu', 'autres'))
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'weapon'), true, true, true, function()
                    for i = 1, #WeaponData, 1 do
                        if HasPedGotWeapon(PlayerPedId(), WeaponData[i].hash, false) then
                            local ammo = GetAmmoInPedWeapon(Ped, WeaponData[i].hash)
            
                            RageUI.ButtonWithStyle(WeaponData[i].label, "Munition(s) : ~c~x"..ammo, {RightLabel = "~b~Donner~s~ →"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if WeaponData[i].name == "WEAPON_MUSKET" then
                                        ESX.ShowNotification("~r~Erreur~s~~n~Vous ne pouvez pas donner cette arme !")
                                        return
                                    else
                                        local playerdst, distance = ESX.Game.GetClosestPlayer()
                                        if playerdst ~= -1 and distance <= 2.0 then
                                            local closestPed = GetPlayerPed(playerdst)
                                            if IsPedOnFoot(closestPed) then
                                                local ammo = GetAmmoInPedWeapon(PlayerPedId(), WeaponData[i].hash)
                                                SwLife.InternalToServer('::{razzway.xyz}::esx:giveInventoryItem', GetPlayerServerId(playerdst), "item_weapon", WeaponData[i].name, ammo)
                                                RageUI.CloseAll()
                                                PersonalMenu.Menu = false
                                            else
                                             RageUI.Popup({message = "~r~Impossible~s~ de donner une arme dans un véhicule."})
                                            end
                                        else
                                             ESX.ShowNotification("~r~Personne autour de vous !")
                                        end             
                                    end
                                end
                            end)
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'gestion'), true, true, true, function()
                    RageUI.ButtonWithStyle("Gestion des clés", nil, { RightLabel = "→→" },true, function(h,a,s)
                        if s then
                            getvehicleskey()
                        end
                    end, RMenu:Get('personalmenu', 'keys'))
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then

                        RageUI.ButtonWithStyle("Gestion d'entreprise", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                        end
                    end, RMenu:Get('personalmenu', 'boss'))
                else
                    RageUI.ButtonWithStyle("Gestion d'entreprise", "Vous devez être patron pour y accéder.", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
                        if Selected then
                            end
                        end)
                    end 
                    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then

                        RageUI.ButtonWithStyle("Gestion Organisation", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                        end
                    end, RMenu:Get('personalmenu', 'boss2'))
                else
                    RageUI.ButtonWithStyle("Gestion Organisation", "Vous devez être jefe pour y accéder.", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(Hovered, Active, Selected)
                        if Selected then
                            end
                        end)
                    end 
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'keys'), true, true, true, function()
                    for k,v in pairs(getplayerkeys) do
                        RageUI.ButtonWithStyle(v.label, nil, {RightLabel = ""}, true, function(h,a,s)  
                            if s then
                                v.value = actualvalue
                            end
                        end,RMenu:Get("personalmenu","keysmanagement"))
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'clothes'), true, true, true, function()

                    RageUI.ButtonWithStyle("Haut", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("rRazzway:requestClothes", "haut")
                        end
                    end)
                    RageUI.ButtonWithStyle("Bas", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("rRazzway:requestClothes", "bas")
                        end
                    end)
                    RageUI.ButtonWithStyle("Chaussures", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("rRazzway:requestClothes", "chaussures")
                        end
                    end)
                    RageUI.ButtonWithStyle("Sac", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("rRazzway:requestClothes", "sac")
                        end
                    end)
                    RageUI.ButtonWithStyle("Gilet par Balles", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("rRazzway:requestClothes", "gilet")
                        end
                    end)
                    RageUI.ButtonWithStyle("Masque", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("rRazzway:requestClothes", "masque")
                        end
                    end)

                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'touches'), true, true, true, function()
                    RageUI.ButtonWithStyle("Téléphone ", nil, {RightLabel = "G"},true, function(h,a,s)  
                        if s then   

                        end
                    end) 

                    RageUI.ButtonWithStyle("Menu Emotes ", nil, {RightLabel = "K"},true, function(h,a,s)  
                    if s then   
        
                        end
                    end)

                    RageUI.ButtonWithStyle("Menu Personnel ", nil, {RightLabel = "F5"},true, function(h,a,s)  
                        if s then   
            
                        end
                    end)

                    RageUI.ButtonWithStyle("Menu Métiers ", nil, {RightLabel = "F6"},true, function(h,a,s)  
                        if s then   
                
                        end
                    end)

                    RageUI.ButtonWithStyle("Menu Radio", nil, {RightLabel = "F9"},true, function(h,a,s)  
                        if s then   
                    
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Menu Vêtement", nil, {RightLabel = "Y"},true, function(h,a,s)  
                        if s then   
        
                        end
                    end) 

                    RageUI.ButtonWithStyle("Vérouiller/ Déverouiller son véhicule ", nil, {RightLabel = "U"},true, function(h,a,s)  
                        if s then   
        
                        end
                    end) 

                    RageUI.ButtonWithStyle("Mode de Voix", nil, {RightLabel = "F3"},true, function(h,a,s)  
                        if s then   
            
                        end
                    end)

                    RageUI.ButtonWithStyle("Coffre de Vehicule ", nil, {RightLabel = "L"},true, function(h,a,s)  
                        if s then   
            
                        end
                    end)
            
                    RageUI.ButtonWithStyle("Annuler Annimation ", nil, {RightLabel = "X"},true, function(h,a,s)  
                        if s then   
            
                        end
                    end)

                    RageUI.ButtonWithStyle("Lever les Mains", nil, {RightLabel = "²"},true, function(h,a,s)  
                        if s then   
            
                        end
                    end)

                    RageUI.ButtonWithStyle("Montrer du Doigt ", nil, {RightLabel = "B"},true, function(h,a,s)  
                        if s then   
            
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'keysmanagement'), true, true, true, function()
                    local player, distance = ESX.Game.GetClosestPlayer()
					local playerPed = PlayerPedId()
					local plyCoords = GetEntityCoords(playerPed, false)
					local vehicle = GetClosestVehicle(plyCoords, 7.0, 0, 71)
					local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
					local vehPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                    RageUI.ButtonWithStyle("Donner le véhicule/clés", nil, {RightLabel = ""}, true, function(h,a,s)  
                        if s then
							if distance ~= -1 and distance <= 3.0 then
								SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:changeowner', GetPlayerServerId(player), vehPlate, vehicleProps)
							else
								ESX.ShowNotification("~r~Erreur~s~ \nAucun joueur à proximité")
							end
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'autres'), true, true, true, function()
                    RageUI.ButtonWithStyle('Personnage ID :', nil, {RightLabel = GetPlayerServerId(PlayerId())}, true, function() end)
                    RageUI.ButtonWithStyle('Numéro de Compte :', nil, {RightLabel = ESX.PlayerData.character_id}, true, function() end)
                    RageUI.Checkbox('Interface GPS', nil, Player.minimap, {}, function(h,a,s)
                        if s then
                            Player.minimap = not Player.minimap
                            DisplayRadar(Player.minimap)
                        end
                    end)
                    RageUI.ButtonWithStyle("Porter la personne la plus proche", nil,{ RightLabel = "→" }, true, function(_,_,s)
                        if s then 
                            ExecuteCommand("porter")
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'gestionveh'), true, true, true, function()
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                        RageUI.List("Action moteur", PersonalMenu.engineActionList, PersonalMenu.engineActionIndex, nil, {}, not engineCoolDown, function(h,a,s, Index)
                            if s then        
                                if Index == 1 then
                                    SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(),false),true,true,false)
                                else
                                    SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(),false),false,true,true)
                                end
                                engineCoolDown = true
                                Citizen.SetTimeout(1000, function()
                                    engineCoolDown = false
                                end)
                            end
                
                            PersonalMenu.engineActionIndex = Index
                        end)
                        if ESX.PlayerData.job.label == "Police" then
                            RageUI.List("Extra du véhicule", extraList, extraIndex, nil, {}, true, function(h,a,s, Index)
                                if s then
                                    if isAllowedToManageVehicle() then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                                        if not vehicleIsDamaged() then
                                            if Index == 1 then
                                                SetVehicleExtra(vehicle,1)
                                                ESX.Game.SetVehicleProperties(vehicle, {
                                                    modFender = 0
                                                })
                                            elseif Index == 2 then
                                                SetVehicleExtra(vehicle,2)
                                            elseif Index == 3 then
                                                SetVehicleExtra(vehicle,3)
                                            elseif Index == 4 then
                                                SetVehicleExtra(vehicle,4)
                                            elseif Index == 5 then
                                                SetVehicleExtra(vehicle,5)
                                            elseif Index == 6 then
                                                SetVehicleExtra(vehicle,6)
                                            elseif Index == 7 then
                                                SetVehicleExtra(vehicle,7)
                                            elseif Index == 8 then
                                                SetVehicleExtra(vehicle,8)
                                            elseif Index == 9 then
                                                SetVehicleExtra(vehicle,9)
                                            elseif Index == 10 then
                                                SetVehicleExtra(vehicle,10)
                                            elseif Index == 11 then
                                                SetVehicleExtra(vehicle,11)
                                            elseif Index == 12 then
                                                SetVehicleExtra(vehicle,12)
                                            elseif Index == 13 then
                                                SetVehicleExtra(vehicle,13)
                                            elseif Index == 14 then
                                                SetVehicleExtra(vehicle,14)
                                            elseif Index == 15 then
                                                SetVehicleExtra(vehicle,15)
                                            end
                                        end
                                    end
                                end
                                extraIndex = Index
                            end)
                            RageUI.ButtonWithStyle("Extra ~g~ON", nil, {}, not extraCooldown, function(_,_,s)
                                if s then
                                    if isAllowedToManageVehicle() then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                                        if not vehicleIsDamaged() then
                                            SetVehicleExtra(vehicle,extraIndex,0)
                                            ESX.Game.SetVehicleProperties(vehicle, {
                                                modFender = 0
                                            })
                                            extraCooldown = true
                                            Citizen.SetTimeout(150, function()
                                                extraCooldown = false
                                            end)
                                        else
                                            ESX.ShowNotification("Ton véhicule est trop endommagé pour pouvoir y apporter des modificiations.")
                                        end
                                    end  
                                end
                            end)
            
                            RageUI.ButtonWithStyle("Extra ~r~OFF", nil, {}, not extraCooldown, function(_,_,s)
                                if s then
                                    if isAllowedToManageVehicle() then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                                        if not vehicleIsDamaged() then
                                            SetVehicleExtra(vehicle,extraIndex,1)
                                            ESX.Game.SetVehicleProperties(vehicle, {
                                                modFender = 1
                                            })
                                            extraCooldown = true
                                            Citizen.SetTimeout(150, function()
                                                extraCooldown = false
                                            end)
                                        else
                                            ESX.ShowNotification("Ton véhicule est trop endommagé pour pouvoir y apporter des modificiations.")
                                        end
                                    end  
                                end
                            end)
                            RageUI.List("Tous les extras", {"Activer","Désactiver"}, extraStateIndex, nil, {}, not extraCooldown, function(h,a,s, Index)
                                if s then
                                    if isAllowedToManageVehicle() then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                                        if not vehicleIsDamaged() then
                                            if Index == 1 then
                                                for index,_ in pairs(extraList) do
                                                    SetVehicleExtra(vehicle,index,0)
                                                end
                                            else
                                                for index,_ in pairs(extraList) do
                                                    SetVehicleExtra(vehicle,index,1)
                                                end
                                            end
                                            extraCooldown = true
                                            Citizen.SetTimeout(150, function()
                                                extraCooldown = false
                                            end)
                                        else
                                            ESX.ShowNotification("Ton véhicule est trop endommagé pour pouvoir y apporter des modificiations.")
                                        end
                                    end
                                end
                                extraStateIndex = Index
                            end)
                            
                        end
                        RageUI.List("Action portes", {"Ouvrir","Fermer"}, doorActionIndex, nil, {}, true, function(h,a,s, Index)
                            doorActionIndex = Index
                        end)
        
                        RageUI.ButtonWithStyle("Tout le véhicule", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(-1) end
                            end
                        end)
        
                        RageUI.ButtonWithStyle("Porte avant-gauche", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(0) end 
                            end
                        end)
        
                        RageUI.ButtonWithStyle("Porte avant-droite", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(1) end 
                            end
                        end)
        
                        RageUI.ButtonWithStyle("Porte arrière-gauche", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(2) end 
                            end
                        end)
        
                        RageUI.ButtonWithStyle("Porte arrière-droite", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(3) end 
                            end
                        end)
        
                        RageUI.ButtonWithStyle("Capot", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(4) end 
                            end
                        end)
        
                        RageUI.ButtonWithStyle("Coffre", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(5) end
                            end
                        end)
                    else
                        RageUI.GoBack()
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'inventory'), true, true, true, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    RageUI.Separator("~b~Inventaire~s~ ".. GetCurrentWeight().." / 45.0")
                    for i = 1, #ESX.PlayerData.inventory, 1 do
                        if ESX.PlayerData.inventory[i].count > 0 then
                            local invCount = {}

                            for i = 1, ESX.PlayerData.inventory[i].count, 1 do
                                table.insert(invCount, i)
                            end

                            RageUI.ButtonWithStyle(ESX.PlayerData.inventory[i].label .. ' ~b~(' .. ESX.PlayerData.inventory[i].count .. ')~s~', nil, {}, true, function(h, a, s)
                                if s then
                                    ItemSelected = ESX.PlayerData.inventory[i]
                                end
                            end, RMenu:Get('personalmenu', 'inventory_use'))
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'inventory_use'), true, true, true, function()
                    RageUI.Separator(ItemSelected.label.." ~b~("..ItemSelected.count..")")
                    RageUI.ButtonWithStyle("Utiliser", nil, {}, true, function(h, a, s)
                        if s then
                            SwLife.InternalToServer('::{razzway.xyz}::esx:useItem', ItemSelected.name)
                        end
                    end)
                    RageUI.ButtonWithStyle("Donner", nil, {}, true, function(h, a, s)
                        if a then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer ~= -1 and closestDistance <= 3 then
                                playerMarker(closestPlayer)
                            end
                        end
                        if s then
                            local sonner,quantity = CheckQuantity(CustomAmount())
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            local pPed = GetPlayerPed(-1)
                            local coords = GetEntityCoords(pPed)
                            local x,y,z = table.unpack(coords)
                            if sonner then
                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)

                                    if IsPedOnFoot(closestPed) then
                                        SwLife.InternalToServer('::{razzway.xyz}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', ItemSelected.name, quantity)
                                    else
                                        ESX.ShowNotification("~b~Menu personnel~s~\nvous ne pouvez pas donner d'item en étant dans une voiture")
                                    end
                                else
                                    ESX.ShowNotification("~r~Erreur\n~s~Aucun joueur à proximité !")
                                end
                            end
                        end
                    end) 
                    RageUI.ButtonWithStyle("Jeter", nil, {}, true, function(h,a,s)
                        if s then
                            local sonner,quantity = CheckQuantity(CustomAmount())
                            if sonner then
                                if IsPedInAnyVehicle(PlayerPedId(), true) then
                                    ESX.ShowNotification("~r~Erreur~s~\nvous ne pouvez pas jeter d'item en étant dans une voiture")
                                else
                                    SwLife.InternalToServer('::{razzway.xyz}::esx:dropInventoryItem', 'item_standard', ItemSelected.name, quantity)
                                    RageUI.GoBack()
                                end
                            else
                                ESX.ShowNotification("~r~Erreur\n~s~Valeur incorrect")
                            end
                        end
                    end) 
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'wallet'), true, true, true, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'cash'  then
                            cash = RageUI.ButtonWithStyle('Argent en Liquide :', description, {RightLabel = "~g~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.." ~g~$")}, true, function(h, a, s) 
                            end, RMenu:Get('personalmenu', 'portefeuille_money'))
                        end
                    end
            
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'bank'  then
                            bank = RageUI.ButtonWithStyle('Argent en Banque :', description, {RightLabel = "~b~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.." ~b~$")}, true, function(h, a, s) 
                        if s then
                            ESX.ShowNotification("~b~Menu personnel~s~\nMerci de vous rendre dans une banque")
                        end 
                    end)
            
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'dirtycash'  then
                            sale = RageUI.ButtonWithStyle('Source inconnue :', description, {RightLabel = "~c~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.." ~c~$")}, true, function() 
                            end, RMenu:Get('personalmenu', 'portefeuille_blackmoney'))
                        end
                    end
                        end
                    end
                    RageUI.ButtonWithStyle("Papiers", nil, { RightLabel = "→→" },true, function()
                    end, RMenu:Get('personalmenu', 'papers'))
                    RageUI.ButtonWithStyle("Factures", nil, { RightLabel = "→→" },true, function(h,a,s)
                        if s then
                            RefreshBilling()
                        end
                    end, RMenu:Get('personalmenu', 'billing'))
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'billing'), true, true, true, function()
                    if #PersonalMenu.billing == 0 then
                        RageUI.Separator("")
                        RageUI.Separator("~r~Vous n'avez aucune facture")
                        RageUI.Separator("")
                    end
                    for i = 1, #PersonalMenu.billing, 1 do
						RageUI.ButtonWithStyle(PersonalMenu.billing[i].label, nil, {RightLabel = ESX.Math.GroupDigits(PersonalMenu.billing[i].amount.."~g~$")}, true, function(h,a,s)
							if s then
								ESX.TriggerServerCallback('::{razzway.xyz}::esx_billing:payBill', function()
								end, PersonalMenu.billing[i].id)
                                ESX.SetTimeout(100, function()
                                    RefreshBilling()
                                    RageUI.GoBack()
                                end)
							end
						end)
					end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'papers'), true, true, true, function()
                    RageUI.ButtonWithStyle("Regarder sa carte d'identité", nil, { RightLabel = "→→" },true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                        end
                    end)
                    RageUI.ButtonWithStyle("Montrer sa carte d'identité", nil, { RightLabel = "→→" },true, function(h,a,s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                                SwLife.InternalToServer('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                            else
                                ESX.ShowNotification("Personne autour")
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle("Regarder son permis de conduire", nil, { RightLabel = "→→" },true, function(h,a,s)
                        if s then
                            SwLife.InternalToServer('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                        end
                    end)
                    RageUI.ButtonWithStyle("Montrer son permis de conduire", nil, { RightLabel = "→→" },true, function(h,a,s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                            if closestDistance ~= -1 and closestDistance <= 3.0 then
                                SwLife.InternalToServer('::{razzway.xyz}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                            else
                                ESX.ShowNotification("Personne autour")
                            end
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'boss'), true, true, true, function()
                    RageUI.Separator("Votre Métier : ~b~"..ESX.PlayerData.job.label.."")
                    RageUI.Separator("Votre Grade : ~b~"..ESX.PlayerData.job.grade_label.."")
                    if societymoney ~= nil then
                        RageUI.Separator("Argent dans la société : ~b~"..societymoney.."$")
                    end

                    RageUI.Separator("")
                RageUI.ButtonWithStyle('Recruter une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Aucun joueur proche.')
                            else
                                SwLife.InternalToServer('rRazzway:recrutejoueur', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
                            end
                        else
                            ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)
        
                RageUI.ButtonWithStyle('Virer une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Aucun joueur proche.')
                            else
                                SwLife.InternalToServer('rRazzway:virerjoueur', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)
        
                RageUI.ButtonWithStyle('Promouvoir une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Aucun joueur proche.')
                            else
                                SwLife.InternalToServer('c26bgdtoklmtbr:{-pp}', GetPlayerServerId(closestPlayer))
                        end
                        else
                            ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)
        
                RageUI.ButtonWithStyle('Destituer une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification('~r~Aucun joueur proche.')
                                else
                                SwLife.InternalToServer('f45bgdtj78ql:[tl-yu]', GetPlayerServerId(closestPlayer))
                                    end
                                else
                                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                                end
                            end
                        end)
                    end, function()
                end)

                RageUI.IsVisible(RMenu:Get('personalmenu', 'boss2'), true, true, true, function()

                    RageUI.Separator("Organisation : ~r~"..ESX.PlayerData.job2.label.."")
                    RageUI.Separator("Votre Grade : ~r~"..ESX.PlayerData.job2.grade_label.."")
                    if societymoney ~= nil then
                        RageUI.Separator("Argent dans le coffre~s~ : ~r~"..societymoney2.."$")
                    end

                    RageUI.Separator("")
                    RageUI.ButtonWithStyle('Recruter une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if ESX.PlayerData.job2.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification('~r~Aucun joueur proche.')
                                else
                                    SwLife.InternalToServer('rRazzway:recrutejoueur2', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0)
                                end
                            else
                                ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                            end
                        end
                    end)
            
                    RageUI.ButtonWithStyle('Virer une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if ESX.PlayerData.job2.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification('~r~Aucun joueur proche.')
                                else
                                    SwLife.InternalToServer('rRazzway:virerjoueur2', GetPlayerServerId(closestPlayer))
                                end
                            else
                                ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                            end
                        end
                    end)
            
                    RageUI.ButtonWithStyle('Promouvoir une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if ESX.PlayerData.job2.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification('~r~Aucun joueur proche.')
                                else
                                    SwLife.InternalToServer('rRazzway:promouvoirjoueur2', GetPlayerServerId(closestPlayer))
                            end
                            else
                                ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                            end
                        end
                    end)
            
                    RageUI.ButtonWithStyle('Destituer une personne', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if ESX.PlayerData.job2.grade_name == 'boss' then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                        ESX.ShowNotification('~r~Aucun joueur proche.')
                                    else
                                    SwLife.InternalToServer('rRazzway:destituerjoueur2', GetPlayerServerId(closestPlayer))
                                        end
                                    else
                                        ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                                    end
                                end
                            end)
                        end, function()
                    end)
            
                RageUI.IsVisible(RMenu:Get('personalmenu', 'portefeuille_money'), true, true, true, function()
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'cash'  then
                            cash = RageUI.Separator('Argent liquide :~g~ '..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.." ~g~$")) 
                            RageUI.ButtonWithStyle("Donner", nil, {}, true, function(h,a,s)
                                if a then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    if closestPlayer ~= -1 and closestDistance <= 3 then
                                        playerMarker(closestPlayer)
                                    end
                                end
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                        if black then
                                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                                if closestDistance ~= -1 and closestDistance <= 3 then
                                                    local closestPed = GetPlayerPed(closestPlayer)
                                                    if not IsPedSittingInAnyVehicle(closestPed) then
                                                        SwLife.InternalToServer('::{razzway.xyz}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                                    else
                                                        ESX.ShowNotification('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles')
                                                    end
                                                else
                                                    ESX.ShowNotification('~r~Erreur\n~s~Aucune personne à proximité.')
                                                end
                                        else
                                            ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                        end
                                end
                            end)
                            RageUI.ButtonWithStyle("Jeter", nil, {}, true, function(h,a,s)
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                    if black then
                                        if not IsPedSittingInAnyVehicle(PlayerPed) then
                                            SwLife.InternalToServer('::{razzway.xyz}::esx:dropInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                        else
                                            ESX.ShowNotification('Vous pouvez pas jeter', 'de l\'argent')
                                        end
                                    else
                                        ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                    end
                                end
                            end)
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'portefeuille_blackmoney'), true, true, true, function()
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'dirtycash' then
                            RageUI.Separator("Source inconnue :~c~ "..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."$"), nil, {}, true, function(h,a,s)
                            end)
                            RageUI.ButtonWithStyle("Donner", nil, {}, true, function(h,a,s)
                                if a then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    if closestPlayer ~= -1 and closestDistance <= 3 then
                                        playerMarker(closestPlayer)
                                    end
                                end
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                    if black then
                                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                        if closestDistance ~= -1 and closestDistance <= 3 then
                                            local closestPed = GetPlayerPed(closestPlayer)
            
                                            if not IsPedSittingInAnyVehicle(closestPed) then
                                                SwLife.InternalToServer('::{razzway.xyz}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                            else
                                                ESX.ShowNotification('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles')
                                            end
                                        else
                                            ESX.ShowNotification('~r~Erreur\n~s~Aucune personne à proximité.')
                                        end
                                    else
                                        ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                    end
                                end
                            end)
                            RageUI.ButtonWithStyle("Jeter", nil, {}, true, function(h,a,s)
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                    if black then
                                        if not IsPedSittingInAnyVehicle(PlayerPed) then
                                            SwLife.InternalToServer('::{razzway.xyz}::esx:dropInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                        else
                                            ESX.ShowNotification('~r~Erreur\n~s~nVous ne pouvez pas jeter de l\'argent dans un véhicule')
                                        end
                                    else
                                        ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                    end
                                end
                            end)
                        end
                    end
                end)
				Wait(0)
			end
		end)
	end

end

Keys.Register('F5','F5', 'Menu Personnel ', function()
    refresh()
    OpenRzInteract()
end)

function refresh()
    SwLife.newThread(function()
        ESX.PlayerData = ESX.GetPlayerData() ------ ca sert a rien de le laisser dans ton button il tourner en boucle et surtout te faire monter en ms
    end)
end

function RefreshBilling()
    ESX.TriggerServerCallback('Razzway#1337:GetBills', function(bills)
        PersonalMenu.billing = bills
    end)
end

function doorAction(door)
    if not IsPedInAnyVehicle(PlayerPedId(),false) then return end
    local veh = GetVehiclePedIsIn(PlayerPedId(),false)
    if door == -1 then
        if doorActionIndex == 1 then
            for i = 0, 7 do
                SetVehicleDoorOpen(veh,i,false,false)
            end
        else
            for i = 0, 7 do
                SetVehicleDoorShut(veh,i,false)
            end
        end
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
        return
    end
    if doorActionIndex == 1 then
        SetVehicleDoorOpen(veh,door,false,false)
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
    else
        SetVehicleDoorShut(veh,door,false)
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
    end
end

function vehicleIsDamaged()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
    return GetVehicleEngineHealth(vehicle) < 1000
end

function isAllowedToManageVehicle()
    if IsPedInAnyVehicle(PlayerPedId(),false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            return true
        end
        return false
    end
    return false
end

function CheckQuantity(number)
    number = tonumber(number)
  
    if type(number) == 'number' then
      number = ESX.Math.Round(number)
  
      if number > 0 then
        return true, number
      end
    end
  
    return false, number
end

RegisterNetEvent('rRazzway:CloseMenu')
AddEventHandler('rRazzway:CloseMenu', function()
	RageUI.Visible(RMenu:Get('personalmenu', 'main'), false)
end)

function playerMarker(player)
    local ped = GetPlayerPed(player)
    local pos = GetEntityCoords(ped)
    DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end

RegisterNetEvent('G39klmyzgdzud:(1441-lmp)')
AddEventHandler('G39klmyzgdzud:(1441-lmp)', function(value, quantity)
	local weaponHash = GetHashKey(value)

	if HasPedGotWeapon(plyPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
		AddAmmoToPed(plyPed, value, quantity)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx_addonaccount:setMoney')
AddEventHandler('::{razzway.xyz}::esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	end
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		societymoney2 = ESX.Math.GroupDigits(money)
    end
end)

RegisterNetEvent('::{razzway.xyz}::esx:setJob')
AddEventHandler('::{razzway.xyz}::esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('::{razzway.xyz}::esx:setJob2')
AddEventHandler('::{razzway.xyz}::esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
	RefreshMoney2()
end)


function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('pSociety::getSocietyMoney', function(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('pSociety::getSocietyMoney', function(money)
			societymoney2 = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job2.name)
	end
end