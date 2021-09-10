

--CREATION OF MENU
local main = ContextUI:CreateMenu(1, "Menu Rapide")
local main_car = ContextUI:CreateMenu(2, "Menu Rapide")
local main_props = ContextUI:CreateMenu(3, "Menu Rapide")

--PLAYERS SUB MENU
local gestion_car = ContextUI:CreateSubMenu(main_car)
local vetements = ContextUI:CreateSubMenu(main)
local accessoires = ContextUI:CreateSubMenu(main)
--ADMIN SUB MENU
local admin = ContextUI:CreateSubMenu(main)
local admin_car = ContextUI:CreateSubMenu(main_car)
local admin_props = ContextUI:CreateSubMenu(main_props)
local report_menu = ContextUI:CreateSubMenu(main)
local info_veh = ContextUI:CreateSubMenu(admin_car)

local settings = {
    car = {
        capot = false,
        coffre = false,
        portedroite = false,
        protegauche = false,
        portedroite2 = false,
        protegauche2 = false,
    },
    sitting = false,
}

local SEAT_MODEL = {
	[-99500382] = true,
	[-71417349] = true,
	[1805980844] = true,
}

local ReportList = {
	{ name = "Comportement HRP" },
	{ name = "Troll" },
	{ name = "Insulte hors-rp" },
	{ name = "Meta gaming" },
	{ name = "Action sexuel non consentie" },
	{ name = "Autre" },
}

local Table_info = nil

RegisterNetEvent("Razzway:RecoisLaTableFDP")
AddEventHandler("Razzway:RecoisLaTableFDP", function(Oof)
    Table_info = Oof
end)

function Razzway.Helper:OnGetInfoPlayers(ID)
    TriggerServerEvent("Razzway:GetInformationPlayers", ID)

    while not Table_info do
        Citizen.Wait(0)
    end

    return Table_info
end

ContextUI:IsVisible(main, function(Entity)    
    if Entity.ServerID ~= GetPlayerServerId(PlayerId()) then
        if Table_info == nil then
            Razzway.Helper:OnGetInfoPlayers(Entity.ServerID)
        end
    
        ContextUI:Button("- Donner de l'argent", function(onSelected)
            if onSelected then
                local amount_givexd = KeyboardInput('Razzway_BOX_BAN_RAISON', "Combien ?", '', 50)
                if (tonumber(amount_givexd) ~= nil) and (tonumber(amount_givexd) >= 1) then
                    TriggerServerEvent('::{razzway.xyz}::esx:giveInventoryItem', Entity.ServerID, 'item_account', "cash", tonumber(amount_givexd))
                    TriggerServerEvent('::{razzway.xyz}::esx:sendlog', 'MONEY', tonumber(amount_givexd), "cash", Entity.ServerID)
                end
            end
        end)
    
        ContextUI:Button("- Donner de l'argent sale", function(onSelected)
            if onSelected then
                local amount_givexd = KeyboardInput('Razzway_BOX_BAN_RAISON', "Combien ?", '', 50)
                if (tonumber(amount_givexd) ~= nil) and (tonumber(amount_givexd) >= 1) then
                    TriggerServerEvent('::{razzway.xyz}::esx:giveInventoryItem', Entity.ServerID, 'item_account', "dirtycash", tonumber(amount_givexd))
                    TriggerServerEvent('::{razzway.xyz}::esx:sendlog', 'MONEY', tonumber(amount_givexd), "dirtycash", Entity.ServerID)
                end
            end
        end)
    
        ContextUI:Button("- Information du joueur", function(onSelected)
            if onSelected then
                ESX.ShowNotification("~r~~h~ID :~s~ \n" .. Table_info.source .. "\n~r~License :~s~ " .. Table_info.lisence)
            end
        end)
    
        ContextUI:Button("→ Signaler ce joueur", function(onSelected)
            if onSelected then
                report_menu.Title = "Assistance Rapide"
            end
        end, report_menu)

        if (ESX.GetPlayerData()['group'] ~= "user") and (Razzway.SelfPlayer.isStaffEnabled) then
            ContextUI:Button("→ Administration", function(onSelected)
                if (onSelected) then
                    admin.Title = "Administration"
                end
            end, admin)
        end    
    else
        ContextUI:Button("→ Vetements", function(onSelected)
            if onSelected then
                vetements.Title = "Vetements"
            end
        end, vetements)
        ContextUI:Button("→ Accessoires", function(onSelected)
            if onSelected then
                accessoires.Title = "Accessoires"
            end
        end, accessoires)
    end
end)

