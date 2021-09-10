-------- OBLIGER DE DUMP PARCE QUE T'ARRIVES PAS A CHEAT ? PFF TU PUES ^^ --------
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local _Razzourson = TriggerServerEvent

---@type table Shared object
ESX = {};

TriggerEvent('SwLife:initObject', function(obj)
    ESX = obj
end)

local gamertag = {
    ["user"] = "Joueurs",
    ["help"] = "Helpeur",
    ["mod"] = "Modo",
    ["admin"] = "Admin",
    ["superadmin"] = "Gérant Staff",
    ["_dev"] = "Fondateur",
}

local player = {};
local jobs = nil
local lisenceontheflux = nil
local Bot = {}
local get = false

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

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('SwLife:initObject', function(obj)
            ESX = obj
        end)
        player = ESX.GetPlayerData()
        Citizen.Wait(100)
    end
end)

local TempsValue = ""
local raisontosend = "Aucune Raison !"
local GroupItem = {}
GroupItem.Value = 1

local mainMenu = RageUIRZ.CreateMenu("Administration", "~b~Gestions du serveur")
local inventoryMenu = RageUIRZ.CreateSubMenu(mainMenu, "Administration", "Inventaire du joueur")

local TARGET_INVENTORY = {}

mainMenu:AddInstructionButton({
    [1] = GetControlInstructionalButton(1, 334, 0),
    [2] = "Modifier la vitesse du NoClip",
});

local selectedMenu = RageUIRZ.CreateSubMenu(mainMenu, "Administration", "placeholder")

local playerActionMenu = RageUIRZ.CreateSubMenu(mainMenu, "Administration", "placeholder")

local adminmenu = RageUIRZ.CreateSubMenu(mainMenu, "Administration", "Menu Admin")

local utilsmenu = RageUIRZ.CreateSubMenu(mainMenu, "Administration", "Menu Utils")

local moneymenu = RageUIRZ.CreateSubMenu(mainMenu, "Administration", "Menu Give")

local tpmenu = RageUIRZ.CreateSubMenu(mainMenu, "Administration", "Menu Teleportation")

local vehiculemenu = RageUIRZ.CreateSubMenu(mainMenu, "Administration", "Menu Vehicule")

local reportmenu = RageUIRZ.CreateSubMenu(mainMenu, "Administration", "Liste Report")

---@class Razzway
Razzway = {} or {};

---@class SelfPlayer Administrator current settings
Razzway.SelfPlayer = {
    ped = 0,
    isStaffEnabled = false,
    isClipping = false,
    isGamerTagEnabled = false,
    isReportEnabled = true,
    isInvisible = false,
    isCarParticleEnabled = false,
    isSteve = false,
    isDelgunEnabled = false,
};

Razzway.SelectedPlayer = {};

Razzway.Menus = {} or {};

Razzway.Helper = {} or {}

---@class Players
Razzway.Players = {} or {} --- Players lists
---
Razzway.PlayersStaff = {} or {} --- Players Staff

Razzway.AllReport = {} or {} --- Players Staff


---@class GamerTags
ESX.StreamingrTags = {} or {};

playerActionMenu.onClosed = function()
    Razzway.SelectedPlayer = {};
    lisenceontheflux = nil;
end

local NoClip = {
    Camera = nil,
    Speed = 1.0
}

local oldpos = nil
local specatetarget = nil
local specateactive = false

function spectate(target)
    if not oldpos then
        _Razzourson("Razzway:teleport", target)
        oldpos = GetEntityCoords(GetPlayerPed(PlayerId()))
		SetEntityVisible(GetPlayerPed(PlayerId()), false)
        SetEntityCollision(GetPlayerPed(PlayerId()), false, false)
        specatetarget = target
        specateactive = true
    else
        SetEntityCoords(GetPlayerPed(PlayerId()), oldpos.x, oldpos.y, oldpos.z)
        SetEntityVisible(GetPlayerPed(PlayerId()), true)
        SetEntityCollision(GetPlayerPed(PlayerId()), true, true)
        specatetarget = nil
        gang = ""
        oldpos = nil
        specateactive = false
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if specateactive then
            for _, player in ipairs(GetActivePlayers()) do
                if GetPlayerServerId(player) == tonumber(specatetarget) then
                    local ped = GetPlayerPed(player)
                    local coords = GetEntityCoords(ped)
                    SetEntityNoCollisionEntity(GetPlayerPed(PlayerId()), ped, true)
                    SetEntityCoords(GetPlayerPed(PlayerId()), coords.x, coords.y, coords.z)
                end
            end             
        end            
    end
end)

local selectedIndex = 0;

local FastTravel = {
    { Name = "~g~Parking central~s~", Value = vector3(215.76, -810.8, 30.72) },
    { Name = "~g~Fourrière~s~", Value = vector3(409.16, -1625.47, 29.29) },
    { Name = "~g~Concessionaire~s~", Value = vector3(-67.6, -1091.21, 26.63) },
    { Name = "~g~Mécano~s~", Value = vector3(-211.44, -1323.68, 30.89) },
    { Name = "~g~Cayo Perico~s~", Value = vector3(4509.66, -4508.96, 3.01) },
}

local GroupIndex = 1;
local GroupIndexx = 1;
local GroupIndexxx = 1;
local GroupIndexxxx = 1;
local GroupIndexxxxx = 1;
local GroupIndexxxxxWeapon = 1;
local GroupIndexxxxxPed = 1;
local IndexJobs = 1;
local IndexJobsGrade = 1;
local IndexGangs = 1;
local IndexGangsGrade = 1;
local PermissionIndex = 1;
local VehicleIndex = 1;
local FastTravelIndex = 1;
local idtosanctionbaby = 1;
local idtoreport = 1;
local kvdureport = 1;

function Razzway.Helper:RetrievePlayersDataByID(source)
    local player = {};
    for i, v in pairs(Razzway.Players) do
        if (v.source == source) then
            player = v;
        end
    end
    return player;
end

function Razzway.Helper:onToggleNoClip(toggle)
    if (toggle) then
        ESX.ShowNotification("~g~Vous venez d'activer le noclip")
        if (ESX.GetPlayerData()['group'] ~= "user") then
            if (NoClip.Camera == nil) then
                NoClip.Camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            end
            SetCamActive(NoClip.Camera, true)
            RenderScriptCams(true, false, 0, true, true)
            SetCamCoord(NoClip.Camera, GetEntityCoords(Razzway.SelfPlayer.ped))
            SetCamRot(NoClip.Camera, GetEntityRotation(Razzway.SelfPlayer.ped))
            SetEntityCollision(NoClip.Camera, false, false)
            SetEntityVisible(NoClip.Camera, false)
            SetEntityVisible(Razzway.SelfPlayer.ped, false, false)
        end
    else
        if (ESX.GetPlayerData()['group'] ~= "user") then
            ESX.ShowNotification("~y~Vous venez de désactiver le noclip")
            SetCamActive(NoClip.Camera, false)
            RenderScriptCams(false, false, 0, true, true)
            SetEntityCollision(Razzway.SelfPlayer.ped, true, true)
            SetEntityCoords(Razzway.SelfPlayer.ped, GetCamCoord(NoClip.Camera))
            SetEntityHeading(Razzway.SelfPlayer.ped, GetGameplayCamRelativeHeading(NoClip.Camera))
            if not (Razzway.SelfPlayer.isInvisible) then
                SetEntityVisible(Razzway.SelfPlayer.ped, true, false)
            end
        end
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

