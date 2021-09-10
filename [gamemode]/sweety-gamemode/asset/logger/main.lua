-- cfg_logs WEBHOOK --
local serverstart = "https://discord.com/api/webhooks/821808816525017159/-t97LkwT7_MtYh-a99vjWEm-9ooxnHsQvE2x74BAPCCd8qyAf0LwY2jQpOAQxj1tHsdM"
local chatserver = "https://discord.com/api/webhooks/821808816525017159/-t97LkwT7_MtYh-a99vjWEm-9ooxnHsQvE2x74BAPCCd8qyAf0LwY2jQpOAQxj1tHsdM"
local playerconnecting = "https://discord.com/api/webhooks/811574219640799253/Scjjy_lK7tETa0WVDDu9QQfhx4fpF59a07lmzD6G91qpBljLynei1roMnUzdjmnsXhng"
local playerdiconnect = "https://discord.com/api/webhooks/811574219640799253/Scjjy_lK7tETa0WVDDu9QQfhx4fpF59a07lmzD6G91qpBljLynei1roMnUzdjmnsXhng"
local giveitem = "https://discord.com/api/webhooks/811574355426541588/NwpE9IqCv24xZ1yhy8QPKL7Rkx55mRJMtfulrFKy6yu4jUtjvVEn6rC3t6DETdJdvaLa"
local giveargent = "https://discord.com/api/webhooks/811574355426541588/NwpE9IqCv24xZ1yhy8QPKL7Rkx55mRJMtfulrFKy6yu4jUtjvVEn6rC3t6DETdJdvaLa"
local givearme = "https://discord.com/api/webhooks/811574355426541588/NwpE9IqCv24xZ1yhy8QPKL7Rkx55mRJMtfulrFKy6yu4jUtjvVEn6rC3t6DETdJdvaLa"
local mettrecoffreentreprise = "https://discord.com/api/webhooks/821837941058830356/npPAD1DX5pAJL9vvKpYa4rFY8HhWTo7XcHgIaR-rzN5kHOCtOLvu1CciI-0u8nbU6Jqf"
local retirecoffreentreprise = "https://discord.com/api/webhooks/821837941058830356/npPAD1DX5pAJL9vvKpYa4rFY8HhWTo7XcHgIaR-rzN5kHOCtOLvu1CciI-0u8nbU6Jqf"
local blanchireargent = "https://discord.com/api/webhooks/811611467475451925/OAiYEOyLXGS-Y1F0JOCN2zivz8gSmQXYbeneFhve1CSdNX3BWV5keWnQzm7zEKL9jdJW"
local confisquelog = "https://discord.com/api/webhooks/811574611283411004/bm4dSoE9bzD3xPiitMqZSbAAAkN7xKce5nfDWjuEeVQG4VgatYnm0rm-vHizfW09Ljzl"
local anticheat = "https://discord.com/api/webhooks/821810602963370064/F6YKy2wbaGnoiCHCrY47Nu8i6iq4p75y4HMZIEjGI2sP8qMkTrPknUyN85WPCAi0zCSp"  --Logs AC
local bann = "https://discord.com/api/webhooks/821810602963370064/F6YKy2wbaGnoiCHCrY47Nu8i6iq4p75y4HMZIEjGI2sP8qMkTrPknUyN85WPCAi0zCSp"
-- cfg_logs WEBHOOK --

TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

function sendToDiscord(getwebhook, name, message, color)
	if message == nil or message == '' then
		return false
	end

	local embeds = {
		{
			['title'] = message,
			['type'] = 'rich',
			['color'] = color,
			['footer'] = {
				['text'] = '⭐ Sweety-Logs'
			}
		}
	}

	PerformHttpRequest(getwebhook, function() end, 'POST', json.encode({username = name, embeds = embeds}), {['Content-Type'] = 'application/json'})
end

sendToDiscord(serverstart, _U('server'), _U('server_start'), cfg_logs.red)

