local sexeSelect = 0
local teteSelect = 0
local colorPeauSelect = 0
local cheveuxSelect = 0
local bebarSelect = -1
local poilsCouleurSelect = 0
local ImperfectionsPeau = 0
local face, acne, skin, eyecolor, skinproblem, freckle, wrinkle, hair, haircolor, eyebrow, beard, beardcolor
local camfin = false

local playerPed = PlayerPedId()
local incamera = false
local board_scaleform
local handle
local board
local board_model = GetHashKey("prop_police_id_board")
local board_pos = vector3(0.0,0.0,0.0)
local overlay
local overlay_model = GetHashKey("prop_police_id_text")
local isinintroduction = false
local pressedenter = false
local introstep = 0
local timer = 0
local inputgroups = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31}
local enanimcinematique = false
local guiEnabled = false
local sound = false
local FirstSpawn     = true
local LastSkin       = nil
local PlayerLoaded   = false
local sound = false

Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            TriggerEvent('::{razzway.xyz}::esx_status:setDisplay', 0.0)
            DisplayRadar(false)
            DisableControlAction(0, 1,   true) -- LookLeftRight
            DisableControlAction(0, 2,   true) -- LookUpDown
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 30,  true) -- MoveLeftRight
            DisableControlAction(0, 31,  true) -- MoveUpDown
            DisableControlAction(0, 21,  true) -- disable sprint
            DisableControlAction(0, 24,  true) -- disable attack
            DisableControlAction(0, 25,  true) -- disable aim
            DisableControlAction(0, 47,  true) -- disable weapon
            DisableControlAction(0, 58,  true) -- disable weapon
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 166, true) -- disable F5
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(2, 37, true) -- disable melee
            DisableControlAction(0, 75,  true) -- disable exit vehicle
            DisableControlAction(27, 75, true) -- disable exit vehicle
        end
        Citizen.Wait(500)
    end
end)

function destorycam()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end

function spawncinematiqueplayer(a)
    DisplayRadar(false)
    TriggerEvent('::{razzway.xyz}::esx_status:setDisplay', 0.0)
    guiEnabled = true
    local playerPed = PlayerPedId()
    pressedenter = true
    local introcam
    SetEntityVisible(playerPed, false, false)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    SetFocusEntity(playerPed)
    Wait(1)
    SetOverrideWeather("EXTRASUNNY")
    NetworkOverrideClockTime(19, 0, 0)
    BeginSrl()
    introstep = 1
    isinintroduction = true
    Wait(1)
    DoScreenFadeIn(500)
    if introstep == 1 then
        introcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
        SetCamActive(introcam, true)
        SetCamCoord(introcam, 701.47, 1031.08, 330.57)
        ShakeCam(introcam, "HAND_SHAKE", 0.1)
        SetCamRot(introcam, -0, -0, -11.48)
        SetCamActive(introcam, true)
        RenderScriptCams(1, 0, 500, false, false)
        return
    end
end

function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end

local Razzway = {}

local waitenterspawn = 500

RMenu.Add('rz-spawn', 'main', RageUI.CreateMenu("SweetyLife", "~b~Bienvenue parmi nous."))
RMenu:Get('rz-spawn', 'main').EnableMouse = false
RMenu:Get('rz-spawn', 'main').Closed = function()
    Razzway.Visible = false
    ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin, jobSkin)
        if skin ~= nil then
            TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin)
            spawncinematiqueplayer()
            RazzwaySpawnMenu()
        end
    end)
end

function RazzwaySpawnMenu()

    if Razzway.Visible then
        Razzway.Visible = false
    else
        Razzway.Visible = true
        RageUI.Visible(RMenu:Get('rz-spawn', 'main'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        SwLife.newThread(function()
			while Razzway.Visible do
                RageUI.IsVisible(RMenu:Get('rz-spawn', 'main'), true, true, true, function()
                    RageUI.ButtonWithStyle("Entrez dans la ville", "La légende raconte que SweetyLife est le meilleur serveur Free-Access de tous les temps.", {RightLabel = "→→"}, true, function(h,a,s)
                        if s then
                            SpawnEntrer()
                        end
                    end)
                end)
                Wait(0)
            end
		end)
	end
end

function SpawnEntrer()
    local playerPed = PlayerPedId()
    DoScreenFadeOut(1500)
    Wait(3000)
    RageUI.CloseAll()
    StartAudioScene("MP_LEADERBOARD_SCENE")
    PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    ESX.ShowNotification("~b~Connexion au vocal établie.")
    ESX.ShowNotification("~b~Vous avez été replacé à votre ancienne position.")
    destorycam()
    spawncinematiqueplayer(false)
    enanimcinematique = false
    guiEnabled = false
    isinintroduction = false
    TriggerEvent("playerSpawned")
    SetEntityVisible(playerPed, true, false)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    DestroyCam(createdCamera, 0)
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
    DoScreenFadeIn(1500)
    DisplayRadar(true)
    TriggerEvent('::{razzway.xyz}::esx_status:setDisplay', 0.5)
end

RegisterNetEvent('::{razzway.xyz}::esx:playerLoaded')
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(xPlayer)
	PlayerLoaded = true
end)

AddEventHandler('playerSpawned', function()
	SwLife.newThread(function()
		while not PlayerLoaded do
			Citizen.Wait(10)
		end
		if FirstSpawn then
			ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin ~= nil then
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin)
                    spawncinematiqueplayer()
                    RazzwaySpawnMenu()
				end
			end)
			FirstSpawn = false
		end
	end)
end)
