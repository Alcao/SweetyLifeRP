local isMenuOpened, cat = false, "astrastaff"
local prefix = "~r~[Astra]~s~"
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local alphaFilter = false
local creditsSent = false


local hideTakenReports = false

local function subCat(name)
    return cat .. name
end

local function msg(string)
    ESX.ShowNotification(string)
end

local function colorByState(bool)
    if bool then
        return "~g~"
    else
        return "~s~"
    end
end

local function statsSeparator()
    RageUI.Separator("Connectés : ~b~" .. connecteds .. " ~b~|~s~ Staff en ligne : ~y~" .. staff)
end

local function generateTakenBy(reportID)
    if localReportsTable[reportID].taken then
        return "~s~ | Pris (~o~" .. localReportsTable[reportID].takenBy .."~s~)"
    else
        return ""
    end
end

function RequestPtfx(assetName)
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

local WeaponGive = {
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

local MoneyGive = {
    action = {
        '~g~Propre~s~',
        '~b~Banque~s~',
        '~r~Sale~s~',
    },
    list = 1
}

local PedsChanges = {
    action = {
        'Mon personnage',
        'Dealer',
        'Singe',
        'Tonton',
    },
    list = 1
}


local ranksRelative = {
    ["user"] = 1,
    ["admin"] = 2,
    ["superadmin"] = 3,
    ["_dev"] = 4
}

local ranksInfos = {
    [1] = { label = "Joueur", rank = "user" },
    [2] = { label = "Admin", rank = "admin" },
    [3] = { label = "Super Admin", rank = "superadmin" },
    [4] = { label = "Propriétaire", rank = "_dev" }
}

local function getRankDisplay(rank)
    local ranks = {
        ["_dev"] = "~o~[Propriétaire] ~s~",
        ["superadmin"] = "~y~[S.Admin] ~s~",
        ["admin"] = "~p~[Admin] ~s~",
    }
    return ranks[rank] or ""
end

local function getIsTakenDisplay(bool)
    if bool then
        return ""
    else
        return "~r~[EN ATTENTE]~s~ "
    end
end

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function openAdministrationMenu()
    if menuOpen then
        return
    end
    if permLevel == "user" then
        ESX.ShowNotification("~r~Vous n'avez pas accès à ce menu.")
        return
    end
    local selectedColor = 1
    local cVarLongC = { "~p~", "~r~", "~o~", "~y~", "~c~", "~g~", "~b~" }
    local cVar1, cVar2 = "~y~", "~r~"
    local cVarLong = function()
        return cVarLongC[selectedColor]
    end
    menuOpen = true

    RMenu.Add(cat, subCat("main"), RageUI.CreateMenu("Management", "~b~Management du serveur", 1100))
    RMenu:Get(cat, subCat("main")).Closed = function()
    end

    RMenu.Add(cat, subCat("players"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "Management", "~b~Management du serveur", nil, nil, "menutoutbo", "interaction_bgd"))
    RMenu:Get(cat, subCat("players")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "Management", "~b~Management du serveur", nil, nil, "menutoutbo", "interaction_bgd"))
    RMenu:Get(cat, subCat("reports")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports_take"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("reports")), "Management", "~b~Management du serveur", nil, nil, "menutoutbo", "interaction_bgd"))
    RMenu:Get(cat, subCat("reports_take")).Closed = function()
    end

    RMenu.Add(cat, subCat("playersManage"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("players")), "Management", "~b~Management du serveur", nil, nil, "menutoutbo", "interaction_bgd"))
    RMenu:Get(cat, subCat("playersManage")).Closed = function()
    end

    RMenu.Add(cat, subCat("setGroup"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "Management", "~b~Management du serveur", nil, nil, "menutoutbo", "interaction_bgd"))
    RMenu:Get(cat, subCat("setGroup")).Closed = function()
    end

    RMenu.Add(cat, subCat("items"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "Management", "~b~Management du serveur", nil, nil, "menutoutbo", "interaction_bgd"))
    RMenu:Get(cat, subCat("items")).Closed = function()
    end

    RMenu.Add(cat, subCat("vehicle"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "Management", "~b~Management du serveur", nil, nil, "menutoutbo", "interaction_bgd"))
    RMenu:Get(cat, subCat("vehicle")).Closed = function()
    end

    RMenu.Add(cat, subCat("cardinal"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "Management", "~b~Management du serveur", nil, nil, "menutoutbo", "interaction_bgd"))
    RMenu:Get(cat, subCat("cardinal")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, subCat("main")), true)
    Citizen.CreateThread(function()
        while menuOpen do
            Wait(800)
            if cVar1 == "~y~" then
                cVar1 = "~o~"
            else
                cVar1 = "~y~"
            end
            if cVar2 == "~r~" then
                cVar2 = "~s~"
            else
                cVar2 = "~r~"
            end
        end
    end)
    Citizen.CreateThread(function()
        while menuOpen do
            Wait(250)
            selectedColor = selectedColor + 1
            if selectedColor > #cVarLongC then
                selectedColor = 1
            end
        end
    end)
    Citizen.CreateThread(function()
        while menuOpen do
            local shouldStayOpened = false
            RageUI.IsVisible(RMenu:Get(cat, subCat("main")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()

                RageUI.Checkbox(colorByState(service) .. "Prendre son service", nil, service, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    service = Checked;
                end, function()
                    TriggerServerEvent("astra_staff:setStaffState", true)
                end, function()
                    TriggerServerEvent("astra_staff:setStaffState", false)
                end)

                if isStaffMode then

                    RageUI.ButtonWithStyle("Joueurs en ligne", nil, { RightLabel = "" .. connecteds .."" }, true, function()
                    end, RMenu:Get(cat, subCat("players")))
                    RageUI.ButtonWithStyle("Staff en service", nil, { RightLabel = "" .. staff .."" }, true, function(h,a,s)
                        if s then
                        end
                    end)
                    RageUI.ButtonWithStyle("Report en attente", nil, { RightLabel = "" .. reportCount .. "" }, isStaffMode, function(_, _, s)
                    end, RMenu:Get(cat, subCat("reports")))
                    RageUI.Checkbox(colorByState(isNoClip) .. "Caméra Libre", nil, isNoClip, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        isNoClip = Checked;
                    end, function()
                        NoClip(true)
                    end, function()
                        NoClip(false)
                    end)
                    -- TODO -> Faire avec les DecorSetInt le grade du joueur et faire les couleurs avec les mpGamerTag
                    RageUI.Checkbox(colorByState(isNameShown) .. "Affichage des noms", nil, isNameShown, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        isNameShown = Checked;
                    end, function()
                        showNames(true)
                    end, function()
                        showNames(false)
                    end)
                    RageUI.ButtonWithStyle("Gestion véhicules", nil, { RightLabel = "→→" }, true, function()
                    end, RMenu:Get(cat, subCat("vehicle")))
                    RageUI.ButtonWithStyle("La Suprémacie", nil, { RightLabel = "→→", Color = {BackgroundColor = { 255, 180, 0, 160 }} }, true, function()
                    end, RMenu:Get(cat, subCat("cardinal")))

                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("players")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Checkbox("→ " .. colorByState(showAreaPlayers) .. "Restreindre à ma zone", nil, showAreaPlayers, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    showAreaPlayers = Checked;
                end, function()
                end, function()
                end)

                RageUI.Checkbox("→ " .. colorByState(showAreaPlayers) .. "Filtre alphabétique", nil, alphaFilter, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    alphaFilter = Checked;
                end, function()
                end, function()
                end)

                if alphaFilter then
                    RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                        filter = i
                    end)
                end

                RageUI.Separator("↓ ~g~Joueurs ~s~↓")
                if not showAreaPlayers then
                    for source, player in pairs(localPlayers) do
                        if alphaFilter then
                            if starts(player.name:lower(), filterArray[filter]:lower()) then
                                RageUI.ButtonWithStyle(getRankDisplay(player.rank) .. "~s~[~o~" .. source .. "~s~] " .. "→ ~s~" .. player.name or "<Pseudo invalide>" .. " (~b~" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[player.rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                    if s then
                                        selectedPlayer = source
                                    end
                                end, RMenu:Get(cat, subCat("playersManage")))
                            end
                        else
                            RageUI.ButtonWithStyle(getRankDisplay(player.rank) .. "~s~[~o~" .. source .. "~s~] " .. "→ ~s~" .. player.name or "<Pseudo invalide>" .. " (~b~" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[player.rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                if s then
                                    selectedPlayer = source
                                end
                            end, RMenu:Get(cat, subCat("playersManage")))
                        end
                    end
                else
                    for _, player in ipairs(GetActivePlayers()) do
                        local sID = GetPlayerServerId(player)
                        if localPlayers[sID] ~= nil then
                            if alphaFilter then
                                if starts(localPlayers[sID].name:lower(), filterArray[filter]:lower()) then
                                    RageUI.ButtonWithStyle(getRankDisplay(localPlayers[sID].rank) .. "~s~[~o~" .. sID .. "~s~] " .. "→ ~s~" .. localPlayers[sID].name or "<Pseudo invalide>" .. " (~b~" .. localPlayers[sID].timePlayed[2] .. "h " .. localPlayers[sID].timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[localPlayers[sID].rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                        if s then
                                            selectedPlayer = sID
                                        end
                                    end, RMenu:Get(cat, subCat("playersManage")))
                                end
                            else
                                RageUI.ButtonWithStyle(getRankDisplay(localPlayers[sID].rank) .. "~s~[~o~" .. sID .. "~s~] " .. "→ ~s~" .. localPlayers[sID].name or "<Pseudo invalide>" .. " (~b~" .. localPlayers[sID].timePlayed[2] .. "h " .. localPlayers[sID].timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[localPlayers[sID].rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                    if s then
                                        selectedPlayer = sID
                                    end
                                end, RMenu:Get(cat, subCat("playersManage")))
                            end
                        end
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports")), true, true, true, function()
                shouldStayOpened = true
                RageUI.Checkbox(colorByState(hideTakenReports) .. "Masquer les report pris en charge", nil, hideTakenReports, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    hideTakenReports = Checked;
                end, function()
                end, function()
                end)
                RageUI.Separator("↓  ~y~Liste des Reports~s~  ↓")
                for sender, infos in pairs(localReportsTable) do
                    if infos.taken then
                        if hideTakenReports == false then
                            RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. "- ~s~" .. infos.name, "~g~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason .. "~n~~o~Pris en charge par~s~: " .. infos.takenBy, { RightLabel = "→→" }, true, function(_, _, s)
                                if s then
                                    selectedReport = sender
                                end
                            end, RMenu:Get(cat, subCat("reports_take")))
                        end
                    else
                        RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. "→ ~s~" .. infos.name, "~g~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                            if s then
                                selectedReport = sender
                            end
                        end, RMenu:Get(cat, subCat("reports_take")))
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports_take")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                if localReportsTable[selectedReport] ~= nil then
                    RageUI.Separator("Report: ~b~#" .. localReportsTable[selectedReport].uniqueId .. " ~s~| ID : ~y~" .. selectedReport .. generateTakenBy(selectedReport))
                    RageUI.Separator("↓ ~g~Actions sur le report ~s~↓")
                    local infos = localReportsTable[selectedReport]
                    if not localReportsTable[selectedReport].taken then
                        RageUI.ButtonWithStyle("→ ~s~Prendre en charge ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                            if s then
                                TriggerServerEvent("astra_staff:takeReport", selectedReport)
                            end
                        end)
                    end
                    RageUI.ButtonWithStyle("→ ~s~Cloturer ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:closeReport", selectedReport)
                        end
                    end)
                    RageUI.Separator("↓ ~y~Actions rapides ~s~↓")
                    RageUI.ButtonWithStyle("→ ~s~Revive", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Revive du joueur en cours...")
                            TriggerServerEvent("astra_staff:revive", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle("→ ~s~Soigner", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Heal du joueur en cours...")
                            TriggerServerEvent("astra_staff:heal", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle("→ ~s~TP sur lui", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:goto", selectedReport)
                        end
                    end)
                    RageUI.ButtonWithStyle("→ ~s~TP sur moi", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:bring", selectedReport, GetEntityCoords(PlayerPedId()))
                        end
                    end)

                    RageUI.ButtonWithStyle("→ ~s~TP Parking Central", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("tppc", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Téléportation du joueur en cours...")
                            TriggerServerEvent("astra_staff:tppc", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle("→ ~y~Actions avancées", "~y~Description~s~: " .. infos.reason.."~n~~r~Attention~s~: Cette action vous fera changer de menu", { RightLabel = "→→" }, GetPlayerServerId(PlayerId()) ~= selectedReport, function(_, _, s)
                        if s then
                            selectedPlayer = selectedReport
                        end
                    end,RMenu:Get(cat,subCat("playersManage")))
                else
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce report n'est plus valide")
                    RageUI.Separator("")
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("playersManage")), true, true, true, function()
                shouldStayOpened = true
                if not localPlayers[selectedPlayer] then
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce joueur n'est plus connecté !")
                    RageUI.Separator("")
                else
                    RageUI.ButtonWithStyle("→ ~s~Joueur : ~b~" .. localPlayers[selectedPlayer].name .. " ~s~[~y~ " .. selectedPlayer .. " ~s~]", nil, {}, true, function(_, _, s)
                        if s then
                        end
                    end)
                    RageUI.Separator("~b~↓↓~s~ ~y~Liste des actions disponibles ~b~↓↓~s~")
                    RageUI.ButtonWithStyle("S'y téléporter", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:goto", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle("Téléporter sur moi", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:bring", selectedPlayer, GetEntityCoords(PlayerPedId()))
                        end
                    end)
                    RageUI.ButtonWithStyle("Message", nil, { RightLabel = "→→" }, canUse("mess", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Message", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Envoie du message en cours...")
                                TriggerServerEvent("astra_staff:message", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle("Kick", nil, { RightLabel = "→→" }, canUse("kick", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Raison", "", 80, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Application de la sanction en cours...")
                                TriggerServerEvent("astra_staff:kick", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle("Bannir", nil, { RightLabel = "→→" }, canUse("ban", permLevel), function(_, _, s)
                        if s then
                            local days = input("Durée du banissement (en heures)", "", 20, true)
                            if days ~= nil then
                                local reason = input("Raison", "", 80, false)
                                if reason ~= nil then
                                    ESX.ShowNotification("~y~Application de la sanction en cours...")
                                    ExecuteCommand(("sqlban %s %s %s"):format(selectedPlayer, days, reason))
                                end
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle("Changer le groupe", nil, { RightLabel = "→→" }, canUse("setGroup", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("setGroup")))

                    RageUI.ButtonWithStyle("Revive", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Revive du joueur en cours...")
                            TriggerServerEvent("astra_staff:revive", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle("Soigner", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Heal du joueur en cours...")
                            TriggerServerEvent("astra_staff:heal", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle("Donner un véhicule", nil, { RightLabel = "→→" }, canUse("vehicles", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            local veh = CustomString()
                            if veh ~= nil then
                                local model = GetHashKey(veh)
                                if IsModelValid(model) then
                                    RequestModel(model)
                                    while not HasModelLoaded(model) do
                                        Wait(1)
                                    end
                                    TriggerServerEvent("astra_staff:spawnVehicle", model, selectedPlayer)
                                else
                                    msg("Ce modèle n'existe pas")
                                end
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Wipe l'inventaire", nil, { RightLabel = "→→" }, canUse("clearInventory", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Suppression de l'inventaire du joueur en cours...")
                            TriggerServerEvent("astra_staff:clearInv", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle("Wipe les armes", nil, { RightLabel = "→→" }, canUse("clearLoadout", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Suppression des armes du joueur en cours...")
                            TriggerServerEvent("astra_staff:clearLoadout", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle("Give un item", nil, { RightLabel = "→→" }, canUse("give", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("items")))

                    RageUI.ButtonWithStyle("Give de l'argent [ ~g~Liquide~s~ ]", nil, { RightLabel = "→→" }, canUse("giveMoney", permLevel), function(_, _, s)
                        if s then
                            local qty = input("Quantité", "", 20, true)
                            if qty ~= nil then
                                ESX.ShowNotification("~y~Don de l'argent au joueur...")
                                TriggerServerEvent("astra_staff:addMoney", selectedPlayer, qty)
                            end
                        end
                    end)

                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("items")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                    filter = i
                end)
                RageUI.Separator("↓ ~g~Items disponibles ~s~↓")
                for id, itemInfos in pairs(items) do
                    if starts(itemInfos.label:lower(), filterArray[filter]:lower()) then
                        RageUI.ButtonWithStyle("→ ~s~" .. itemInfos.label, nil, { RightLabel = "~b~Donner ~s~→→" }, true, function(_, _, s)
                            if s then
                                local qty = input("Quantité", "", 20, true)
                                if qty ~= nil then
                                    ESX.ShowNotification("~y~Give de l'item...")
                                    TriggerServerEvent("astra_staff:give", selectedPlayer, itemInfos.name, qty)
                                end
                            end
                        end)
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("setGroup")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                RageUI.Separator("↓ ~g~Rangs disponibles ~s~↓")
                for i = 1, #ranksInfos do
                    RageUI.ButtonWithStyle("→ ~s~" .. ranksInfos[i].label, nil, { RightLabel = "~b~Attribuer ~s~→→" }, ranksRelative[permLevel] > i, function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Application du rang...")
                            TriggerServerEvent("astra_staff:setGroup", selectedPlayer, ranksInfos[i].rank)
                        end
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("vehicle")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.ButtonWithStyle("Spawn un véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local veh = CustomString()
                        if veh ~= nil then
                            local model = GetHashKey(veh)
                            if IsModelValid(model) then
                                RequestModel(model)
                                while not HasModelLoaded(model) do
                                    Wait(1)
                                end
                                TriggerServerEvent("astra_staff:spawnVehicle", model)
                            else
                                msg("~r~Le modèle est invalide")
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Réparer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                        NetworkRequestControlOfEntity(veh)
                        while not NetworkHasControlOfEntity(veh) do
                            Wait(1)
                        end
                        SetVehicleFixed(veh)
                        SetVehicleDeformationFixed(veh)
                        SetVehicleDirtLevel(veh, 0.0)
                        SetVehicleEngineHealth(veh, 1000.0)
                        ESX.ShowNotification("~g~Véhicule réparé")
                    end
                end)
                RageUI.ButtonWithStyle("Supprimer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        Citizen.CreateThread(function()
                            local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                            NetworkRequestControlOfEntity(veh)
                            while not NetworkHasControlOfEntity(veh) do
                                Wait(1)
                            end
                            DeleteEntity(veh)
                            ESX.ShowNotification("~g~Véhicule supprimé")
                        end)
                    end
                end)

                RageUI.ButtonWithStyle("Upgrade le véhicule au max", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                        NetworkRequestControlOfEntity(veh)
                        while not NetworkHasControlOfEntity(veh) do
                            Wait(1)
                        end
                        ESX.Game.SetVehicleProperties(veh, {
                            modEngine = 3,
                            modBrakes = 3,
                            modTransmission = 3,
                            modSuspension = 3,
                            modTurbo = true
                        })
                        ESX.ShowNotification("~g~Les performances du véhicule ont été upgrade avec succès.")
                    end
                end)

                RageUI.ButtonWithStyle("Changer la plaque", nil, {RightLabel = "→→"}, true, function(h,a,s)
                    if s then
                        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            local plaqueVehicule = input("Veuillez entrer le ~y~nom~s~ de la plaque", "", 8)
                            SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)
                            ESX.ShowAdvancedNotification('Administration', '~y~Informations', 'Le nom de la plaque est désormais : ~y~' ..plaqueVehicule, 'CHAR_KIRITO', 2)
                        else
                            ESX.ShowAdvancedNotification('Administration', '~y~Informations', '~r~Erreur :~s~ Vous n\'êtes pas dans un véhicule ~y~', 'CHAR_KIRITO', 2)
                        end
                    end
                end)

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("cardinal")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.ButtonWithStyle("Spawn un véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local veh = CustomString()
                        if veh ~= nil then
                            local model = GetHashKey(veh)
                            if IsModelValid(model) then
                                RequestModel(model)
                                while not HasModelLoaded(model) do
                                    Wait(1)
                                end
                                TriggerServerEvent("astra_staff:spawnVehicle", model)
                            else
                                msg("~r~Le modèle est invalide")
                            end
                        end
                    end
                end)
                RageUI.List('Argent', MoneyGive.action, MoneyGive.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        if Index == 1 then
                            local qty = input("Quantité", "", 20, true)
                            if qty ~= nil then
                                TriggerServerEvent("Razzway:GiveMoney", "cash", qty)
                                ESX.ShowNotification("Give de ~g~"..qty.." $")
                            end
                    elseif Index == 2 then
                        local qty = input("Quantité", "", 20, true)
                        if qty ~= nil then
                            TriggerServerEvent("Razzway:GiveMoney", "bank", qty)
                            ESX.ShowNotification("Give de ~b~"..qty.." $")
                        end
                    elseif Index == 3 then
                        local qty = input("Quantité", "", 20, true)
                        if qty ~= nil then
                            TriggerServerEvent("Razzway:GiveMoney", "dirtycash", qty)
                            ESX.ShowNotification("Give de ~r~"..qty.." $")
                        end
                    end
                end
                   MoneyGive.list = Index;              
                end)
                RageUI.List('Armes', WeaponGive.action, WeaponGive.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        if Index == 1 then
                            TriggerServerEvent('rz-admin:weapon', "weapon_pistol", 250)
                    elseif Index == 2 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_pistol50", 250)
                    elseif Index == 3 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_heavypistol", 250)
                    elseif Index == 4 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_vintagepistol", 250)
                    elseif Index == 5 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_flaregun", 250)
                    elseif Index == 6 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_revolver", 250)
                    elseif Index == 7 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_doubleaction", 250)
                    elseif Index == 8 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_microsmg", 250)
                    elseif Index == 9 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_smg", 250)
                    elseif Index == 10 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_assaultsmg", 250)
                    elseif Index == 11 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_combatpdw", 250)
                    elseif Index == 12 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_machinepistol", 250)
                    elseif Index == 13 then
                        TriggerServerEvent('rz-admin:weapon', "minismg", 250)
                    elseif Index == 14 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_pumpshotgun", 250)
                    elseif Index == 15 then
                        TriggerServerEvent('rz-admin:weapon', "weapon_carbinerifle", 250)
                    end
                end
                   WeaponGive.list = Index;              
                end)
                RageUI.List('Peds', PedsChanges.action, PedsChanges.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        if Index == 1 then
                            ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin, jobSkin)
                                local isMale = skin.sex == 0
                                TriggerEvent('::{razzway.xyz}::skinchanger:loadDefaultModel', isMale, function()
                                    ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin)
                                        TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin)
                                        TriggerEvent('::{razzway.xyz}::esx:restoreLoadout')
                                    end)
                                end)
                            end)
                    elseif Index == 2 then
                        local coords = GetEntityCoords(GetPlayerPed(-1))
                        RequestPtfx('scr_rcbarry1')
                        UseParticleFxAsset('scr_rcbarry1')
                        StartNetworkedParticleFxNonLoopedAtCoord('scr_alien_teleport', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)
                        ESX.Streaming.RequestModel("ig_claypain", function()
                            SetPlayerModel(PlayerId(), "ig_claypain")
                            SetModelAsNoLongerNeeded("ig_claypain")
                        end)
                    elseif Index == 3 then
                        local coords = GetEntityCoords(GetPlayerPed(-1))
                        RequestPtfx('scr_rcbarry1')
                        UseParticleFxAsset('scr_rcbarry1')
                        StartNetworkedParticleFxNonLoopedAtCoord('scr_alien_teleport', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)
                        ESX.Streaming.RequestModel("u_m_m_streetart_01", function()
                            SetPlayerModel(PlayerId(), "u_m_m_streetart_01")
                            SetModelAsNoLongerNeeded("u_m_m_streetart_01")
                        end)
                    elseif Index == 4 then
                        local coords = GetEntityCoords(GetPlayerPed(-1))
                        RequestPtfx('scr_rcbarry1')
                        UseParticleFxAsset('scr_rcbarry1')
                        StartNetworkedParticleFxNonLoopedAtCoord('scr_alien_teleport', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)
                        ESX.Streaming.RequestModel("a_m_y_downtown_01", function()
                            SetPlayerModel(PlayerId(), "a_m_y_downtown_01")
                            SetModelAsNoLongerNeeded("a_m_y_downtown_01")
                        end)
                    end
                end
                   PedsChanges.list = Index;              
                end)
            end, function()
            end, 1)

            if not shouldStayOpened and menuOpen then
                menuOpen = false
                RMenu:Delete(RMenu:Get(cat, subCat("main")))
                RMenu:Delete(RMenu:Get(cat, subCat("players")))
                RMenu:Delete(RMenu:Get(cat, subCat("reports")))
                RMenu:Delete(RMenu:Get(cat, subCat("reports_take")))
                RMenu:Delete(RMenu:Get(cat, subCat("vehicle")))
                RMenu:Delete(RMenu:Get(cat, subCat("cardinal")))
                RMenu:Delete(RMenu:Get(cat, subCat("setGroup")))
                RMenu:Delete(RMenu:Get(cat, subCat("items")))
                RMenu:Delete(RMenu:Get(cat, subCat("playersManage")))
            end
            Wait(0)
        end
    end)
end