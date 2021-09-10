ESX = {}

local BanList            = {}

local giveway = {
    isEnabled = false,
    points = 500
}

---@class STebex
STebex = STebex or {};

---@class STebex.Cache
STebex.Cache = STebex.Cache or {}

---@class STebex.Cache.Case
STebex.Cache.Case = STebex.Cache.Case or {}

function STebex:HasValue(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    return false
end

TriggerEvent('SwLife:initObject', function(obj)
    ESX = obj
end)

SwLife.newThread(function()
    while ESX == nil do
        TriggerEvent('SwLife:initObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)


local characters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }

Server = {};

function Server:GetIdentifiers(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers[_]
        end
        return identifiers
    else
        error("source is nil")
    end
end

function sendToDiscord (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "https://discord.com/api/webhooks/824245572906385449/v-1ARsOIvdXAB5Z0k155FsQT2OsMUklnnOTNg-tsRyXP-m19uafDpSYTOt9NA4OY2D1d"
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

function Server:CreateRandomPlateText()
    local plate = ""
    math.randomseed(GetGameTimer())
    for i = 1, 4 do
        plate = plate .. characters[math.random(1, #characters)]
    end
    plate = plate .. ""
    for i = 1, 3 do
        plate = plate .. math.random(1, 9)
    end
    return plate
end

RegisterServerEvent("tebex:on-process-checkout-fullcustom")
AddEventHandler("tebex:on-process-checkout-fullcustom", function()

    Server:OnProcessCheckout(source, 1000, "Full Custom vehicule", function()

    end)

end)

function Server:OnProcessCheckout(source, price, transaction, onAccepted, onRefused)
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            local current = tonumber(result[1]["SUM(points)"]);
            if (current ~= nil) then
                if (current >= price) then
                    LiteMySQL:Insert('tebex_players_wallet', {
                        identifiers = after,
                        transaction = transaction,
                        price = '0',
                        currency = 'Points',
                        points = -price,
                    });
                    onAccepted();
                else
                    onRefused();
                    xPlayer.showNotification('Vous ne possédez pas les points nécessaires pour votre achat, visité notre boutique.')
                end
            else
                onRefused();
                print('[Info] CET ENCULE A PAS DE COINS')
            end
        end);
    else
        onRefused();
        --print('[Exeception] Failed to retrieve fivem identifier')
    end
end

function Server:Giving(xPlayer, identifier, item)
    local content = json.decode(item.action);

    if (content.vehicles) then
        for key, value in pairs(content.vehicles) do
            local plate = Server:CreateRandomPlateText()
            sendToDiscord('Cardinal', '[BOUTIQUE] ' ..xPlayer.getName().. ' vient d\'acheter un véhicule : ' ..value.name.. '', 2061822)
            LiteMySQL:Insert('owned_vehicles', {
                owner = identifier['license'],
                plate = plate,
                vehicle = json.encode({ model = value.name, plate = plate }),
                type = value.type,
                state = 1,
            })
            LiteMySQL:Insert('open_car', {
                owner = identifier['license'],
                plate = plate
            });

        end
    end

    if (content.weapons) then
        for key, value in pairs(content.weapons) do
            if (value.name ~= "weapon_custom") then
                print(value.name)
                xPlayer.addWeapon(value.name, value.ammo)
                sendToDiscord('Cardinal', '[BOUTIQUE] ' ..xPlayer.getName().. ' vient d\'acheter une arme : ' ..value.name.. '', 2061822)
            end
        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end

    if (content.bank) then
        for key, value in pairs(content.bank) do
            xPlayer.addAccountMoney('bank', value.count)
        end
    end
end

function Server:onGiveaway(source)
    if (giveway.isEnabled) then
        local identifier = Server:GetIdentifiers(source);
        if (identifier['fivem']) then
            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
            local count, value = LiteMySQL:Select('tebex_players_wallet_gift'):Where('identifiers', '=', after):Get()
            if (count == 0) then
                LiteMySQL:Insert('tebex_players_wallet_gift', {
                    identifiers = after,
                    have_receive = true,
                    points = giveway.points
                })
                LiteMySQL:Insert('tebex_players_wallet', {
                    identifiers = after,
                    transaction = 'Automatics Gift',
                    price = 0,
                    currency = 'EUR',
                    points = giveway.points
                })
                TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "~g~Pour vous excuser de ce désagrément, nous vous avons donné " .. giveway.points .. " points boutique (F1).")
            else
                TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "~g~Vous avez déjà reçu votre récompense.")
            end
        else
            TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, "~b~Vous ne pouvez pas bénéficier des " .. giveway.points .. " points gratuits car votre compte de FiveM n'est pas lié.")
        end
    end
end

RegisterServerEvent('tebex:on-process-checkout')
AddEventHandler('tebex:on-process-checkout', function(itemId)
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            local count, content = LiteMySQL:Select('tebex_boutique'):Where('id', '=', itemId):Get();
            local item = content[1];
            if (item) then
                Server:OnProcessCheckout(source, item.price, string.format("Achat object %s", item.name), function()
                    Server:Giving(xPlayer, identifier, item);
                end, function()
                    xPlayer.showNotification("~r~Vous ne possédé pas les points nécessaires.")
                end)
            else
                print('[[Exeception] Failed to retrieve boutique item')
            end
        else
            print('[Exeception] Failed to retrieve ESX player')
        end
    else
        print('[Exeception] Failed to retrieve source')
    end
end)

local function random(x, y)
    local u = 0;
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x + (math.random(math.randomseed(os.time() + u)) * 999999 % y))
    else
        return math.floor((math.random(math.randomseed(os.time() + u)) * 100))
    end
end

local function GenerateLootbox(source, box, list)
    local chance = random(1, 100)
    local gift = { category = 1, item = 1 }
    local minimalChance = 4

    local identifier = Server:GetIdentifiers(source);
    minimalChance = 3
    if (STebex.Cache.Case[source] == nil) then
        STebex.Cache.Case[source] = {};
        if (STebex.Cache.Case[source][box] == nil) then
            STebex.Cache.Case[source][box] = {};
        end
    end
    if chance <= minimalChance then
        local rand = random(1, #list[3])
        STebex.Cache.Case[source][box][3] = list[3][rand]
        gift.category = 3
        gift.item = list[3][rand]
    elseif (chance > minimalChance and chance <= 30) or (chance > 80 and chance <= 100) then
        local rand = random(1, #list[2])
        STebex.Cache.Case[source][box][2] = list[2][rand]
        gift.category = 2
        gift.item = list[2][rand]
    else
        local rand = random(1, #list[1])
        STebex.Cache.Case[source][box][1] = list[1][rand]
        gift.category = 1
        gift.item = list[1][rand]
    end
    local finalList = {}
    for _, category in pairs(list) do
        for _, item in pairs(category) do
            local result = { name = item, time = 150 }
            table.insert(finalList, result)
        end
    end
    table.insert(finalList, { name = gift.item, time = 5000 })
    return finalList, gift.item
end

local reward = {
    ["point_3000"] = { type = "point", message = "Félicitation, vous avez gagner 3000 Crédits" },
    ["point_1000"] = { type = "vehicle", message = "Félicitation, vous avez gagner 1000 Crédits" },
    ["rs6+"] = { type = "vehicle", message = "Félicitation, vous avez gagner une RS6" },

    ["weapon_smg"] = { type = "weapon", message = "Félicitation, vous avez gagner une SMG" },
    ["weapon_carbinerifle"] = { type = "weapon", message = "Félicitation, vous avez gagner une Carabine" },
    ["weapon_microsmg"] = { type = "weapon", message = "Félicitation, vous avez gagner une Micro SMG" },

    ["italirsx"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Itali RSX" }, -- Car
    ["nero2"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Nero 2" }, -- Car


    ["a8l"] = { type = "vehicle", message = "Félicitation, vous avez gagner Audi A8L" },
}

local box = {
    [1] = {
        [3] = {
            "point_3000",
            "weapon_carbinerifle",
            "point_1000",
            "rs6+",
        },
        [2] = {
            "italirsx",
            "nero2",
            "weapon_smg",
        },
        [1] = {
            "a8l",
            "weapon_microsmg",
        },
    }
}

RegisterServerEvent('tebex:on-process-checkout-case')
AddEventHandler('tebex:on-process-checkout-case', function()
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            Server:OnProcessCheckout(source, 1500, "Achat d'une caisse (Impulsion - Limited).", function()

                local boxId = 1;
                local lists, result = GenerateLootbox(source, boxId, box[boxId])
                local giveReward = {
                    ["vehicle"] = function(_s, license, player)
                        local plate = Server:CreateRandomPlateText()

                        LiteMySQL:Insert('owned_vehicles', {
                            owner = license,
                            plate = plate,
                            vehicle = json.encode({ model = result, plate = plate }),
                            type = 'car',
                            state = 1,
                        })
                        LiteMySQL:Insert('open_car', {
                            owner = license,
                            plate = plate
                        });
                    end,
                    ["plane"] = function(_s, license, player)
                        local plate = Server:CreateRandomPlateText()

                        LiteMySQL:Insert('owned_vehicles', {
                            owner = license,
                            plate = plate,
                            vehicle = json.encode({ model = result, plate = plate }),
                            type = 'aircraft',
                            state = 1,
                        })
                        LiteMySQL:Insert('open_car', {
                            owner = license,
                            plate = plate
                        });
                    end,
                    ["point"] = function(_s, license, player)
                        local before, after = result:match("([^_]+)_([^_]+)")
                        local quantity = tonumber(after)
                        if (identifier['fivem']) then
                            local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                            LiteMySQL:Insert('tebex_players_wallet', {
                                identifiers = fivemid,
                                transaction = "Gain dans la caisse",
                                price = '0',
                                currency = 'Points',
                                points = quantity,
                            });
                        end
                    end,
                    ["weapon"] = function(_s, license, player)
                        xPlayer.addWeapon(result, 500)
                    end,
                    ["money"] = function(_s, license, player)
                        local before, after = result:match("([^_]+)_([^_]+)")
                        local quantity = tonumber(after)
                        player.addAccountMoney('bank', quantity)
                    end,
                }

                local r = reward[result];

                if (r ~= nil) then
                    if (giveReward[r.type]) then
                        giveReward[r.type](source, identifier['license'], xPlayer);
                    else
                        -- FATAL ERROR
                    end
                else
                    -- FATAL ERROR
                end

                if (identifier['fivem']) then
                    local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                    LiteMySQL:Insert('tebex_players_wallet', {
                        identifiers = after,
                        transaction = r.message,
                        price = '0',
                        currency = 'Box',
                        points = 0,
                    });
                end

                TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                sendToDiscord('Cardinal', '[BOUTIQUE] ' ..xPlayer.getName().. ' vient d\'acheter une caisse est a obtenu : ' ..result.. '', 2061822)

            end, function()
                xPlayer.showNotification("~r~Vous ne procédé pas les point nécessaire")
            end)
        else
            print('[Exeception] Failed to retrieve ESX player')
        end
    else
        print('[Exeception] Failed to retrieve source')
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-category', function(source, callback)
    --EventRateLimit('tebex:retrieve-category', source, 5, function()
    local count, result = LiteMySQL:Select('tebex_boutique_category'):Where('is_enabled', '=', true):Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Exceptions] retrieve category is nil')
        callback({ })
    end
    --end)
end)

ESX.RegisterServerCallback('tebex:retrieve-items', function(source, callback, category)
    --EventRateLimit('tebex:retrieve-items', source, 5, function()
    local count, result = LiteMySQL:Select('tebex_boutique'):Wheres({
        { column = 'is_enabled', operator = '=', value = true },
        { column = 'category', operator = '=', value = category },
    })                             :Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Exceptions] retrieve category is nil')
        callback({ })
    end
    --end)
end)

ESX.RegisterServerCallback('tebex:retrieve-history', function(source, callback)
    -- EventRateLimit('tebex:retrieve-history', source, 5, function()
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        local count, result = LiteMySQL:Select('tebex_players_wallet'):Where('identifiers', '=', after):Get();
        if (result ~= nil) then
            callback(result)
        else
            print('[Exceptions] retrieve category is nil')
            callback({ })
        end
    end
    --  end)
end)

ESX.RegisterServerCallback('tebex:retrieve-points', function(source, callback)

    -- EventRateLimit('tebex:retrieve-points', source, 5, function()
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")

        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            if (result[1]["SUM(points)"] ~= nil) then
                callback(result[1]["SUM(points)"])
            else
                print('[Info] retrieve points nil')
                callback(0)
            end
        end);
    else
        callback(0)
    end
    -- end)

end)

AddEventHandler('playerSpawned', function()
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local fivem = Server:GetIdentifiers(source)['fivem'];
        if (fivem) then
            local license = Server:GetIdentifiers(source)['license'];
            if (license) then
                local before, after = fivem:match("([^:]+):([^:]+)")
                LiteMySQL:Update('users', 'identifier', '=', license, {
                    fivem_id = after,
                })
                xPlayer.showNotification('~g~Vous pouvez faire des achats dans notre boutique pour nous soutenir. Votre compte FiveM attaché à votre jeux a été mis à jour.')
            else
                print('[Exeception] User don\'t have license identif0ier.')
            end
        else
            xPlayer.showNotification('~r~Vous n\'avez pas d\'identifiant FiveM associé à votre compte, reliez votre profil à partir de votre jeux pour recevoir vos achats potentiel sur notre boutique.')
            print('[Exeception] FiveM ID not found, send warning message to customer.')
        end
    else
        print('[Exeception] ESX Get players form ID not found.')
    end 
end)

RegisterCommand("fivemid", function(source, callback)

    local source = source;

    local fivem = Server:GetIdentifiers(source)['fivem'];

    if fivem ~= nil then

    TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, '~g~Nous vous avons trouvé, votre FiveM-ID est le suivant : '.. fivem ..'')

    end

    if fivem == nil then

        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', source, '~r~Mince, il semblerait que vous n\'ayez toujours pas relier votre compte CFX.re')

    end
end, false)

local messages = {
    "N'oubliez pas de ~b~rejoindre~s~ notre serveur ~b~discord~s~, le voici : ~p~discord.gg/dCKZtWzPCN",
}

SwLife.newThread(function()
    while true do
        Citizen.Wait(1000)

        for i = 1, #messages do
            --- triggerEvent('Impulsionesx:showAdvancedNotification', title, subject, msg, icon, iconType, hudColorIndex)
            TriggerClientEvent('::{razzway.xyz}::esx:showAdvancedNotification', -1, 'SwLife', '~b~Information', messages[i], 'CHAR_MP_FM_CONTACT', 2, 2)
            Citizen.Wait(500000)
        end


    end
end)

RegisterServerEvent("Razzway.io:ArmeProtection")
AddEventHandler("Razzway.io:ArmeProtection", function(Arme)
    local xPlayer  = ESX.GetPlayerFromId(source)
    local license,identifier,liveid,xblid,discord,playerip,target
    local duree     = 0
    local reason    = reason

    PerformHttpRequest('https://discord.com/api/webhooks/821810602963370064/F6YKy2wbaGnoiCHCrY47Nu8i6iq4p75y4HMZIEjGI2sP8qMkTrPknUyN85WPCAi0zCSp', function(err, text, headers) end, 'POST', json.encode({username = "Protection Armes", content = "Nom : " .. xPlayer.getName() .. "\nId : " .. source .. "\nLisence : " .. xPlayer.identifier .. "\nArme : " ..Arme}), { ['Content-Type'] = 'application/json' })

    if not reason then reason = "Il est interdit de se give une arme sur notre serveur." end

    if tostring(source) == "" then
            target = tonumber(servertarget)
    else
            target = source
    end

    if target and target > 0 then
            local ping = GetPlayerPing(target)

            if ping and ping > 0 then
                    if duree and duree < 365 then
                            local sourceplayername = "Aincrad"
                            local targetplayername = GetPlayerName(target)
                                    for k,v in ipairs(GetPlayerIdentifiers(target))do
                                            if string.sub(v, 1, string.len("license:")) == "license:" then
                                                    license = v
                                            elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                                                    identifier = v
                                            elseif string.sub(v, 1, string.len("live:")) == "live:" then
                                                    liveid = v
                                            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                                                    xblid  = v
                                            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                                                    discord = v
                                            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                                                    playerip = v
                                            end
                                    end

                            if duree > 0 then
                                    ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
                                    DropPlayer(target, "" .. reason)
                            else
                                    ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
                                    DropPlayer(target, "" .. reason)
                            end

                    else
                            --print("BanSql Error : Auto-Cheat-Ban time invalid.")
                    end
            else
                    --print("BanSql Error : Auto-Cheat-Ban target are not online.")
            end
    else
            --print("BanSql Error : Auto-Cheat-Ban have recive invalid id.")
    end
end)

AddEventHandler('playerConnecting', function (playerName,setKickReason)
    local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

    for k,v in ipairs(GetPlayerIdentifiers(source))do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                    license = v
            elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                    steamID = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
                    liveid = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                    xblid  = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                    playerip = v
            end
    end

    --Si Banlist pas chargée
    if (Banlist == {}) then
            Citizen.Wait(1000)
    end


    for i = 1, #BanList, 1 do
            if
                      ((tostring(BanList[i].license)) == tostring(license)
                    or (tostring(BanList[i].identifier)) == tostring(steamID)
                    or (tostring(BanList[i].liveid)) == tostring(liveid)
                    or (tostring(BanList[i].xblid)) == tostring(xblid)
                    or (tostring(BanList[i].discord)) == tostring(discord)
                    or (tostring(BanList[i].playerip)) == tostring(playerip))
            then

                    if (tonumber(BanList[i].permanent)) == 1 then
                            setKickReason("" .. BanList[i].reason)
            CancelEvent()
            print("^1Aincrad request - ".. GetPlayerName(source) .." se connecte mais il est ban")
            break
                    end
            end
    end
end)

function ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
    --calcul total expiration (en secondes)
            local expiration = duree * 86400
            local timeat     = os.time()
            local added      = os.date()
    
            if expiration < os.time() then
                    expiration = os.time()+expiration
            end
    
                    table.insert(BanList, {
                            license    = license,
                            identifier = identifier,
                            liveid     = liveid,
                            xblid      = xblid,
                            discord    = discord,
                            playerip   = playerip,
                            reason     = reason,
                            expiration = expiration,
                            permanent  = permanent
              })
    
                    MySQL.Async.execute(
                    'INSERT INTO sCoreAC_ban (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                    {
                                    ['@license']          = license,
                                    ['@identifier']       = identifier,
                                    ['@liveid']           = liveid,
                                    ['@xblid']            = xblid,
                                    ['@discord']          = discord,
                                    ['@playerip']         = playerip,
                                    ['@targetplayername'] = targetplayername,
                                    ['@sourceplayername'] = sourceplayername,
                                    ['@reason']           = reason,
                                    ['@expiration']       = expiration,
                                    ['@timeat']           = timeat,
                                    ['@permanent']        = permanent,
                                    },
                                    function ()
                    end)
                    BanListHistoryLoad = false
end