ESX = nil

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)


RegisterServerEvent('BBanque:setstatecompte')
AddEventHandler('BBanque:setstatecompte', function(statecompte)
	local xPlayer = ESX.GetPlayerFromId(source)
	--local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Sync.execute('UPDATE users SET statuscompte = @statuscompte WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@statuscompte'] = statecompte     
	})
end)

ESX.RegisterServerCallback('BBanque:getstate', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	--local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchScalar('SELECT statuscompte FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(statecompte)
		
		cb(statecompte)
	end) 
end) 

RegisterNetEvent('BBanque:setname')
AddEventHandler('BBanque:setname', function(playerId, Prenom, Nom, Naissance, Mdp)  
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('INSERT INTO bbanque VALUES (@identifier, @Prenom, @Nom, @Naissance, @nivcompte, @motdepasse, @statemdp)', {  
        ['@identifier'] = xPlayer.identifier,        
        ['@Prenom'] = Prenom,      
        ['@Nom'] = Nom,      
        ['@Naissance'] = Naissance,
		['@nivcompte'] = 1,
		['@motdepasse'] = Mdp,
		['@statemdp'] = 0,    
        
    }, function(rowsChanged)            
    end)   
end)

RegisterNetEvent('BBanque:setpassword')
AddEventHandler('BBanque:setpassword', function(playerId, Password)  
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Sync.execute('UPDATE bbanque SET motdepasse = @motdepasse WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@motdepasse'] = Password     
	})   
end)

RegisterServerEvent('BBanque:deletecompte') 
AddEventHandler('BBanque:deletecompte', function()  
    --local identifier = GetPlayerIdentifiers(source)[1]
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM bbanque WHERE identifier = @identifier', {  
        ['@identifier'] = xPlayer.identifier  
    })
	MySQL.Sync.execute('UPDATE users SET statuscompte = @statuscompte WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier ,
		['@statuscompte'] = 0     
	})
	xPlayer.removeInventoryItem("cb", 1)  
end)

ESX.RegisterServerCallback('BBanque:getname', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll("SELECT * FROM bbanque WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {
			name = GetPlayerName(source),
			prenom = result[1]['Prenom'],
			nom = result[1]['Nom'],
			naissance = result[1]['naissance'],
			motpasse = result[1]['motdepasse'],
			statemotpasse = result[1]['statemdp']
		}
		cb(data)
	end)
end)

RegisterNetEvent('BBanque:buycbdepart')
AddEventHandler('BBanque:buycbdepart', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('cb', 1)
	TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Compte Ouvert, Merci à vous !")
end)

RegisterNetEvent('BBanque:BuyCB')
AddEventHandler('BBanque:BuyCB', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 250
    local xMoney = xPlayer.getAccount('cash').money
	local cbs = xPlayer.getInventoryItem('cb')

    if xMoney >= price then
		if cbs.count < 1 then
			xPlayer.removeAccountMoney('cash', price)
			xPlayer.addInventoryItem('cb', 1)
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Achat effectué !")
		else
			TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Vous avez déjà une Carte Bancaire sur vous.")
		end
    else
		 TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'Information', 'Problème lors du paiement', 'Désoler mais tu n\'as pas assez ~r~d\'argent', 'CHAR_BLOCKED', 3)
    end
end)

RegisterServerEvent('BBanque:buycb1')
AddEventHandler('BBanque:buycb1', function(playerId)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 1250
    local xMoney = xPlayer.getAccount('cash').money

    if xMoney >= price then
		xPlayer.removeAccountMoney('cash', price)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Félicitation, votre compte est actuellement au niveau 1 !")
		--local identifier = GetPlayerIdentifiers(source)[1]
		MySQL.Sync.execute('UPDATE bbanque SET nivcompte = @nivcompte WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier ,
			['@nivcompte'] = 1     
		})
    else
		 TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'Information', 'Problème lors du paiement', 'Désoler mais tu n\'as pas assez ~r~d\'argent', 'CHAR_BLOCKED', 3)
    end
end) 

RegisterServerEvent('BBanque:buycb2')
AddEventHandler('BBanque:buycb2', function(playerId)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2500
    local xMoney = xPlayer.getAccount('cash').money

    if xMoney >= price then
		xPlayer.removeAccountMoney('cash', price)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Félicitation, votre compte est actuellement au niveau 2 !")
		--local identifier = GetPlayerIdentifiers(source)[1]
		MySQL.Sync.execute('UPDATE bbanque SET nivcompte = @nivcompte WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier ,
			['@nivcompte'] = 2     
		})
    else
		 TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'Information', 'Problème lors du paiement', 'Désoler mais tu n\'as pas assez ~r~d\'argent', 'CHAR_BLOCKED', 3)
    end
end)

RegisterServerEvent('BBanque:buycb3')
AddEventHandler('BBanque:buycb3', function(playerId)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 5000
    local xMoney = xPlayer.getAccount('cash').money

    if xMoney >= price then
		xPlayer.removeAccountMoney('cash', price)
		TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "Félicitation, votre compte est actuellement au niveau 3 !")
		--local identifier = GetPlayerIdentifiers(source)[1]
		MySQL.Sync.execute('UPDATE bbanque SET nivcompte = @nivcompte WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier ,
			['@nivcompte'] = 3     
		})
    else
		 TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', source, 'Information', 'Problème lors du paiement', 'Désoler mais tu n\'as pas assez ~r~d\'argent', 'CHAR_BLOCKED', 3)
    end
end)

RegisterServerEvent('BBanque:activemdp')
AddEventHandler('BBanque:activemdp', function(playerId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	--local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Sync.execute('UPDATE bbanque SET statemdp = @statemdp WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier ,
		['@statemdp'] = 1     
	})
end)


RegisterServerEvent('BBanque:desacmdp')
AddEventHandler('BBanque:desacmdp', function(playerId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	--local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Sync.execute('UPDATE bbanque SET statemdp = @statemdp WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@statemdp'] = 0     
	})
end)