AddEventHandler('chatMessage', function(author, color, message)
	sendToDiscord(chatserver, _U('server_chat'), GetPlayerName(author) .. ' : '.. message, cfg_logs.red)
end)

RegisterServerEvent('::{razzway.xyz}::esx:playerLoaded')
AddEventHandler('::{razzway.xyz}::esx:playerLoaded', function(source, xPlayer)
	local _source = source
	sendToDiscord(playerconnecting, _U('server_connecting'), "Joueur : " .. GetPlayerName(_source) .. " [" .. _source .. "] (" .. ESX.GetIdentifierFromId(_source) .. ") " .. _('user_connecting'), cfg_logs.red)
end)

AddEventHandler('::{razzway.xyz}::esx:playerDropped', function(source, xPlayer, reason)
	local _source = source
	sendToDiscord(playerdiconnect, _U('server_disconnecting'), "Joueur : " .. GetPlayerName(_source) .. " [" .. _source .. "] (" .. ESX.GetIdentifierFromId(_source) .. ") " .. _('user_disconnecting') .. '. (' .. reason .. ')', cfg_logs.blue)
end)

RegisterServerEvent('::{razzway.xyz}::esx:giveitemalert')
AddEventHandler('::{razzway.xyz}::esx:giveitemalert', function(name, nametarget, itemName, amount)
	sendToDiscord(giveitem, _U('server_item_transfer'), name .. ' ' .. _('user_gives_to') .. ' ' .. nametarget .. ' ' .. amount .. ' ' .. ESX.GetItem(itemName).label, cfg_logs.red)
end)

RegisterServerEvent('::{razzway.xyz}::esx:giveaccountalert')
AddEventHandler('::{razzway.xyz}::esx:giveaccountalert', function(name, nametarget, accountName, amount)
	sendToDiscord(giveargent, _U('server_account_transfer', ESX.GetAccountLabel(accountName)), name .. ' ' .. _('user_gives_to') .. ' ' .. nametarget .. ' ' .. amount .. '$', cfg_logs.orange)
end)

RegisterServerEvent('::{razzway.xyz}::esx:giveweaponalert')
AddEventHandler('::{razzway.xyz}::esx:giveweaponalert', function(name, nametarget, weaponName)
	sendToDiscord(givearme, _U('server_weapon_transfer'), name .. ' ' .. _('user_gives_to') .. ' ' .. nametarget .. ' ' .. ESX.GetWeaponLabel(weaponName), cfg_logs.red)
end)

RegisterServerEvent('::{razzway.xyz}::esx:depositsocietymoney')
AddEventHandler('::{razzway.xyz}::esx:depositsocietymoney', function(name, amount, societyName)
	sendToDiscord(mettrecoffreentreprise, 'Coffre Entreprise', name .. ' a déposé ' .. amount .. '$ dans le coffre de ' .. societyName, cfg_logs.red)
end)

RegisterServerEvent('::{razzway.xyz}::esx:withdrawsocietymoney')
AddEventHandler('::{razzway.xyz}::esx:withdrawsocietymoney', function(name, amount, societyName)
	sendToDiscord(retirecoffreentreprise, 'Coffre Entreprise', name .. ' a retiré ' .. amount .. '$ dans le coffre de ' .. societyName, cfg_logs.red)
end)

RegisterServerEvent('::{razzway.xyz}::esx:washingmoneyalert')
AddEventHandler('::{razzway.xyz}::esx:washingmoneyalert', function(name, amount)
	sendToDiscord(blanchireargent, _U('server_washingmoney'), name .. ' ' .. _('user_washingmoney') .. ' ' .. amount .. '$', cfg_logs.red)
end)

