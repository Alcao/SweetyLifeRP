ESX = nil
isRoll = false
amount = 50000
TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)

RegisterServerEvent('Razzway:ch45tyuhyy477j5yj5')
AddEventHandler('Razzway:ch45tyuhyy477j5yj5', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not isRoll then
        if xPlayer ~= nil then
            if 1 < 2 then
                isRoll = true
                -- local _priceIndex = math.random(1, 20)
                local _randomPrice = math.random(1, 100)
                if _randomPrice == 1 then
                    -- une voiture
                    local _subRan = math.random(1,1000)
                    if _subRan <= 1 then
                        _priceIndex = 19
                    else
                        _priceIndex = 3
                    end
                elseif _randomPrice > 1 and _randomPrice <= 6 then
                    -- une arme
                    _priceIndex = 12
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 12
                    else
                        _priceIndex = 7
                    end
                elseif _randomPrice > 6 and _randomPrice <= 15 then
                    -- argent sale
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 4
                    elseif _sRan == 2 then
                        _priceIndex = 8
                    elseif _sRan == 3 then
                        _priceIndex = 11
                    else
                        _priceIndex = 16
                    end
                elseif _randomPrice > 15 and _randomPrice <= 25 then
                    -- argent
                    -- _priceIndex = 5
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 5
                    else
                        _priceIndex = 20
                    end
                elseif _randomPrice > 25 and _randomPrice <= 40 then
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 1
                    elseif _sRan == 2 then
                        _priceIndex = 9
                    elseif _sRan == 3 then
                        _priceIndex = 13
                    else
                        _priceIndex = 17
                    end
                elseif _randomPrice > 40 and _randomPrice <= 60 then
                    local _itemList = {}
                    _itemList[1] = 2
                    _itemList[2] = 6
                    _itemList[3] = 10
                    _itemList[4] = 14
                    _itemList[5] = 18
                    _priceIndex = _itemList[math.random(1, 5)]
                elseif _randomPrice > 60 and _randomPrice <= 100 then
                    local _itemList = {}
                    _itemList[1] = 3
                    _itemList[2] = 7
                    _itemList[3] = 15
                    _itemList[4] = 20
                    _priceIndex = _itemList[math.random(1, 4)]
                end
                -- print("Price " .. _priceIndex)
                
                SetTimeout(5000, function()
                    isRoll = false
                    -- Prix a gagner
                    if _priceIndex == 1 or _priceIndex == 9 or _priceIndex == 13 or _priceIndex == 17 then
                        --print("armure")
                        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~s~Vous n'avez rien gagné, retentez votre chance dans 24H !")
                    elseif _priceIndex == 2 or _priceIndex == 6 or _priceIndex == 10 or _priceIndex == 14 or _priceIndex == 18 then
                        --print("pain eau")
                        xPlayer.addInventoryItem("bread", 10)
                        xPlayer.addInventoryItem("water", 24)
                        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~s~Vous avez gagné~b~ du pain et de l'eau !")
                        sendToDiscord('Dynasty - LOGS', '[ROUE-BITE] ' ..xPlayer.getName().. ' Viens de gagner du pain et de l\'eau :', 3145658)
                    elseif _priceIndex == 3 or _priceIndex == 7 or _priceIndex == 15 or _priceIndex == 20 then
                        --print("argent")
                        local _money = 0
                        if _priceIndex == 3 then
                            _money = 20000
                        elseif _priceIndex == 7 then
                            _money = 30000
                        elseif _priceIndex == 15 then
                            _money = 40000
                        elseif _priceIndex == 20 then
                            _money = 50000
                        end
                        xPlayer.addAccountMoney('cash', _money)
                        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~s~Vous avez gagné~b~ " .. ESX.Math.GroupDigits(_money) .. "$")
                        sendToDiscord('Dynasty - LOGS', '[ROUE-BITE] ' ..xPlayer.getName().. ' Viens de gagné de l\'argent', 3145658)
                    elseif _priceIndex == 4 or _priceIndex == 8 or _priceIndex == 11 or _priceIndex == 16 then
                        local _blackMoney = 0
                        if _priceIndex == 4 then
                            _blackMoney = 10000
                        elseif _priceIndex == 8 then
                            _blackMoney = 15000
                        elseif _priceIndex == 11 then
                            _blackMoney = 20000
                        elseif _priceIndex == 16 then
                            _blackMoney = 25000
                        end
                        xPlayer.addAccountMoney("black_money", _blackMoney * 10)
                        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~s~Vous avez gagné~b~ " .. ESX.Math.GroupDigits(_blackMoney * 10) .. "$")
                        sendToDiscord('Dynasty - LOGS', '[ROUE-BITE] ' ..xPlayer.getName().. ' Viens de gagner une voiture :', 3145658)
                    elseif _priceIndex == 5 then
                        xPlayer.addAccountMoney('dirtycash', 300000)
                        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~s~Vous avez gagné~b~ 300,000$ ~s~ d'argent sale !")
                        sendToDiscord('Dynasty - LOGS', '[ROUE-BITE] ' ..xPlayer.getName().. ' Viens de gagner 300,000 $ d\'argent sale :', 3145658)
                    elseif _priceIndex == 12 then
                        xPlayer.addWeapon("weapon_pistol", 42)
                        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~s~Vous avez gagné~b~ une arme (Pistolet) !")
                        sendToDiscord('Dynasty - LOGS', '[ROUE-BITE] ' ..xPlayer.getName().. ' Viens de gagner une arme (PISTOLET) :', 3145658)
                    elseif _priceIndex == 19 then
                        TriggerClientEvent("Razzway:vg47821gg4z5", _source)
                        TriggerClientEvent('::{razzway.xyz}::esx:showNotification', _source, "~s~Vous avez gagné~b~ une voiture !")
                        sendToDiscord('Dynasty - LOGS', '[ROUE-BITE] ' ..xPlayer.getName().. ' Viens de gagner une voiture :', 3145658)
                    end
                    TriggerClientEvent("Razzway:ougahugahuhzid", -1)
                end)
                TriggerClientEvent("Razzway:zd454z5dzd4z5", -1, _priceIndex)
            else
                TriggerClientEvent("Razzway:ougahugahuhzid", -1)    
            end
        end
    end
end)


RegisterNetEvent("Razzway:kll5ili5im4illi5")
AddEventHandler("Razzway:kll5ili5im4illi5", function(playerNameee)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll("SELECT * FROM roueFortune WHERE name = @a", {["@a"] = playerNameee},
    function(result)
        if result[1] then
            if tostring(result[1].args) == os.date("%d/%m/%Y") then
                --meme jour
                TriggerClientEvent('::{razzway.xyz}::esx:showNotification', xPlayer.source, '~b~Roue de la fortune\n~w~Vous avez déjà effectué votre tour gratuit.\n~r~Revenez dans 24h !')
            else
                --c'est bon
                TriggerClientEvent("Razzway:945efef475efef1e4", -1) 
                MySQL.Async.execute("UPDATE roueFortune SET args = @a WHERE name = @b",     
                {["@b"] = playerNameee, ["@a"] = os.date("%d/%m/%Y")},function () end)
            end
        else
            TriggerClientEvent("Razzway:945efef475efef1e4", -1) 
            MySQL.Async.execute("INSERT INTO roueFortune (name, args) VALUES (@name, @args)",     
            {["@name"] = playerNameee, ["@args"] = os.date("%d/%m/%Y")},function () end)
        end
    end)  
end)

