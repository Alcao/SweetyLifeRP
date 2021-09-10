Event = {
	{
		type = "package",
		message = "Une cargaison de drogue a été trouvée ! Viens la récupérer avant la police!",
		possibleZone = {
			vector3(-2119.944, -494.6833, 3.23038),
			vector3(-2452.462, -305.4738, 3.530489),
			vector3(-1241.547, -1842.904, 2.140611),
			vector3(-1199.163, -1954.809, 4.497078),
			vector3(2826.995, -623.7655, 2.090363),
			vector3(-851.3315, 5767.705, 4.644025),
			vector3(488.5908, -3362.791, 6.069853),
			vector3(1106.406, -2638.728, 10.34015),
		},
		prop = {
			"hei_prop_heist_box",
		},
		item = {
			"weed_pooch",
			"coke_pooch",
			"opium_pooch",
		},
	},
	{
		type = "money",
		message = "Un fourgon blindé vient de se faire pété ! Viens récupérer l'argent avant la police!",
		possibleZone = {
			vector3(-576.4575, 327.1224, 83.9983),
			vector3(-262.2542, 195.8889, 84.50397),
			vector3(-12.40661, -685.8273, 31.66441),
			vector3(40.24453, -868.2159, 30.48704),
			vector3(18.79272, -1073.074, 38.15213),
			vector3(55.42496, -1672.947, 29.29726),
			vector3(776.0305, -2064.744, 29.3819),
			vector3(862.7224, -913.9108, 25.94606),
		},
		prop = {
			"bkr_prop_moneypack_01a",
			"bkr_prop_moneypack_02a",
			"bkr_prop_moneypack_03a",
		},
	},
}


local minute = 60*1000
local eventStarted = true
SwLife.newThread(function()
	while true do
		Wait(2000)
		local i = math.random(1, #Event)
		local randomEvent = Event[i]
		local i = math.random(1, #randomEvent.possibleZone)
		local zone = randomEvent.possibleZone[i]
		TriggerClientEvent("RS_AutoEvents_SendEvent", -1, randomEvent, zone)
		print("\n\n\nDEBUT DE L'EVENT RESELLER\n\n\n")
		Citizen.Wait(10*minute)
		if eventStarted then
			TriggerClientEvent("RS_AutoEvents_StopEvent", -1)
		end
		Citizen.Wait(60*minute)
	end
end)


RegisterNetEvent("RS_AUTOEVENT:Recuperer")
AddEventHandler("RS_AUTOEVENT:Recuperer", function()
	print("\n\n\nFIN DE L'EVENT RESELLER\n\n\n")
	TriggerClientEvent("RS_AutoEvents_StopEvent", -1)
	eventStarted = false
end)

ESX = nil

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

RegisterNetEvent("RS_AUTOEVENT:GetItem")
AddEventHandler("RS_AUTOEVENT:GetItem", function(item, nombre)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item, nombre)
end)

RegisterNetEvent("RS_AUTOEVENT:GetArgent")
AddEventHandler("RS_AUTOEVENT:GetArgent", function(nombre)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('dirtycash', nombre)
end)