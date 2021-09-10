-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
SwLife.InternalToServer = SwLife.InternalToServer
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local PlayerData = {}

local CurrentAction = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('::{razzway.xyz}::esx:playerLoaded')
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('::{razzway.xyz}::esx:setJob')
AddEventHandler('::{razzway.xyz}::esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('::{razzway.xyz}::esx_repairkit:onUse')
AddEventHandler('::{razzway.xyz}::esx_repairkit:onUse', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			if ConfigRepair.IgnoreAbort then
				SwLife.InternalToServer('::{razzway.xyz}::esx_repairkit:removeKit')
			end
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

			SwLife.newThread(function()
				ThreadID = GetIdOfThisThread()
				CurrentAction = 'repair'

				Citizen.Wait(ConfigRepair.RepairTime * 1000)

				if CurrentAction ~= nil then
					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('finished_repair'))
				end

				if not ConfigRepair.IgnoreAbort then
					SwLife.InternalToServer('::{razzway.xyz}::esx_repairkit:removeKit')
				end

				CurrentAction = nil
				TerminateThisThread()
			end)
		end

		SwLife.newThread(function()
			Citizen.Wait(0)

			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentSubstringPlayerName(_U('abort_hint'))
				EndTextCommandDisplayHelp(0, 0, 1, -1)

				if IsControlJustReleased(0, 73) then
					TerminateThread(ThreadID)
					ESX.ShowNotification(_U('aborted_repair'))
					CurrentAction = nil
				end
			end

		end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'))
	end
end)