ContextUI:IsVisible(accessoires, function(Entity)
    ContextUI:Button("- Accessoire d\'Oreilles", function(onSelected)
        if onSelected then
            setAccessory("Ears")
        end
    end)
    ContextUI:Button("- Lunettes", function(onSelected)
        if onSelected then
            setAccessory("Glasses")
        end
    end)
    ContextUI:Button("- Chapeau/Casque", function(onSelected)
        if onSelected then
            setAccessory("Helmet")
        end
    end)
    ContextUI:Button("- Masque", function(onSelected)
        if onSelected then
            setAccessory("Mask")
        end
    end)
end)

ContextUI:IsVisible(vetements, function(Entity)
    ContextUI:Button("- Haut", function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "torso")
        end
    end)
    ContextUI:Button("- Bas", function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "pants")
        end
    end)
    ContextUI:Button("- Chaussures", function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "shoes")
        end
    end)
    ContextUI:Button("- Sac", function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "bag") 
        end
    end)
    ContextUI:Button("- Gilet par Balle", function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "bproof")
        end
    end)
end)

ContextUI:IsVisible(main_car, function(Entity)
    ContextUI:Button("- Fermer/Ouvrir le vehicule", function(onSelected)
        if (onSelected) then
            local simple_vehicle = GetVehicleIndexFromEntityIndex(Entity.ID)
            OpenCloseVehicle(simple_vehicle)
        end
    end)
    ContextUI:Button("→ Gestion Vehicule", function(onSelected)
        if (onSelected) then
            gestion_car.Title = "Gestion Vehicule"
        end
    end, gestion_car)
    if (ESX.GetPlayerData()['group'] ~= "user") and (Razzway.SelfPlayer.isStaffEnabled) then
        ContextUI:Button("→ Administration", function(onSelected)
            if (onSelected) then
                admin_car.Title = "Administration"
            end
        end, admin_car)
    end
end)

ContextUI:IsVisible(main_props, function(Entity)
    if not (settings.sitting) and (SEAT_MODEL[Entity.Model]) then
        ContextUI:Button("S'asseoir", function(onSelected)
            if (onSelected) then
                local position = GetEntityCoords(PlayerPedId())
                local coordsobj = GetEntityCoords(Entity.ID)
                local headingobj = GetEntityHeading(Entity.ID)
                if not HasEntityClearLosToEntity(PlayerPedId(), Entity.ID, 17) then
                    ESX.ShowAdvancedNotification(GetConvar("servername", "Magic Collective"), '~y~Clés', "Vous ne regardez l'objet.", 'CHAR_CALIFORNIA', 7)
					return
				end
                if (GetFollowPedCamViewMode() ~= 4) then
					SetFollowPedCamViewMode(4)
				end
				TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_BENCH", coordsobj.x, coordsobj.y, coordsobj.z + (position.z - coordsobj.z) / 2, headingobj + 180.0, 0, true, false)
				settings.sitting = true;
            end
        end)
    end

    if not (SEAT_MODEL[Entity.Model]) and not (Razzway.SelfPlayer.isStaffEnabled) then
        ContextUI:Button("Aucun interaction disponible", function(onSelected)
            if (onSelected) then
            end
        end)
    end

    if (ESX.GetPlayerData()['group'] ~= "user") and (Razzway.SelfPlayer.isStaffEnabled) then
        ContextUI:Button("→ Administration", function(onSelected)
            if (onSelected) then
                admin_props.Title = "Administration"
            end
        end, admin_props)
    end
end)

local AC_SEV = AC_SEV_PARAM
local freeze = false

