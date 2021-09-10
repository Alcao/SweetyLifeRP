local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local handsup = false
local pointing = false

function getSurrenderStatus()
	return handsup
end

RegisterNetEvent('KZ:getSurrenderStatusPlayer')
AddEventHandler('KZ:getSurrenderStatusPlayer', function(event, source)
	if handsup then
		SwLife.InternalToServer("KZ:reSendSurrenderStatus", event, source, true)
	else
		SwLife.InternalToServer("KZ:reSendSurrenderStatus", event, source, false)
	end
end)

RegisterCommand('+handsup', function()
		if DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
			if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedSwimming(PlayerPedId()) and not IsPedShooting(PlayerPedId()) and not IsPedClimbing(PlayerPedId()) and not IsPedCuffed(plyPed) and not IsPedDiving(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) then
				RequestAnimDict("random@mugging3")

				while not HasAnimDictLoaded("random@mugging3") do
					Citizen.Wait(100)
				end

				if not handsup then
					handsup = true
					--pipicaca = true
					TaskPlayAnim(PlayerPedId(), "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
					SwLife.InternalToServer("esx_thief:update", true)
				elseif handsup then
					handsup = false
					ClearPedSecondaryTask(PlayerPedId())
					SwLife.InternalToServer("esx_thief:update", false)
				end
			end
		end
end, false)
RegisterKeyMapping('+handsup', 'Lever les mains', 'keyboard', 'X')



local crouched = false
local GUI = {}
GUI.Time = 0

RegisterCommand('+crouch', function() 
    RequestAnimSet("move_ped_crouched")

    while not HasAnimSetLoaded("move_ped_crouched") do 
        Citizen.Wait(100)
    end 

    if crouched == true then 
        ResetPedMovementClipset(PlayerPedId(), 0)
        crouched = false 
    elseif crouched == false then
        SetPedMovementClipset(PlayerPedId(), "move_ped_crouched", 0.25)
        crouched = true 
		----pipicaca = true
    end 
    
    GUI.Time = GetGameTimer()
end, false)
RegisterKeyMapping('+crouch', 'S\'accroupir', 'keyboard', 'N')

--[[function startPointing(plyPed)
	ESX.Streaming.RequestAnimDict('anim@mp_point')
	SetPedConfigFlag(plyPed, 36, true)
	TaskMoveNetworkByName(plyPed, 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
	RemoveAnimDict('anim@mp_point')
end

function stopPointing()
	RequestTaskMoveNetworkStateTransition(plyPed, 'Stop')

	if not IsPedInjured(plyPed) then
		ClearPedSecondaryTask(plyPed)
	end

	SetPedConfigFlag(plyPed, 36, false)
	ClearPedSecondaryTask(plyPed)
end]]

RegisterCommand('+pointing', function()
	local plyPed = PlayerPedId()

	if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) and IsPedOnFoot(plyPed) then
		ESX.Streaming.RequestAnimDict('anim@mp_point')
		SetPedConfigFlag(plyPed, 36, true)
		TaskMoveNetworkByName(plyPed, 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
		RemoveAnimDict('anim@mp_point')
		local camPitch = GetGameplayCamRelativePitch()

		if camPitch < -70.0 then
    		camPitch = -70.0
		elseif camPitch > 42.0 then
    		camPitch = 42.0
		end

		camPitch = (camPitch + 70.0) / 112.0

		local camHeading = GetGameplayCamRelativeHeading()
		local cosCamHeading = Cos(camHeading)
		local sinCamHeading = Sin(camHeading)

		if camHeading < -180.0 then
    		camHeading = -180.0
		elseif camHeading > 180.0 then
    		camHeading = 180.0
		end

		camHeading = (camHeading + 180.0) / 360.0
		local coords = GetOffsetFromEntityInWorldCoords(plyPed, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
		local rayHandle, blocked = GetShapeTestResult(StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, plyPed, 7))

		SetTaskMoveNetworkSignalFloat(plyPed, 'Pitch', camPitch)
		SetTaskMoveNetworkSignalFloat(plyPed, 'Heading', (camHeading * -1.0) + 1.0)
		SetTaskMoveNetworkSignalBool(plyPed, 'isBlocked', blocked)
		SetTaskMoveNetworkSignalBool(plyPed, 'isFirstPerson', N_0xee778f8c7e1142e2(N_0x19cafa3c87f7c2ff()) == 4)
		
		pointing = true
		--pipicaca = true
	else
		Citizen.Wait(0)
	end

	if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) and IsPedOnFoot(plyPed) and pointing then
		RequestTaskMoveNetworkStateTransition(plyPed, 'Stop')

		if not IsPedInjured(plyPed) then
			ClearPedSecondaryTask(plyPed)
		end
	
		SetPedConfigFlag(plyPed, 36, false)
		ClearPedSecondaryTask(plyPed)
		pointing = false
		----pipicaca = false
	end

end, false)
RegisterKeyMapping('+pointing', 'Pointer du doigt', 'keyboard', 'B')