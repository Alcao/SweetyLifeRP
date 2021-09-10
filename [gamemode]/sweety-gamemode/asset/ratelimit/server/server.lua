file = io.open("event.txt", "w")

RegisterServerEvent("Razzway:GetEvent")
AddEventHandler("Razzway:GetEvent", function(eventmec)
    file:write(eventmec .. "\n")

    for k,v in pairs(cfg_ratelimit.BlacklistEvent) do
        if v == eventmec then 
            print("Event blacklisted : " .. eventmec)
            return
        else
            RegisterNetEvent(eventmec)
            AddEventHandler(eventmec, function()
                local _source = source
                TriggerEvent('ratelimit', _source, v)
            end)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(10000)
    file:close()
end)

Citizen.CreateThread(function()
    if cfg_ratelimit.BanSystem == true then
    function AddBan(licenseid, targetName, permanent)
        MySQL.Async.execute('INSERT INTO ratelimit_ban (licenseid, targetName, permanent) VALUES (@licenseid, @targetName, @permanent)', {
            ['@licenseid'] = licenseid,
            ['@targetName'] = targetName,
            ['@permanent'] = permanent
        }, function()
        end)
    end
 
    function IsBanned(licenseid, cb)
        MySQL.Async.fetchAll('SELECT * FROM ratelimit_ban WHERE licenseid = @licenseid', {
            ['@licenseid'] = licenseid
        }, function(result)
            if #result > 0 then
                cb(true, result[1])
            else
                cb(false, result[1])
            end
        end)
    end
    AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
        local _source = source
        local licenseid, playerip = 'N/A', 'N/A'
        licenseid = GetPlayerIdentifier(_source)
 
        if not licenseid then
            setKickReason("NOTHING")
            CancelEvent()
        end
 
        deferrals.defer()
        Citizen.Wait(0)
        deferrals.update(('Vérification de %s en cours...'):format(playerName))
        Citizen.Wait(0)
 
        IsBanned(licenseid, function(isBanned, banData)
            if isBanned then
                deferrals.done(cfg_ratelimit.BanMessage)
            else
                deferrals.done()
            end
        end)
    end)
end
end)
 
Citizen.CreateThread(function()
    if cfg_ratelimit.WebhookLink == nil then
        print("[WARNING] Webhook Discord not cfg_ratelimit !")
        return
    end
 
    --CODE FOR RATE
    local Trig = {}
    AddEventHandler('ratelimit', function(ids, res)
    local _source = source
	local w = "unknown"
	local x = "unknown"
	local y = "unknown"
	local z = "unknown"
	local A = "unknown"
	local B = "unknown"
	local C = "unknown"
	for m, n in ipairs(GetPlayerIdentifiers(ids)) do
		if n:match("steam") then
			w = n
		elseif n:match("discord") then
			x = n:gsub("discord:", "")
		elseif n:match("license") then
			y = n
		elseif n:match("live") then
			z = n
		elseif n:match("xbl") then
			B = n
		elseif n:match("ip") then
			C = n:gsub("ip:", "")
		end
	end;
	local D = GetPlayerName(ids) or "JSP"
	logwebhookcolor = 1769216;
    if Trig[ids] ~= nil then
        if Trig[ids] ~= 'off' then
            if Trig[ids] == cfg_ratelimit.RateLimit then 
                if cfg_ratelimit.BanSystem == true then
                    --ban function
                    AddBan(GetPlayerIdentifier(ids), GetPlayerName(ids), 1)
                    DropPlayer(ids, cfg_ratelimit.BanMessage)
                    PerformHttpRequest(cfg_ratelimit.WebhookLink, function(E, F, G)
                    end, "POST", json.encode({
                        embeds = {
                            {
                                author = {
                                    name = "Rate Limit",
                                    icon_url = "https://assets.stickpng.com/images/5a81af7d9123fa7bcc9b0793.png"
                                },
                                title = "BANNED !",
                                description = "**Player:** "..D.."\n**ServerID:** "..ids.."\n**Violation:** ".."Spam Trigger".."\n**Details:** ".."Trigger Used : ".. res .."\n**SteamID:** "..w.."\n**Discord:** <@"..x..">".."\n**License:** "..y.."\n**Live:** "..z.."\n**Xbox:** "..B.."\n**IP:** "..C,
								color = 16711680
                            }
                        }
                    }), {
                        ["Content-Type"] = "application/json"
                    })        
                    Trig[ids] = 'off'
                else
                    DropPlayer(ids, cfg_ratelimit.KickMessage)
                    PerformHttpRequest(cfg_ratelimit.WebhookLink, function(E, F, G)
                    end, "POST", json.encode({
                        embeds = {
                            {
                                author = {
                                    name = "Rate Limit",
                                    icon_url = "https://assets.stickpng.com/images/5a81af7d9123fa7bcc9b0793.png"
                                },
                                title = "KICKED !",
                                description = "**Player:** "..D.."\n**ServerID:** "..ids.."\n**Violation:** ".."Spam Trigger".."\n**Details:** ".."Trigger Used : ".. res .."\n**SteamID:** "..w.."\n**Discord:** <@"..x..">".."\n**License:** "..y.."\n**Live:** "..z.."\n**Xbox:** "..B.."\n**IP:** "..C,
								color = 16760576
                            }
                        }
                    }), {
                        ["Content-Type"] = "application/json"
                    })        
                    Trig[ids] = 'off'    
                end
            else
                Trig[ids] = Trig[ids] + 1
            end
            else
                if BanSystem == true then
                    --ban function
                    AddBan(GetPlayerIdentifier(ids), GetPlayerName(ids), 1)
                    DropPlayer(ids, cfg_ratelimit.BanMessage)
                else
                    DropPlayer(ids, cfg_ratelimit.KickMessage)
                end
            end
        else
            Trig[ids] = 1
        end
    end)
 
    --FUNCTION START COUTING
    CountTrig()
end)
 
 
function CountTrig()
    Trig = {}
    SetTimeout(cfg_ratelimit.ResetRateLimit, CountTrig)
end