ContextUI:IsVisible(admin, function(Entity)
    if (Razzway.SelfPlayer.isStaffEnabled) then
        ContextUI:Button("→ Menu des sanctions", function(onSelected)
            if onSelected then
                TriggerEvent("Razzway:OpenSanctionMenu", Entity.ServerID)
            end
        end)
        ContextUI:Button("→ Profile du joueur", function(onSelected)
            if onSelected then
                TriggerEvent("Razzway:OpenProfilePlayers", Entity.ServerID)
            end
        end)

        ContextUI:Button("- Mettre en prison", function(onSelected)
            if onSelected then
                local temps = KeyboardInput('Razzway_BOX_BAN_RAISON', "Temps en seconde", '', 50)
                local raison = KeyboardInput('Razzway_BOX_BAN_RAISON', "Raison du JAIL", '', 50)
                if tonumber(temps) and raison and tonumber(temps) > 0 and raison ~= nil and raison ~= "" and raison ~= " " then
                    -- AC_P("SUCESS")
                    TriggerServerEvent("Razzway:Jail", Entity.ServerID, tonumber(temps), raison)
                end
            end
        end)
        if (ESX.GetPlayerData()['group'] ~= "user") then
            ContextUI:Button("- Bannir", function(onSelected)
                if onSelected then
                    local temps = KeyboardInput('Razzway_BOX_BAN_RAISON', "Temps en heure", '', 50)
                    local raison = KeyboardInput('Razzway_BOX_BAN_RAISON', "Raison du BAN", '', 50)
                    if tonumber(temps) and raison and tonumber(temps) > 0 and raison ~= nil and raison ~= "" and raison ~= " " then
                        -- AC_P("SUCESS")
                        TriggerServerEvent("Razzway:Ban", Entity.ServerID, tonumber(temps), raison)
                    end
                end
            end)

            ContextUI:Button("- Expulser", function(onSelected)
                if onSelected then
                    local raison = KeyboardInput('Razzway_BOX_BAN_RAISON', "Raison du KICK", '', 50)
                    if raison and raison ~= nil and raison ~= "" and raison ~= " " then
                        TriggerServerEvent("Razzway:kick", Entity.ServerID, raison)
                    end
                end
            end)
        end

        ContextUI:Button("- Réanimer", function(onSelected)
            if onSelected then
                TriggerServerEvent("Razzway:Revive", Entity.ServerID)
            end
        end)

        ContextUI:Button("- Freeze", function(onSelected)
            if onSelected then
                TriggerServerEvent("Razzway:FreezePlayers", Entity.ServerID, true)
            end
        end)

        ContextUI:Button("- UnFreeze", function(onSelected)
            if onSelected then
                TriggerServerEvent("Razzway:FreezePlayers", Entity.ServerID, false)
            end
        end)

        ContextUI:Button("- Teleport", function(onSelected)
            if onSelected then
                TriggerServerEvent("Razzway:teleport", Entity.ServerID)
            end
        end)

        ContextUI:Button("- Vehicule", function(onSelected)
            if onSelected then
                local vehicule_name = KeyboardInput('Razzway_BOX_BAN_RAISON', "Nom du vehicule", '', 50)
                if vehicule_name and vehicule_name ~= nil and vehicule_name ~= "" and vehicule_name ~= " " then
                    TriggerServerEvent("Razzway:SpawnVehicleOnPlayers", Entity.ServerID, vehicule_name)
                end
            end
        end)
    end
end)

ContextUI:IsVisible(info_veh, function(Entity)
    ContextUI:Button("- Plaque du vehicule : ", function(onSelected)
        if onSelected then
            
        end
    end)
    ContextUI:Button("& " .. GetVehicleNumberPlateText(Entity.ID), function(onSelected)
        if onSelected then
            
        end
    end)
    ContextUI:Button("- Spawn Par : ", function(onSelected)
        if onSelected then
            
        end
    end)
    if Razzway.Players[GetPlayerServerId(NetworkGetEntityOwner(Entity.ID))].name then
        ContextUI:Button("& " .. Razzway.Players[GetPlayerServerId(NetworkGetEntityOwner(Entity.ID))].name, function(onSelected)
            if onSelected then

            end
        end)
    end        
end)

