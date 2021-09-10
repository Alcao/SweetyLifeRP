ESX = nil

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)


RegisterNetEvent('BBanque:getcardecompte')
AddEventHandler('BBanque:getcardecompte', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local cbposs = xPlayer.getInventoryItem('cb')

    if cbposs.count <= 0 then
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'Banque', 'Information', "Désoler mais vous n'avez pas de carte Bancaire sur vous.", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('BBanque:acceptedopen', source)
     end
end)

RegisterServerEvent("bank:solde") 
AddEventHandler("bank:solde", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local argentman = xPlayer.getAccount('bank').money

    TriggerClientEvent("solde:argent", _source, argentman)
end)

RegisterServerEvent("money:solde") 
AddEventHandler("money:solde", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local argentmoney = xPlayer.getAccount('cash').money

    TriggerClientEvent("solde2:argent2", _source, argentmoney)
end)


RegisterServerEvent("BBanque:moins1000")
AddEventHandler("BBanque:moins1000", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = 1000
    local xMoney = xPlayer.getAccount('bank').money
    
    if xMoney >= price then

    xPlayer.removeAccountMoney('bank', price)
    xPlayer.addAccountMoney('cash', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Retrait de ~g~1000$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)

RegisterServerEvent("BBanque:moins5000")
AddEventHandler("BBanque:moins5000", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = 5000
    local xMoney = xPlayer.getAccount('bank').money
    
    if xMoney >= price then

    xPlayer.removeAccountMoney('bank', price)
    xPlayer.addAccountMoney('cash', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Retrait de ~g~5000$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)

RegisterServerEvent("BBanque:retraitperso")
AddEventHandler("BBanque:retraitperso", function(sommme)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = sommme
    local xMoney = xPlayer.getAccount('cash').bank
    
    if xMoney >= price then

        xPlayer.addAccountMoney('cash', price)
        xPlayer.removeAccountMoney('bank', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Dépôt de ~g~"..price.."$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)

RegisterServerEvent("BBanque:retraitperso5k")
AddEventHandler("BBanque:retraitperso5k", function(sommme5k)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = sommme5k
    local xMoney = xPlayer.getAccount('bank').money
    
    if xMoney >= price then

    xPlayer.removeAccountMoney('bank', price)
    xPlayer.addAccountMoney('cash', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Retrait de ~g~"..price.."$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)

RegisterServerEvent("BBanque:retraitpersocb3")
AddEventHandler("BBanque:retraitpersocb3", function(sommmeperso)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = sommmeperso
    local xMoney = xPlayer.getAccount('bank').money
    
    if xMoney >= price then

    xPlayer.removeAccountMoney('bank', price)
    xPlayer.addAccountMoney('cash', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Retrait de ~g~"..price.."$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)

RegisterServerEvent("BBanque:depotperso")
AddEventHandler("BBanque:depotperso", function(sommme)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = sommme
    local xMoney = xPlayer.getAccount('cash').money
    
    if xMoney >= price then

        xPlayer.addAccountMoney('bank', price)
        xPlayer.removeAccountMoney('cash', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Dépôt de ~g~"..price.."$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)

RegisterServerEvent("BBanque:depotperso5k")
AddEventHandler("BBanque:depotperso5k", function(sommme5s)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = sommme5s
    local xMoney = xPlayer.getAccount('cash').money
    
    if xMoney >= price then

        xPlayer.addAccountMoney('bank', price)
        xPlayer.removeAccountMoney('cash', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Dépôt de ~g~"..price.."$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)

RegisterServerEvent("BBanque:depotcb3")
AddEventHandler("BBanque:depotcb3", function(sommme5s)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = sommme5s
    local xMoney = xPlayer.getAccount('cash').money
    
    if xMoney >= price then

        xPlayer.addAccountMoney('bank', price)
        xPlayer.removeAccountMoney('cash', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Dépôt de ~g~"..price.."$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)

RegisterServerEvent("BBanque:dep1000")
AddEventHandler("BBanque:dep1000", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = 1000
    local xMoney = xPlayer.getAccount('cash').money
    if xMoney >= price then
    xPlayer.addAccountMoney('bank', price)
    xPlayer.removeAccountMoney('cash', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Dépôt de ~g~1000$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)

RegisterServerEvent("BBanque:dep5000")
AddEventHandler("BBanque:dep5000", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local price = 5000
    local xMoney = xPlayer.getAccount('cash').money
    if xMoney >= price then
    xPlayer.addAccountMoney('bank', price)
    xPlayer.removeAccountMoney('cash', price)
        TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque', 'Information', "Dépôt de ~g~5000$~s~ effectué", 'CHAR_BANK_FLEECA', 8)
    else
        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~r~Tu n'as pas assez d'argent")
    end    
end)



RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amountt)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0
    if zPlayer ~= nil and GetPlayerEndpoint(to) ~= nil then
        balance = xPlayer.getAccount('bank').money
        zbalance = zPlayer.getAccount('bank').money
        if tonumber(_source) == tonumber(to) then
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source, 'Banque','Transférer de l\'argent','Vous ne pouvez pas vous transférer !','CHAR_BANK_MAZE', 9)
        else
            if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <=
                0 then
                TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source,'Banque', 'Transférer de l\'argent','Pas assez d\'argent à transférer !','CHAR_BANK_MAZE', 9)
            else
                xPlayer.removeAccountMoney('bank', tonumber(amountt))
                zPlayer.addAccountMoney('bank', tonumber(amountt))
                TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', _source,'Banque', 'Transférer de l\'argent','Vous avez transféré ~r~$' .. amountt ..'~s~ à ~r~' .. to .. ' .','CHAR_BANK_MAZE', 9)
                TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', to, 'Banque','Transférer de l\'argent', 'Vous avez reçu ~r~$' ..amountt .. '~s~ de ~r~' .. _source ..' .', 'CHAR_BANK_MAZE', 9)
            end
        end
    end
end)

ESX.RegisterServerCallback('BBanque:gettypecompte', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll("SELECT * FROM bbanque WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {
			name = GetPlayerName(source),
			type = result[1]['nivcompte'],
		}
		cb(data)
	end)
end)


ESX.RegisterServerCallback('BBanque:getstatemdp', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchScalar('SELECT statemdp FROM bbanque WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(statemdpo)
		
		cb(statemdpo)
	end) 
end)

ESX.RegisterServerCallback('BBanque:getmotpasse', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll("SELECT * FROM bbanque WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {
			name = GetPlayerName(source),
			motdpasse = result[1]['motdepasse'],
		}
		cb(data)
	end)
end) 