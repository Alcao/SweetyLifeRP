-------- BAH ALORS TU DUMP PCQ T ARRIVES PAS A CHEAT BOUFFON ? ^^ --------
_print = print
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local alcao = SwLife.InternalToServer

local GoFastDejaFait = nil

ESX = nil

PlayerData = {}


-- Coordonée pour le point de début de mission

local DebutMission = {coords = vector3(1570.1783, -2130.38, 78.33)}
local SpawnVehicule = {coords = vector3(1563.67, -2168.06, 77.51)}
local SpawnVehiculeJoueur = {coords = vector3(1566.83, -2168.48, 77.53)}
local GoFastVente = {coords = vector3(114.87, 6611.87, 31.86)}

local GoFastEnCours = true
local BlipsGoFast = nil
local clegal = false

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

RegisterNetEvent("Sync:GoFast")
AddEventHandler("Sync:GoFast", function(_GoFastDejaFait)
	GoFastDejaFait = _GoFastDejaFait
end)

SwLife.newThread(function()
	while true do
		while GoFastDejaFait == nil do
			Wait(1000)
			GoFastDejaFait = 1
		end
		local sleepThread = 500
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, DebutMission.coords, true)
		if dstCheck <= 4.2 then
			sleepThread = 5
			if dstCheck <= 4.2 then
				ESX.Game.Utils.DrawText3D(DebutMission.coords, "[E] Ouvrir le menu de ~g~GoFast\n~r~Activitée illégal\n~w~GoFast disponible: ~g~"..GoFastDejaFait, 1.0)
				if IsControlJustPressed(0, 38) then
					if GoFastDejaFait > 0 then
						DebutMissionMenu()
					else
						ESX.ShowAdvancedNotification("SweetyLife", "~b~Livraison GoFast", "Aucun GoFast disponbile, revient plus tard.", "CHAR_LESTER_DEATHWISH", 8)
					end
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)

SwLife.newThread(function()
	while true do
		local sleepThread = 500
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, GoFastVente.coords, true)
		if GoFastEnCours then
			if dstCheck <= 10.0 then
				sleepThread = 5
				if dstCheck <= 10.0 then
					ESX.Game.Utils.DrawText3D(GoFastVente.coords, "[E] Livrer le véhicule\n~r~Activitée illégal", 1.0)
					if IsControlJustPressed(0, 38) then
						FinDeGoFast()
					end
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)

-- Menu de début de mission 

local sGoFast = {}
RMenu.Add('gofast', 'main', RageUI.CreateMenu("~r~GoFast", "~r~Que veux-tu faire ?"))
RMenu:Get('gofast', 'main').EnableMouse = false
RMenu:Get('gofast', 'main').Closed = function()
	local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	local ped = PlayerPedId()
	sGoFast.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false)
	RenderScriptCams(0, 1, 1000, 1, 1)
	DestroyCam(camera, true)
	RenderScriptCams(0, 1, 1000, 1, 1)
	DestroyCam(camera, true)
end
function DebutMissionMenu()
	if sGoFast.Menu then
		sGoFast.Menu = false
	else
		sGoFast.Menu = true
		RageUI.Visible(RMenu:Get('gofast', 'main'), true)
		FreezeEntityPosition(GetPlayerPed(-1), true)
		local elements = {}
		local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		--CreateCam(camera, true)
		local ped = PlayerPedId()
		SetCamCoord(camera, 1571.88, -2135.56, 80.43)
		--AttachCamToEntity(camera, ped, -10.31, -2519.99, 8.19, 1)
		PointCamAtEntity(camera, ped, 0, 0, 0, 1)
		RenderScriptCams(1, 1, 1000, 1, 1)
		SetCamShakeAmplitude(camera, 3.0)
		SwLife.newThread(function()
			while sGoFast.Menu do
				RageUI.IsVisible(RMenu:Get('gofast', 'main'), true, true, true, function()
					RageUI.ButtonWithStyle("Lancer la mission", nil, {RightLabel = "→"}, true, function(h,a,s)
						if s then
							FreezeEntityPosition(GetPlayerPed(-1), false)
							RageUI.CloseAll()
							alcao("Sync:MoinUnGoFast")
							RenderScriptCams(0, 1, 1000, 1, 1)
							DestroyCam(camera, true)
							AnimDebutMission()
							RenderScriptCams(0, 1, 1000, 1, 1)
							DestroyCam(camera, true)
						end
					end)
				end)
				Wait(1)
			end
		end)
	end
