ESX = nil
local _wheel = nil
local _baseWheel = nil
local _lambo = nil
local _isShowCar = false
local _isRolling = false

local object_model = "vw_prop_vw_luckywheel_01a"
local object_model2 = "vw_prop_vw_luckywheel_02a"

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end

    local iter_for_request = 1
    while not HasModelLoaded(object_model) and iter_for_request < 5 do
        Citizen.Wait(500)				
        iter_for_request = iter_for_request + 1
    end
    _baseWheel = CreateObjectNoOffset(object_model, 223.010, -897.405, 29.60, 1, 0, 1)
    SetEntityHeading(_baseWheel , 150.0)
    PlaceObjectOnGroundProperly(_baseWheel)
    FreezeEntityPosition(_baseWheel ,true)
    SetModelAsNoLongerNeeded(object_model)

    local iter_for_request2 = 1
    while not HasModelLoaded(object_model2) and iter_for_request2 < 5 do
        Citizen.Wait(500)				
        iter_for_request2 = iter_for_request2 + 1
    end
    _wheel = CreateObjectNoOffset(object_model2, 223.010, -897.405, 31.10, 1, 0, 1)
    SetEntityHeading(_wheel, 150.0)
    PlaceObjectOnGroundProperly(_wheel)
    FreezeEntityPosition(_wheel,true)
    SetModelAsNoLongerNeeded(object_model2)
    

    _lambo = object_model
end)

Citizen.CreateThread(function() 
    while true do
        if _lambo ~= nil then
            local _heading = GetEntityHeading(_lambo)
            local _z = _heading - 0.3
            SetEntityHeading(_lambo, _z)
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent("Razzway:zd454z5dzd4z5")
AddEventHandler("Razzway:zd454z5dzd4z5", function(_priceIndex) 
    _isRolling = true
    SetEntityHeading(_wheel, 150.0)
    SetEntityRotation(_wheel, 0.0, 0.0, 150.0, 1, true)
    Citizen.CreateThread(function()
        local speedIntCnt = 1
        local rollspeed = 1.0
        local _winAngle = (_priceIndex - 1) * 18
        local _rollAngle = _winAngle + (360 * 8)
        local _midLength = (_rollAngle / 2)
        local intCnt = 0
        while speedIntCnt > 0 do
            local retval = GetEntityRotation(_wheel, 1)
            if _rollAngle > _midLength then
                speedIntCnt = speedIntCnt + 1
            else
                speedIntCnt = speedIntCnt - 1
                if speedIntCnt < 0 then
                    speedIntCnt = 0
                    
                end
            end
            intCnt = intCnt + 1
            rollspeed = speedIntCnt / 10
            local _y = retval.y - rollspeed
            _rollAngle = _rollAngle - rollspeed
			SetEntityHeading(_wheel, 150.0)
            SetEntityRotation(_wheel, 0.0, _y, 150.0, 2, true)
            Citizen.Wait(5)
        end
    end)
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(223.53, -896.68, 30.69)

	SetBlipSprite (blip, 266)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.95)
	SetBlipColour (blip, 83)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Roue de la Fortune")
	EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("Razzway:ougahugahuhzid")
AddEventHandler("Razzway:ougahugahuhzid", function() 
    _isRolling = false
end)


Citizen.CreateThread(function()
    while true do
        local interval = 1
        local pos = GetEntityCoords(PlayerPedId())
        local dest = vector3(223.010, -897.405, 30.692)
        local distance = GetDistanceBetweenCoords(pos, dest, true)
        if distance > 30 then
            interval = 200
        else
            interval = 1
            --DrawMarker(29, 223.010, -897.405, 30.692, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
            if distance < 3 then  
                AddTextEntry("HELP", "Appuyez sur ~b~E ~s~pour lancer la roue de la ~b~Fortune ~s~!")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustReleased(0, 51) then
                    TriggerServerEvent("Razzway:kll5ili5im4illi5", GetPlayerName(PlayerId()))
                end
            end
        end

        Citizen.Wait(interval)
    end
end)

RegisterNetEvent("Razzway:945efef475efef1e4")
AddEventHandler("Razzway:945efef475efef1e4", function()
    if not _isRolling then
        _isRolling = true
        local playerPed = PlayerPedId()
        local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
        if IsPedMale(playerPed) then
            _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
        end
        local lib, anim = _lib, 'enter_right_to_baseidle'
        ESX.Streaming.RequestAnimDict(lib, function()
            local _movePos = vector3(224.415, -897.142, 30.692)
            TaskGoStraightToCoord(playerPed,  _movePos.x,  _movePos.y,  _movePos.z,  1.0,  150,  0.0,  0.0)
            local _isMoved = false
            while not _isMoved do
                local coords = GetEntityCoords(PlayerPedId())
                if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
                    _isMoved = true
                end
                Citizen.Wait(0)
            end
            SetEntityHeading(playerPed , 150.0)
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TaskPlayAnim(playerPed, lib, 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
            while IsEntityPlayingAnim(playerPed, lib, 'enter_to_armraisedidle', 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerServerEvent("Razzway:ch45tyuhyy477j5yj5")
            TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
    end
end)

RegisterNetEvent("Razzway:vg47821gg4z5")
AddEventHandler("Razzway:vg47821gg4z5", function() 
    
    ESX.Game.SpawnVehicle("ztype", { x = 218.98,y = -893.33, z = 30.69 }, 316.74, function (vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        local newPlate     = GeneratePlate()
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        vehicleProps.plate = newPlate
        SetVehicleNumberPlateText(vehicle, newPlate)

        TriggerServerEvent('::{razzway.xyz}::esx_vehicleshop:setVehicleOwned', vehicleProps)

        ESX.ShowNotification("Félicitation ! Vous avez remporté la voiture !")
    end)

    FreezeEntityPosition(playerPed, false)
    SetEntityVisible(playerPed, true)
end)