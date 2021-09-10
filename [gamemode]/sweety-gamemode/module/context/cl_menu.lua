local settings = {
    car = {
        capot = false,
        coffre = false,
        portedroite = false,
        protegauche = false,
        portedroite2 = false,
        protegauche2 = false,
    },
}
sitting = false

local main = ContextUI:CreateMenu(1, "Menu Contextuel")
local main_car = ContextUI:CreateMenu(2, "Menu Contextuel")
local main_props = ContextUI:CreateMenu(3, "Menu Contextuel")

local gestion_car = ContextUI:CreateSubMenu(main_car)
local police_car = ContextUI:CreateSubMenu(main_car)
local vetements = ContextUI:CreateSubMenu(main)
local actionsjoueurs = ContextUI:CreateSubMenu(main)
local actionsjob = ContextUI:CreateSubMenu(main)
local actionsgang = ContextUI:CreateSubMenu(main)

local police = ContextUI:CreateSubMenu(main)
local subsanctions = ContextUI:CreateSubMenu(main)
local admin = ContextUI:CreateSubMenu(main)
local admin_car = ContextUI:CreateSubMenu(main_car)
local admin_props = ContextUI:CreateSubMenu(main_props)
local report_menu = ContextUI:CreateSubMenu(main)
local info_veh = ContextUI:CreateSubMenu(admin_car)

ContextUI:IsVisible(main, function(Entity)
    if Entity.ServerID == GetPlayerServerId(PlayerId()) then
        ContextUI:Button("→ Gestion des Vetements", nil, function(onSelected)
            if (onSelected) then 
                vetements.Title = 'Gestion des Vetements'
            end
        end, vetements)
    end
    ContextUI:Button("→ Actions Joueurs", nil, function(onSelected)
        if (onSelected) then 
            actionsjoueurs.Title = 'Actions Joueurs'
        end
    end, actionsjoueurs)
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and Entity.ServerID ~= GetPlayerServerId(PlayerId()) then
        ContextUI:Button("→ Police", nil, function(onSelected)
            if (onSelected) then
                police.Title = 'Police'
            end
        end, police)
    end
    if ESX.PlayerData.group ~= 'user' then
        ContextUI:Button("→ Récupérer l'id du joueur", nil, function(onSelected)
            if (onSelected) then
                admin.Title = 'Récupérer l\'id du joueur'
            end
        end, admin)
    end
end)

ContextUI:IsVisible(admin, function(Entity)
    ContextUI:Button("ID du joueur : ".. Entity.ServerID, nil, function(onSelected)
        if (onSelected) then
        end
    end)
end)

ContextUI:IsVisible(actionsjoueurs, function(Entity)
    if ESX.PlayerData.job.grade_name == 'boss' then 
        if Entity.ServerID ~= GetPlayerServerId(PlayerId()) then
            ContextUI:Button("- Actions ~y~".. ESX.PlayerData.job.label .. " ~w~", nil,function(onSelected)
                if onSelected then
                    actionsjob.Title = 'Intéraction ~r~'.. ESX.PlayerData.job.label 
                end
            end, actionsjob)
        end
    end
    if ESX.PlayerData.job2 ~= 'unemployed' then 
        if Entity.ServerID ~= GetPlayerServerId(PlayerId()) then
            ContextUI:Button("- Actions ~y~".. ESX.PlayerData.job2.label .. " ~w~", nil,function(onSelected)
                if onSelected then
                    actionsgang.Title = 'Intéraction ~r~'.. ESX.PlayerData.job2.label 
                end
            end, actionsgang)
        end
    end
end)

