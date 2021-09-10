ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('::{razzway.xyz}::esx:setJob')
AddEventHandler('::{razzway.xyz}::esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local societycarshopmoney = nil

carshop             = {}
carshop.DrawDistance = 100
carshop.Size         = {x = 1.0, y = 1.0, z = 1.0}
carshop.Color        = {r = 255, g = 255, b = 255}
carshop.Type         = 20

h4ci_conc = {
	catevehi = {},
	listecatevehi = {},
}

local derniervoituresorti = {}
local sortirvoitureacheter = {}
--blips

Citizen.CreateThread(function()

        local carshopmap = AddBlipForCoord(-57.0, -1099.44, 26.42)
        SetBlipSprite(carshopmap, 326)
        SetBlipColour(carshopmap, 18)
        SetBlipScale(carshopmap, 0.90)
        SetBlipAsShortRange(carshopmap, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Concessinaire Automobile")
        EndTextCommandSetBlipName(carshopmap)

end)

--travail carshop

local markerjob = {
    {x = -45.23, y = -1093.43, z = 26.39}, --point vente
}  

--point vente
local carshoppointvente = false
RMenu.Add('carshopvente', 'main', RageUI.CreateMenu("Concessinaire", "~b~Actions disponibles"))
RMenu.Add('carshopvente', 'listevehicule', RageUI.CreateSubMenu(RMenu:Get('carshopvente', 'main'), "Catalogue", "Pour acheter un véhicule"))
RMenu.Add('carshopvente', 'categorievehicule', RageUI.CreateSubMenu(RMenu:Get('carshopvente', 'listevehicule'), "Véhicules", "Pour acheter un véhicule"))
RMenu.Add('carshopvente', 'achatvehicule', RageUI.CreateSubMenu(RMenu:Get('carshopvente', 'categorievehicule'), "Véhicules", "Pour acheter un véhicule"))
RMenu.Add('carshopvente', 'annonces', RageUI.CreateSubMenu(RMenu:Get('carshopvente', 'main'), "Annonces", "Annonces de la ville"))
RMenu:Get('carshopvente', 'main').Closed = function()
    carshoppointvente = false
end
RMenu:Get('carshopvente', 'categorievehicule').Closed = function()
    supprimervehiculecarshop()
end

function OpenConcessMenu()
    if not carshoppointvente then
        carshoppointvente = true
        RageUI.Visible(RMenu:Get('carshopvente', 'main'), true)
    while carshoppointvente do

        RageUI.IsVisible(RMenu:Get('carshopvente', 'main'), true, true, true, function()
           
            RageUI.ButtonWithStyle("Catalogue véhicules", nil, {RightLabel = "→→"},true, function()
           end, RMenu:Get('carshopvente', 'listevehicule'))
           
           RageUI.ButtonWithStyle("Facture", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('Personne autour')
                    else
                    	local amount = KeyboardInput('Veuillez saisir le montant de la facture', '', 8)
                        SwLife.InternalToServer('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_carshop', 'carshop', amount)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Annonces", nil, {RightLabel = "→→"},true, function()
            end, RMenu:Get('carshopvente', 'annonces'))
    
            end, function()
            end)

        RageUI.IsVisible(RMenu:Get('carshopvente', 'listevehicule'), true, true, true, function()
        	for i = 1, #h4ci_conc.catevehi, 1 do
            RageUI.ButtonWithStyle("Catégorie - "..h4ci_conc.catevehi[i].label, nil, {RightLabel = "→→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            		nomcategorie = h4ci_conc.catevehi[i].label
                    categorievehi = h4ci_conc.catevehi[i].name
                    ESX.TriggerServerCallback('h4ci_carshop:recupererlistevehicule', function(listevehi)
                            h4ci_conc.listecatevehi = listevehi
                    end, categorievehi)
                end
            end, RMenu:Get('carshopvente', 'categorievehicule'))
        	end
            end, function()
            end)

        RageUI.IsVisible(RMenu:Get('carshopvente', 'categorievehicule'), true, true, true, function()
        	RageUI.ButtonWithStyle("↓ Catégorie : "..nomcategorie.." ↓", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if (Selected) then   
            end
            end)

        	for i2 = 1, #h4ci_conc.listecatevehi, 1 do
            RageUI.ButtonWithStyle(h4ci_conc.listecatevehi[i2].name, "Pour acheter ce véhicule", {RightLabel = h4ci_conc.listecatevehi[i2].price.."$"},true, function(Hovered, Active, Selected)
            if (Selected) then
            		nomvoiture = h4ci_conc.listecatevehi[i2].name
            		prixvoiture = h4ci_conc.listecatevehi[i2].price
            		modelevoiture = h4ci_conc.listecatevehi[i2].model
            		supprimervehiculecarshop()
					chargementvoiture(modelevoiture)

					ESX.Game.SpawnLocalVehicle(modelevoiture, {x = -51.38, y = -1094.05, z = 26.42}, 251.959, function (vehicle)
					table.insert(derniervoituresorti, vehicle)
					FreezeEntityPosition(vehicle, true)
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					SetModelAsNoLongerNeeded(modelevoiture)
					end)
                end
            end, RMenu:Get('carshopvente', 'achatvehicule'))

        	end
            end, function()
            end)

        RageUI.IsVisible(RMenu:Get('carshopvente', 'achatvehicule'), true, true, true, function()
        	RageUI.ButtonWithStyle("Nom du modèle : "..nomvoiture, nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if (Selected) then   
            end
            end)
            RageUI.ButtonWithStyle("Prix du véhicule : "..prixvoiture.."$", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
            if (Selected) then   
            end
            end)
            RageUI.ButtonWithStyle("Vendre au client", "Attribue le véhicule au client le plus proche (paiement avec argent entreprise)", {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            if (Selected) then   
            	ESX.TriggerServerCallback('h4ci_carshop:verifsouscarshop', function(suffisantsous)
                if suffisantsous then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification('Personne autour')
				else
				supprimervehiculecarshop()
				chargementvoiture(modelevoiture)

				ESX.Game.SpawnVehicle(modelevoiture, {x = -51.38, y = -1094.05, z = 26.42}, 251.959, function (vehicle)
				table.insert(sortirvoitureacheter, vehicle)
				FreezeEntityPosition(vehicle, true)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				SetModelAsNoLongerNeeded(modelevoiture)
				local plaque     = GeneratePlate()
                local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
                vehicleProps.plate = plaque
                SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)
                FreezeEntityPosition(sortirvoitureacheter[#sortirvoitureacheter], false)

				SwLife.InternalToServer('h4ci_carshop:vendrevoiturejoueur', GetPlayerServerId(closestPlayer), vehicleProps, prixvoiture)
				ESX.ShowNotification('Le véhicule '..nomvoiture..' avec la plaque '..vehicleProps.plate..' a été vendu à '..GetPlayerName(closestPlayer))
                SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:registerkey', vehicleProps.plate, GetPlayerServerId(closestPlayer))
				end)
				end
                else
                    ESX.ShowNotification('La société n\'as pas assez d\'argent pour ce véhicule!')
                end

            end, prixvoiture)
                end
            end)

            RageUI.ButtonWithStyle("Acheter le véhicule", "Attribue le véhicule à vous même ( argent de societé )", {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                    ESX.TriggerServerCallback('h4ci_carshop:verifsouscarshop', function(suffisantsous)
                    if suffisantsous then
                    supprimervehiculecarshop()
                    chargementvoiture(modelevoiture)
                    ESX.Game.SpawnVehicle(modelevoiture, {x = -51.38, y = -1094.05, z = 26.42}, 251.959, function (vehicle)
                    table.insert(sortirvoitureacheter, vehicle)
                    FreezeEntityPosition(vehicle, true)
                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                    SetModelAsNoLongerNeeded(modelevoiture)
                    local plaque     = GeneratePlate()
                    local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
                    vehicleProps.plate = plaque
                    SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)
                    FreezeEntityPosition(sortirvoitureacheter[#sortirvoitureacheter], false)

                    SwLife.InternalToServer('shop:vehicule', vehicleProps, prixvoiture)
                    ESX.ShowNotification('Le véhicule '..nomvoiture..' avec la plaque '..vehicleProps.plate..' a été vendu à '..GetPlayerName(closestPlayer))
                    SwLife.InternalToServer('::{razzway.xyz}::esx_vehiclelock:registerkey', vehicleProps.plate, GetPlayerServerId(closestPlayer))
                    end)

                    else
                        ESX.ShowNotification('La société n\'as pas assez d\'argent pour ce véhicule!')
                    end
    
                end, prixvoiture)
                    end
                end)

            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('carshopvente', 'annonces'), true, true, true, function()
                
                RageUI.ButtonWithStyle("Ouvert", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        SwLife.InternalToServer('Open:Ads')
                    end
                end)

                RageUI.ButtonWithStyle("Fermer", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        SwLife.InternalToServer('Close:Ads')
                    end
                end)

                RageUI.ButtonWithStyle("Personnalisé", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local msg = KeyboardInput("Message", "", 100)
                        ExecuteCommand("acon" ..msg)
                    end
                end)

                end, function()
                end)

            Citizen.Wait(0)
        end
    else
        carshoppointvente = false
    end
end

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
    while true do
        razzou = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(markerjob) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, markerjob[k].x, markerjob[k].y, markerjob[k].z)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'carshop' then
                if distance <= 9.0 then
                    DrawMarker(6, markerjob[k].x, markerjob[k].y, markerjob[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.9, 0.9, 0.9, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                    razzou = 1
                    if distance <= 1.5 then
                        ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour accéder au menu")
                        if IsControlJustPressed(0, 51) then
                            ESX.TriggerServerCallback('h4ci_carshop:recuperercategorievehicule', function(catevehi)
                                h4ci_conc.catevehi = catevehi
                            end)
                            carshoppointvente = false
                            OpenConcessMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)

function supprimervehiculecarshop()
	while #derniervoituresorti > 0 do
		local vehicle = derniervoituresorti[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(derniervoituresorti, 1)
	end
end

function chargementvoiture(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName('shop_awaiting_model')
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
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
