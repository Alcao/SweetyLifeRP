ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(1000)
	end
end)

local AutoEcoleS = {}
local ConfigEcole = {}
local CurrentTest           = nil
local CurrentCheckPoint     = 0
local DriveErrors 		    = 0
local LastCheckPoint        = -1
local CurrentBlip           = nil
local CurrentZoneType       = nil
local IsAboveSpeedLimit     = false
local VehicleHealth     	= nil
local success               = false
local pieton                = false
local startedconduite 		= false
local drivetest = nil
local cvrai = 0
local blockitvoiture = false
local blockitmoto = false
local blockitcamion = false
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
permisencours = ""

function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

-----------------------------------------------------------------------------------------------------------------------

local function StopDriveTest(success)
	if success then
		SwLife.InternalToServer('rz-core:addpermis', permisencours)
		RemoveBlip(CurrentBlip)
		ESX.ShowAdvancedNotification('Mme Pavoshko', '~r~Bravo~w~', 'Vous avez reçu votre permis !', 'CHAR_MOLLY', 'CHAR_MOLLY')
		if DoesEntityExist(GetVehiclePedIsIn(PlayerPedId(), false)) then
			DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
			SetVehicleAsNoLongerNeeded(GetVehiclePedIsIn(PlayerPedId(), false))
		end
		if DoesEntityExist(pedssss) then
			DeleteEntity(pedssss)
		end
	else
		if DoesEntityExist(pedssss) then
			DeleteEntity(pedssss)
		end
		ESX.ShowAdvancedNotification('Mme Pavoshko', '~r~Malheureusement~w~', 'Vous avez raté le test !', 'CHAR_MOLLY', 'CHAR_MOLLY')			
		if DoesEntityExist(GetVehiclePedIsIn(PlayerPedId(), false)) then
			DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
			SetVehicleAsNoLongerNeeded(GetVehiclePedIsIn(PlayerPedId(), false))
		end
	end
	SetEntityCoords(pietonped, 394.12, -111.84, 65.23, false, false, false, true)
	SetEntityHeading(pietonped, 234.62)
	CurrentTest     = nil
	CurrentTestType = nil
end

local function SetCurrentZoneType(type)
    CurrentZoneType = type
end

local CheckPoints = {

	{
		Pos = {x = -2205.33, y = -361.39, z = 13.1},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Allons sur la route, tournez à droite, vitesse limitée à~w~ ~y~80km/h", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -2116.74, y = -376.62, z = 12.9},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Continuez tout droit", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -2028.5, y = -429.92, z = 11.39},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Vous entrez sur l'autoroute, vitesse limitée à ~y~120km/h", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -1023.76, y = -602.17, z = 18.4},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Continuez sur l'autoroute", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -741.91, y = -531.34, z = 25.17},
        Action = function(playerPed, setCurrentZoneType)
            ESX.ShowAdvancedNotification('Mme Pavoshko', 'Tournez !~w~', "Tournez à droite, n'oubliez pas vos clignotants", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -598.49, y = -547.53, z = 25.4},
		Action = function(playerPed, setCurrentZoneType)
            ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien !~w~', "Continuez sur cette voie", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -431.98, y = -682.32, z = 37.23},
		Action = function(playerPed, setCurrentZoneType)
            ESX.ShowAdvancedNotification('Mme Pavoshko', 'Votre Attention~w~', "Préparez vous à prendre la sortie à droite", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -432.0, y = -928.51, z = 34.29},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Continuez tout droit", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = 484.05, y = 39.68, z = 92.18},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Allez vers le prochain passage", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 1
		end
	},	

	{
		Pos = {x = -413.25, y = -1270.02, z = 20.98}, 
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Prenez la prochaine sortie", 'CHAR_MOLLY', 'CHAR_MOLLY') --## 393.65, -111.565, 65.29
			TesOuFDPRendMonQuad = 2
		end
	},
 --
	{
		Pos = {x = -408.93, y = -1404.39, z = 29.4},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Prenez à droite, vitesse limité à ~y~80km/h", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -510.19, y = -1322.81, z = 28.78},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Continuez tout droit", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -530.64, y = -1162.56, z = 19.49},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Tourner à gauche", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -606.18, y = -1248.94, z = 12.14},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Tourner à droite", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -733.64, y = -1163.89, z = 10.67},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Prenez la prochaine à gauche", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -888.26, y = -1173.96, z = 4.76},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Prenez la prochaine à droite", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -996.55, y = -1131.35, z = 2.15},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Ralentissez.", 'CHAR_MOLLY', 'CHAR_MOLLY') -- ici
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -1159.73, y = -859.86, z = 14.15},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Tournez à gauche", 'CHAR_MOLLY', 'CHAR_MOLLY') -- ici
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -1179.65, y = -958.88, z = 3.81},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Continuez tout droit", 'CHAR_MOLLY', 'CHAR_MOLLY') -- ici
			TesOuFDPRendMonQuad = 1
		end
	},

	{
		Pos = {x = -1272.11, y = -899.9, z = 11.21},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Tourner à droite, vitesse limite ~y~120km/h.", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -1516.78, y = -681.49, z = 28.6},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Continuez tout droit.", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -1764.7, y = -545.16, z = 35.52},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Continuez tout droit.", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -2044.87, y = -379.97, z = 10.99},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Dernière ligne droite !", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -2150.22, y = -347.93, z = 13.21},
		Action = function(playerPed, setCurrentZoneType)
			ESX.ShowAdvancedNotification('Mme Pavoshko', 'Bien~w~', "Tourner à gauche !", 'CHAR_MOLLY', 'CHAR_MOLLY')
			TesOuFDPRendMonQuad = 2
		end
	},

	{
		Pos = {x = -2178.44, y = -385.94, z = 13.31},
		Action = function(playerPed, setCurrentZoneType)
			startedconduite = false
			if DriveErrors < 5 then
				StopDriveTest(true)
			else
				StopDriveTest(false)
			end
		end
	},

}