ContextUI:IsVisible(admin_car, function(Entity)
    if (Razzway.SelfPlayer.isStaffEnabled) then
        ContextUI:Button("→ Information", function(onSelected)
            if onSelected then
                info_veh.Title = "Information"
            end
        end, info_veh)

        ContextUI:Button("- Supprimer le vehicule", function(onSelected)
            if onSelected then
                ForceDeleteEntity(Entity.ID)
            end
        end)
        ContextUI:Button("- Reparer le vehicule", function(onSelected)
            if onSelected then
                local simple_vehicle = GetVehicleIndexFromEntityIndex(Entity.ID)
                SetVehicleFixed(simple_vehicle)
                SetVehicleDeformationFixed(simple_vehicle)
                SetVehicleUndriveable(simple_vehicle, false)
                SetVehicleEngineOn(simple_vehicle,  true,  true)
            end
        end)
        if (ESX.GetPlayerData()['group'] == "gs" and ESX.GetPlayerData()['group'] == "_dev") then
            ContextUI:Button("- Custom MAX le vehicule", function(onSelected)
                if onSelected then
                    local simple_vehicle = GetVehicleIndexFromEntityIndex(Entity.ID)
                    fullupgrade(simple_vehicle)
                end
            end)
        end
        ContextUI:Button("- Freeze le vehicule", function(onSelected)
            if onSelected then
                FreezeEntityPosition(Entity.ID, true)
            end
        end)
        ContextUI:Button("- UnFreeze le vehicule", function(onSelected)
            if onSelected then
                FreezeEntityPosition(Entity.ID, false)
            end
        end)
        ContextUI:Button("- Expulser le conducteur", function(onSelected)
            if onSelected then
                local simple_vehicle = GetVehicleIndexFromEntityIndex(Entity.ID)
                local ped = GetPedInVehicleSeat(simple_vehicle, -1)
                TaskLeaveVehicle(ped, simple_vehicle)
            end
        end)
        ContextUI:Button("- Ramener le vehicule", function(onSelected)
            if onSelected then
                local simple_vehicle = GetVehicleIndexFromEntityIndex(Entity.ID)
                local coords = GetEntityCoords(PlayerPedId())
                local PVAutoDriving = true

                Citizen.CreateThread(function()
                    if DoesEntityExist(Driver) then
                        DeleteEntity(Driver)
                    end
                    Driver = AC_CP(5, GetEntityModel(PlayerPedId()), spawnCoords, spawnHeading, true)
                    TaskWarpPedIntoVehicle(Driver, simple_vehicle, -1)
                    AC_SEV(Driver, false)
                    while not killmenu and PVAutoDriving do
                        SetPedMaxHealth(Driver, 10000)
                        AC_SEH(Driver, 10000)
                        AC_SEI(Driver, false)
                        SetPedCanRagdoll(Driver, true)
                        ClearPedLastWeaponDamage(Driver)
                        SetEntityProofs(Driver, false, false, false, false, false, false, false, false)
                        SetEntityOnlyDamagedByPlayer(Driver, true)
                        SetEntityCanBeDamaged(Driver, true)

                        if not DoesEntityExist(simple_vehicle) or not DoesEntityExist(Driver) then
                            break
                        end
                        Wait(100)
                        coords = GetEntityCoords(simple_vehicle)
                        plycoords = GetEntityCoords(PlayerPedId())
                        TaskVehicleDriveToCoordLongrange(Driver, simple_vehicle, plycoords.x, plycoords.y, plycoords.z, 25.0, 1074528293, 1.0)
                        SetVehicleLightsMode(simple_vehicle, 2)
                        distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, plycoords.x, plycoords.y, coords.z, true)
                        if IsVehicleStuckOnRoof(simple_vehicle) then
                            SetVehicleCoords(simple_vehicle, GetEntityCoords(simple_vehicle))
                        end
                        if distance < 5.0 then
                            SetVehicleForwardSpeed(simple_vehicle, 1.0)
                            DeleteEntity(Driver)
                            PVAutoDriving = false
                            return
                        end
                    end
                end)
            end
        end)
    end
end)

ContextUI:IsVisible(gestion_car, function(Entity)
    ContextUI:Button("- Capot", function(onSelected)
        if onSelected then
            local car_from_entity = GetVehicleIndexFromEntityIndex(Entity.ID)
            if settings.car.capot == true then
                SetVehicleDoorShut(car_from_entity, 4, false, false)
                settings.car.capot = false
            else
                SetVehicleDoorOpen(car_from_entity, 4, false, false)
                settings.car.capot = true
            end
        end
    end)
    ContextUI:Button("- Coffre", function(onSelected)
        if onSelected then
            local car_from_entity = GetVehicleIndexFromEntityIndex(Entity.ID)
            if settings.car.coffre == true then
                SetVehicleDoorShut(car_from_entity, 5, false, false)
                settings.car.coffre = false
            else
                SetVehicleDoorOpen(car_from_entity, 5, false, false)
                settings.car.coffre = true
            end
        end
    end)
end)

ContextUI:IsVisible(admin_props, function(Entity)    
    ContextUI:Button("- Supprimer le props", function(onSelected)
        if onSelected then
            ForceDeleteEntity(Entity.ID)
        end
    end)
end)

