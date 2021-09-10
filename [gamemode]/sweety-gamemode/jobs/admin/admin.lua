ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

local AdminMain = {}
local ServersIdSession = {}
local TARGET_INVENTORY = {}

Citizen.CreateThread(function()
    while true do
        Wait(500)
        for k,v in pairs(GetActivePlayers()) do
            local found = false
            for _,j in pairs(ServersIdSession) do
                if GetPlayerServerId(v) == j then
                    found = true
                end
            end
            if not found then
                table.insert(ServersIdSession, GetPlayerServerId(v))
            end
        end
    end
end)

local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTaska, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
isStaffMode, serverInteraction = false,false

isNoClip,NoClipSpeed,isNameShown = false,0.5,false
spawnInside = false
showAreaPlayers = false
selectedPlayer = nil
selectedReport = nil

localPlayers, connecteds, staff, items = {},0,0, {}
permLevel = nil

function getPosition()
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    return x,y,z
end

local function colorByState(bool)
    if bool then
        return "~b~"
    else
        return "~s~"
    end
end

RegisterNetEvent("Razzway:envoyer")
AddEventHandler("Razzway:envoyer", function(msg)
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	local head = RegisterPedheadshot(PlayerPedId())
	while not IsPedheadshotReady(head) or not IsPedheadshotValid(head) do
		Wait(1)
	end
	headshot = GetPedheadshotTxdString(head)
	ESX.ShowAdvancedNotification('Message du Staff', '~y~Informations', '~y~Message ~w~: ' ..msg, headshot, 2)
end)

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = 0
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

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

function KeyBoardText(TextEntry, ExampleText, MaxStringLength)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
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