ContextUI:IsVisible(actionsjob, function(Entity)
    if ESX.PlayerData.job.grade_name == 'boss' then
        ContextUI:Button("- Recruter", nil,function(onSelected)
            if onSelected then
                if ESX.PlayerData.job.grade_name == 'boss' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
                    else
                        SwLife.InternalToServer('ewen:recrutementjob', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
                    end
                end
            end
        end)
        ContextUI:Button("- Recruter", nil,function(onSelected)
            if onSelected then
                if ESX.PlayerData.job.grade_name == 'boss' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
                    else
                        SwLife.InternalToServer('rRazzway:recrutejoueur', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
                    end
                end
            end
        end)
        ContextUI:Button("- Virer", nil,function(onSelected)
            if onSelected then
                if ESX.PlayerData.job.grade_name == 'boss' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
                    else
                        SwLife.InternalToServer('rRazzway:virerjoueur', GetPlayerServerId(closestPlayer))
                    end
                end
            end
        end)
        ContextUI:Button("- Promouvoir", nil,function(onSelected)
            if onSelected then
                if ESX.PlayerData.job.grade_name == 'boss' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
                    else
                        SwLife.InternalToServer('c26bgdtoklmtbr:{-pp}', GetPlayerServerId(closestPlayer))
                    end
                end
            end
        end)
        ContextUI:Button("- Rétrograder", nil,function(onSelected)
            if onSelected then
                if ESX.PlayerData.job.grade_name == 'boss' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
                    else
                        SwLife.InternalToServer('f45bgdtj78ql:[tl-yu]', GetPlayerServerId(closestPlayer))
                    end
                end
            end
        end)
    end
end)

ContextUI:IsVisible(actionsgang, function(Entity)
    if ESX.PlayerData.job2.grade_name == 'boss' then
        ContextUI:Button("- Recruter", nil,function(onSelected)
            if onSelected then
                if ESX.PlayerData.job2.grade_name == 'boss' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
                    else
                        SwLife.InternalToServer('ewen:recrutementgang', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0)
                    end
                end
            end
        end)
        ContextUI:Button("- Virer", nil,function(onSelected)
            if onSelected then
                if ESX.PlayerData.job2.grade_name == 'boss' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
                    else
                        SwLife.InternalToServer('ewen:virergang', GetPlayerServerId(closestPlayer))
                    end
                end
            end
        end)
        ContextUI:Button("- Promouvoir", nil,function(onSelected)
            if onSelected then
                if ESX.PlayerData.job2.grade_name == 'boss' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
                    else
                        SwLife.InternalToServer('ewen:promouvoirplayergang', GetPlayerServerId(closestPlayer))
                    end
                end
            end
        end)
        ContextUI:Button("- Rétrograder", nil,function(onSelected)
            if onSelected then
                if ESX.PlayerData.job2.grade_name == 'boss' then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
                    else
                        SwLife.InternalToServer('ewen:retrogradationgang', GetPlayerServerId(closestPlayer))
                    end
                end
            end
        end)
    end
end)

ContextUI:IsVisible(vetements, function(Entity)
    ContextUI:Button("- Haut", nil,function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "torso")
        end
    end)
    ContextUI:Button("- Bas", nil,function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "pants")
        end
    end)
    ContextUI:Button("- Chaussures", nil,function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "shoes")
        end
    end)
    ContextUI:Button("- Sac", nil,function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "bag") 
        end
    end)
    ContextUI:Button("- Gilet par Balle", nil,function(onSelected)
        if onSelected then
            setUniform(PlayerPedId(), "bproof")
        end
    end)
end)

