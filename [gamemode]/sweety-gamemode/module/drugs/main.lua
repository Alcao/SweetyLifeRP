-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
SwLife.InternalToServer = SwLife.InternalToServer

local HasAlreadyEnteredMarker = false

local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	ESX.TriggerServerCallback('::{korioz#0110}::dumpIsForGayDude', function(gayData)
		cfg_drugs.Zones = gayData
	end)
end)

AddEventHandler('moulamoula:esx_drugs:hasEnteredMarker', function(zone)
	if zone == 'CokeField' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_collect_coke')
		CurrentActionData = {}
	end

	if zone == 'CokeProcessing' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_process_coke')
		CurrentActionData = {}
	end

	if zone == 'CokeDealer' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_sell_coke')
		CurrentActionData = {}
	end

	if zone == 'MethField' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_collect_meth')
		CurrentActionData = {}
	end

	if zone == 'MethProcessing' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_process_meth')
		CurrentActionData = {}
	end

	if zone == 'MethDealer' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_sell_meth')
		CurrentActionData = {}
	end

	if zone == 'WeedField' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_collect_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedProcessing' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_process_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedDealer' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_sell_weed')
		CurrentActionData = {}
	end

	if zone == 'OpiumField' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_collect_opium')
		CurrentActionData = {}
	end

	if zone == 'OpiumProcessing' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_process_opium')
		CurrentActionData = {}
	end

	if zone == 'OpiumDealer' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_sell_opium')
		CurrentActionData = {}
	end

	if zone == 'BilletField' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_collect_billet')
		CurrentActionData = {}
	end

	if zone == 'BilletProcessing' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_process_billet')
		CurrentActionData = {}
	end

	if zone == 'BilletDealer' then
		CurrentAction = zone
		CurrentActionMsg = _U('press_sell_billet')
		CurrentActionData = {}
	end
end)

AddEventHandler('moulamoula:esx_drugs:hasExitedMarker', function()
	SwLife.InternalToServer('moulamoula:esx_drugs:stopHarvestCoke')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopTransformCoke')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopSellCoke')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopHarvestMeth')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopTransformMeth')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopSellMeth')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopHarvestWeed')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopTransformWeed')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopSellWeed')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopHarvestOpium')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopTransformOpium')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopSellOpium')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopHarvestBillet')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopTransformBillet')
	SwLife.InternalToServer('moulamoula:esx_drugs:stopSellBillet')
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local coords = GetEntityCoords(PlayerPedId(), false)
		local isInMarker = false
		local currentZone = nil

		for k, v in pairs(cfg_drugs.Zones) do
			if #(coords - v) < cfg_drugs.ZoneSize.x / 2 then
				isInMarker = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('moulamoula:esx_drugs:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('moulamoula:esx_drugs:hasExitedMarker')
		end
	end
end)

RegisterNetEvent('moulamoula:esx_drugs:onPot')
AddEventHandler('moulamoula:esx_drugs:onPot', function()
	ESX.Streaming.RequestAnimSet('MOVE_M@DRUNK@SLIGHTLYDRUNK')

	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_SMOKING_POT', 0, true)
	Citizen.Wait(5000)
		
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)

	ClearPedTasksImmediately(PlayerPedId())
	SetTimecycleModifier('spectator5')
	SetPedMotionBlur(PlayerPedId(), true)
	SetPedMovementClipset(PlayerPedId(), 'MOVE_M@DRUNK@SLIGHTLYDRUNK', true)
	RemoveAnimSet('MOVE_M@DRUNK@SLIGHTLYDRUNK')
	SetPedIsDrunk(PlayerPedId(), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(120000)

	DoScreenFadeOut(1000)
	Citizen.Wait(1000)

	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(PlayerPedId(), 0.0)
	SetPedIsDrunk(PlayerPedId(), false)
	SetPedMotionBlur(PlayerPedId(), false)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'CokeField' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startHarvestCoke')
				elseif CurrentAction == 'CokeProcessing' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startTransformCoke')
				elseif CurrentAction == 'CokeDealer' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startSellCoke')
				elseif CurrentAction == 'MethField' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startHarvestMeth')
				elseif CurrentAction == 'MethProcessing' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startTransformMeth')
				elseif CurrentAction == 'MethDealer' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startSellMeth')
				elseif CurrentAction == 'WeedField' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startHarvestWeed')
				elseif CurrentAction == 'WeedProcessing' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startTransformWeed')
				elseif CurrentAction == 'WeedDealer' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startSellWeed')
				elseif CurrentAction == 'OpiumField' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startHarvestOpium')
				elseif CurrentAction == 'OpiumProcessing' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startTransformOpium')
				elseif CurrentAction == 'OpiumDealer' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startSellOpium')
				elseif CurrentAction == 'BilletField' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startHarvestBillet')
				elseif CurrentAction == 'BilletProcessing' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startTransformBillet')
				elseif CurrentAction == 'BilletDealer' then
					SwLife.InternalToServer('moulamoula:esx_drugs:startSellBillet')
				end
				
				CurrentAction = nil
			end
		end
	end
end)


