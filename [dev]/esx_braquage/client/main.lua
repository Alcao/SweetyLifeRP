-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local holdingup = false
local holdingup2 = false
local bank = ''
local store = ""
local secondsRemaining = 0
local blipRobbery = nil
local vetrineRotte = 0 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentSubstringPlayerName(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('::{razzway.xyz}::esx_holdupbank:currentlyrobbing')
AddEventHandler('::{razzway.xyz}::esx_holdupbank:currentlyrobbing', function(robb)
	holdingup = true
	bank = robb
	secondsRemaining = 900
end)

RegisterNetEvent('::{razzway.xyz}::esx_holdupbank:killblip')
AddEventHandler('::{razzway.xyz}::esx_holdupbank:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('::{razzway.xyz}::esx_holdupbank:setblip')
AddEventHandler('::{razzway.xyz}::esx_holdupbank:setblip', function(position)
	blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
	
    SetBlipSprite(blipRobbery, 161)
    SetBlipScale(blipRobbery, 2.0)
	SetBlipColour(blipRobbery, 3)

    PulseBlip(blipRobbery)
end)

RegisterNetEvent('::{razzway.xyz}::esx_holdupbank:toofarlocal')
AddEventHandler('::{razzway.xyz}::esx_holdupbank:toofarlocal', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	secondsRemaining = 900 -- 0
	incircle = false
end)


RegisterNetEvent('::{razzway.xyz}::esx_holdupbank:robberycomplete')
AddEventHandler('::{razzway.xyz}::esx_holdupbank:robberycomplete', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_complete') .. Banks[bank].reward)
	bank = ""
	secondsRemaining = 900 -- 0
	incircle = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if holdingup then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end
	end
end)

Citizen.CreateThread(function()
	for k, v in pairs(Banks) do
		local blip = AddBlipForCoord(v.position)

		SetBlipSprite(blip, 255)
		SetBlipScale(blip, 0.6)
		SetBlipColour(blip, 75)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(_U('bank_robbery'))
		EndTextCommandSetBlipName(blip)
	end
end)

incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(PlayerPedId(), false)

		for k, v in pairs(Banks) do
			if Vdist(pos, v.position) < 15.0 then
				if not holdingup then
					DrawMarker(1, v.position.x, v.position.y, v.position.z - 1.05, 0, 0, 0, 0, 0, 0, 1.50, 1.50, 1.00, 255, 0, 0,255, 0, 0, 0,0)

					if Vdist(pos, v.position) < 1.5 then
						if not incircle then
							DisplayHelpText(_U('press_to_rob') .. v.nameofbank)
						end

						incircle = true

						if IsControlJustReleased(0, 51) then
							TriggerServerEvent('::{razzway.xyz}::esx_holdupbank:rob', k)
						end
					elseif Vdist(pos, v.position) > 1.5 then
						incircle = false
					end
				end
			end
		end

		if holdingup then
			drawTxt(0.66, 1.44, 1.0, 1.0, 0.4, _U('robbery_of') .. secondsRemaining .. _U('seconds_remaining'), 255, 255, 255, 255)

			if Vdist(pos, Banks[bank].position) > 7.5 then
				TriggerServerEvent('::{razzway.xyz}::esx_holdupbank:toofar', bank)
			end
		end

		Citizen.Wait(1)
	end
end)

-- Bijouterie
local vetrine = {
	{x = 147.085, y = -1048.612, z = 29.346, heading = 70.326, isOpen = false},--
	{x = -626.735, y = -238.545, z = 38.057, heading = 214.907, isOpen = false},--
	{x = -625.697, y = -237.877, z = 38.057, heading = 217.311, isOpen = false},--
	{x = -626.825, y = -235.347, z = 38.057, heading = 33.745, isOpen = false},--
	{x = -625.77, y = -234.563, z = 38.057, heading = 33.572, isOpen = false},--
	{x = -627.957, y = -233.918, z = 38.057, heading = 215.214, isOpen = false},--
	{x = -626.971, y = -233.134, z = 38.057, heading = 215.532, isOpen = false},--
	{x = -624.433, y = -231.161, z = 38.057, heading = 305.159, isOpen = false},--
	{x = -623.045, y = -232.969, z = 38.057, heading = 303.496, isOpen = false},--
	{x = -620.265, y = -234.502, z = 38.057, heading = 217.504, isOpen = false},--
	{x = -619.225, y = -233.677, z = 38.057, heading = 213.35, isOpen = false},--
	{x = -620.025, y = -233.354, z = 38.057, heading = 34.18, isOpen = false},--
	{x = -617.487, y = -230.605, z = 38.057, heading = 309.177, isOpen = false},--
	{x = -618.304, y = -229.481, z = 38.057, heading = 304.243, isOpen = false},--
	{x = -619.741, y = -230.32, z = 38.057, heading = 124.283, isOpen = false},--
	{x = -619.686, y = -227.753, z = 38.057, heading = 305.245, isOpen = false},--
	{x = -620.481, y = -226.59, z = 38.057, heading = 304.677, isOpen = false},--
	{x = -621.098, y = -228.495, z = 38.057, heading = 127.046, isOpen = false},--
	{x = -623.855, y = -227.051, z = 38.057, heading = 38.605, isOpen = false},--
	{x = -624.977, y = -227.884, z = 38.057, heading = 48.847, isOpen = false},--
	{x = -624.056, y = -228.228, z = 38.057, heading = 216.443, isOpen = false},--
}

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

end

function DisplayHelpTextRobbery(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("mt:missiontext")
AddEventHandler("mt:missiontext", function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end)

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('::{razzway.xyz}::esx_vangelico_robbery:currentlyrobbing')
AddEventHandler('::{razzway.xyz}::esx_vangelico_robbery:currentlyrobbing', function(robb)
	holdingup2 = true
	store = robb
end)

RegisterNetEvent('::{razzway.xyz}::esx_vangelico_robbery:killblip')
AddEventHandler('::{razzway.xyz}::esx_vangelico_robbery:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('::{razzway.xyz}::esx_vangelico_robbery:setblip')
AddEventHandler('::{razzway.xyz}::esx_vangelico_robbery:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
end)

RegisterNetEvent('::{razzway.xyz}::esx_vangelico_robbery:toofarlocal')
AddEventHandler('::{razzway.xyz}::esx_vangelico_robbery:toofarlocal', function(robb)
	holdingup2 = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	incircle = false
end)


RegisterNetEvent('::{razzway.xyz}::esx_vangelico_robbery:robberycomplete')
AddEventHandler('::{razzway.xyz}::esx_vangelico_robbery:robberycomplete', function(robb)
	holdingup2 = false
	ESX.ShowNotification(_U('robbery_complete2'))
	store = ""
	incircle = false
end)

Citizen.CreateThread(function()
	for k,v in pairs(Stores)do
		local ve = v.position2

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 439)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('shop_robbery'))
		EndTextCommandSetBlipName(blip)
	end
end)

animazione = false
incircle = false
soundid = GetSoundId()

function drawTxt2(x, y, scale, text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.64, 0.64)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
    DrawText(0.155, 0.935)
end

--local borsa = nil

--[[Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)
	  TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
		borsa = skin['bags_1']
	  end)
	  Citizen.Wait(1000)
	end
end)]]

