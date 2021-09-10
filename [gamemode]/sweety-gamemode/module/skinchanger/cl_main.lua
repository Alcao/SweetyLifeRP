-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
SwLife.InternalToServer = SwLife.InternalToServer
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local LastSkin, PlayerLoaded, cam, isCameraActive
local FirstSpawn, zoomOffset, camOffset, heading = true, 0.0, 0.0, 90.0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

function CreateSkinCam()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)

	isCameraActive = true
	SetCamRot(cam, 0.0, 0.0, 270.0, true)
	SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
	isCameraActive = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil
end

function OpenSaveableMenu(submitCb, cancelCb, restrict)
	TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
		LastSkin = skin
	end)

	OpenMenu(function(data, menu)
		menu.close()
		DeleteSkinCam()

		TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
			SwLife.InternalToServer('::{razzway.xyz}::esx_skin:save', skin)

			if submitCb ~= nil then
				submitCb(data, menu)
			end
		end)
	end, cancelCb, restrict)
end

AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		while not PlayerLoaded do
			Citizen.Wait(100)
		end

		if FirstSpawn then
			ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then
					TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', {sex = 0})
				else
					TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin)
				end
			end)

			FirstSpawn = false
		end
	end)
end)

RegisterNetEvent('::{razzway.xyz}::esx:playerLoaded')
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(xPlayer)
	PlayerLoaded = true
end)

AddEventHandler('::{razzway.xyz}::esx_skin:getLastSkin', function(cb)
	cb(LastSkin)
end)

AddEventHandler('::{razzway.xyz}::esx_skin:setLastSkin', function(skin)
	LastSkin = skin
end)

RegisterNetEvent('::{razzway.xyz}::esx_skin:openMenu')
AddEventHandler('::{razzway.xyz}::esx_skin:openMenu', function(submitCb, cancelCb)
	OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('::{razzway.xyz}::esx_skin:openRestrictedMenu')
AddEventHandler('::{razzway.xyz}::esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('::{razzway.xyz}::esx_skin:openSaveableMenu')
AddEventHandler('::{razzway.xyz}::esx_skin:openSaveableMenu', function(submitCb, cancelCb)
	OpenSaveableMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('::{razzway.xyz}::esx_skin:openSaveableRestrictedMenu')
AddEventHandler('::{razzway.xyz}::esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenSaveableMenu(submitCb, cancelCb, restrict)
end)
