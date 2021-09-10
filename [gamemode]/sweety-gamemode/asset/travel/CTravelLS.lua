ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RMenu.Add('razzcayoo', 'menucayoo', RageUI.CreateMenu("~b~Express Travel", "~b~Voici notre destination"))

-- FONCTION CUTSCENE
function LoadCutscene(cut, flag1, flag2)
  if (not flag1) then
    RequestCutscene(cut, 8)
  else
    RequestCutsceneEx(cut, flag1, flag2)
  end
  while (not HasThisCutsceneLoaded(cut)) do Wait(0) end
  return
end

local function BeginCutsceneWithPlayer()
  local plyrId = PlayerPedId()
  local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1)

  SetBlockingOfNonTemporaryEvents(playerClone, true)
  SetEntityVisible(playerClone, false, false)
  SetEntityInvincible(playerClone, true)
  SetEntityCollision(playerClone, false, false)
  FreezeEntityPosition(playerClone, true)
  SetPedHelmet(playerClone, false)
  RemovePedHelmet(playerClone, true)

  SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
  RegisterEntityForCutscene(plyrId, 'MP_1', 0, GetEntityModel(plyrId), 64)

  Wait(10)
  StartCutscene(0)
  Wait(10)
  ClonePedToTarget(playerClone, plyrId)
  Wait(10)
  DeleteEntity(playerClone)
  Wait(50)
  DoScreenFadeIn(250)

  return playerClone
end

local function Finish(timer)
  local tripped = false

  repeat
    Wait(0)
    if (timer and (GetCutsceneTime() > timer))then
      DoScreenFadeOut(250)
      tripped = true
    end

    if (GetCutsceneTotalDuration() - GetCutsceneTime() <= 250) then
      DoScreenFadeOut(250)
      tripped = true
    end
  until not IsCutscenePlaying()
  if (not tripped) then
    DoScreenFadeOut(100)
    Wait(150)
  end
  return
end

local landAnim = {1, 2, 4}
local timings = {
  [1] = 9100,
  [2] = 17500,
  [4] = 25400
}

function BeginLeaving(isIsland)
  if (isIsland) then
    RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)

    LoadCutscene('hs4_nimb_isd_lsa', 8, 24)
    BeginCutsceneWithPlayer()
    Finish()
    RemoveCutscene()
  else
    RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)

    LoadCutscene('hs4_lsa_take_nimb2')
    BeginCutsceneWithPlayer()

    Finish()
    RemoveCutscene()

    if (ConfigLocation.Cutscenes.long) then
      LoadCutscene('hs4_nimb_lsa_isd', 128, 24)
      BeginCutsceneWithPlayer()
      Finish(165000)

      LoadCutscene('hs4_nimb_lsa_isd', 256, 24)
      BeginCutsceneWithPlayer()
      Finish(170000)

      LoadCutscene('hs4_nimb_lsa_isd', 512, 24)
      BeginCutsceneWithPlayer()
      Finish(175200)
      RemoveCutscene()
    end
  end
end

function BeginLanding(isIsland)
  if (isIsland) then
    RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)
    local flag = landAnim[ math.random( #landAnim ) ]
    LoadCutscene('hs4_lsa_land_nimb', flag, 24)
    BeginCutsceneWithPlayer()
    Finish(timings[flag])
    RemoveCutscene()
  else
    LoadCutscene('hs4_nimb_lsa_isd_repeat')

    RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)
    BeginCutsceneWithPlayer()

    Finish()
    RemoveCutscene()
  end
end

CreateThread(function()
    while true do
        Wait(1)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), 4435.43, -4485.0, 4.29)
        if Distance < 500.0 then
            if Distance < 1 then
                AddTextEntry("HELP", "Appuyer sur ~INPUT_PICKUP~ pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 38) then
                    RageUI.Visible(RMenu:Get('razzcayoo', 'menucayoo'), true)
                    local IsCayooMenuOpen = true
                    while IsCayooMenuOpen do
                        Wait(1)
                        if not RageUI.Visible(RMenu:Get('razzcayoo', 'menucayoo')) then
                            IsCayooMenuOpen = false
                        end

                        RageUI.IsVisible(RMenu:Get('razzcayoo', 'menucayoo'), true, true, true, function()

                            RageUI.ButtonWithStyle("Aller à Los Santos", nil, { RightLabel = "~b~10000$" }, true, function(h, a, s)
                                if s then
                                    RageUI.CloseAll()
                                    ESX.TriggerServerCallback('razzouvoyage:givemoney', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            local plyrId = PlayerPedId()
                                            local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1)
                                            DoScreenFadeIn(250) --- ecran blanc de 250 milliseconde
                                            RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)
                                            LoadCutscene('hs4_nimb_isd_lsa', 8, 24)
                                            BeginCutsceneWithPlayer()
                                            Finish()
                                            RemoveCutscene()
                                            Wait(10)
                                            StartCutscene(0)
                                            Wait(10)
                                            ClonePedToTarget(playerClone, plyrId)
                                            Wait(10)
                                            DeleteEntity(playerClone)
                                            DoScreenFadeIn(10000) --- ecran blanc de 250 milliseconde
                                            RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)
                                            local flag = landAnim[ math.random( #landAnim ) ]
                                            LoadCutscene('hs4_lsa_land_nimb', flag, 24)
                                            BeginCutsceneWithPlayer()
                                            Finish(timings[flag])
                                            RemoveCutscene()   
                                            Wait(2000) --- temps de la custscene
                                            StopCutsceneImmediately()
                                            DoScreenFadeOut(1000)
                                            StartPlayerTeleport(PlayerId(), -1037.91, -2738.24, 20.17, 10.94, true, true, false)
                                            Wait(10)
                                            StartCutscene(0)
                                            Wait(10)
                                            ClonePedToTarget(playerClone, plyrId)
                                            Wait(10)
                                            DeleteEntity(playerClone)
                                            Wait(50)
                                            DoScreenFadeIn(10000)
                                        else
                                            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
                                        end
                                    end)
                                end
                            end)
                        end, function()end, 1)
                    end
                end
            end
        else
            Wait(5000)
        end
    end
end)

--------- PED & BLIPS -----------

DecorRegister("AIRPORT LE PORT", 4)
pedHash777 = "s_m_m_security_01"
zone777 = vector3(4435.11, -4484.13, 3.3)
Heading777 = 195.79
Ped777 = nil
HeadingSpawn777 = 315.00

Citizen.CreateThread(function()
    LoadModel(pedHash777)
    Ped777 = CreatePed(2, GetHashKey(pedHash777), zone777, Heading777, 0, 0)
    DecorSetInt(Ped777, "AIRPORT LE PORT", 5431)
    FreezeEntityPosition(Ped777, 1)
    TaskStartScenarioInPlace(Ped777, "WORLD_HUMAN_CLIPBOARD", 0, false)
    SetEntityInvincible(Ped777, true)
    SetBlockingOfNonTemporaryEvents(Ped777, 1)

    local blip777 = AddBlipForCoord(zone777)
    SetBlipSprite(blip777, 467)
    SetBlipScale(blip777, 0.6)
    SetBlipShrink(blip777, true)
    SetBlipColour(blip777, 61)
    SetBlipAsShortRange(blip777, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Retour Los Santos")
    EndTextCommandSetBlipName(blip777)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end