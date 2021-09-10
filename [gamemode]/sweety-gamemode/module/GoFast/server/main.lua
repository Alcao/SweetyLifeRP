ESX = nil

-- Gestion GoFast
GoFastDejaFait = 1
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10*60000)
          GoFastDejaFait = GoFastDejaFait + 1
          print(GoFastDejaFait)
          TriggerClientEvent("Sync:GoFast", -1, GoFastDejaFait)
	end
end)

RegisterServerEvent("Sync:MoinUnGoFast")
AddEventHandler("Sync:MoinUnGoFast", function()
     GoFastDejaFait = GoFastDejaFait - 1
     TriggerClientEvent("Sync:GoFast", -1, GoFastDejaFait)
     print(GoFastDejaFait)
     print("-1 gofast")
end)


TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

local toutedesputes = false

function CountCops()
	local xPlayers = ESX.GetPlayers()
	CopsConnected = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
			CopsConnected = CopsConnected + 1
		end
	end
	SetTimeout(120 * 1000, CountCops)
end

CountCops()

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		PrixPolicierVente = CopsConnected * 50
		local r = math.random(100, 300) + PrixPolicierVente
		PrixVente = r
	end
end)

RegisterServerEvent("GoFast:MessagePolice")
AddEventHandler("GoFast:MessagePolice", function()

	local xPlayers	= ESX.GetPlayers()

    -- caca = true

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
          if xPlayer.job.name == 'police' then
               Citizen.Wait(10*1000)
               TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], "Central 911", "~b~Message de l'indic", "D'après mes infos, un GoFast à commencé, rester attentif!", "CHAR_KIRINSPECTEUR", 3)
               print('Message GoFast envoyé à la police')
		end
	end

end)

RegisterServerEvent("Razzway:MerciAuxClientsFidèles")
AddEventHandler("Razzway:MerciAuxClientsFidèles", function(bonus)
     local _source = source
     local xPlayer = ESX.GetPlayerFromId(_source)
     if not xPlayer then return; end
     local bonusFinal = bonus
     local coords = GetEntityCoords(GetPlayerPed(source))
	sellGoFast = vector3(114.87, 6611.87, 31.86)
	ZoneSize = 50.0
     --if caca then
          --if GoFastDejaFait == 0 then
     if #(coords - sellGoFast) < ZoneSize / 2 then
          if CopsConnected < 2 then
               bonusFinal = bonusFinal / 2
          end
          if bonus > 900 then
               TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '🔧~w~Véhicule en parfait état ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
          elseif bonus > 600 then
               TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '🔧~w~Véhicule en états correct ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
          elseif bonus > 400 then
               TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '🔧~w~Véhicule assez abimé ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
          elseif bonus > 100 then
               TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '🔧~w~Véhicule complétement abimé ! Bonus de ~g~'..bonusFinal..'$', 'CHAR_LESTER_DEATHWISH', 3)
          end
          PrixVente = PrixVente + bonusFinal
          xPlayer.addAccountMoney('bank', PrixVente)
          TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'GoFast', '~b~Récompense GoFast', '✅~w~Vous avez gagné ~g~'..PrixVente..'$', 'CHAR_LESTER_DEATHWISH', 3)
          sendToDiscord('Cardinal', '[GOFAST] ' ..xPlayer.getName().. ' vient de gagner ' ..PrixVente..' au GoFast', 2061822)
     else
          TriggerEvent("::{razzway.xyz}::BanSql:ICheatServer", source, "Merci aux clients fidèles :p")
     end
end)

RegisterServerEvent("GoFast:MessageSheriff")
AddEventHandler("GoFast:MessageSheriff", function()

	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
          if xPlayer.job.name == 'sheriff' then
               Citizen.Wait(10*1000)
               TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], "Indic Sheriff", "~b~Message de l'indic", "D'après mes infos, un GoFast à commencé, rester attentif!", "CHAR_JOSEF", 3)
               print('Message GoFast envoyé aux sheriff')
		end
	end

end)

function sendToDiscord (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "https://discord.com/api/webhooks/821837941058830356/npPAD1DX5pAJL9vvKpYa4rFY8HhWTo7XcHgIaR-rzN5kHOCtOLvu1CciI-0u8nbU6Jqf"
	-- Modify here your discordWebHook username = name, content = message,embeds = embeds

local embeds = {
	{
		["title"]=message,
		["type"]="rich",
		["color"] =color,
		["footer"]=  {
			["text"]= "Heure: " ..date_local.. "",
		},
	}
}

	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 