local function GoToTargetWalking()
	pieton = false
	FreezeEntityPosition(pietonped, false)
    TaskGoToCoordAnyMeans(pietonped, 414.1815, -124.91, 63.71, 1.0, 0, 0, 786603, 0xbf800000)
    distanceToTarget = GetDistanceBetweenCoords(pietonped, 414.1815, -124.91, 63.71, true)
    if distanceToTarget <= 1 then
        FreezeEntityPosition(pietonped, true)
    end
end


local function StartConduite()
	startedconduite = true
	while startedconduite do
		Wait(0)

		if CurrentTest == 'drive' then

			if pieton then
				GoToTargetWalking()
			end

			local nextCheckPoint = CurrentCheckPoint + 1

			if CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil

				while not IsPedheadshotReady(RegisterPedheadshot(PlayerPedId())) or not IsPedheadshotValid(RegisterPedheadshot(PlayerPedId())) do
					Wait(100)
				end
		
				BeginTextCommandThefeedPost("PS_UPDATE")
				AddTextComponentInteger(50)
			
				EndTextCommandThefeedPostStats("PSF_DRIVING", 14, 50, 25, false, GetPedheadshotTxdString(RegisterPedheadshot(PlayerPedId())), GetPedheadshotTxdString(RegisterPedheadshot(PlayerPedId())))
			
				EndTextCommandThefeedPostTicker(false, true)
				
				UnregisterPedheadshot(RegisterPedheadshot(PlayerPedId()))

			else

				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(CurrentBlip, 1)

					LastCheckPoint = CurrentCheckPoint
				end

				local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 90.0 then
					DrawMarker(36, CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3.0 then
					CheckPoints[nextCheckPoint].Action(PlayerPedId(), SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end
			end

			----------

			if IsPedInAnyVehicle(GetPlayerPed(-1), false) then

				local vehicle      = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				local speed        = GetEntitySpeed(vehicle) * 3.6
				local tooMuchSpeed = false
				local GetSpeed = math.floor(GetEntitySpeed(vehicle) * 3.6)
				local speed_limit_residence = 50.0
				local speed_limit_ville = 80.0
				local speed_limit_otoroute = 120.0

				local DamageControl = 0

				if TesOuFDPRendMonQuad == 0 and GetSpeed >= speed_limit_residence then
					tooMuchSpeed 	  = true
					DriveErrors       = DriveErrors + 1
					IsAboveSpeedLimit = true
					ESX.ShowAdvancedNotification('Mme Pavoshko', '~r~Vous avez fait une erreur~w~', "Vous roulez trop vite, vitesse limite : " ..speed_limit_residence.. " km/h~w~!\n~r~Nombre d'erreurs " ..DriveErrors.. "/5", 'CHAR_MOLLY', 'CHAR_MOLLY')
					Wait(2000) -- evite bug
				end

				if TesOuFDPRendMonQuad == 1 and GetSpeed >= speed_limit_ville then
					tooMuchSpeed = true
					DriveErrors       = DriveErrors + 1
					IsAboveSpeedLimit = true
					ESX.ShowAdvancedNotification('Mme Pavoshko', '~r~Vous avez fait une erreur~w~', "Vous roulez trop vite, vitesse limite : " ..speed_limit_ville.. " km/h~w~!\n~r~Nombre d'erreurs " ..DriveErrors.. "/5", 'CHAR_MOLLY', 'CHAR_MOLLY')
					Wait(2000)
				end

				if TesOuFDPRendMonQuad == 2 and GetSpeed >= speed_limit_otoroute then
					tooMuchSpeed = true
					DriveErrors       = DriveErrors + 1
					IsAboveSpeedLimit = true
					ESX.ShowAdvancedNotification('Mme Pavoshko', '~r~Vous avez fait une erreur~w~', "Vous roulez trop vite, vitesse limite : " ..speed_limit_otoroute.. " km/h~w~!\n~r~Nombre d'erreurs " ..DriveErrors.. "/5", 'CHAR_MOLLY', 'CHAR_MOLLY')
					Wait(2000)
				end

				if HasEntityCollidedWithAnything(vehicle) and DamageControl == 0 then
					DriveErrors       = DriveErrors + 1
					ESX.ShowAdvancedNotification('Mme Pavoshko', '~r~Vous avez fait une erreur~w~', "Votre vehicule s\'est pris des dégats\n~r~Nombre d'erreurs " ..DriveErrors.. "/5", 'CHAR_MOLLY', 'CHAR_MOLLY')
					Wait(2000)
				end

				if not tooMuchSpeed then
					IsAboveSpeedLimit = false
				end

				if GetEntityHealth(vehicle) < GetEntityHealth(vehicle) then

					DriveErrors = DriveErrors + 1

					ESX.ShowAdvancedNotification('Mme Pavoshko', '~r~Vous avez fait une erreur~w~', "Votre vehicule s\'est pris des dégats\n~r~Nombre d'erreurs " ..DriveErrors.. "/5", 'CHAR_MOLLY', 'CHAR_MOLLY')
					
					VehicleHealth = GetEntityHealth(vehicle)
					Wait(2000)
				end
				if DriveErrors >= 5 then
					CurrentCheckPoint = 10
					RemoveBlip(CurrentBlip)
					SetNewWaypoint(204.82, 377.133)
					DrawMarker(36, 204.82, 377.133, 107.24, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
					local dist = Vdist2(GetEntityCoords(PlayerPedId()), 204.82, 377.133, 107.24)
					if dist <= 2.5 then
						HelpNotif("Appuyez sur ~INPUT_TALK~ pour rendre le véhicule.")
						if IsControlJustPressed(0, 51) then
							StopDriveTest(false)
							DriveErrors = 0
							CurrentCheckPoint = 0
							RemoveBlip(CurrentBlip)
						end
					end
				end
			end
		else -- si jamais il prend pas en compte
			Wait(500)
		end
	end
end

local function StartDriveTest()
	CurrentTest       = 'drive'
	CurrentTestType   = type
	startedconduite = true
    permisencours = "drive"
	drivetest = "voiture"

	ConfigEcole.Zones = {

		VehicleSpawnPoint = {
			Pos = vector3(-2183.35, -413.26, 13.07)
		}
	}

	ESX.Game.SpawnVehicle('blista', ConfigEcole.Zones.VehicleSpawnPoint.Pos, 315.05, function(vehicle)
		local playerPed = PlayerPedId()
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	end)

	RequestModel(0x242C34A7)
    while not HasModelLoaded(0x242C34A7) do
        Wait(100)
	end
	
	pedssss = CreatePedInsideVehicle(veh, 5, 0x242C34A7, 0, true, false)
	SetEntityAsMissionEntity(pedssss, 0, 0)
	ESX.ShowAdvancedNotification('Mme Pavoshko', '~r~Me voila !~w~', 'Tenez votre voiture, bonne route et bonne chance !', 'CHAR_MOLLY', 'CHAR_MOLLY')

	StartConduite()
end

local function StartDriveTestMoto()
	CurrentTest = 'drive'
	startedconduite = true
permisencours = "bike"
	drivetest = "moto"

	ConfigEcole.Zones = {

		VehicleSpawnPoint = {
			Pos = vector3(-2183.35, -413.26, 13.07)
		}
	}

	ESX.Game.SpawnVehicle('bati', ConfigEcole.Zones.VehicleSpawnPoint.Pos, 315.05, function(vehicle)
		local playerPed = PlayerPedId()
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	end)

	RequestModel(0x242C34A7)
    while not HasModelLoaded(0x242C34A7) do
        Wait(100)
	end
	pedssss = CreatePedInsideVehicle(veh, 5, 0x242C34A7, 0, true, false)
	SetEntityAsMissionEntity(pedssss, 0, 0)
	ESX.ShowAdvancedNotification('Mme Pavoshko', '~r~Me voila !~w~', 'Tenez votre moto, bonne route et bonne chance !', 'CHAR_MOLLY', 'CHAR_MOLLY')

	StartConduite()
end

------------------------------------------------------------------------------------------------------------------------

RMenu.Add('rz-permis', 'main', RageUI.CreateMenu("Permis", "~b~Bienvenue à l\'auto-ecole"))
RMenu:Get('rz-permis', 'main').EnableMouse = false

RMenu:Get('rz-permis', 'main').Closed = function() end

function AutoEcoleMenu()

    if AutoEcoleS.Menu then
        AutoEcoleS.Menu = false
    else
        AutoEcoleS.Menu = true
        RageUI.Visible(RMenu:Get('rz-permis', 'main'), true)
		
        SwLife.newThread(function()
			while AutoEcoleS.Menu do
				RageUI.IsVisible(RMenu:Get('rz-permis', 'main'), true, true, true, function()

					RageUI.ButtonWithStyle("Passer le permis voiture", "Passer le permis voiture pour ~b~1200$.", { RightLabel = "1200$" }, true, function(_, _, Selected)
						if Selected then
							StartDriveTest()
							RageUI.CloseAll()
						end
					end)

					RageUI.ButtonWithStyle("Passer le permis moto", "Passer le permis moto pour ~b~1000$.", { RightLabel = "1000$" }, true, function(_, _, Selected)
						if Selected then
							StartDriveTestMoto()
							RageUI.CloseAll()
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end


local AutoEcole = {
    {x = -2187.3, y = -409.25, z = 13.12}
}  

SwLife.newThread(function()
    while true do
        local razzou = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(AutoEcole) do
            local distance = Vdist(pCoords.x, pCoords.y, pCoords.z, AutoEcole[k].x, AutoEcole[k].y, AutoEcole[k].z)
            if not AutoEcoleS.Menu then
                if distance <= 10.0 then
                    razzou = 1
                    --DrawMarker(6, AutoEcole[k].x, AutoEcole[k].y, AutoEcole[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                
                    if distance <= 1.5 then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour parler à la dame")
                        if IsControlJustPressed(0, 51) then
                            AutoEcoleMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(razzou)
    end
end)

CreateThread(function()
    local hash = GetHashKey("a_f_m_bevhills_02")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(2000)
    end
    local ped = CreatePed("PED_TYPE_CIVFEMALE", "a_f_m_bevhills_02", -2187.82, -408.84, 12.15, 231.41, false, true) 
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	
	local blipauto = AddBlipForCoord(-2187.3, -409.25, 13.12)
	SetBlipSprite (blipauto, 498)
	SetBlipDisplay(blipauto, 4)
	SetBlipScale  (blipauto, 0.7)
	SetBlipAsShortRange(blipauto, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Auto Ecole")
	EndTextCommandSetBlipName(blipauto)
end)