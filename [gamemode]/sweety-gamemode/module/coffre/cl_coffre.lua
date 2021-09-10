ESX               = nil
weightCoffreCL = 0
SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent(cfg_coffre.esxEvent, function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
local ServerEvent = SwLife.InternalToServer
local openedCoffreMenu, openMenu, mainMenu, resultTable, colorChange = false, false, RageUIv2.CreateMenu("Coffre", "Véhicule"), nil, "~s~"
local coffreMenu = RageUIv2.CreateSubMenu(mainMenu, "Véhicule", "Coffre")
local invMenu = RageUIv2.CreateSubMenu(mainMenu, "Moi", "Inventaire")
if cfg_coffre.Banner then
    mainMenu:DisplayHeader(true)
    coffreMenu:DisplayHeader(true)
    invMenu:DisplayHeader(true)
else
    mainMenu:DisplayHeader(false)
    coffreMenu:DisplayHeader(false)
    invMenu:DisplayHeader(false)
end
mainMenu.Closed = function() targetItem = nil targetWeapon = nil resultTable = nil openedCoffreMenu = false openMenu = false SwLife.InternalToServer("kCoffre:enter", GetVehicleNumberPlateText(vehicle)) end
coffreMenu.Closed = function() targetItem = nil targetWeapon = nil resultTable = nil openedCoffreMenu = false end
local function Menu()
    if openMenu then
        openMenu = false
    else
        SwLife.InternalToServer("kCoffre:enter", GetVehicleNumberPlateText(vehicle))
        openMenu = true
        RageUIv2.Visible(mainMenu, true)
        SwLife.newThread(function()
            while openMenu do
                local playerPed = PlayerPedId()
                local coords    = GetEntityCoords(playerPed, true)
                vehicle = nil
                if IsPedInAnyVehicle(playerPed,  false) then
                    vehicle = 0
                    return
                else
                    if GetVehicleDoorLockStatus(vehicle) == 2 then vehicle = 0 return end
                    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
                end
                Wait(500)
            end
        end)
        CreateThread(function()
            while openMenu do
                Wait(850)
                if colorChange == "~s~" then colorChange = cfg_coffre.ColorChange else colorChange = "~s~" end
            end
        end)
        CreateThread(function()
            while openMenu do
                Wait(1.0)
                if vehicle ~= 0 then
                    RageUIv2.IsVisible(mainMenu, function()
                            lastVehicle = vehicle
                            RageUIv2.Separator("Plaque : "..colorChange..GetVehicleNumberPlateText(vehicle))
                            RageUIv2.Button("Prendre", nil, { RightLabel = "→→" }, true, {
                                onSelected = function(Index, Items)
                                    print("[COFFRE - DEBUG] Coffre menu opened !")
                                    openedCoffreMenu = true
                                    while resultTable == nil and openedCoffreMenu do
                                        Wait(1500)
                                        print("[COFFRE - DEBUG] Loaded a trunk")
                                        ESX.TriggerServerCallback('kCoffre:getVeh', function(targetTable)
                                            resultTable = targetTable
                                        end, GetVehicleNumberPlateText(vehicle))     
                                    end
                                end,
                            }, coffreMenu);
                            RageUIv2.Button("Poser", nil, { RightLabel = "→→"} , true, {
                                onSelected = function(Index, Items)
                                    targetItem = {}
                                    targetWeapon = {}
                                    targetMoney = {}
                                    ESX.TriggerServerCallback('kCoffre:MyInventory', function(inv)
                                        table.insert(targetMoney, {label = "~r~Non déclaré~s~", name = "dirty", count = inv.money})
                                        for i=1, #inv.item, 1 do
                                            local item = inv.item[i]
                                            if item.count > 0 then
                                                table.insert(targetItem, {canRemove = item.canRemove, usable = item.usable, count = item.count, label = item.label, name = item.name})
                                            end
                                       end
                                        for i=1, #inv.weapon, 1 do
                                            local weapon = inv.weapon[i]
                                            table.insert(targetWeapon, {hash = weapon.hash, label = weapon.label, name = weapon.name, count = weapon.ammo })
                                        end
                                    end)   
                                end,
                            }, invMenu);
                    end, function() end)
                    RageUIv2.IsVisible(coffreMenu, function()
                        if resultTable ~= nil then
                            if resultTable == 0 then
                                RageUIv2.Separator("")
                                RageUIv2.Separator(colorChange.."Il n'y a rien dans ce coffre")
                                RageUIv2.Separator("")
                            else
                                if cfg_coffre.Vehicle.maxWeight[GetVehicleClass(vehicle)]-weightCoffreCL ~= 0 then
                                    RageUIv2.Separator("~o~"..math.floor((cfg_coffre.Vehicle.maxWeight[GetVehicleClass(vehicle)]-weightCoffreCL) / 1000).."KG~s~ LIBRE")
                                else
                                    RageUIv2.Separator("~r~PLUS DE PLACE~s~")
                                end
                                for k,v in pairs(resultTable) do
                                    if v.count >= 1 then
                                        if v.type == "money" then
                                            RageUIv2.Button("Argent ("..v.label..") "..v.count.."$", nil, {RightLabel = colorChange.."Prendre~s~ →→"}, true, {
                                                onSelected = function(Index, Items)
                                                    local afterCount = tonumber(coffreInput("Veuillez entrer une somme", "", 6))
                                                    if not afterCount then return end
                                                    if afterCount <= v.count then
                                                        SwLife.InternalToServer("kCoffre:action", GetVehicleClass(vehicle), GetHashKey(vehicle), GetVehicleNumberPlateText(vehicle), v.label, v.name, afterCount, 0, "money", "take")
                                                        RageUIv2.GoBack()
                                                        targetMoney = nil targetItem = nil targetWeapon = nil resultTable = nil openedCoffreMenu = false
                                                    end
                                                end,
                                                })    
                                        elseif v.type == "item" then
                                            RageUIv2.Button(v.label.." x"..v.count.." (~o~"..(cfg_coffre.Vehicle.itemWeight[v.name]*v.count / 1000).."kg~s~)", nil, {RightLabel = colorChange.."Prendre~s~ →→"}, true, {
                                            onSelected = function(Index, Items)
                                                local afterCount = tonumber(coffreInput("Veuillez entrer une somme", "", 3))
                                                if not afterCount then return end
                                                if afterCount <= v.count then
                                                    SwLife.InternalToServer("kCoffre:action", GetVehicleClass(vehicle), GetHashKey(vehicle), GetVehicleNumberPlateText(vehicle), v.label, v.name, afterCount, 0, "item", "take")
                                                    RageUIv2.GoBack()
                                                    targetMoney = nil targetItem = nil targetWeapon = nil resultTable = nil openedCoffreMenu = false
                                                end
                                            end,
                                            })
                                        elseif v.type == "weapon" then
                                            RageUIv2.Button(v.label.." "..v.ammo.."munition(s) (~o~"..(cfg_coffre.Vehicle.itemWeight[v.name] / 1000).."kg~s~)", nil, {RightLabel = colorChange.."Prendre~s~ →→"}, true, {
                                                onSelected = function(Index, Items)
                                                    SwLife.InternalToServer("kCoffre:action", GetVehicleClass(vehicle), GetHashKey(vehicle), GetVehicleNumberPlateText(vehicle), v.label, v.name, 1, v.ammo, "weapon", "take")
                                                    RageUIv2.GoBack()
                                                    targetMoney = nil targetItem = nil targetWeapon = nil resultTable = nil openedCoffreMenu = false    
                                                end,
                                                })    
                                        end
                                    end
                                end
                            end
                        else
                            RageUIv2.Separator("")
                            RageUIv2.Separator(colorChange.."Chargement des données")
                            RageUIv2.Separator("")
                        end
                    end, function() end)
                    RageUIv2.IsVisible(invMenu, function()
                        if targetItem ~= nil and targetWeapon ~= nil and targetMoney ~= nil then
                            if #targetMoney > 0 then
                                for k,v in pairs(targetMoney) do
                                    RageUIv2.Button("Argent ("..v.label..") "..v.count.."$", nil, {RightLabel = "Déposer~s~ →"}, true, {
                                        onSelected = function(Index, Items)
                                            local afterCount = tonumber(coffreInput("Veuillez entrer une somme", "", 6))
                                            if not afterCount then return end
                                            if afterCount <= v.count then
                                                if not cfg_coffre.Vehicle.itemWeight[v.name] then Visual.Popup({message = "Cette item ne peux pas allez dans le coffre !"}) return end
                                                if (weightCoffreCL + (cfg_coffre.Vehicle.itemWeight[v.name] * afterCount)) <= cfg_coffre.Vehicle.maxWeight[GetVehicleClass(vehicle)] then
                                                    SwLife.InternalToServer("kCoffre:action", GetVehicleClass(vehicle), GetHashKey(vehicle), GetVehicleNumberPlateText(vehicle), v.label, v.name, afterCount, 0, "money", "put")
                                                    RageUIv2.GoBack()
                                                    targetItem = nil targetWeapon = nil resultTable = nil openedCoffreMenu = false
                                                else
                                                    Visual.Popup({message = "~r~Il n'y a plus assez de place dans le coffre !"})                                                        
                                                end
                                            end
                                        end,
                                    }) 
                                end
                            end
                            if #targetWeapon > 0 then
                                for k,v in pairs(targetWeapon) do
                                    RageUIv2.Button(v.label.." "..v.count.."munition(s)", nil, {RightLabel = "Déposer~s~ →→"}, true, {
                                        onSelected = function(Index, Items)
                                            if not cfg_coffre.Vehicle.itemWeight[v.name] then Visual.Popup({message = "Cette item ne peux pas allez dans le coffre !"}) return end
                                            if (weightCoffreCL + (cfg_coffre.Vehicle.itemWeight[v.name] * 1)) <= cfg_coffre.Vehicle.maxWeight[GetVehicleClass(vehicle)] then
                                                SwLife.InternalToServer("kCoffre:action", GetVehicleClass(vehicle), GetHashKey(vehicle), GetVehicleNumberPlateText(vehicle), v.label, v.name, 1, v.count, "weapon", "put")
                                                RageUIv2.GoBack()
                                                targetItem = nil targetWeapon = nil resultTable = nil openedCoffreMenu = false
                                            else
                                                Visual.Popup({message = "~r~Il n'y a plus assez de place dans le coffre !"})                                                        
                                            end
                                        end,
                                    })    
                                end
                            end
                            if #targetItem > 0 then
                                for k,v in pairs(targetItem) do
                                    RageUIv2.Button(v.label.." x"..v.count, nil, {RightLabel = colorChange.."Déposer~s~ →→"}, true, {
                                        onSelected = function(Index, Items)
                                            local afterCount = tonumber(coffreInput("Veuillez entrer une somme", "", 3))
                                            if not afterCount then return end
                                            if afterCount <= v.count then
                                                if not cfg_coffre.Vehicle.itemWeight[v.name] then Visual.Popup({message = "Cette item ne peux pas allez dans le coffre !"}) return end
                                                if (weightCoffreCL + (cfg_coffre.Vehicle.itemWeight[v.name] * afterCount)) <= cfg_coffre.Vehicle.maxWeight[GetVehicleClass(vehicle)] then
                                                    SwLife.InternalToServer("kCoffre:action", GetVehicleClass(vehicle), GetHashKey(vehicle), GetVehicleNumberPlateText(vehicle), v.label, v.name, afterCount, 0, "item", "put")
                                                    RageUIv2.GoBack()
                                                    targetItem = nil targetWeapon = nil resultTable = nil openedCoffreMenu = false
                                                else
                                                    Visual.Popup({message = "~r~Il n'y a plus assez de place dans le coffre !"})                                                        
                                                end
                                            end
                                        end,
                                    })
                                end
                            end
                        else
                            RageUIv2.Separator("")
                            RageUIv2.Separator(colorChange.."Chargement des données")
                            RageUIv2.Separator("")
                        end
                    end, function() end)
                else
                    SwLife.InternalToServer("kCoffre:enter", GetVehicleNumberPlateText(lastVehicle))
                    RageUIv2.CloseAll()
                    openMenu = false
                    targetItem = nil targetWeapon = nil resultTable = nil openedCoffreMenu = false
                end
            end
        end)
    end
end

function coffreInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
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

Keys.Register(cfg_coffre.Touche, 'openCoffreMenu', 'Touche pour ouvrir le coffre', function()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed, true)
    if IsPedInAnyVehicle(playerPed,  false) then
        Visual.Popup({message = 'Vous ne pouvez ouvrir le coffre ici !'})
        return
    else
        if GetVehicleDoorLockStatus(vehicle) == 2 then Visual.Popup({message = "~r~Ce véhicule est fermé !"}) return end
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
    end
    if vehicle ~= 0 then
        ESX.TriggerServerCallback('kCoffre:getEnterCoffre', function(ready)
            if ready  then
                if openMenu == false then
                    Menu()
                end
            else
                Visual.Popup({message = 'Il y a déjà une personne dans le coffre !'})
            end
        end, GetVehicleNumberPlateText(vehicle))  
    else
        Visual.Popup({message = '~r~Aucun véhicule à proximité !'})
    end
end)

RegisterNetEvent("kCoffre:RefreshWeightTrunk")
AddEventHandler("kCoffre:RefreshWeightTrunk", function(niceWeight)
    weightCoffreCL = niceWeight
end)