Citizen.CreateThread(function()
      
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(Stores)do
			local pos2 = v.position2

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if not holdingup2 then
					DrawMarker(27, v.position2.x, v.position2.y, v.position2.z-0.9, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)

					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) then
							DisplayHelpText(_U('press_to_rob2'))
						end
						incircle = true
						if IsPedShooting(GetPlayerPed(-1)) then
							if ConfigBraco.NeedBag then
							    --if borsa == 40 or borsa == 41 or borsa == 44 or borsa == 45 then
							        ESX.TriggerServerCallback('::{razzway.xyz}::esx_vangelico_robbery:conteggio', function(CopsConnected)
								        if CopsConnected >= ConfigBraco.RequiredCopsRob then
							                TriggerServerEvent('::{razzway.xyz}::esx_vangelico_robbery:rob', k)
									        PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", pos2.x, pos2.y, pos2.z)
								        else
									        TriggerEvent('::{razzway.xyz}::esx:showNotification', _U('min_two_police') .. ConfigBraco.RequiredCopsRob .. _U('min_two_police2'))
								        end
							        end)		
						       -- else
							        --TriggerEvent('::{razzway.xyz}::esx:showNotification', _U('need_bag'))
								--end
							else
								ESX.TriggerServerCallback('::{razzway.xyz}::esx_vangelico_robbery:conteggio', function(CopsConnected)
									if CopsConnected >= ConfigBraco.RequiredCopsRob then
										TriggerServerEvent('::{razzway.xyz}::esx_vangelico_robbery:rob', k)
										PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", pos2.x, pos2.y, pos2.z)
									else
										TriggerEvent('::{razzway.xyz}::esx:showNotification', _U('min_two_police') .. ConfigBraco.RequiredCopsRob .. _U('min_two_police2'))
									end
								end)	
							end	
                        end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end		
				end
			end
		end

		if holdingup2 then
			drawTxt2(0.3, 1.4, 0.45, _U('smash_case') .. ' :~r~ ' .. vetrineRotte .. '/' .. ConfigBraco.MaxWindows, 185, 185, 185, 255)

			for i,v in pairs(vetrine) do 
				if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 10.0) and not v.isOpen and ConfigBraco.EnableMarker then 
					DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 0, 255, 0, 200, 1, 1, 0, 0)
				end
				if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 0.75) and not v.isOpen then 
					DrawText3D(v.x, v.y, v.z, '~w~[~g~E~w~] ' .. _U('press_to_collect'), 0.6)
					if IsControlJustPressed(0, 38) then
						animazione = true
					    SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z-0.95)
					    SetEntityHeading(GetPlayerPed(-1), v.heading)
						v.isOpen = true 
						PlaySoundFromCoord(-1, "Glass_Smash", v.x, v.y, v.z, "", 0, 0, 0)
					    if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
					    RequestNamedPtfxAsset("scr_jewelheist")
					    end
					    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
					    Citizen.Wait(0)
					    end
					    SetPtfxAssetNextCall("scr_jewelheist")
					    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", v.x, v.y, v.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
					    loadAnimDict( "missheist_jewel" ) 
						TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
						TriggerEvent("::{razzway.xyz}::mt:missiontext", _U('collectinprogress'), 3000)
					    --DisplayHelpText(_U('collectinprogress'))
					    DrawSubtitleTimed(5000, 1)
					    Citizen.Wait(5000)
					    ClearPedTasksImmediately(GetPlayerPed(-1))
					    TriggerServerEvent('::{razzway.xyz}::esx_vangelico_robbery:gioielli')
					    PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					    vetrineRotte = vetrineRotte+1
					    animazione = false

						if vetrineRotte == ConfigBraco.MaxWindows then 
						    for i,v in pairs(vetrine) do 
								v.isOpen = false
								vetrineRotte = 0
							end
							TriggerServerEvent('::{razzway.xyz}::esx_vangelico_robbery:endrob', store)
						    ESX.ShowNotification(_U('lester'))
						    holdingup2 = false
						    StopSound(soundid)
						end
					end
				end
			end


			local pos2 = Stores[store].position2

			if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -622.566, -230.183, 38.057, true) > 11.5 ) then
				TriggerServerEvent('::{razzway.xyz}::esx_vangelico_robbery:toofar', store)
				holdingup2 = false
				for i,v in pairs(vetrine) do 
					v.isOpen = false
					vetrineRotte = 0
				end
				StopSound(soundid)
			end

		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
      
	while true do
		Wait(1)
		if animazione == true then
			if not IsEntityPlayingAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 3) then
				TaskPlayAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 8.0, 8.0, -1, 17, 1, false, false, false)
			end
		end
	end