function Razzway.Helper:OnRequestGamerTags()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if (ESX.StreamingrTags[ped] == nil) or (ESX.StreamingrTags[ped].ped == nil) or not (IsMpGamerTagActive(ESX.StreamingrTags[ped].tags)) then
            local formatted;
            local group = 0;
            local permission = 0;
            local fetching = Razzway.Helper:RetrievePlayersDataByID(GetPlayerServerId(player));
            if fetching.group ~= nil then
                if fetching.group ~= "user" then
                    formatted = string.format('[' .. gamertag[fetching.group] .. '] %s | %d', GetPlayerName(player), GetPlayerServerId(player),fetching.jobs)
                else
                    formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), fetching.jobs)
                end
            else
                formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), "Jobs Unknow")
            end
            if (fetching) then
                group = fetching.group
                permission = fetching.permission
            end

            ESX.StreamingrTags[ped] = {
                player = player,
                ped = ped,
                group = group,
                permission = permission,
                tags = CreateFakeMpGamerTag(ped, formatted)
            };
        end

    end
end

function Razzway.Helper:RequestModel(model)
    if (IsModelValid(model)) then
        if not (HasModelLoaded(model)) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Visual.Prompt(string.format("Razzway : Loading %s model..", model), 4)
                Citizen.Wait(1.0)
            end
            BusyspinnerOff()
            return model;
        else
            Visual.PromptDuration(1000, string.format('Razzway : Can\'t load model %s but is already load', model), 1)
            return model;
        end
        Visual.FloatingHelpText(string.format("~r~ Razzway : The model %s you just asked for does not exist in the game files or on the server.", model))
        return model;
    end
end

RegisterNetEvent("arme:event")
AddEventHandler("arme:event", function()
    GiveWeaponToPed(PlayerPedId(), "weapon_carbinerifle", 9999, false, false)
end)

function Razzway.Helper:RequestPtfx(assetName)
    RequestNamedPtfxAsset(assetName)
    if not (HasNamedPtfxAssetLoaded(assetName)) then
        while not HasNamedPtfxAssetLoaded(assetName) do
            Citizen.Wait(1.0)
        end
        return assetName;
    else
        return assetName;
    end
end

function Razzway.Helper:CreateVehicle(model, vector3)
    self:RequestModel(model)
    local vehicle = CreateVehicle(model, vector3, 100.0, true, false)
    local id = NetworkGetNetworkIdFromEntity(vehicle)

    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(vehicle, false, false)
    SetModelAsNoLongerNeeded(model)

    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    while not HasCollisionLoadedAroundEntity(vehicle) do
        Citizen.Wait(0)
    end
    return vehicle, GetEntityCoords(vehicle);
end

function Razzway.Helper:KeyboardInput(TextEntry, ExampleText, MaxStringLength, OnlyNumber)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", 500)
    local blocking = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blocking = false
        if (OnlyNumber) then
            local number = tonumber(result)
            if (number ~= nil) then
                return number
            end
            return nil
        else
            return result
        end
    else
        Citizen.Wait(500)
        blocking = false
        return nil
    end
end

function Razzway.Helper:OnGetPlayers()
    local clientPlayers = false;
    ESX.TriggerServerCallback('Razzway:retrievePlayers', function(players)
        clientPlayers = players
    end)

    while not clientPlayers do
        Citizen.Wait(0)
    end
    return clientPlayers
end

function Razzway.Helper:OnGetStaffPlayers()
    local clientPlayers = false;
    ESX.TriggerServerCallback('Razzway:retrieveStaffPlayers', function(players)
        clientPlayers = players
    end)
    while not clientPlayers do
        Citizen.Wait(0)
    end
    return clientPlayers
end

function Razzway.Helper:GetReport()
    ESX.TriggerServerCallback('Razzway:retrieveReport', function(allreport)
        ReportBB = allreport
    end)
    while not ReportBB do
        Citizen.Wait(0)
    end
    return ReportBB
end

function admin_vehicle_flip()

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

RegisterNetEvent("Razzway:RefreshReport")
AddEventHandler("Razzway:RefreshReport", function()
    Razzway.GetReport = Razzway.Helper:GetReport()
end)