function FullVehicleBoost()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
		SetVehicleModKit(vehicle, 0)
		SetVehicleMod(vehicle, 14, 0, true)
		SetVehicleNumberPlateTextIndex(vehicle, 5)
		ToggleVehicleMod(vehicle, 18, true)
		SetVehicleColours(vehicle, 0, 0)
		SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
		SetVehicleModColor_2(vehicle, 5, 0)
		SetVehicleExtraColours(vehicle, 111, 111)
		SetVehicleWindowTint(vehicle, 2)
		ToggleVehicleMod(vehicle, 22, true)
		SetVehicleMod(vehicle, 23, 11, false)
		SetVehicleMod(vehicle, 24, 11, false)
		SetVehicleWheelType(vehicle, 12) 
		SetVehicleWindowTint(vehicle, 3)
		ToggleVehicleMod(vehicle, 20, true)
		SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)
		LowerConvertibleRoof(vehicle, true)
		SetVehicleIsStolen(vehicle, false)
		SetVehicleIsWanted(vehicle, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetCanResprayVehicle(vehicle, true)
		SetPlayersLastVehicle(vehicle)
		SetVehicleFixed(vehicle)
		SetVehicleDeformationFixed(vehicle)
		SetVehicleTyresCanBurst(vehicle, false)
		SetVehicleWheelsCanBreak(vehicle, false)
		SetVehicleCanBeTargetted(vehicle, false)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		SetVehicleHasStrongAxles(vehicle, true)
		SetVehicleDirtLevel(vehicle, 0)
		SetVehicleCanBeVisiblyDamaged(vehicle, false)
		IsVehicleDriveable(vehicle, true)
		SetVehicleEngineOn(vehicle, true, true)
		SetVehicleStrong(vehicle, true)
		RollDownWindow(vehicle, 0)
		RollDownWindow(vehicle, 1)
		SetVehicleNeonLightEnabled(vehicle, 0, true)
		SetVehicleNeonLightEnabled(vehicle, 1, true)
		SetVehicleNeonLightEnabled(vehicle, 2, true)
		SetVehicleNeonLightEnabled(vehicle, 3, true)
		SetVehicleNeonLightsColour(vehicle, 0, 0, 255)
		SetPedCanBeDraggedOut(PlayerPedId(), false)
		SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
		SetPedRagdollOnCollision(PlayerPedId(), false)
		ResetPedVisibleDamage(PlayerPedId())
		ClearPedDecorations(PlayerPedId())
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
		for i = 0,14 do
			SetVehicleExtra(veh, i, 0)
		end
		SetVehicleModKit(veh, 0)
		for i = 0,49 do
			local custom = GetNumVehicleMods(veh, i)
			for j = 1,custom do
				SetVehicleMod(veh, i, math.random(1,j), 1)
			end
		end
	end
end

function VehicleFlip()

    local player = GetPlayerPed(-1)
    posdepmenu = GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
    if carTargetDep ~= nil then
            platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
    end
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    playerCoords = playerCoords + vector3(0, 2, 0)
    
    SetEntityCoords(carTargetDep, playerCoords)
    
    ESX.ShowAdvancedNotification('Administration', '~y~Informations', 'Le ~y~véhicule~s~ a été retourné', 'CHAR_KIRITO', 2)

end

RegisterNetEvent('Razzway:spawnVehicle')
AddEventHandler('Razzway:spawnVehicle', function(model)
    model = (type(model) == 'number' and model or GetHashKey(model))

    if IsModelInCdimage(model) then
        local playerPed = PlayerPedId()
        local plyCoords = GetEntityCoords(playerPed)

        ESX.Game.SpawnVehicle(model, plyCoords, 90.0, function(vehicle)
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        end)
    else
        ESX.ShowNotification('~r~Modèle véhicule invalide.')
    end
end)

local Menu = {

    action = {

        'Pistolet',
        'Pistolet 50',
        'Pistolet Lourd',
        'Pistolet Vintage',
        'Pistolet Détresse',
        'Revolver',
        'Double Action',
        'Micro SMG',
        'SMG',
        'SMG d\'assault',
        'ADP de combat',
        'Machine Pistol',
        'Mini SMG',
        'Pompe',
        'Carabine',
    },


    list = 1
}

function OpenMenuAdmin()

    if AdminMain.Menu then 
        AdminMain.Menu = false 
        RageUI.Visible(RMenu:Get('rz-admin', 'main'), false)
        return
    else
        RMenu.Add('rz-admin', 'main', RageUI.CreateMenu("Administation", "Test"))
        RMenu.Add('rz-admin', 'gestionp', RageUI.CreateSubMenu(RMenu:Get("rz-admin", "main"),"Administation", "~b~Intéraction Menu"))
        RMenu.Add('rz-admin', 'interactionveh', RageUI.CreateSubMenu(RMenu:Get("rz-admin", "main"),"Administation", "~b~Intéraction Menu"))
        RMenu.Add('rz-admin', 'gestionserv', RageUI.CreateSubMenu(RMenu:Get("rz-admin", "main"),"Administation", "~b~Give Menu"))
        RMenu.Add('rz-admin', 'players', RageUI.CreateSubMenu(RMenu:Get("rz-admin", "gestionp"),"Administation", "~b~Gestion Joueurs"))
        RMenu.Add('rz-admin', 'inventory', RageUI.CreateSubMenu(RMenu:Get("rz-admin", "players"),"Administation", "~b~Inventaire Joueurs"))
        RMenu.Add('rz-admin', 'report', RageUI.CreateSubMenu(RMenu:Get("rz-admin", "main"),"Administation", "~b~Report Menu"))
        RMenu.Add('rz-admin', 'vehicle', RageUI.CreateSubMenu(RMenu:Get("rz-admin", "gestionserv"),"Administation", "~b~Vehicule Menu"))
        RMenu.Add('rz-admin', 'argent', RageUI.CreateSubMenu(RMenu:Get("rz-admin", "gestionserv"),"Administation", "~b~Argent Menu"))
        RMenu:Get('rz-admin', 'main'):SetSubtitle("~b~Administatrion - SweetyLife")
        RMenu:Get('rz-admin', 'main').EnableMouse = false
        RMenu:Get('rz-admin', 'main').Closed = function()
            AdminMain.Menu = false
        end
        AdminMain.Menu = true 
        RageUI.Visible(RMenu:Get('rz-admin', 'main'), true)
        Citizen.CreateThread(function()
			while AdminMain.Menu do
                RageUI.IsVisible(RMenu:Get('rz-admin', 'main'), true, true, true, function()
                    RageUI.Separator("Joueurs : ~y~0~s~ | Staff en ligne : ~b~0")
                    RageUI.Checkbox("".. colorByState(service) .."Prendre son service",nil, service,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            service = Checked
                            if Checked then
                                onservice = true
                            else
                                onservice = false
                            end
                        end
                    end)
                    if onservice then
                        RageUI.Text({message = "Rang : ~r~".. ESX.GetPlayerData()['group'] .."~s~ | Report actuels : ~y~"})
                        RageUI.ButtonWithStyle("Intéraction Joueurs", nil, {RightLabel = "→→"},true, function()
                        end, RMenu:Get('rz-admin', 'gestionp'))
                        RageUI.ButtonWithStyle("Report en attente", nil, {RightLabel = "0"},true, function()
                        end, RMenu:Get('rz-admin', 'report'))
                        RageUI.Checkbox("" .. colorByState(isNoClip) .. "Caméra Libre", nil, isNoClip, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                            isNoClip = Checked;
                        end, function()
                            NoClip(true)
                            ESX.ShowNotification("Vous avez ~g~activé~s~ le noclip")
                        end, function()
                            NoClip(false)
                            ESX.ShowNotification("Vous avez ~r~désactivé~s~ le noclip")
                        end)
                        RageUI.Checkbox("" .. colorByState(isNameShown) .. "Affichage des noms", nil, isNameShown, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                            isNameShown = Checked;
                        end, function()
                            showNames(true)
                        end, function()
                            showNames(false)
                        end)
                        RageUI.ButtonWithStyle("Gestion Téléportation", nil, {RightLabel = "→→"},true, function()
                        end, RMenu:Get('rz-admin', 'interactionveh'))
                        RageUI.ButtonWithStyle("Gestion du Serveur", nil, {RightLabel = "→→"},true, function()
                        end, RMenu:Get('rz-admin', 'gestionserv'))
                    end
                    
                end)

                RageUI.IsVisible(RMenu:Get('rz-admin', 'gestionp'), true, true, true, function()
                    for k,v in ipairs(ServersIdSession) do
                        if GetPlayerName(GetPlayerFromServerId(v)) == "**Invalid**" then table.remove(ServersIdSession, k) end
                        RageUI.ButtonWithStyle(v.." - " ..GetPlayerName(GetPlayerFromServerId(v)), nil, {}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                IdSelected = v
                            end
                        end, RMenu:Get('rz-admin', 'players'))
                    end
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('rz-admin', 'players'), true, true, true, function()
                    RageUI.ButtonWithStyle("Se téléporter sur lui", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected))))
                        end
                    end)
                    RageUI.ButtonWithStyle("Téléporter vers moi", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            ExecuteCommand("bring "..IdSelected)
                        end
                    end)
                    RageUI.ButtonWithStyle("Voir l'inventaire", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            ESX.TriggerServerCallback('::{razzway.xyz}::esx_policejob:getOtherPlayerData', function(data)
                                for i = 1, #data.accounts, 1 do
                                    if (data.accounts[i].money ~= 0) then
                                        TARGET_INVENTORY[#TARGET_INVENTORY + 1] = { label = data.accounts[i].name, count = data.accounts[i].money, value = data.accounts[i].name }
                                    end
                                end
        
                                for i = 1, #data.weapons, 1 do
                                    TARGET_INVENTORY[#TARGET_INVENTORY + 1] = { label = data.weapons[i].label, count = data.weapons[i].ammo, value = data.weapons[i].name }
                                end
        
                                for i = 1, #data.inventory, 1 do
                                    if data.inventory[i].count > 0 then
                                        TARGET_INVENTORY[#TARGET_INVENTORY + 1] = { label = data.inventory[i].label, count = data.inventory[i].count, value = data.inventory[i].name }
                                    end
                                end
        
                            end, tonumber(IdSelected))
                        end
                    end, RMenu:Get('rz-admin', 'inventory'))
                    RageUI.ButtonWithStyle("Spectate", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local playerId = GetPlayerFromServerId(IdSelected)
                            SpectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
                        end
                    end)
                    RageUI.ButtonWithStyle("Wipe l'inventaire", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            ExecuteCommand("clearinventory "..IdSelected)
                            ESX.ShowAdvancedNotification("Administration", "~y~Informations", "Vous venez de WIPE les items de ~b~".. GetPlayerName(GetPlayerFromServerId(IdSelected)) .."~s~ !", "CHAR_KIRITO", 1) 																
                        end
                    end)
                    RageUI.ButtonWithStyle("Wipe les armes", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            ExecuteCommand("clearloadout "..IdSelected)
                            ESX.ShowAdvancedNotification("Administration", "~y~Informations", "Vous venez de WIPE les armes de ~b~".. GetPlayerName(GetPlayerFromServerId(IdSelected)) .."~s~ !", "CHAR_KIRITO", 1) 																
                        end
                    end)
                    RageUI.ButtonWithStyle("Envoyer un message", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local msg = KeyboardInput('Razzway_BOX_BAN_RAISON', "Message Privée", '', 50)
                        
                            if msg ~= nil then
                                msg = tostring(msg)
                    
                                if type(msg) == 'string' then
                                    SwLife.InternalToServer("Razzway:Message", IdSelected, msg)
                                end
                            end
                            ESX.ShowNotification("Vous venez d'envoyer le message à ~y~" .. GetPlayerName(GetPlayerFromServerId(IdSelected)))
                        end
                    end)
                end)

                RageUI.IsVisible(RMenu:Get('rz-admin', 'inventory'), true, true, true, function()
                    for i, v in pairs(TARGET_INVENTORY) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = v.count }, true, function(h,a,s)
                            if s then
            
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(RMenu:Get('rz-admin', 'gestionserv'), true, true, true, function()

                    RageUI.ButtonWithStyle("Module Véhicule", nil, {RightLabel = "→→"},true, function()
                    end, RMenu:Get('rz-admin', 'vehicle'))

                    RageUI.ButtonWithStyle("Module Argent", nil, {RightLabel = "→→"},true, function()
                    end, RMenu:Get('rz-admin', 'argent'))

                    RageUI.List('Armes', Menu.action, Menu.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                SwLife.InternalToServer('rz-admin:weapon', "weapon_pistol", 250)
                        elseif Index == 2 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_pistol50", 250)
                        elseif Index == 3 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_heavypistol", 250)
                        elseif Index == 4 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_vintagepistol", 250)
                        elseif Index == 5 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_flaregun", 250)
                        elseif Index == 6 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_revolver", 250)
                        elseif Index == 7 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_doubleaction", 250)
                        elseif Index == 8 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_microsmg", 250)
                        elseif Index == 9 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_smg", 250)
                        elseif Index == 10 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_assaultsmg", 250)
                        elseif Index == 11 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_combatpdw", 250)
                        elseif Index == 12 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_machinepistol", 250)
                        elseif Index == 13 then
                            SwLife.InternalToServer('rz-admin:weapon', "minismg", 250)
                        elseif Index == 14 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_pumpshotgun", 250)
                        elseif Index == 15 then
                            SwLife.InternalToServer('rz-admin:weapon', "weapon_carbinerifle", 250)
                        end
                    end
                       Menu.list = Index;              
                    end)
                    
                end)

                RageUI.IsVisible(RMenu:Get('rz-admin', 'vehicle'), true, true, true, function()
                    RageUI.ButtonWithStyle("Spawn un véhicule", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local modelName = KeyboardInput('Razzway_BOX_VEHICLE_NAME', "Veuillez entrer le ~y~nom~s~ du véhicule", '', 50)
                            TriggerEvent('Razzway:spawnVehicle', modelName)
                        end
                    end)

                    RageUI.ButtonWithStyle("Upgrade au max le véhicule", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            FullVehicleBoost()
                        end
                    end)

                    
                    RageUI.ButtonWithStyle("Réparer le véhicule", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local plyVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                            SetVehicleFixed(plyVeh)
                            SetVehicleDirtLevel(plyVeh, 0.0)
                            ESX.ShowAdvancedNotification('Administration', '~y~Informations', 'Le ~y~véhicule~s~ a été réparé', 'CHAR_KIRITO', 2)
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Retourner le véhicule", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            VehicleFlip()
                        end
                    end)

                    RageUI.ButtonWithStyle("Changer la plaque", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                                local plaqueVehicule = KeyBoardText("Veuillez entrer le ~y~nom~s~ de la plaque", "", 8)
                                SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)
                                ESX.ShowAdvancedNotification('Administration', '~y~Informations', 'Le nom de la plaque est désormais : ~y~' ..plaqueVehicule, 'CHAR_KIRITO', 2)
                            else
                                ESX.ShowAdvancedNotification('Administration', '~y~Informations', '~r~Erreur :~s~ Vous n\'êtes pas dans un véhicule ~y~', 'CHAR_KIRITO', 2)
                            end
                        end
                    end)
                end)

                RageUI.IsVisible(RMenu:Get('rz-admin', 'argent'), true, true, true, function()
                    RageUI.ButtonWithStyle("S'octroyer de ~g~l'argent en liquide", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                            if amount ~= nil then
                                amount = tonumber(amount)
                    
                                if type(amount) == 'number' then
                                    SwLife.InternalToServer('Razzway:GiveMoney', "cash", amount)  
                                    ESX.ShowNotification("Give de ~g~" .. amount .. "$~s~")                             
                                end
                            end
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("S'octroyer de ~b~l'argent en banque", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                            if amount ~= nil then
                                amount = tonumber(amount)
                    
                                if type(amount) == 'number' then
                                    SwLife.InternalToServer('Razzway:GiveMoney', "bank", amount)  
                                    ESX.ShowNotification("Give de ~b~" .. amount .. "$~s~")                             
                                end
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("S'octroyer de ~r~l'argent en sale", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                            if amount ~= nil then
                                amount = tonumber(amount)
                    
                                if type(amount) == 'number' then
                                    SwLife.InternalToServer('Razzway:GiveMoney', "dirtycash", amount)  
                                    ESX.ShowNotification("Give de ~r~" .. amount .. "$~s~")                             
                                end
                            end
                        end
                    end)
                end)
                
                RageUI.IsVisible(RMenu:Get('rz-admin', 'interactionveh'), true, true, true, function()
                    local coords  = GetEntityCoords(PlayerPedId())
                    local vehicle = ESX.Game.GetVehicleInDirection()
                    
                    RageUI.ButtonWithStyle("TP Waypoint", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            plyPed = PlayerPedId()
                            local waypointHandle = GetFirstBlipInfoId(8)
        
                            if DoesBlipExist(waypointHandle) then
                                Citizen.CreateThread(function()
                                    local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
                                    local foundGround, zCoords, zPos = false, -500.0, 0.0
                
                                    while not foundGround do
                                        zCoords = zCoords + 10.0
                                        RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
                                        Citizen.Wait(0)
                                        foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)
                
                                        if not foundGround and zCoords >= 2000.0 then
                                            foundGround = true
                                        end
                                    end
                
                                    SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
                                    ESX.ShowNotification("Vous avez été TP")
                                end)
                            else
                                ESX.ShowNotification("Pas de marqueur sur la carte")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre en Fourrière", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

                            currentTaska.busy = true
                            currentTaska.task = ESX.SetTimeout(10000, function()
                                ClearPedTasks(playerPed)
                                ESX.Game.DeleteVehicle(vehicle)
                                ESX.ShowNotification("~b~Mise en fourrière effectuée.")
                                currentTaska.busy = false
                                Citizen.Wait(100) 
                            end)
        
                        
                            Citizen.CreateThread(function()
                                while currentTaska.busy do
                                    Citizen.Wait(1000)
        
                                    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                    if not DoesEntityExist(vehicle) and currentTaska.busy then
                                        ESX.ShowNotification("~r~Mise en Fourrière (Erreur) \n~s~Il n'y a pas de véhicule dans les environs !")
                                        ESX.ClearTimeout(currentTaska.task)
                                        ClearPedTasks(playerPed)
                                        currentTaska.busy = false
                                        break
                                    end
                                end
                            end)
                        end
                    end)
                end)
                    
                RageUI.IsVisible(RMenu:Get('rz-admin', 'report'), true, true, true, function()
                    RageUI.ButtonWithStyle("Soon", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            local raison = 'petit'
                            local elements  = {}
                            local playerPed = PlayerPedId()
                            local coords  = GetEntityCoords(playerPed)
                            local name = GetPlayerName(PlayerId())
                            SwLife.InternalToServer('renfort', coords, raison)
                        end
                    end)
                end)
                Wait(0)
            end
        end)
    end
end

Keys.Register('F10','InteractionsAdmin', 'Menu Admin', function()
    if (ESX.GetPlayerData()['group'] ~= "user") then
        OpenMenuAdmin()
    end
end)