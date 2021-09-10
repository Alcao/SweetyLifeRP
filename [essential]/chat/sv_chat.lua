local ESX = nil

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

RegisterServerEvent('__cfx_internal:commandFallback')
AddEventHandler('__cfx_internal:commandFallback', function(command)
	local _source = source
	local name = GetPlayerName(_source)
	TriggerEvent('chatMessage', _source, name, '/' .. command)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, name, {5,300,400}, '/' .. command)
	end

	CancelEvent()
end)

RegisterServerEvent('::{razzway.xyz}::_chat:messageEntered')
AddEventHandler('::{razzway.xyz}::_chat:messageEntered', function(author, color, message)
	local _source = source

	if not message or not author then
		return
	end

	TriggerEvent('chatMessage', _source, author, message)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, author, {5,300,400}, message)
	end

	print(author .. '^7: ' .. message .. '^7')
end)

AddEventHandler('onServerResourceStart', function(resName)
	Citizen.Wait(500)
	local players = GetPlayers()

	for i = 1, #players, 1 do
		refreshCommands(players[i])
	end
end)

function refreshCommands(playerId)
	local registeredCommands = GetRegisteredCommands()
	local suggestions = {}

	for i = 1, #registeredCommands do
		if IsPlayerAceAllowed(playerId, ('command.%s'):format(registeredCommands[i].name)) then
			table.insert(suggestions, {
				name = '/' .. registeredCommands[i].name,
				help = ''
			})
		end
	end

	TriggerClientEvent('chat:addSuggestions', playerId, suggestions)
end

RegisterCommand('say', function(source, args, rawCommand)
	if source == 0 then
		TriggerClientEvent('chatMessage', -1, 'CONSOLE', {5,300,400}, rawCommand:sub(5))
	end
end, true)

RegisterCommand('twt', function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= GetPlayers(id)
        for i=1, #xPlayers, 1 do
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], '~b~Twitter', ''..name..'', ''..msg..'', 'CHAR_STRETCH', 0)
        end
        sendToDiscord('SweetyLife', '[MESSAGE] ' ..name.. ' Vient de twitter : ' ..msg..' . ', 15158332)
    end
end, false)

RegisterCommand('ist', function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= GetPlayers(id)
        for i=1, #xPlayers, 1 do
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'Instagram', ''..name..'', ''..msg..'', 'CHAR_BARRY', 0)
        end
        sendToDiscord('SweetyLife', '[MESSAGE] ' ..name.. ' Vient de poster sur instagram : ' ..msg..' . ', 15158332)
    end
end, false)

RegisterCommand('ano', function(source, args, rawCommand)
    local src = source
	local msg = rawCommand:sub(5)
	local args = msg
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= GetPlayers(id)
        for i=1, #xPlayers, 1 do
			TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'Anonyme', '', ''..msg..'', 'CHAR_ARTHUR', 0)
        end
        sendToDiscord('SweetyLife', '[MESSAGE] ' ..name.. ' Vient de mettre sur le darkweb : ' ..msg..' . ', 15158332)
    end
end, false)

RegisterCommand('lspd', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "police" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce LSPD', ''..msg..'', 'CHAR_ABIGAIL', 0)
        end
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'policier pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
    else
    TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'policier pour faire cette commande', 'CHAR_BLOCKED', 0)
	end
end, false)

RegisterCommand('lspd', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "police" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce', ''..msg..'', 'CHAR_ABIGAIL', 0)
        end
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être policier pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
    else
    TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être policier pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
 end, false)
 
RegisterCommand('mecano', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "mecano" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'Mécano', '~b~Annonce', ''..msg..'', 'CHAR_LS_CUSTOMS', 0)
        end
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être mecano pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
    else
    TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être mecano pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
 end, false)
 
 RegisterCommand('concess', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "carshop" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'Concessionnaire', '~b~Annonce', ''..msg..'', 'CHAR_CARSITE', 0)
        end
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être concessionnaire pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
    else
    TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être concessionnaire pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
 end, false)
 
RegisterCommand('unicorn', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "unicorn" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'Unicorn', '~b~Annonce', ''..msg..'', 'CHAR_TANISHA', 0)
        end
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être unicorn pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
    else
    TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être unicorn pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
 end, false)
 
RegisterCommand('taxi', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "taxi" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'Taxi', '~b~Annonce', ''..msg..'', 'CHAR_TAXI', 0)
        end
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être taxi pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
    else
    TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être taxi pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
 end, false)
 
RegisterCommand('vigne', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "vigne" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'Vigneron', '~b~Annonce', ''..msg..'', 'CHAR_CHEF', 0)
        end
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être vigneron pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
    else
    TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être vigneron pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
 end, false)
 
RegisterCommand('ems', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "ambulance" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Annonce', ''..msg..'', 'CHAR_CALL911', 0)
        end
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être EMS pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
    else
    TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'System', '~r~Avertissement' , 'Vous devez être EMS pour faire cette commande', 'CHAR_BLOCKED', 0)
    end
 end, false)

function sendToDiscord (name,message,color)
    date_local1 = os.date('%H:%M:%S', os.time())
    local date_local = date_local1
    local DiscordWebHook = "https://discord.com/api/webhooks/843805138060705842/lSdrI7slQr1XHn9k6O5SPjPOoccBvHzsyMpVT-M4Gfj4mu9yqWUcsSgC_MkTHvs8mmNh"
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