function Razzway.Helper:onStaffMode(status)
    if (status) then
        onStaffMode = true
        CreateThread(function()
            while onStaffMode do
                Visual.Subtitle("Rang : ~r~".. ESX.GetPlayerData()['group'] .."~s~ | Report actuels : ~y~" .. #Razzway.GetReport , 999999999999999)
                Citizen.Wait(500)
            end
        end)
        Razzway.PlayersStaff = Razzway.Helper:OnGetStaffPlayers()
        Razzway.GetReport = Razzway.Helper:GetReport()
    else
        onStaffMode = false
        Visual.Subtitle("Report actifs : ~y~" .. #Razzway.GetReport , 1)
        if (Razzway.SelfPlayer.isClipping) then
            Razzway.Helper:onToggleNoClip(false)
        end
        if (Razzway.SelfPlayer.isInvisible) then
            Razzway.SelfPlayer.isInvisible = false;
            SetEntityVisible(Razzway.SelfPlayer.ped, true, false)
        end
    end
    
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if (Razzway.SelfPlayer.isStaffEnabled) then
            Razzway.Players = Razzway.Helper:OnGetPlayers()
            Razzway.PlayersStaff = Razzway.Helper:OnGetStaffPlayers()
            Razzway.GetReport = Razzway.Helper:GetReport()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if (IsControlJustPressed(0, 57)) then
            if (ESX.GetPlayerData()['group'] ~= "user") then
                Razzway.Players = Razzway.Helper:OnGetPlayers();
                Razzway.PlayersStaff = Razzway.Helper:OnGetStaffPlayers()
                Razzway.GetReport = Razzway.Helper:GetReport()
                RageUIRZ.Visible(mainMenu, not RageUIRZ.Visible(mainMenu))
            end
        end

        if (IsControlJustPressed(0, 344)) then
            if (ESX.GetPlayerData()['group'] ~= "user") then
                Razzway.GetReport = Razzway.Helper:GetReport()
                RageUIRZ.Visible(reportmenu, not RageUIRZ.Visible(reportmenu))
            end
        end


        RageUIRZ.IsVisible(mainMenu, function()

            RageUIRZ.Separator("Joueurs : ~y~" .. #Razzway.Players.. "~s~ | Staff en ligne : ~b~" .. #Razzway.PlayersStaff .. "")
            RageUIRZ.Checkbox("Prendre son service", "Le mode staff ne peut être utilisé que pour modérer le serveur, tout abus sera sévèrement puni, l'intégralité de vos actions sera enregistrée.", Razzway.SelfPlayer.isStaffEnabled, { }, {
                onChecked = function()
                    Razzway.Helper:onStaffMode(true)
                    _Razzourson('Razzway:onStaffJoin')
                end,
                onUnChecked = function()
                    Razzway.Helper:onStaffMode(false)
                    _Razzourson('Razzway:onStaffLeave')
                end,
                onSelected = function(Index)
                    Razzway.SelfPlayer.isStaffEnabled = Index
                end
            })

            local colors = {"~p~", "~r~","~o~","~y~","~c~","~g~","~b~"}

            if (Razzway.SelfPlayer.isStaffEnabled) then
   
                RageUIRZ.Button('Intéractions Joueurs', nil, { RightLabel = "→→" }, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Joueurs en lignes [%s]', #Razzway.Players))
                        selectedIndex = 1;
                    end
                }, selectedMenu)

                RageUIRZ.Button('Report en attente', nil, { RightLabel = #Razzway.GetReport }, true, {
                    onSelected = function()
                    end
                }, reportmenu)

                RageUIRZ.Checkbox("Caméra Libre", "Vous permet de vous déplacer librement sur toute la carte sous forme de caméra libre.", Razzway.SelfPlayer.isClipping, { }, {
                    onChecked = function()
                    _Razzourson("Razzway:SendLogs", "Active noclip")
                    Razzway.Helper:onToggleNoClip(true)
                    end,
                    onUnChecked = function()
                    _Razzourson("Razzway:SendLogs", "Désactive noclip")
                    Razzway.Helper:onToggleNoClip(false)
                    end,
                    onSelected = function(Index)
                    Razzway.SelfPlayer.isClipping = Index
                    end
                }, selectedMenu)

                RageUIRZ.Checkbox("Afficher les Noms", "L'affichage des tags des joueurs vous permet de voir les informations des joueurs, y compris de vous reconnaître entre les membres du personnel grâce à votre couleur.", Razzway.SelfPlayer.isGamerTagEnabled, { }, {
                    onChecked = function()
                    if (ESX.GetPlayerData()['group'] ~= "user") then
                    _Razzourson("Razzway:SendLogs", "Active GamerTags")
                    Razzway.Helper:OnRequestGamerTags()
                    end
                    end,
                    onUnChecked = function()
                    for i, v in pairs(ESX.StreamingrTags) do
                    _Razzourson("Razzway:SendLogs", "Désactive GamerTags")
                    RemoveMpGamerTag(v.tags)
                    end
                    ESX.StreamingrTags = {};
                    end,
                    onSelected = function(Index)
                    Razzway.SelfPlayer.isGamerTagEnabled = Index
                    end
                }, selectedMenu)

                RageUIRZ.Button('Practics', nil, { RightLabel = "→→" }, true, {
                    onSelected = function()
                    end
                }, tpmenu)

                RageUIRZ.Button('Véhicules', nil, { RightLabel = "→→" }, true, {
                    onSelected = function()
                    end
                }, vehiculemenu)

                RageUIRZ.Button('System', nil, { RightLabel = "→→" }, true, {
                    onSelected = function()
                    end
                }, utilsmenu)

            end
        end)

        if (Razzway.SelfPlayer.isStaffEnabled) then
            RageUIRZ.IsVisible(inventoryMenu, function()
                for i, v in pairs(TARGET_INVENTORY) do
                    RageUIRZ.Button(v.label, nil, { RightLabel = v.count }, true, {
                        onSelected = function()
        
                        end
                    })
                end
            end)
        end


        if (Razzway.SelfPlayer.isStaffEnabled) then
            RageUIRZ.IsVisible(tpmenu, function()

            RageUIRZ.Button('TP Waypoint', 'Permet de se ~y~téléporter~s~ sur un ~y~point~s~', { RightLabel = gang }, true, {
                onSelected = function()
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
                            _Razzourson("Razzway:SendLogs", "Se TP sur le waypoint")
                        end)
                    else
                        ESX.ShowNotification("Pas de marqueur sur la carte")
                    end
                end
            })
            
            local gang = ""
            if specateactive then
                gang = "✅"
            end    

            RageUIRZ.Button('Spectate Aléatoire', nil, { RightLabel = gang }, true, {
                onSelected = function()
                    local number = #Razzway.Players
                    local target = Razzway.Players[math.random(0~number)].source
                    if target == GetPlayerServerId(PlayerId()) then
                        ESX.ShowNotification("Votre ID a été sélectionné mais vous ne pouvez pas vous spec vous même ! Réessayer !")
                    else
                        spectate(target)
                    end
                end
            })

            RageUIRZ.Checkbox("Mode Invisible", nil, Razzway.SelfPlayer.isInvisible, { }, {
                onChecked = function()
                _Razzourson("Razzway:SendLogs", "Active invisible")
                SetEntityVisible(Razzway.SelfPlayer.ped, false, false)
                end,
                onUnChecked = function()
                _Razzourson("Razzway:SendLogs", "Désactive invisible")
                SetEntityVisible(Razzway.SelfPlayer.ped, true, false)
                end,
                onSelected = function(Index)
                    Razzway.SelfPlayer.isInvisible = Index
                end
            })

            RageUIRZ.List('Fast Travel', FastTravel, FastTravelIndex, nil, {}, true, {
                onListChange = function(Index, Item)
                FastTravelIndex = Index;
                end,
                onSelected = function(Index, Item)
                Razzway.SelfPlayer.isInvisible = true
                SetEntityVisible(Razzway.SelfPlayer.ped, false, false)
                SetEntityCoords(PlayerPedId(), Item.Value)
                _Razzourson("Razzway:SendLogs", "Utilise le fast travel")
                end
            })
        end)
    end

        if (Razzway.SelfPlayer.isStaffEnabled) then
            RageUIRZ.IsVisible(utilsmenu, function()

                RageUIRZ.Checkbox("Show Coords", "Affiche les ~o~coordonnées", Razzway.SelfPlayer.ShowCoords, { }, {
                    onChecked = function()
                        _Razzourson("Razzway:SendLogs", "Affiche les coordonnées")
                        coords = true
                    end,
                    onUnChecked = function()
                        _Razzourson("Razzway:SendLogs", "Désactive l'affichage des coordonnées")
                        coords = false
                    end,
                    onSelected = function(Index)
                        Razzway.SelfPlayer.ShowCoords = Index
                    end
                })

                RageUIRZ.Checkbox("Quick Delgun", 'Active le ~g~pistolet~s~ qui ~r~delete', Razzway.SelfPlayer.isDelgunEnabled, { }, {
                    onChecked = function()
                        _Razzourson("Razzway:SendLogs", "Active Delgun")
                    end,
                    onUnChecked = function()
                        _Razzourson("Razzway:SendLogs", "Désactive Delgun")
                    end,
                    onSelected = function(Index)
                        Razzway.SelfPlayer.isDelgunEnabled = Index
                    end
                })

                if (ESX.GetPlayerData()['group'] == "superadmin") or (ESX.GetPlayerData()['group'] == "_dev") then
                    RageUIRZ.Button("S'octroyer de ~g~l'argent en liquide", nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                            if amount ~= nil then
                                amount = tonumber(amount)
                    
                                if type(amount) == 'number' then
                                    _Razzourson('Razzway:GiveMoney', "cash", amount)   
                                    ESX.ShowNotification("Give de ~g~" .. amount .. "$~s~")                            
                                end
                            end
                        end,
                    })
                end
                if (ESX.GetPlayerData()['group'] == "superadmin") or (ESX.GetPlayerData()['group'] == "_dev") then
                    RageUIRZ.Button("S'octroyer de ~b~l'argent en banque", nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                            if amount ~= nil then
                                amount = tonumber(amount)
                    
                                if type(amount) == 'number' then
                                    _Razzourson('Razzway:GiveMoney', "bank", amount)  
                                    ESX.ShowNotification("Give de ~b~" .. amount .. "$~s~")                             
                                end
                            end
                        end,
                    })
                end
                if (ESX.GetPlayerData()['group'] == "superadmin") or (ESX.GetPlayerData()['group'] == "_dev") then
                    RageUIRZ.Button("S'octroyer de ~r~l'argent sale", nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                            if amount ~= nil then
                                amount = tonumber(amount)
                    
                                if type(amount) == 'number' then
                                    _Razzourson('Razzway:GiveMoney', "dirtycash", amount)   
                                    ESX.ShowNotification("Give de ~r~" .. amount .. "$~s~")                            
                                end
                            end
                        end,
                    })
                end
                if (ESX.GetPlayerData()['group'] == "superadmin") or (ESX.GetPlayerData()['group'] == "_dev") then
                    RageUIRZ.List('Liste ~o~des items', {
                        { Name = "Menotte Police", Value = 'police_cuff' },
                        { Name = "Clefs Menotte Police", Value = 'police_key' },
                        { Name = "Bitcoin", Value = 'bitcoin' },
                        { Name = "Kevlar", Value = 'armor' },
                        { Name = "Bandage", Value = 'bandage' },
                        { Name = "Menottes Basique", Value = 'basic_cuff' },
                        { Name = "Clefs de Menottes Basique", Value = 'basic_key' },
                        { Name = "Bière", Value = 'beer' },
                        { Name = "Chalumeaux", Value = 'blowpipe' },
                        { Name = "Pain", Value = 'bread' },
                        { Name = "Burger", Value = 'burger' },
                        { Name = "Kit carosserie", Value = 'carokit' },
                        { Name = "Outils carosserie", Value = 'carotool' },
                        { Name = "Jeton", Value = 'chip' },
                        { Name = "Cigarette", Value = 'cigarette' },
                        { Name = "Chargeur", Value = 'clip' },
                        { Name = "Coca", Value = 'coca' },
                        { Name = "Coke", Value = 'coke' },
                        { Name = "Pochon de coke", Value = 'coke_pooch' },
                        { Name = "Défibrillateur", Value = 'defibrillateur' },
                        { Name = "Feuille de coca", Value = 'feuille_coca' },
                        { Name = "Trousse premier secours", Value = 'firstaidkit' },
                        { Name = "Kit réparation", Value = 'fixkit' },
                        { Name = "Outils réparation", Value = 'fixtool' },
                        { Name = "Bouteille de gaz", Value = 'gazbottle' },
                        { Name = "Gitanes", Value = 'gitanes' },
                        { Name = "Grand cru", Value = 'grand_cru' },
                        { Name = "Grappe de raisin", Value = 'grapperaisin' },
                        { Name = "Serre câble", Value = 'handcuff' },
                        { Name = "Glaçon", Value = 'ice' },
                        { Name = "Jägermeister", Value = 'jager' },
                        { Name = "Jägermeister", Value = 'jagerbomb' },
                        { Name = "Jäger Cerbère", Value = 'jagercerbere' },
                        { Name = "Jumelles", Value = 'jumelles' },
                        { Name = "Jus de coca", Value = 'jus_coca' },
                        { Name = "Jus de raisin", Value = 'jus_raisin' },
                        { Name = "Jus de fruits", Value = 'jusfruit' },
                        { Name = "Limonade", Value = 'limonade' },
                        { Name = "Martini blanc", Value = 'martini' },
                        { Name = "Pied de Biche", Value = 'lockpick' },
                        { Name = "Malboro", Value = 'malbora' },
                        { Name = "Viande", Value = 'meat' },
                        { Name = "Medikit", Value = 'medikit' },
                        { Name = "Feuille de menthe", Value = 'menthe' },
                        { Name = "Malboro", Value = 'malbora' },
                        { Name = "Meth", Value = 'meth' },
                        { Name = "Pochon de meth", Value = 'meth_pooch' },
                        { Name = "Mètre de shooter", Value = 'metreshooter' },
                        { Name = "Mix Apéritif", Value = 'mixapero' },
                        { Name = "Mojito", Value = 'mojito' },
                        { Name = "Opium", Value = 'opium' },
                        { Name = "Pochon d'opium", Value = 'opium_pooch' },
                        { Name = "Orange", Value = 'orange' },
                        { Name = "Jus d'orange", Value = 'orange_juice' },
                        { Name = "Masque à Oxygène", Value = 'oxygen_mask' },
                        { Name = "Gazeuse", Value = 'pepperspray' },
                        { Name = "Téléphone", Value = 'phone' },
                        { Name = "GHB", Value = 'piluleoubli' },
                        { Name = "Pomme", Value = 'pomme' },
                        { Name = "Radio", Value = 'radio' },
                        { Name = "Raisin", Value = 'raisin' },
                        { Name = "Redbull", Value = 'redbull' },
                        { Name = "Repairkit", Value = 'repairkit' },
                        { Name = "Rhum", Value = 'rhum' },
                        { Name = "Rhum-Coca", Value = 'rhumcoca' },
                        { Name = "Rhum-Jus de fruits", Value = 'rhumfruit' },
                        { Name = "~abac", Value = 'tabac' },
                        { Name = "Tabac Blond", Value = 'tabacblond' },
                        { Name = "Tabac Blond Séché", Value = 'tabacblondsec' },
                        { Name = "Tabac Brun", Value = 'tabacbrun' },
                        { Name = "Tabac Brun Séché", Value = 'tabacbrunsec' },
                        { Name = "Tarte aux Pommes", Value = 'tarte_pomme' },
                        { Name = "Teq'paf", Value = 'teqpaf' },
                        { Name = "Tequila", Value = 'tequila' },
                        { Name = "Vin", Value = 'vine' },
                        { Name = "Vin Blanc", Value = 'vittvin' },
                        { Name = "Vodka", Value = 'vodka' },
                        { Name = "Vodka-Energy", Value = 'vodkaenergy' },
                        { Name = "Vodka-Jus de fruits", Value = 'vodkafruit' },
                        { Name = "Vodka-Redbull", Value = 'vodkaredbull' },
                        { Name = "Bouteille d'eau", Value = 'water' },
                        { Name = "Weed", Value = 'weed' },
                        { Name = "Pochon de weed", Value = 'weed_pooch' },
                        { Name = "Whisky", Value = 'whisky' },
                        { Name = "Whisky-coca", Value = 'whiskycoca' },
                        { Name = "Jetons", Value = 'zetony' },
                    }, GroupIndexxxxx, "Se donner un item ! ~g~(Entrée pour valider)\n", {}, true, {
                        onListChange = function(Index, Item)
                            GroupIndexxxxx = Index;
                        end,
                        onSelected = function(Index, Item) 
                            _Razzourson("Razzway:GiveItem", Item.Value)
                            ESX.ShowNotification("Vous avez reçu l'item ~o~" .. Item.Name .. "~s~ dans ~o~votre inventaire !")
                        end,
                    })

                    if (ESX.GetPlayerData()['group'] == "superadmin") or (ESX.GetPlayerData()['group'] == "_dev") or (ESX.GetPlayerData()['group'] == "admin") then
                        RageUIRZ.List('Liste ~p~des peds', {
                            { Name = "Beach 01", Value = 'a_f_m_beach_01' },
                            { Name = "Harley Queen", Value = 'Harley' },
                            { Name = "Dealer", Value = 'ig_claypain' },
                            { Name = "Ryan", Value = 'u_m_y_smugmech_01' },
                            { Name = "Clochard", Value = 'u_m_y_militarybum' },
                            { Name = "Cagoule", Value = 'g_m_m_chicold_01' },
                            { Name = "Tonton", Value = 'a_m_y_downtown_01' },
                            { Name = "Fou", Value = 'a_m_m_hillbilly_02' },
                            { Name = "Fou 1", Value = 'a_m_y_jetski_01' },
                            { Name = "Tonton Fou", Value = 'a_m_y_acult_02' },
                            { Name = "Plage", Value = 'a_m_y_beach_03' },
                            { Name = "Singe", Value = 'u_m_m_streetart_01' },
                            { Name = "Emma", Value = 'Ronin' },
                            { Name = "Kirito", Value = 'kirito' },
                            { Name = "Ada", Value = 'Ada' },
                            { Name = "Vagos 1", Value = 'g_m_y_mexgoon_01' },
                            { Name = "Vagos 2", Value = 'g_m_y_mexgoon_02' },
                        }, GroupIndexxxxxPed, "Se changer en ped ! ~g~(Entrée pour valider)\n", {}, true, {
                            onListChange = function(Index, Ped)
                                GroupIndexxxxxPed = Index;
                            end,
                            onSelected = function(Index, Ped) 
                                ESX.Streaming.RequestModel(Ped.Value, function()
                                    SetPlayerModel(PlayerId(), Ped.Value)
                                    SetModelAsNoLongerNeeded(Ped.Value)
                                    _Razzourson("Razzway:LogsPed", Ped.Name)
                                end)
                                --ESX.ShowNotification("Vous avez reçu l'item ~o~" .. Item.Name .. "~s~ dans ~o~votre inventaire !")
                            end,
                        })
                    end

                    if (ESX.GetPlayerData()['group'] == "superadmin") or (ESX.GetPlayerData()['group'] == "_dev") then
                        RageUIRZ.List('Liste ~y~des Armes', {
                            { Name = "Pistolet", Value = 'WEAPON_pistol' },
                            { Name = "Calibre 50", Value = 'WEAPON_pistol50' },
                            { Name = "Pitsolet SNS", Value = 'WEAPON_snspistol' },
                            { Name = "Pistolet Lourd", Value = 'WEAPON_heavypistol' },
                            { Name = "Pistolet Vintage", Value = 'WEAPON_vintagepistol' },
                            { Name = "Pistolet Détresse", Value = 'WEAPON_flaregun' },
                            { Name = "Pistolet Marksman", Value = 'WEAPON_marksmanpistol' },
                            { Name = "Revolver", Value = 'WEAPON_revolver' },
                            { Name = "Double Action", Value = 'WEAPON_doubleaction' },
                            { Name = "Micro SMG", Value = 'WEAPON_microsmg' },
                            { Name = "SMG", Value = 'WEAPON_smg' },
                            { Name = "SMG d'assault", Value = 'WEAPON_assaultsmg' },
                            { Name = "ADP de combat", Value = 'WEAPON_combatpdw' },
                            { Name = "Machine Pistol", Value = 'WEAPON_machinepistol' },
                            { Name = "Mini SMG", Value = 'WEAPON_minismg' },
                            { Name = "Pompe", Value = 'WEAPON_pumpshotgun' },
                            { Name = "Pompe mk2", Value = 'WEAPON_pumpshotgun_mk2' },
                            { Name = "Pompe Canon scié", Value = 'WEAPON_sawnoffshotgun' },
                            { Name = "Pompe d'assault", Value = 'WEAPON_assaultshotgun' },
                            { Name = "Pompe Lourd", Value = 'WEAPON_heavyshotgun' },
                            { Name = "Double Pompe", Value = 'WEAPON_dbshotgun' },
                            { Name = "Pompe Sweeper", Value = 'WEAPON_autoshotgun' },
                            { Name = "Pompe de Combat", Value = 'WEAPON_combatshotgun' },
                            { Name = "Fusil d'assault", Value = 'WEAPON_assaultrifle' },
                            { Name = "Carabine d'assault", Value = 'WEAPON_carbinerifle' },
                            { Name = "Carabine Special", Value = 'WEAPON_specialcarbine' },
                            { Name = "Fusil Bull", Value = 'WEAPON_bullpuprifle' },
                            { Name = "Fusil Compact", Value = 'WEAPON_compactrifle' },
                            { Name = "MG", Value = 'WEAPON_mg' },
                            { Name = "Combat MG", Value = 'WEAPON_combatmg' },
                            { Name = "Gusenberg", Value = 'WEAPON_gusenberg' },
                            { Name = "Fusil de Sniper", Value = 'WEAPON_sniperrifle' },
                            { Name = "Fusil de Sniper Lourd", Value = 'WEAPON_heavysniper' },
                        }, GroupIndexxxxxWeapon, "Se give une arme ! ~g~(Entrée pour valider)\n", {}, true, {
                            onListChange = function(Index, Arme)
                                GroupIndexxxxxWeapon = Index;
                            end,
                            onSelected = function(IndexPed, Arme) 
                                _Razzourson("Razzway:GiveWeapon", Arme.Value)
                                ESX.ShowNotification("Vous avez reçu l'arme ~o~" .. Arme.Name .. "~s~ dans ~o~votre inventaire !")
                                --ESX.ShowNotification("Vous avez reçu l'item ~o~" .. Item.Name .. "~s~ dans ~o~votre inventaire !")
                            end,
                        })
                    end
                end
            end)
        end

        if (Razzway.SelfPlayer.isStaffEnabled) then
            RageUIRZ.IsVisible(vehiculemenu, function()
                RageUIRZ.List('Véhicules', {
                    { Name = "Véhicule personnalisée", Value = nil },
                    { Name = "BMX", Value = 'bmx' },
                    { Name = "Sanchez", Value = 'sanchez' },
                    { Name = "Honda Cb500F", Value = "cb500f" },
                }, VehicleIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        VehicleIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        if Item.Value == nil then
                            local modelName = KeyboardInput('Razzway_BOX_VEHICLE_NAME', "Veuillez entrer le ~y~nom~s~ du véhicule", '', 50)
                            TriggerEvent('Razzway:spawnVehicle', modelName)
                            _Razzourson("Razzway:SendLogs", "Spawn custom vehicle")
                        else
                            TriggerEvent('Razzway:spawnVehicle', Item.Value)
                            _Razzourson("Razzway:SendLogs", "Spawn vehicle")
                        end
                    end,
                })
                RageUIRZ.Button('~g~Réparation~s~ du véhicule', nil, { }, true, {
                    onSelected = function()
                        local plyVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleFixed(plyVeh)
                        SetVehicleDirtLevel(plyVeh, 0.0)
                        ESX.ShowAdvancedNotification('Administration', '~y~Informations', 'Le ~y~véhicule~s~ a été réparé', 'CHAR_KIRITO', 2)
                        _Razzourson("Razzway:SendLogs", "Repair Vehicle")
                    end
                })

                RageUIRZ.Button("~b~Retourner~s~ le véhicule", nil, {RightLabel = ""}, true, {
                    onSelected = function()
                        admin_vehicle_flip()
                    end
                })

                RageUIRZ.List('~r~Suppression~s~ des véhicules (Zone)', {
                    { Name = "1", Value = 1 },
                    { Name = "5", Value = 5 },
                    { Name = "10", Value = 10 },
                    { Name = "15", Value = 15 },
                    { Name = "20", Value = 20 },
                    { Name = "25", Value = 25 },
                    { Name = "30", Value = 30 },
                    { Name = "50", Value = 50 },
                    { Name = "100", Value = 100 },
                }, GroupIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        GroupIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        _Razzourson("Razzway:SendLogs", "Delete vehicle zone")
                        ESX.ShowAdvancedNotification('Administration', '~y~Informations', 'La ~r~suppression~s~ a été effectué', 'CHAR_KIRITO', 2)
                        local playerPed = PlayerPedId()
                        local radius = Item.Value
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
                    end,
                })

                RageUIRZ.Button('~y~Changer~s~ la plaque', nil, {}, true, {
                    onSelected = function()
                        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            local plaqueVehicule = KeyBoardText("Veuillez entrer le ~y~nom~s~ de la plaque", "", 8)
                            SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)
                            ESX.ShowAdvancedNotification('Administration', '~y~Informations', 'Le nom de la plaque est désormais : ~y~' ..plaqueVehicule, 'CHAR_KIRITO', 2)
                        else
                            ESX.ShowAdvancedNotification('Administration', '~y~Informations', '~r~Erreur :~s~ Vous n\'êtes pas dans un véhicule ~y~', 'CHAR_KIRITO', 2)
                        end
                    end
                })

            end)
        end

        if (Razzway.SelfPlayer.isStaffEnabled) then
            RageUIRZ.IsVisible(selectedMenu, function()
                table.sort(Razzway.Players, function(a,b) return a.source < b.source end)
                if (selectedIndex == 1) then
                    if (#Razzway.Players > 0) then

                        for i, v in pairs(Razzway.Players) do
                            local colors = {
                                ["_dev"] = '~r~',
                                ["superadmin"] = '~o~',
                                ["admin"] = '~p~',
                                ["modo"] = '~y~',
                                ["user"] = '',
                            }
                            RageUIRZ.Button(string.format('%s[%s] %s [%s]', colors[v.group], v.source, v.name, v.group), nil, {}, true, {
                                onSelected = function()
                                    playerActionMenu:SetSubtitle(string.format('[%s] %s', i, v.name))
                                    Razzway.SelectedPlayer = v;
                                end
                            }, playerActionMenu)
                        end
                    else
                        RageUIRZ.Separator("Aucun joueur en ligne.")
                    end
                end
                if (selectedIndex == 2) then
                    if (#Razzway.PlayersStaff > 0) then
                        for i, v in pairs(Razzway.PlayersStaff) do
                            local colors = {
                                ["_dev"] = '~r~',
                                ["superadmin"] = '~o~',
                                ["admin"] = '~p~',
                                ["modo"] = '~y~',
                            }
                            RageUIRZ.Button(string.format('%s[%s] %s', colors[v.group], v.source, v.name), nil, {}, true, {
                                onSelected = function()
                                    playerActionMenu:SetSubtitle(string.format('[%s] %s', v.source, v.name))
                                    Razzway.SelectedPlayer = v;
                                end
                            }, playerActionMenu)
                        end
                    else
                        RageUIRZ.Separator("Aucun joueur en ligne.")
                    end
                end

                if (selectedIndex == 3) then
                    --idtosanctionbaby

                    for i, v in pairs(Razzway.Players) do
                        if v.source == idtosanctionbaby then
                            RageUIRZ.Separator("↓ INFORMATION ↓")
                            RageUIRZ.Button('ID : ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUIRZ.Button('Nom : ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUIRZ.Button('Jobs : ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end

                    RageUIRZ.Separator("↓ SANCTION ↓")
                    RageUIRZ.List('Temps de ban', {
                        { Name = "1 Heure", Value = '0.2' },
                        { Name = "12 Heure", Value = '1' },
                        { Name = "1 Semaine", Value = '7' },
                        { Name = "1 Mois", Value = '30' },
                        { Name = "Permanent", Value = '0' },
                    }, GroupIndex, "Pour mettre le temps de ban ! ~g~(Entrée pour valider)\n", {}, true, {
                        onListChange = function(Index, Item)
                            GroupItem = Item;
                            GroupIndex = Index;
                        end,
                    })
                    RageUIRZ.Button('Raison du ban', nil, { RightLabel = raisontosend }, true, {
                        onSelected = function()
                            local Raison = KeyboardInput('Razzway_BOX_BAN_RAISON', "Raison du ban", '', 50)
                            raisontosend = Raison
                        end
                    })

                    RageUIRZ.Button('Valider', nil, { RightLabel = "✅" }, true, {
                        onSelected = function()
                            _Razzourson("Razzway:Ban", idtosanctionbaby, GroupItem.Value, raisontosend)
                        end
                    })
                end

                if (selectedIndex == 4) then
                    for i, v in pairs(Razzway.Players) do
                        if v.source == idtosanctionbaby then
                            RageUIRZ.Separator("↓ INFORMATION ↓")
                            RageUIRZ.Button('ID : ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUIRZ.Button('Nom : ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUIRZ.Button('Jobs : ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end
                    RageUIRZ.Separator("↓ SANCTION ↓")
                    RageUIRZ.Button('Raison du kick', nil, { RightLabel = raisontosend }, true, {
                        onSelected = function()
                            local Raison = KeyboardInput('Razzway_BOX_BAN_RAISON', "Raison du ban", '', 50)
                            raisontosend = Raison
                        end
                    })

                    RageUIRZ.Button('Valider', nil, { RightLabel = "✅" }, true, {
                        onSelected = function()
                            _Razzourson("Razzway:kick", idtosanctionbaby, raisontosend)
                        end
                    })
                end
                if (selectedIndex == 5) then
                    for i, v in pairs(Razzway.Players) do
                        if v.source == idtosanctionbaby then
                            RageUIRZ.Separator("↓ INFORMATION ↓")
                            RageUIRZ.Button('ID : ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUIRZ.Button('Nom : ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUIRZ.Button('Jobs : ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end
                    RageUIRZ.Separator("↓ SANCTION ↓")
                    for i = 1, 200 do 
                        RageUIRZ.Button(i .. ' Minutes', nil, {}, true, {
                            onSelected = function()
                                _Razzourson("Razzway:Jail", idtosanctionbaby, i * 60)
                            end
                        })
                    end
                end
                if (selectedIndex == 6) then
                    for i, v in pairs(Razzway.Players) do
                        if v.source == idtoreport then
                            RageUIRZ.Button('Nom : ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUIRZ.Button('ID : ' .. idtoreport, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUIRZ.Button('Jobs : ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end

                    RageUIRZ.Button('Se Teleporter sur lui', nil, {}, true, {
                        onSelected = function()
                            _Razzourson("Razzway:teleport", idtoreport)
                        end
                    })
                    RageUIRZ.Button('Le Teleporter sur moi', nil, {}, true, {
                        onSelected = function()
                            _Razzourson("Razzway:teleportTo", idtoreport)
                        end
                    })
                    RageUIRZ.Button('Le Teleporter au Parking Central', nil, {}, true, {
                        onSelected = function()
                            _Razzourson('Razzway:teleportcoords', idtoreport, vector3(215.76, -810.12, 30.73))
                        end
                    })

                    RageUIRZ.Button('Le Revive', nil, {}, true, {
                        onSelected = function()
                            _Razzourson("Razzway:Revive", idtoreport)
                        end
                    })

                    RageUIRZ.Button('~g~Report Effectué', nil, { }, true, {
                        onSelected = function()
                            _Razzourson("Razzway:ReportRegle", kvdureport)
                            TriggerEvent("Razzway:RefreshReport")
                        end
                    }, reportmenu)
                end
            end)

            RageUIRZ.IsVisible(playerActionMenu, function()

                if specateactive then
                    gang = "✅"
                end
                RageUIRZ.Button("Spectate", nil, { RightLabel = gang }, true, { 
                    onSelected = function()
                        spectate(Razzway.SelectedPlayer.source)
                    end 
                })
                RageUIRZ.Button('Vous téléporter sur lui', nil, {}, true, {
                    onSelected = function()
                        _Razzourson('Razzway:teleport', Razzway.SelectedPlayer.source)
                    end
                })
                RageUIRZ.Button('Téléporter vers vous', nil, {}, true, {
                    onSelected = function()
                        _Razzourson('Razzway:teleportTo', Razzway.SelectedPlayer.source)
                    end
                })

                RageUIRZ.Button('Le téléporter au Parking Central', nil, {}, true, {
                    onSelected = function()
                        _Razzourson('Razzway:teleportcoords', Razzway.SelectedPlayer.source, vector3(215.76, -810.12, 30.73))
                    end
                })

                RageUIRZ.Button("Voir l'inventaire", nil, {  }, true, {
                    onSelected = function()
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
    
                        end, tonumber(Razzway.SelectedPlayer.source))
                    end
                }, inventoryMenu)

                RageUIRZ.Button('Bannir le joueur', nil, {}, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Bannir le joueur'))
                        idtosanctionbaby = Razzway.SelectedPlayer.source
                        selectedIndex = 3;
                    end
                }, selectedMenu)

                RageUIRZ.Button('Kick le joueur', nil, {}, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Kick le joueur'))
                        idtosanctionbaby = Razzway.SelectedPlayer.source
                        selectedIndex = 4;
                    end
                }, selectedMenu)

                RageUIRZ.Button('Mettre en Prison', nil, {}, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Jail le joueur'))
                        idtosanctionbaby = Razzway.SelectedPlayer.source
                        selectedIndex = 5;
                    end
                }, selectedMenu)
                RageUIRZ.Button('Retirer de Prison', nil, {}, true, {
                    onSelected = function()
                        _Razzourson("Razzway:SendLogs", "Unjail Players !")
                        _Razzourson('::{razzway.xyz}::esx_jail:unjail', Razzway.SelectedPlayer.source)
                    end
                })

                RageUIRZ.Button("Wipe l'inventaire du Joueur", nil, {RightLabel = nil}, true, {
                    onSelected = function()
                        ExecuteCommand("clearinventory "..Razzway.SelectedPlayer.source)
                    ESX.ShowAdvancedNotification("Administration", "~y~Informations", "Vous venez de WIPE les items de ~b~".. GetPlayerName(GetPlayerFromServerId(Razzway.SelectedPlayer.source)) .."~s~ !", "CHAR_KIRITO", 1) 																
                    end
                })

                RageUIRZ.Button("Wipe les Armes du Joueur", "", {RightLabel = nil}, true, {
                    onSelected = function()
                        ExecuteCommand("clearloadout "..Razzway.SelectedPlayer.source)
                    ESX.ShowAdvancedNotification("Administration", "~y~Informations", "Vous venez de WIPE les armes de ~b~".. GetPlayerName(GetPlayerFromServerId(Razzway.SelectedPlayer.source)) .."~s~ !", "CHAR_KIRITO", 1) 								
                    end
                })

                RageUIRZ.Button('Send Private Message', nil, {}, true, {
                    onSelected = function()
                        local msg = KeyboardInput('Razzway_BOX_BAN_RAISON', "Message Privée", '', 50)
                        
                        if msg ~= nil then
                            msg = tostring(msg)
                    
                            if type(msg) == 'string' then
                                _Razzourson("Razzway:Message", Razzway.SelectedPlayer.source, msg)
                            end
                        end
                        ESX.ShowNotification("Vous venez d'envoyer le message à ~y~" .. GetPlayerName(GetPlayerFromServerId(Razzway.SelectedPlayer.source)))
                    end
                })
            end)
            RageUIRZ.IsVisible(reportmenu, function()
                for i, v in pairs(Razzway.GetReport) do
                    if i == 0 then
                        return
                    end
                    RageUIRZ.Button("[" .. v.id .. "] " .. v.name, "ID : " .. v.id .. "\n" .. "Name : " .. v.name .. "\nRaison : " .. v.reason, {}, true, {
                        onSelected = function()
                            selectedMenu:SetSubtitle(string.format('Report'))
                            kvdureport = i
                            idtoreport = v.id
                            selectedIndex = 6;
                        end
                    }, selectedMenu)
                end
            end)
        end
        for i, onTick in pairs(Razzway.Menus) do
            onTick();
        end
    end
    Citizen.Wait(500)
end)

local function getEntity(player)
    -- function To Get Entity Player Is Aiming At
    local _, entity = GetEntityPlayerIsFreeAimingAt(player)
    return entity
end

local function aimCheck(player)
    -- function to check config value onAim. If it's off, then
    return IsPedShooting(player)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if (Razzway.SelfPlayer.isStaffEnabled) then
            if (Razzway.SelfPlayer.isDelgunEnabled) then
                if IsPlayerFreeAiming(PlayerId()) then
                    local entity = getEntity(PlayerId())
                    if GetEntityType(entity) == 2 or 3 then
                        if aimCheck(GetPlayerPed(-1)) then
                            SetEntityAsMissionEntity(entity, true, true)
                            DeleteEntity(entity)
                        end
                    end
                end
            end

            --if (Razzway.SelfPlayer.isStaffEnabled) then
                if (Razzway.SelfPlayer.ShowCoords) then
                    plyPed = PlayerPedId()
                    local plyCoords = GetEntityCoords(plyPed, false)
                    Text('~r~X~s~: ' .. ESX.Math.Round(plyCoords.x, 2) .. '\n~y~Y~s~: ' .. ESX.Math.Round(plyCoords.y, 2) .. '\n~g~Z~s~: ' .. ESX.Math.Round(plyCoords.z, 2) .. '\n~y~Angle~s~: ' .. ESX.Math.Round(GetEntityPhysicsHeading(plyPed), 2))
                end
            --end

            function Text(text)
                SetTextColour(186, 186, 186, 255)
                SetTextFont(0)
                SetTextScale(0.378, 0.378)
                SetTextWrap(0.0, 1.0)
                SetTextCentre(false)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 205)
                BeginTextCommandDisplayText('STRING')
                AddTextComponentSubstringPlayerName(text)
                EndTextCommandDisplayText(0.5, 0.03)
            end

            if (Razzway.SelfPlayer.isClipping) then
                --HideHudAndRadarThisFrame()

                local camCoords = GetCamCoord(NoClip.Camera)
                local right, forward, _, _ = GetCamMatrix(NoClip.Camera)
                if IsControlPressed(0, 32) then
                    local newCamPos = camCoords + forward * NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 8) then
                    local newCamPos = camCoords + forward * -NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 34) then
                    local newCamPos = camCoords + right * -NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 9) then
                    local newCamPos = camCoords + right * NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 334) then
                    if (NoClip.Speed - 0.1 >= 0.1) then
                        NoClip.Speed = NoClip.Speed - 0.1
                    end
                end
                if IsControlPressed(0, 335) then
                    if (NoClip.Speed + 0.1 >= 0.1) then
                        NoClip.Speed = NoClip.Speed + 0.1
                    end
                end

                SetEntityCoords(Razzway.SelfPlayer.ped, camCoords.x, camCoords.y, camCoords.z)

                local xMagnitude = GetDisabledControlNormal(0, 1)
                local yMagnitude = GetDisabledControlNormal(0, 2)
                local camRot = GetCamRot(NoClip.Camera)
                local x = camRot.x - yMagnitude * 10
                local y = camRot.y
                local z = camRot.z - xMagnitude * 10
                if x < -75.0 then
                    x = -75.0
                end
                if x > 100.0 then
                    x = 100.0
                end
                SetCamRot(NoClip.Camera, x, y, z)
            end

            if (Razzway.SelfPlayer.isGamerTagEnabled) then
                for i, v in pairs(ESX.StreamingrTags) do
                    local target = GetEntityCoords(v.ped, false);

                    if #(target - GetEntityCoords(PlayerPedId())) < 120 then
                        SetMpGamerTagVisibility(v.tags, 0, true)
                        SetMpGamerTagVisibility(v.tags, 2, true)

                        SetMpGamerTagVisibility(v.tags, 4, NetworkIsPlayerTalking(v.player))
                        SetMpGamerTagAlpha(v.tags, 2, 255)
                        SetMpGamerTagAlpha(v.tags, 4, 255)

                        local colors = {
                            ["_dev"] = 10,
                            ["superadmin"] = 25,
                            ["admin"] = 18,
                            ["modo"] = 18,
                        }
                        SetMpGamerTagColour(v.tags, 0, colors[v.group] or 0)
                    else
                        RemoveMpGamerTag(v.tags)
                        ESX.StreamingrTags[i] = nil;
                    end
                end


            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Razzway.SelfPlayer.ped = GetPlayerPed(-1);
        if (Razzway.SelfPlayer.isStaffEnabled) then
            if (Razzway.SelfPlayer.isGamerTagEnabled) then
                Razzway.Helper:OnRequestGamerTags();
            end
        end

        Citizen.Wait(1000)
    end