ContextUI:IsVisible(police, function(Entity)
    ContextUI:Button("- Trainer", nil,function(onSelected)
        if onSelected then
            local player, distance = ESX.Game.GetClosestPlayer()
            if distance ~= -1 and distance <= 3.0 then
                SwLife.InternalToServer('::{razzway.xyz}::esx_policejob:drag', Entity.ServerID)
            else
                ESX.ShowNotification('~r~Aucun joueur~s~ à proximité')
            end
        end
    end)
    ContextUI:Button("- Mettre dans Véhicule", nil,function(onSelected)
        if onSelected then
            local player, distance = ESX.Game.GetClosestPlayer()
            if distance ~= -1 and distance <= 3.0 then
                SwLife.InternalToServer('::{razzway.xyz}::esx_policejob:putInVehicle', Entity.ServerID)
            else
                ESX.ShowNotification('~r~Aucun joueur~s~ à proximité')
            end
        end
    end)
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

ContextUI:IsVisible(main_car, function(Entity)
    ContextUI:Button("→ Gestion Vehicule", nil, function(onSelected)
        if (onSelected) then
            gestion_car.Title = "Gestion Vehicule"
        end
    end, gestion_car)
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
        ContextUI:Button("→ Police", nil, function(onSelected)
            if (onSelected) then
                police_car.Title = "Police"
            end
        end, police_car)
    end
    if ESX.PlayerData.group ~= "user" then
        ContextUI:Button("→ Administration", nil, function(onSelected)
            if (onSelected) then
                admin_car.Title = "Administration"
            end
        end, admin_car)
    end
end)

--LMENU => LEFT ALT
Keys.Register("LMENU", "LMENU", "Menu Contextuel", function()
    ContextUI.Focus = not ContextUI.Focus;
end)

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
				--startAnimAction('clothingtie', 'try_tie_neutral_a')
				--Citizen.Wait(1000)
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

ContextUI:IsVisible(gestion_car, function(Entity)
    ContextUI:Button("- Ouvrir / Fermer le véhicule", nil, function(onSelected)
        if (onSelected) then
            ExecuteCommand('opencloseVehicle')
        end
    end)
    ContextUI:Button("- Ouvrir le Capot", nil, function(onSelected)
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
end)

ContextUI:IsVisible(admin_car, function(Entity)
    ContextUI:Button("ID du véhicule : ".. Entity.ID, nil, function(onSelected)
        if (onSelected) then
        end
    end)
    ContextUI:Button("- Clear Zone ( Véhicule )", nil, function(onSelected)
        if (onSelected) then
            local playerPed = PlayerPedId()
            local radius = 10
            if radius and tonumber(radius) then
                radius = tonumber(radius) + 0.01
                local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed, false), radius)

                for i = 1, #vehicles, 1 do
                    local attempt = 0

                    while not NetworkHasControlOfEntity(vehicles[i]) and attempt < 100 and DoesEntityExist(vehicles[i]) do
                        Citizen.Wait(100)
                        NetworkRequestControlOfEntity(vehicles[i])
                        attempt = attempt + 1
                    end

                    if DoesEntityExist(vehicles[i]) and NetworkHasControlOfEntity(vehicles[i]) then
                        ESX.Game.DeleteVehicle(vehicles[i])
                        DeleteEntity(vehicles[i])
                    end
                end
            else
                local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

                if IsPedInAnyVehicle(playerPed, true) then
                    vehicle = GetVehiclePedIsIn(playerPed, false)
                end

                while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
                    Citizen.Wait(100)
                    NetworkRequestControlOfEntity(vehicle)
                    attempt = attempt + 1
                end

                if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
                    ESX.Game.DeleteVehicle(vehicle)
                    DeleteEntity(vehicle)
                end
            end
            ContextUI.Focus = false
        end
    end)
    ContextUI:Button("- Supprimer le véhicule", nil, function(onSelected)
        if onSelected then
            ForceDeleteEntity(Entity.ID)
            ContextUI.Focus = false
        end
    end)
    ContextUI:Button("- Reparer le vehicule", nil, function(onSelected)
        if onSelected then
            local simple_vehicle = GetVehicleIndexFromEntityIndex(Entity.ID)
            SetVehicleFixed(simple_vehicle)
            SetVehicleDeformationFixed(simple_vehicle)
            SetVehicleUndriveable(simple_vehicle, false)
            SetVehicleEngineOn(simple_vehicle,  true,  true)
        end
    end)
    if ESX.PlayerData.group == "_dev" then
        ContextUI:Button("- Custom MAX le vehicule", nil, function(onSelected)
            if onSelected then
                local simple_vehicle = GetVehicleIndexFromEntityIndex(Entity.ID)
                fullupgrade(simple_vehicle)
            end
        end)
    end
    ContextUI:Button("- Freeze le vehicule", nil, function(onSelected)
        if onSelected then
            FreezeEntityPosition(Entity.ID, true)
        end
    end)
    ContextUI:Button("- UnFreeze le vehicule", nil, function(onSelected)
        if onSelected then
            FreezeEntityPosition(Entity.ID, false)
        end
    end)
    ContextUI:Button("- Expulser le conducteur", nil, function(onSelected)
        if onSelected then
            local simple_vehicle = GetVehicleIndexFromEntityIndex(Entity.ID)
            local ped = GetPedInVehicleSeat(simple_vehicle, -1)
            TaskLeaveVehicle(ped, simple_vehicle)
             end
        end)
end)

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