end)

RegisterNetEvent("lester:createBlip")
AddEventHandler("lester:createBlip", function(type, x, y, z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.6)
	SetBlipAsShortRange(blip, true)
	if(type == 77)then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Lester")
		EndTextCommandSetBlipName(blip)
	end
end)

blip = false

Citizen.CreateThread(function()
	TriggerEvent('::{razzway.xyz}::lester:createBlip', 77, 706.669, -966.898, 30.413)
	while true do
	
		Citizen.Wait(1)
	
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 706.669, -966.898, 30.413, true) <= 10 and not blip then
				DrawMarker(20, 706.669, -966.898, 30.413, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 100, 102, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, 706.669, -966.898, 30.413, true) < 1.0 then
					DisplayHelpText(_U('press_to_sell'))
					if IsControlJustReleased(1, 51) then
						blip = true
						ESX.TriggerServerCallback('::{razzway.xyz}::esx_ambulancejob:getItemAmount', function(quantity)
							if quantity >= ConfigBraco.MaxJewelsSell then
								ESX.TriggerServerCallback('::{razzway.xyz}::esx_vangelico_robbery:conteggio', function(CopsConnected)
									if CopsConnected >= ConfigBraco.RequiredCopsSell then
										FreezeEntityPosition(playerPed, true)
										TriggerEvent('::{razzway.xyz}::mt:missiontext', _U('goldsell'), 10000)
										Wait(10000)
										FreezeEntityPosition(playerPed, false)
										TriggerServerEvent('::{razzway.xyz}::lester:vendita')
										blip = false
									else
										blip = false
										TriggerEvent('::{razzway.xyz}::esx:showNotification', _U('copsforsell') .. ConfigBraco.RequiredCopsSell .. _U('copsforsell2'))
									end
								end)
							else
								blip = false
								TriggerEvent('::{razzway.xyz}::esx:showNotification', _U('notenoughgold'))
							end
						end, 'jewels')
					end
				end
			end
	end
end)