end)


RegisterNetEvent('Razzway:teleport')
AddEventHandler('Razzway:teleport', function(coords)
    if (Razzway.SelfPlayer.isClipping) then
        SetCamCoord(NoClip.Camera, coords.x, coords.y, coords.z)
        SetEntityCoords(Razzway.SelfPlayer.ped, coords.x, coords.y, coords.z)
    else
        ESX.Game.Teleport(PlayerPedId(), coords)
    end
end)

RegisterNetEvent('Razzway:spawnVehicle')
AddEventHandler('Razzway:spawnVehicle', function(model)
    if (Razzway.SelfPlayer.isStaffEnabled) then
        model = (type(model) == 'number' and model or GetHashKey(model))

        if IsModelInCdimage(model) then
            local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed)

            ESX.Game.SpawnVehicle(model, plyCoords, 90.0, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end)
        else
            ESX.ShowNotification('Invalid vehicle model.', 5000)
        end
    end
end)

local disPlayerNames = 5
local playerDistances = {}

local function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0 * scale, 0.55 * scale)
        else
            SetTextScale(0.0 * scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    Wait(500)
    while true do
        if (Razzway.SelfPlayer.isGamerTagEnabled) then
            for _, id in ipairs(GetActivePlayers()) do
                local serverId = GetPlayerServerId(id)
                local CCS = {
                    ["_dev"] = "~r~",
                    ["superadmin"] = "~y~",
                    ["admin"] = "~q~",
                    ["modo"] = "~p~",
                    ["user"] = "",
                }
                local formatted = nil;
                if group == '_dev' then
                    formatted = string.format('~h~~u~[Fondateur] ~w~%s~w~', GetPlayerName(id))
                end
                if playerDistances[id] then
                    if (playerDistances[id] < disPlayerNames) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                        if NetworkIsPlayerTalking(id) then
                            DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(id), 247, 124, 24)
                            DrawMarker(1, x2, y2, z2 - 0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 6, 255, 92, 100, 0, 0, 0, 0)
                        else
                            DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(id), 255, 255, 255)
                        end
                    elseif (playerDistances[id] < 25) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                        if NetworkIsPlayerTalking(id) then
                            DrawMarker(1, x2, y2, z2 - 0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001,  6, 255, 92, 100, 0, 0, 0, 0)
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function refreshFouilleStaff(thePlayer)
	ESX.TriggerServerCallback('::{razzway.xyz}::staff:getOtherPlayerData', function(data)
		fouilleElements = {}

		for i = 1, #data.accounts, 1 do
			if data.accounts[i].name == 'dirtycash' and data.accounts[i].money > 0 then
				table.insert(fouilleElements, {
					label = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value = 'dirtycash',
					itemType = 'item_account',
					amount = data.accounts[i].money
				})

				break
			end
		end

		table.insert(fouilleElements, {
			label = _U('inventory_label'),
			value = nil
		})

		for i = 1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(fouilleElements, {
					label = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value = data.inventory[i].name,
					itemType = 'item_standard',
					amount = data.inventory[i].count
				})
			end
		end

		table.insert(fouilleElements, {
			label = _U('guns_label'),
			value = nil
		})

		for i = 1, #data.weapons, 1 do
			table.insert(fouilleElements, {
				label = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value = data.weapons[i].name,
				itemType = 'item_weapon',
				amount = data.weapons[i].ammo
			})
		end
	end, GetPlayerServerId(thePlayer))
end

