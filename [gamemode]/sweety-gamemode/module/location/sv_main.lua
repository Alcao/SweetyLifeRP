getESX(function()
end)

local Locations = {
	Positions = {
		{
			blip = {sprite = 530, colour = 5, pos = vector3(-404.00299072266, 1199.9279785156, 325.0), label = "Arrivé"},
			ped = {"a_m_m_eastsa_02", vector3(-404.00299072266, 1199.9279785156, 325.0), 157.67909240723},
			posLoc = vector3(-404.00299072266, 1199.9279785156, 326.0),
			posSpawn = {
				[0] = {pos = vector3(-399.87, 1197.04, 325.64), heading = 340.89},
				[1] = {pos = vector3(-398.25, 1202.82, 325.64), heading = 344.96},
				[2] = {pos = vector3(-396.46, 1209.17, 325.64), heading = 344.39},
				[3] = {pos = vector3(-394.67, 1214.87, 325.64), heading = 342.56},
				[4] = {pos = vector3(-403.95, 1218.57, 325.64), heading = 164.07},
				[5] = {pos = vector3(-405.64, 1212.60, 325.64), heading = 163.72},
				[6] = {pos = vector3(407.17, 1207.022, 325.64), heading = 159.61},
				[7] = {pos = vector3(-408.74, 1200.96, 325.64), heading = 161.43}
			},
		}
	},
	Vehicles = {
		{name = "panto", price = 25}
	}
}

local function CheckSpawning(zones)
	local found = false
	local count = 0
	for k,v in pairs(zones) do
        local clear = ESX.Game.IsSpawnPointClear(v.pos, 2.0)
		if clear then
			found = v
			break
		end
	end
	return found
end

local function openLocation(table)
	local mainMenu = RageUI.CreateMenu("Location", "Véhicules", 80, 90)

	RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

	while mainMenu do
		Wait(1)
	
		RageUI.IsVisible(mainMenu, function()
		
			for k,v in pairs(Locations.Vehicles) do
				RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.name)).." ("..v.price.."~g~$~s~)", nil, {RightLabel = "Louer~s~ →"}, true, {
                    onSelected = function()
                        local pos = CheckSpawning(table.posSpawn)
                        if pos ~= false then
							SwLife.InternalToServer("fLocation:buyVehicle", v.name, pos)
                        else
                            ESX.ShowNotification("Aucun point de sortie disponible")
                        end
                    end,
				})
			end

		end)

		if not RageUI.Visible(mainMenu) then
			mainMenu = RMenu:DeleteType("menu", true)
		end

	end 

end

local peds = {}

Citizen.CreateThread(function()

	-- Blip and Ped 
	for k,v in pairs(Locations.Positions) do
		-- Blip ↓
		local blip = AddBlipForCoord(v.blip.pos)
		SetBlipSprite (blip, v.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.8)
        SetBlipColour (blip, v.blip.colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("[Location] "..v.blip.label)
        EndTextCommandSetBlipName(blip)     
		
		-- Ped ↓
		local model = GetHashKey(v.ped[1])
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
		local ped = CreatePed(4, model, v.ped[2], v.ped[3], false, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true)
		table.insert(peds, ped)
	end
	
	-- Boucle
	while true do
		local myCoords = GetEntityCoords(PlayerPedId())
		local nofps = false

		for k,v in pairs(Locations.Positions) do
			if #(myCoords-v.posLoc) < 2.0 then
				nofps = true
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acceder à la location.")
				if IsControlJustReleased(0, 54) then
					openLocation(v)
				end
			end
		end

		if nofps then
			Wait(1)
		else
			Wait(850) 
		end
	end 

end)

RegisterNetEvent('fLocation:spawnVehicle')
AddEventHandler('fLocation:spawnVehicle', function(vehicle, table)
	if IsModelInCdimage(vehicle) then
		local playerCoords, playerHeading = vector3(table.pos.x, table.pos.y, table.pos.z), table.heading
		local model = GetHashKey(vehicle)
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
		CreateVehicle(model, playerCoords, playerHeading, true, true)
	end
end)

AddEventHandler("onResourceStop", function(name)
	if name == GetCurrentResourceName() then
		for k,v in pairs(peds) do
			if DoesEntityExist(v) then
				DeleteEntity(v)
			end
		end
	end
end)