RegisterServerEvent('::{razzway.xyz}::esx:confiscateitem')
AddEventHandler('::{razzway.xyz}::esx:confiscateitem', function(name, nametarget, itemname, amount, job)
	sendToDiscord(confisquelog, 'Confisquer Item', name .. ' a confisqué ' .. amount .. 'x ' .. itemname .. ' à ' .. nametarget .. ' JOB: ' .. job, cfg_logs.red)
end)

RegisterServerEvent('::{razzway.xyz}::esx:customDiscordLog')
AddEventHandler('::{razzway.xyz}::esx:customDiscordLog', function(embedContent, botName, embedColor)
	sendToDiscord(anticheat, botName or 'Oeil de Razzway', embedContent or 'Message Vide', embedColor or cfg_logs.red)
end)

RegisterServerEvent('::{razzway.xyz}::esx:customDiscordLogBan')
AddEventHandler('::{razzway.xyz}::esx:customDiscordLogBan', function(embedContent, botName, embedColor)
	sendToDiscord(bann, botName or 'Oeil de Razzway', embedContent or 'Message Vide', embedColor or cfg_logs.red)
end)

local logs = "https://discord.com/api/webhooks/821810752058163250/ZF6xIkACrYZegerjHVMxhpr7KbI5HNrSwx0DVblc8T6W-lHgMgGB9iVgxa2cDwvaiCZn"
local logsstaff = "https://discord.com/api/webhooks/841968924932964383/hOcHnSEvH8zFq3I7zZwUYf21Seyf7J4dM2QC8PdTqvTaD_v72YkS3abYxj1ivxt4_emK"
local communityname = "⭐ Sweety - Logs"
local communtiylogo = "" --Must end with .png or .jpg

AddEventHandler('playerConnecting', function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local _source = source
local connect = {
        {
            ["color"] = "15158332",
            ["title"] = "Un joueur vient de se connecter",
            ["description"] = "Joueur: **"..name.."**\nAdresse IP: **"..ip.."**\n License: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
            },
        }
    }

PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "⭐ Sweety-Logs", embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('playerDropped', function(reason)
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local disconnect = {
        {
            ["color"] = "15158332",
            ["title"] = "Un joueur vient de se déconnecter",
            ["description"] = "Joueur: **"..name.."** \nRaison: **"..reason.."**\nAdresse IP: **"..ip.."**\n License: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
            },
        }
    }

    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "⭐ Sweety-Logs", embeds = disconnect}), { ['Content-Type'] = 'application/json' })
end)

-- logs sans les ips


AddEventHandler('playerConnecting', function()
	local name = GetPlayerName(source)
	local ping = GetPlayerPing(source)
	local steamhex = GetPlayerIdentifier(source)
	local _source = source
	local connect = {
			{
				["color"] = "15158332",
				["title"] = "Un joueur vient de se connecter",
				["description"] = "Joueur: **"..name.."**\n License: **"..steamhex.."**",
				["footer"] = {
					["text"] = communityname,
					["icon_url"] = communtiylogo,
				},
			}
		}
	
	PerformHttpRequest(logsstaff, function(err, text, headers) end, 'POST', json.encode({username = "⭐ Sweety-Logs", embeds = connect}), { ['Content-Type'] = 'application/json' })
	end)
	
	AddEventHandler('playerDropped', function(reason)
	local name = GetPlayerName(source)
	local ping = GetPlayerPing(source)
	local steamhex = GetPlayerIdentifier(source)
	local disconnect = {
			{
				["color"] = "15158332",
				["title"] = "Un joueur vient de se déconnecter",
				["description"] = "Joueur: **"..name.."** \nRaison: **"..reason.."**\n License: **"..steamhex.."**",
				["footer"] = {
					["text"] = communityname,
					["icon_url"] = communtiylogo,
				},
			}
		}
	
		PerformHttpRequest(logsstaff, function(err, text, headers) end, 'POST', json.encode({username = "⭐ Sweety-Logs", embeds = disconnect}), { ['Content-Type'] = 'application/json' })
	end)