end

-- Create Blips
local blips = {
	{title="GoFast",color=24, id=315, x=1566.88, y=-2133.42, z=77.62},
        }

SwLife.newThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.6)
      SetBlipColour(info.blip, 1)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

-- Animation de début de mission


local cloudOpacity = 0.10 -- (default: 0.01)
local muteSound = true -- (default: true)

function ToggleSound(state)
	if state then
		StartAudioScene("MP_LEADERBOARD_SCENE");
	else
		StopAudioScene("MP_LEADERBOARD_SCENE");
	end
end

-- Runs the initial setup whenever the script is loaded.
function InitialSetup()
	-- Stopping the loading screen from automatically being dismissed.
	SetManualShutdownLoadingScreenNui(true)
	-- Disable sound (if configured)
	ToggleSound(muteSound)
	-- Switch out the player if it isn't already in a switch state.
	if not IsPlayerSwitchInProgress() then
		SwitchOutPlayer(PlayerPedId(), 0, 1)
	end
end

-- Hide radar & HUD, set cloud opacity, and use a hacky way of removing third party resource HUD elements.
function ClearScreen()
	SetCloudHatOpacity(cloudOpacity)
	HideHudAndRadarThisFrame()
	
	-- nice hack to 'hide' HUD elements from other resources/scripts. kinda buggy though.
	SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

function SpawnDuVehicule()
	local ped = PlayerPedId()
	print('Début animation')
	local veh = CreateVehicle(917809321, SpawnVehicule.coords, 353.13, true, true)
	print('Spawn du véhicule')
	--ESX.Game.Teleport(ped, SpawnVehiculeJoueur.coords, cb)
	print('Téléportation du joueur')
	TaskEnterVehicle(ped, veh, 0.0, -1, 1.0, p5, p6)
	print('Entré dans le véhicule')
end

function AnimDebutMission()
	InitialSetup()
	local ped = PlayerPedId()
	
	-- Wait for the switch cam to be in the sky in the 'waiting' state (5).
	while GetPlayerSwitchState() ~= 5 do
		Citizen.Wait(0)
		ClearScreen()
	end
	
	-- Shut down the game's loading screen (this is NOT the NUI loading screen).
	ShutdownLoadingScreen()
	
	ClearScreen()
	Citizen.Wait(0)
	--DoScreenFadeOut(0)
	ESX.Game.Teleport(ped, SpawnVehiculeJoueur.coords, cb)
	-- Shut down the NUI loading screen.
	ShutdownLoadingScreenNui()
	
	ClearScreen()
	Citizen.Wait(0)
	ClearScreen()
	--DoScreenFadeIn(500)
	while not IsScreenFadedIn() do
		Citizen.Wait(0)
		ClearScreen()
	end
	
	local timer = GetGameTimer()
	
	-- Re-enable the sound in case it was muted.
	ToggleSound(false)
	
	while true do
		ClearScreen()
		Citizen.Wait(0)
			
		-- wait 5 seconds before starting the switch to the player
		if GetGameTimer() - timer > 5000 then
		
			-- Switch to the player.
			SwitchInPlayer(PlayerPedId())
			ClearScreen()
			RequestModel(917809321)
			while not HasModelLoaded(917809321) do
				Citizen.Wait(0)
			end

			while spawn == false do
				local spawn = ESX.Game.IsSpawnPointClear(SpawnVehicule.coords, 7)
				Citizen.Wait(0)
			end

			local veh = CreateVehicle(917809321, SpawnVehicule.coords, 353.13, true, true)
			SetVehicleNumberPlateText(veh, 'GOFAST')
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 20.0)
			TaskEnterVehicle(ped, veh, 1000, -1, 1.0, 1, 0)
			TaskVehiclePark(ped, veh, 1565.92, -2154.84, 77.55, 352.04, 0, 20.0, true)
			SetModelAsNoLongerNeeded(917809321)
			SetModelAsNoLongerNeeded(veh)
			SetVehicleAsNoLongerNeeded(veh)
			-- Création du blips pour livrer le véhicule
			GoFastEnCours = true
			-- Wait for the player switch to be completed (state 12).
			while GetPlayerSwitchState() ~= 12 do
				Citizen.Wait(0)
				ClearScreen()
			end
			-- Stop the infinite loop.
			break
		end
	end
	
	-- Reset the draw origin, just in case (allowing HUD elements to re-appear correctly)
	ClearDrawOrigin()
	alcao("GoFast:MessagePolice")
	alcao("GoFast:MessageSheriff")
	GoFastBlips()
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 1)
end