ContextUI:IsVisible(report_menu, function(Entity)
    for k,v in pairs(ReportList) do
        ContextUI:Button("- " .. v.name, function(onSelected)
            if onSelected then
                TriggerServerEvent("Razzway:FastReport", v.name, Entity.ServerID)
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 19) then
            ContextUI.Focus = true
        end

        if IsDisabledControlJustReleased(0, 19) then
            Table_info = nil
            ContextUI.Focus = false
        end
    end
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AC_ATE(entryTitle, textEntry)
	AC_DOK(1, entryTitle, '', inputText, '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		return result
	else
		Citizen.Wait(500)
		return nil
	end
end

function ForceDeleteEntity(entity)
	if DoesEntityExist(entity) then
		NetworkRequestControlOfEntity(entity)
		local gameTime = GetGameTimer()

		while DoesEntityExist(entity) and (not NetworkHasControlOfEntity(entity) or ((GetGameTimer() - gameTime) < 1000)) do
			Citizen.Wait(10)
		end

		if DoesEntityExist(entity) then
			DetachEntity(entity, false, false)
			SetEntityAsMissionEntity(entity, false, false)
			SetEntityCollision(entity, false, false)
			SetEntityAlpha(entity, 0, true)
			SetEntityAsNoLongerNeeded(entity)

			if IsAnEntity(entity) then
				DeleteEntity(entity)
			elseif IsEntityAPed(entity) then
				DeletePed(entity)
			elseif IsEntityAVehicle(entity) then
				DeleteVehicle(entity)
			elseif IsEntityAnObject(entity) then
				DeleteObject(entity)
			end

			gameTime = GetGameTimer()

			while DoesEntityExist(entity) and ((GetGameTimer() - gameTime) < 2000) do
				Citizen.Wait(10)
			end

			if DoesEntityExist(entity) then
				AC_SEC(entity, vector3(10000.0, -1000.0, 10000.0), vector3(0.0, 0.0, 0.0), false)
			end
		end
	end
end

function fullupgrade(veh)
	SetVehicleModKit(veh, 0)
	SetVehicleColours(veh, 12, 12)
	SetVehicleModColor_1(veh, 3, false)
	SetVehicleExtraColours(veh, 3, false)
	ToggleVehicleMod(veh, 18, true)
	ToggleVehicleMod(veh, 22, true)
	SetVehicleMod(veh, 16, 5, false)
	SetVehicleMod(veh, 12, 2, false)
	SetVehicleMod(veh, 11, 3, false)
	SetVehicleMod(veh, 14, 14, false)
	SetVehicleMod(veh, 15, 3, false)
	SetVehicleMod(veh, 13, 2, false)
	SetVehicleWindowTint(veh, 5)
	SetVehicleWheelType(veh, false)
	SetVehicleMod(veh, 23, 21, true)
	SetVehicleMod(veh, 0, 1, false)
	SetVehicleMod(veh, 1, 1, false)
	SetVehicleMod(veh, 2, 1, false)
	SetVehicleMod(veh, 3, 1, false)
	SetVehicleMod(veh, 4, 1, false)
	SetVehicleMod(veh, 5, 1, false)
	SetVehicleMod(veh, 6, 1, false)
	SetVehicleMod(veh, 7, 1, false)
	SetVehicleMod(veh, 8, 1, false)
	SetVehicleMod(veh, 9, 1, false)
	SetVehicleMod(veh, 10, 1, false)
	IsVehicleNeonLightEnabled(veh, true)
	SetVehicleNeonLightEnabled(veh, 0, true)
	SetVehicleNeonLightEnabled(veh, 1, true)
	SetVehicleNeonLightEnabled(veh, 2, true)
	SetVehicleNeonLightEnabled(veh, 3, true)
	SetVehicleNeonLightEnabled(veh, 4, true)
	SetVehicleNeonLightEnabled(veh, 5, true)
	SetVehicleNeonLightEnabled(veh, 6, true)
	SetVehicleNeonLightEnabled(veh, 7, true)
	SetVehicleModKit(veh, 0)
	ToggleVehicleMod(veh, 20, true)
	SetVehicleModKit(veh, 0)
	SetVehicleNumberPlateTextIndex(veh, true)
end

function setUniform(plyPed, value)
	ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skina)
			if value == 'torso' then
				ClearPedTasks(plyPed)

				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
			elseif value == 'pants' then
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
					else
						TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == 'shoes' then
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
					else
						TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == 'bag' then
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)

				if skin.bproof_1 ~= skina.bproof_1 then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
			end
		end)
	end)
