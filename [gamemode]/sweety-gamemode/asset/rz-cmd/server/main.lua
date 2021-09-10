TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

local groupsRequired = {
	['kick'] = "admin"
}

RegisterServerEvent('::{razzway.xyz}::es_admin:set')
AddEventHandler('::{razzway.xyz}::es_admin:set', function(target, command, param)
	local xPlayer, xPlayerTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)

	if command == "group" then
		if xPlayerTarget == nil then
			TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEM', {255, 0, 0}, "Player not found")
		else
			ESX.GroupCanTarget(xPlayer.getGroup(), param, function(canTarget)
				if canTarget then
					TriggerEvent('::{razzway.xyz}::esx:customDiscordLog', xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") a modifié le groupe de permission de " .. xPlayerTarget.name .. " [" .. xPlayerTarget.source .. "] (" .. xPlayerTarget.identifier .. ") - Ancien : " .. xPlayer.getGroup() .. " / Nouveau : " .. param)
					xPlayerTarget.setGroup(param)
					TriggerClientEvent('chatMessage', xPlayer.source, "SYSTEME", {0, 0, 0}, "Group of ^2^*" .. xPlayerTarget.getName() .. "^r^0 has been set to ^2^*" .. param)
				else
					TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEME', {255, 0, 0}, "Invalid group or insufficient group.")
				end
			end)
		end
	elseif command == "level" then
		if xPlayerTarget == nil then
			TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEM', {255, 0, 0}, "Player not found")
		else
			param = tonumber(param)
			if param ~= nil and param >= 0 then
				if xPlayer.getLevel() >= param then
					TriggerEvent('::{razzway.xyz}::esx:customDiscordLog', xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") a modifié le niveau de permission de " .. xPlayerTarget.name .. " [" .. xPlayerTarget.source .. "] (" .. xPlayerTarget.identifier .. ") - Ancien : " .. xPlayer.getLevel() .. " / Nouveau : " .. param)
					xPlayerTarget.setLevel(param)
					TriggerClientEvent('chatMessage', xPlayer.source, "SYSTEME", {0, 0, 0}, "Permission level of ^2" .. xPlayerTarget.getName() .. "^0 has been set to ^2 " .. tostring(param))
				else
					TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEME', {255, 0, 0}, "Insufficient level.")
				end
			else
				TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEME', {255, 0, 0}, "Invalid level.")
			end
		end
	end
end)

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'setlevel' then
		if (tonumber(args[1]) ~= nil and tonumber(args[1]) >= 0) and (tonumber(args[2]) ~= nil and tonumber(args[2]) >= 0) then
			local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))

			if xPlayer == nil then
				RconPrint("Player not ingame\n")
				CancelEvent()
				return
			end

			TriggerEvent('::{razzway.xyz}::esx:customDiscordLog', "CONSOLE a modifié le niveau de permission de " .. xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") - Ancien : " .. xPlayer.getLevel() .. " / Nouveau : " .. tostring(args[2]))
			xPlayer.setLevel(tonumber(args[2]))
		else
			RconPrint("Usage: setlevel [user-id] [level]\n")
			CancelEvent()
			return
		end

		CancelEvent()
	elseif commandName == 'setgroup' then
		if (tonumber(args[1]) ~= nil and tonumber(args[1]) >= 0) and (tostring(args[2]) ~= nil) then
			local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))

			if xPlayer == nil then
				RconPrint("Player not ingame\n")
				CancelEvent()
				return
			end

			TriggerEvent('::{razzway.xyz}::esx:customDiscordLog', "CONSOLE a modifié le groupe de permission de " .. xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") - Ancien : " .. xPlayer.getGroup() .. " / Nouveau : " .. tostring(args[2]))
			xPlayer.setGroup(tostring(args[2]))
		else
			RconPrint("Usage: setgroup [user-id] [group]\n")
			CancelEvent()
			return
		end

		CancelEvent()
	end
end)

-- Report
ESX.AddCommand('report', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SUPPORT", {0, 0, 255}, " (^2" .. GetPlayerName(source) .. " | " .. source .. "^0) " .. table.concat(args, " "))
	PerformHttpRequest('https://ptb.discord.com/api/webhooks/801543792757833748/NYGsSqFRh774NLlJ5mukIEfeGlb79EXL4Ybrj-EkpwK-dipDpwV0SoAFTyDHu3LXWpGl', function(err, text, headers) end, 'POST', json.encode({username = "LesReportDePD", content = "```ID : " .. source .. "\nName : " .. GetPlayerName(source) .. "\nMessage : " .. table.concat(args, " ") .. "```"}), { ['Content-Type'] = 'application/json' })
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer and xPlayer.getLevel() > 0 and xPlayer.source ~= source then
			TriggerClientEvent('chatMessage', xPlayer.source, "SUPPORT", {0, 0, 255}, " (^2" .. GetPlayerName(source) .. " | " .. source .. "^0) " .. table.concat(args, " "))
		end
	end
end, {help = "Signalez un joueur ou un problème", params = { {name = "report", help = "Ce que vous voulez signalez"} }})

-- Announce
ESX.AddGroupCommand('announce', "admin", function(source, args, user)
	TriggerClientEvent('chatMessage', -1, "ANNONCE", {255, 0, 0}, table.concat(args, " "))
end, {help = "Announce a message to the entire server", params = { {name = "announcement", help = "The message to announce"} }})

-- Kick
ESX.AddGroupCommand('kick', "admin", function(source, args, user)
	if args[1] then
		if GetPlayerName(tonumber(args[1])) then
			local target = tonumber(args[1])
			local reason = args
			table.remove(reason, 1)

			if #reason == 0 then
				reason = "Kick: Vous avez été exclu du serveur."
			else
				reason = "Kick: " .. table.concat(reason, " ")
			end

			TriggerClientEvent('chatMessage', source, "SYSTEME", {255, 0, 0}, "Player ^2" .. GetPlayerName(target) .. "^0 has been kicked (^2" .. reason .. "^0)")
			DropPlayer(target, reason)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEME", {255, 0, 0}, "Incorrect player ID!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEME", {255, 0, 0}, "Incorrect player ID!")
	end
end, {help = "Kick a user with the specified reason or no reason", params = { {name = "userid", help = "The ID of the player"}, {name = "reason", help = "The reason as to why you kick this player"} }})

-- Delgun
ESX.AddGroupCommand('delgun', "admin", function(source, args, user)
	TriggerClientEvent("::{razzway.xyz}::korioz:delgunToggle", source)
end, {help = "Activate delete gun"})

-- Admin Tag
ESX.AddGroupCommand('adminTag', "_dev", function(source, args, user)
	TriggerClientEvent('::{razzway.xyz}::adminTag:trigger', -1, source, ('%s | %s'):format(GetPlayerName(source), table.concat(args, " ")))
end, {help = "Activate an Admin Tag above Head"})

RegisterServerEvent('detect')
AddEventHandler('detect', function()
    TriggerEvent("::{razzway.xyz}::BanSql:ICheatServerMenuInject", source, "Il est interdit de tricher sur notre serveur.")
end)