ContextUI:IsVisible(police_car, function(Entity)
    ContextUI:Button("Crocheter le véhicule", nil, function(onSelected)
        if (onSelected) then
            local vehicle = ESX.Game.GetVehicleInDirection()
            if DoesEntityExist(vehicle) then
                local plyPed = PlayerPedId()
    
                TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_WELDING', 0, true)
                Citizen.Wait(20000)
                ClearPedTasksImmediately(plyPed)
    
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                ESX.ShowNotification("~g~Le véhicule a été dévérouillé.")
            else
                ESX.ShowNotification("~r~Aucun véhicule~s~ à proximité")
            end
            Wait(100)
            ContextUI.Focus = false
        end
    end)
    ContextUI:Button("Mettre en Fourrière", nil, function(onSelected)
        if (onSelected) then
            local vehicle = ESX.Game.GetVehicleInDirection()
            local plyPed = PlayerPedId()
            if DoesEntityExist(vehicle) then
                TaskStartScenarioInPlace(plyPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                
                ClearPedTasks(plyPed)
                Citizen.Wait(4000)
                ESX.Game.DeleteVehicle(vehicle)
                ClearPedTasks(plyPed) 
                ESX.ShowNotification("~g~Le véhicule a été placé en fourrière avec succès.")
                Wait(100)
            else
                ESX.ShowNotification("~r~Aucun véhicule~s~ à proximité")
            end
            ContextUI.Focus = false
        end
    end)
end)

local SEAT_MODEL = {
	[-99500382] = true,
	[-71417349] = true,
	[1805980844] = true,
}

local NOT_MODEL = {
	[-99500382] = true,
	[-71417349] = true,
    [1805980844] = true,
    [-1901044377] = true,
}

ContextUI:IsVisible(main_props, function(Entity)
    if not sitting and SEAT_MODEL[Entity.Model] then
        ContextUI:Button("S'asseoir", nil, function(onSelected)
            if onSelected then
                local position = GetEntityCoords(PlayerPedId())
                local coordsobj = GetEntityCoords(Entity.ID)
                local headingobj = GetEntityHeading(Entity.ID)
                if not HasEntityClearLosToEntity(PlayerPedId(), Entity.ID, 17) then
					return
				end
                if (GetFollowPedCamViewMode() ~= 4) then
					SetFollowPedCamViewMode(2)
				end
				TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_BENCH", coordsobj.x, coordsobj.y, coordsobj.z + (position.z - coordsobj.z) / 2, headingobj + 180.0, 0, true, false)
                sitting = true;
                ContextUI.Focus = false
            end
        end)
    end
    if Entity.Model == -1901044377 then
        ContextUI:Button("Tourner la roue", nil, function(onSelected)
            if onSelected then
                TriggerEvent('ewen:turnroue')
            end
        end)
    end
    if ESX.PlayerData.group ~= 'user' then
        ContextUI:Button("→ Administration", nil, function(onSelected)
            if onSelected then
                admin_props.Title = 'Props'
            end
        end, admin_props)
    end
    if not (NOT_MODEL[Entity.Model]) and ESX.PlayerData.group == 'user' then
        ContextUI:Button("Aucun interaction disponible", nil, function(onSelected)
            if (onSelected) then
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        if sitting then Wait(0) else Wait(750) end
        
        if sitting then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vous relevez.", true)
            if (IsControlJustPressed(1, 51)) then
                if (GetFollowPedCamViewMode() == 4) then
                    SetFollowPedCamViewMode(2)
                end    
                TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_BENCH", 0.0, 0.0, 0.0, 180.0, 2, true, false)
                while IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_SEAT_BENCH") do
                    Citizen.Wait(100)
                end
                ClearPedTasks(PlayerPedId())
                sitting = false;
            end
        end
    end
end)

ContextUI:IsVisible(admin_props, function(Entity)
    ContextUI:Button("- Supprimer le props", nil, function(onSelected)
        if onSelected then
            ForceDeleteEntity(Entity.ID)
            ContextUI.Focus = false
        end
    end)
end)

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
				SetEntityCoords(entity, vector3(10000.0, -1000.0, 10000.0), vector3(0.0, 0.0, 0.0), false)
			end
		end
	end
end
