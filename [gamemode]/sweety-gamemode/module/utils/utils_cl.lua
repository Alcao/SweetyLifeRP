-- KO ↓

local knockedOut = false
local wait = 15
local count = 60

Citizen.CreateThread(function()
	while true do
		local waiting = 85
		local myPed = GetPlayerPed(-1)
		if IsPedInMeleeCombat(myPed) then
			if GetEntityHealth(myPed) < 115 then
				SetPlayerInvincible(PlayerId(), true)
				SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
				ShowNotificationKO("~r~Vous vous êtes fait assommé...")
				wait = 15
				knockedOut = true
				SetEntityHealth(myPed, 116)
			end
		end
		if knockedOut == true then
			waiting = 15
			SetPlayerInvincible(PlayerId(), true)
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)
			
			if wait >= 0 then
				count = count - 1
				if count == 0 then
					count = 60
					wait = wait - 1
					SetEntityHealth(myPed, GetEntityHealth(myPed)+4)
				end
			else
				SetPlayerInvincible(PlayerId(), false)
				knockedOut = false
			end
		end
		Wait(waiting)
	end
end)

function ShowNotificationKO(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

-- Rich presence ↓

Citizen.CreateThread(function()
	fakeCount = 40
	
	SetDiscordAppId(818502937403719700)
	SetDiscordRichPresenceAsset('sweetylife')
	SetDiscordRichPresenceAssetText('')
	SetRichPresence(GetPlayerName(PlayerId()) .." ["..GetPlayerServerId(PlayerId()).."]")

	SetDiscordRichPresenceAction(0, "Rejoindre le discord", "https://discord.gg/Yc9dC3ysYv")
end)

-- Pause menu ↓

Citizen.CreateThread(function()
	AddTextEntry('PM_PANE_LEAVE', '~o~Retourner sur la liste des serveurs.')
	AddTextEntry('PM_PANE_QUIT', 'Quitter ~r~SweetyLife')
	AddTextEntry('PM_SCR_MAP', 'CARTE')
	AddTextEntry('PM_SCR_GAM', 'DOUANE')
	AddTextEntry('PM_SCR_INF', 'LOGS DU JEU')
	AddTextEntry('PM_SCR_SET', 'CONFIG FIVEM')
	AddTextEntry('PM_SCR_STA', 'STATISTIQUES')
	AddTextEntry('PM_SCR_RPL', '~b~Éditeur ∑')
	AddTextEntry('FE_THDR_GTAO', '[~b~PUBLIC~w~] ~b~Sweety~s~Life | ~b~'..GetPlayerName(PlayerId())..'~w~ [~b~'..GetPlayerServerId(PlayerId())..'~w~] | discord.gg/dCKZtWzPCN')
end)


-- Drift ↓

local drift = false
local kmh = 3.6
CreateThread(function()
    while true do
        local waiting = 250
        if IsPedInAnyVehicle(GetPed(), false) then

             local CarSpeed = GetEntitySpeed(GetCar()) * kmh
             waiting = 50

            if GetPedInVehicleSeat(GetCar(), -1) == GetPed() then

                if CarSpeed <= 130.00 then 
                    if drift then
                        waiting = 1
                        SetVehicleReduceGrip(GetCar(), true)
                    else
                        waiting = 50
                        SetVehicleReduceGrip(GetCar(), false)
                    end
                end
            end
        end
        Wait(waiting)
    end
end)

RegisterCommand('+drift', function()
    drift = true
    if IsPedInAnyVehicle(GetPed(), false) then
    end
end, false)
RegisterCommand('-drift', function()
    drift = false
end, false)
RegisterKeyMapping('+drift', 'Drift', 'keyboard', 'i')

function GetPed() return GetPlayerPed(-1) end
function GetCar() return GetVehiclePedIsIn(GetPlayerPed(-1),false) end