function GoFastBlips()
	BlipsGoFast = AddBlipForCoord(GoFastVente.coords)
	SetBlipSprite(BlipsGoFast, 272)
	SetBlipScale(BlipsGoFast, 0.85) -- set scale
	SetBlipColour(BlipsGoFast, 1)
	SetBlipAlpha(BlipsGoFast, 200)
	PulseBlip(BlipsGoFast)

	SetBlipRoute(BlipsGoFast,  true)

	while GoFastEnCours do
		SetBlipAlpha(BlipsGoFast, 200)
		Wait(1000)
	end
end

function FinDeGoFast()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn( ped, false )
	local plate = GetVehicleNumberPlateText(vehicle)
	print(plate)
	if plate == ' GOFAST ' then
		ESX.ShowAdvancedNotification("GoFast", "~b~Livraison GoFast", "laisse le véhicule se garrer tout seul.", "CHAR_LESTER_DEATHWISH", 8)
		TaskVehiclePark(ped, vehicle, 101.661, 6624.771, 31.82, 44.52, 0, 20.0, false)
-- Cam
		local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		--CreateCam(camera, true)
		SetCamCoord(camera, 118.09, 6600.47, 34.04)
		PointCamAtEntity(camera, ped, 0, 0, 0, 1)
		RenderScriptCams(1, 1, 1000, 1, 1)
		SetCamShakeAmplitude(camera, 3.0)
		Wait(8000)
		RenderScriptCams(0, 1, 1000, 1, 1)
		DestroyCam(camera, true)
		
-- Fin cam
		SetVehicleEngineOn(vehicle, false, false, true)
		TaskLeaveAnyVehicle(ped, 1, 1)
		SetVehicleDoorsLocked(vehicle, 2)
-- Ouverture de toute les portes
		Wait(4000)
		SetVehicleDoorOpen(vehicle, 0, false, false)
		SetVehicleDoorOpen(vehicle, 1, false, false)
		SetVehicleDoorOpen(vehicle, 2, false, false)
		SetVehicleDoorOpen(vehicle, 3, false, false)
		SetVehicleDoorOpen(vehicle, 4, false, false)
		SetVehicleDoorOpen(vehicle, 5, false, false)
		SetVehicleDoorOpen(vehicle, 6, false, false)
		SetVehicleDoorOpen(vehicle, 7, false, false)
		ESX.ShowAdvancedNotification("SweetyLife", "~b~Livraison GoFast", "Calcule du butin en cours ...", "CHAR_LESTER_DEATHWISH", 8)
		FreezeEntityPosition(ped, true)
		Wait(6000)
		RemoveBlip(BlipsGoFast)
		local playerPed = PlayerPedId()
		local bonus = GetVehicleEngineHealth(vehicle)
		--alcao("GoFastHere")
		alcao("Razzway:MerciAuxClientsFidèles", bonus)
		--alcao("toutedesputes")
		FreezeEntityPosition(ped, false)
		ESX.Game.DeleteVehicle(vehicle)
		--PlaySoundFrontend(-1, "MP_WAVE_COMPLETE", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 1)
		GoFastEnCours = false
		clegal = false
	else
		ESX.ShowAdvancedNotification("SweetyLife", "~b~Livraison GoFast", "Hein ? C'est quoi ça ? C'est pas la voiture du GoFast !", "CHAR_LESTER_DEATHWISH", 8)
		PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 1)
	end
	--caca = false
end
