TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

ESX.AddGroupCommand('ac_bypass', 'admin', function(source, args, user) end)

RegisterServerEvent('::{razzway.xyz}::myAcSuckYourAssholeHacker')
AddEventHandler('::{razzway.xyz}::myAcSuckYourAssholeHacker', function(report)
	local _source = source

	if not IsPlayerAceAllowed(_source, 'command.ac_bypass') then
		TriggerEvent('::{razzway.xyz}::esx:customDiscordLog', "Joueur : " .. GetPlayerName(_source) .. " [" .. _source .. "] (" .. ESX.GetIdentifierFromId(_source) .. ") - Méthode : " .. report)
	end
end)

ESX.AddGroupCommand('cleanup', "admin", function(source, args, user)
	TriggerClientEvent('::{razzway.xyz}::byebyeEntities', -1)
end)