end

function setAccessory(accessory)
	ESX.TriggerServerCallback('::{razzway.xyz}::esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = (accessory):lower()

		if hasAccessory then
			TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == 'ears' then
					-- startAnimAction('mini@ears_defenders', 'takeoff_earsdefenders_idle')
					-- Citizen.Wait(250)
					-- Player.handsup, Player.pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'glasses' then
					mAccessory = 0
					-- startAnimAction('clothingspecs', 'try_glasses_positive_a')
					-- Citizen.Wait(1000)
					-- Player.handsup, Player.pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'helmet' then
					-- startAnimAction('missfbi4', 'takeoff_mask')
					-- Citizen.Wait(1000)
					-- Player.handsup, Player.pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'mask' then
					mAccessory = 0
					-- startAnimAction('missfbi4', 'takeoff_mask')
					-- Citizen.Wait(850)
					-- Player.handsup, Player.pointing = false, false
					ClearPedTasks(plyPed)
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			-- if _accessory == 'ears' then
			-- 	ESX.ShowNotification(_U('no_ears'))
			-- elseif _accessory == 'glasses' then
			-- 	ESX.ShowNotification(_U('no_glasses'))
			-- elseif _accessory == 'helmet' then
			-- 	ESX.ShowNotification(_U('no_helmet'))
			-- elseif _accessory == 'mask' then
			-- 	ESX.ShowNotification(_U('no_mask'))
			-- end
		end
	end, accessory)
end


function OpenCloseVehicle(vehicle)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)
	local inveh = false
    local KeyFobHash = `p_car_keys_01`

	ESX.TriggerServerCallback('::{razzway.xyz}::esx_vehiclelock:mykey', function(gotkey)
		if gotkey then
			local locked = GetVehicleDoorLockStatus(vehicle)

			if not inveh then
				local plyPed = PlayerPedId()

				ESX.Streaming.RequestAnimDict("anim@mp_player_intmenu@key_fob@")

				ESX.Game.SpawnObject(KeyFobHash, vector3(0.0, 0.0, 0.0), function(object)
					SetEntityCollision(object, false, false)
					AttachEntityToEntity(object, plyPed, GetPedBoneIndex(plyPed, 57005), 0.09, 0.03, -0.02, -76.0, 13.0, 28.0, false, true, true, true, 0, true)

					SetCurrentPedWeapon(plyPed, `WEAPON_UNARMED`, true)
					ClearPedTasks(plyPed)
					TaskTurnPedToFaceEntity(plyPed, vehicle, 500)

					TaskPlayAnim(plyPed, "anim@mp_player_intmenu@key_fob@", "fob_click", 3.0, 3.0, 1000, 16)
					RemoveAnimDict("anim@mp_player_intmenu@key_fob@")
					PlaySoundFromEntity(-1, "Remote_Control_Fob", vehicle, "PI_Menu_Sounds", true, 0)
					Citizen.Wait(1250)

					DetachEntity(object, false, false)
					DeleteObject(object)
				end)
			end

			if locked == 1 or locked == 0 then
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowAdvancedNotification(GetConvar("servername", "Magic Collective"), '~y~Clés', "Vous avez ~r~fermé~s~ le véhicule.", 'CHAR_CALIFORNIA', 7)
			elseif locked == 2 then
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowAdvancedNotification(GetConvar("servername", "Magic Collective"), '~y~Clés', "Vous avez ~g~ouvert~s~ le véhicule.", 'CHAR_CALIFORNIA', 7)
			end
		else
			ESX.ShowAdvancedNotification(GetConvar("servername", "Magic Collective"), '~y~Clés', "~r~Vous n'avez pas les clés de ce véhicule.", 'CHAR_CALIFORNIA', 7)
		end
	end, GetVehicleNumberPlateText(vehicle))
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (settings.sitting) then
            Visual.FloatingHelpText("Appuyez sur ~INPUT_CONTEXT~ pour vous relevez.", true)
            if (IsControlJustPressed(1, 51)) then
                if (GetFollowPedCamViewMode() == 4) then
                    SetFollowPedCamViewMode(2)
                end    
                TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_BENCH", 0.0, 0.0, 0.0, 180.0, 2, true, false)
                while IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_SEAT_BENCH") do
                    Citizen.Wait(100)
                end
                ClearPedTasks(PlayerPedId())
                settings.sitting = false;
            end
        end
    end
end)