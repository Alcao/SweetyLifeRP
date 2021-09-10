ESX = nil
TriggerEvent(cfg_coffre.esxEvent, function(obj) ESX = obj end)

local cfg_coffreServer =  {
     LogsDiscord = {
          UsernameWebhook = "kCoffre Logs",
          WebhookLogs = "ton-webhook",
          IconUrl = "ton-image",
          AvatarUrl = "ton-image"
     },
     Events = {
          Notification = "::{razzway.xyz}::esx:showNotification"
     },
}

enterCoffre = {}
playersEnter = {}
weightCoffre = {}
local nameItem = ""
local countItem = 0
local id = 0
local beforeCount = 0
local totalTake = 0

local function SendLogs(Color, Title, Description)
     PerformHttpRequest(cfg_coffreServer.LogsDiscord.WebhookLogs, function(err, text, headers) end, 'POST', json.encode({
          username = cfg_coffreServer.LogsDiscord.UsernameWebhook, 
          embeds = {{
               ["color"] = Color, 
               ["title"] = Title,
               ["description"] = "".. Description .."",
               ["footer"] = {
                    ["text"] = cfg_coffreServer.LogsDiscord.UsernameWebhook.." • "..os.date("%x %X %p"),
                    ["icon_url"] = cfg_coffreServer.LogsDiscord.IconUrl,
               },
          }}, 
          avatar_url = cfg_coffreServer.LogsDiscord.AvatarUrl
     }), { 
          ['Content-Type'] = 'application/json' 
     })
end

RegisterServerEvent("kCoffre:enter")
AddEventHandler("kCoffre:enter", function(plate) -- à sécu
     if not plate then return end
     if enterCoffre[plate] then
          print("Coffre is ^2ready^0 ! ("..plate..")")
          SendLogs(15158332, "Exit Menu", "Le joueur **"..GetPlayerName(source).."**, viens de quitter le coffre avec la plaque *"..plate.."*")
          enterCoffre[plate] = false
          playersEnter[source] = false
     else
          print("Coffre is ^1not ready^0 ! ("..plate..")")
          SendLogs(3066993, "Enter Menu", "Le joueur **"..GetPlayerName(source).."**, viens d'entrer dans le coffre avec la plaque *"..plate.."*")
          enterCoffre[plate] = true
          playersEnter[source] = true
     end
end)

ESX.RegisterServerCallback('kCoffre:getEnterCoffre', function(source, cb, plate)
     local _src = source
     if _src then
          if enterCoffre[plate] then
               cb(false)
          else
               cb(true)
          end
     end
end)

ESX.RegisterServerCallback('kCoffre:MyInventory', function(source, cb)
     local xPlayer = ESX.GetPlayerFromId(source)
     local item = xPlayer.getInventory()
     local weapon = xPlayer.getLoadout()
     local money = xPlayer.getAccount('dirtycash').money
     cb({
          item = item,
          weapon = weapon,
          money = money
     }) 
 end)

ESX.RegisterServerCallback('kCoffre:getVeh', function(source, cb, plate)
     print("Go event from  plate ^3"..plate.."^0")
     local FinalWeight = 0
     local _src = source
     if _src then
          local player = ESX.GetPlayerFromId(_src)
          if weightCoffre[plate] == nil then
               weightCoffre[plate] = 0
          end
          MySQL.Async.fetchAll("SELECT * FROM "..cfg_coffre.Table.." WHERE plate = @plate ORDER BY id", {["@plate"] = plate}, function(result)
               if result[1] then
                    for i = 1, #result, 1 do
                         AvvFinalWeight = cfg_coffre.Vehicle.itemWeight[result[i].name] * result[i].count
                         AvFinalWeight = weightCoffre[plate] + AvvFinalWeight
                         if weightCoffre[plate] ~= AvFinalWeight then
                              FinalWeight = FinalWeight+AvFinalWeight
                              TriggerClientEvent("kCoffre:RefreshWeightTrunk", player.source, FinalWeight)
                         end
                    end
                    cb(result)
               else
                    TriggerClientEvent("kCoffre:RefreshWeightTrunk", player.source, 0)
                    cb(0)
               end
          end)
     end
end)



RegisterNetEvent("kCoffre:action")
AddEventHandler("kCoffre:action", function(class, model, plate, label, name, count, ammo, type, action) -- à sécu
     print("Go event from palte ^3"..plate.."^0")
     local _src = source
     if _src then
          if not playersEnter[_src] then return DropPlayer(_src, "Faille trouvé !") end
          local player = ESX.GetPlayerFromId(_src)
          if action == "put" then
                    MySQL.Async.fetchAll("SELECT * FROM "..cfg_coffre.Table.." WHERE plate = @plate ORDER BY id", {["@plate"] = plate}, function(result)
                         for k,v in pairs(result) do
                              if v.type == "money" then
                                   if v.name == name then
                                        itemName = v.name
                                        countItem = v.count
                                        id = v.id
                                        hasItem = true
                                   end
                              elseif v.type == "item" then
                                   if v.name == name then
                                        itemName = v.name
                                        countItem = v.count
                                        id = v.id
                                        hasItem = true
                                   end
                              end
                         end
                         if hasItem then
                              local total = tonumber(countItem+count)
                              print("J'additionne car l'item ("..label..") est existant !","Total : "..total,"Plaque : "..plate)
                              MySQL.Sync.execute("UPDATE "..cfg_coffre.Table.." SET `count` = @a, ammo = @b WHERE id = @id", {
                                   ["@id"] = id,
                                   ["@a"] = total,
                                   ["@b"] = ammo
                              })
                              if type == "item" then
                                   TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de déposer ~b~"..count.."x "..label.."~s~ dans le coffre .")
                                   player.removeInventoryItem(name, count)
                                   SendLogs(3066993, "Put Item", "Le joueur **"..GetPlayerName(source).."**, viens de déposer dans le coffre **x "..count ..""..label.."** avec la plaque *"..plate.."*")
                                   hasItem = false
                              elseif type == "money" then
                                   TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de déposer "..count.."$ d'argent "..label.." dans le coffre .")
                                   player.removeAccountMoney("black_money", count)
                                   SendLogs(3066993, "Put Money", "Le joueur **"..GetPlayerName(source).."**, viens de déposer dans le coffre **"..count.."$** d'argent sale avec la plaque *"..plate.."*")
                                   hasItem = false
                              end
                         else
                              MySQL.Async.execute("INSERT INTO "..cfg_coffre.Table.." (label, name, count, ammo, type, plate, model) VALUES (@label, @name, @count, @ammo, @type, @plate, @model)", {
                                   ['@label'] = label,
                                   ['@name'] = name,
                                   ['@count'] = count,
                                   ["@ammo"] = ammo,
                                   ['@type'] = type,
                                   ['@plate'] = plate,
                                   ['@model'] = model
                              }, function()
                                   if type == "item" then
                                        TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de déposer ~b~"..count.."x "..label.."~s~ dans le coffre .")
                                        player.removeInventoryItem(name, count)
                                        SendLogs(3066993, "Put Item", "Le joueur **"..GetPlayerName(source).."**, viens de déposer dans le coffre **x "..count ..""..label.."** avec la plaque *"..plate.."*")
                                   elseif type == "weapon" then
                                        TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de déposer ~b~"..label.." "..ammo.."munition(s)~s~ dans le coffre .")
                                        player.removeWeapon(name, ammo)
                                        SendLogs(3066993, "Put Weapon", "Le joueur **"..GetPlayerName(source).."**, viens de déposer dans le coffre **"..label.." avec "..ammo.."munition(s)** avec la plaque *"..plate.."*")
                                   elseif type == "money" then
                                        TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de déposer "..count.."$ d'argent "..label.." dans le coffre .")
                                        player.removeAccountMoney("black_money", count)
                                        SendLogs(3066993, "Put Money", "Le joueur **"..GetPlayerName(source).."**, viens de déposer dans le coffre **"..count.."$** d'argent sale avec la plaque *"..plate.."*")
                                   end
                                   hasItem = false
                              end)          
                         end
                    end)  
          elseif action == "take" then
               print("Event take form palte "..plate.." !")
               MySQL.Async.fetchAll("SELECT * FROM "..cfg_coffre.Table.." WHERE plate = @plate ORDER BY id", {["@plate"] = plate}, function(result)
                    for _,v in pairs (result) do
                         if type == "item" then
                              if v.name == name then
                                   id = v.id
                                   beforeCount = v.count
                              end
                         elseif type == "money" then
                                   if v.name == name then
                                        id = v.id
                                        beforeCount = v.count
                                   end
                         elseif type == "weapon" then
                              local weapon = player.getWeapon(v.name)
                              if not weapon then
                                   if v.name == name then
                                        id = v.id
                                        beforeCount = v.count
                                   end
                              else
                                   return
                                   TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous avez déjà l'arme sur vous !")
                              end
                         end
                    end
                    totalTake = beforeCount-count
                    if totalTake < 1 then
                         MySQL.Async.execute("DELETE FROM "..cfg_coffre.Table.." WHERE id = @id",{["@id"] = id},function()
                              if type == "item" then
                                   player.addInventoryItem(name, count)
                                   TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de prendre ~b~"..count.."x "..label.."~s~ dans le coffre .")
                                   SendLogs(15158332, "Take Item", "Le joueur **"..GetPlayerName(source).."**, viens de déposer dans le coffre **x "..count ..""..label.."** avec la plaque *"..plate.."*")
                              elseif type == "weapon" then
                                   player.addWeapon(name, ammo)
                                   TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de prendre ~b~"..label.." "..ammo.."munition(s)~s~ dans le coffre .")
                                   SendLogs(15158332, "Take Weapon", "Le joueur **"..GetPlayerName(source).."**, viens de prendre dans le coffre **"..label.." avec "..ammo.."munition(s)** avec la plaque *"..plate.."*")
                              elseif type == "money" then
                                   player.addAccountMoney("black_money", count)
                                   TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de prendre "..count.."$ d'argent "..label.." dans le coffre .")
                                   SendLogs(15158332, "Take Money", "Le joueur **"..GetPlayerName(source).."**, viens de prendre dans le coffre **"..count.."$** d'argent sale avec la plaque *"..plate.."*")
                              end
                              nameItem = ""
                              countItem = 0
                              beforeCount = 0
                              totalTake = 0
                         end)
                    else
                         MySQL.Async.execute("UPDATE "..cfg_coffre.Table.." SET count = @count WHERE id=@id",{["@id"] = id, ["@count"] = totalTake},function()
                              if type == "item" then
                                   player.addInventoryItem(name, count)
                                   TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de prendre ~b~"..count.."x "..label.."~s~ dans le coffre .")
                                   SendLogs(15158332, "Take Item", "Le joueur **"..GetPlayerName(source).."**, viens de déposer dans le coffre **x "..count ..""..label.."** avec la plaque *"..plate.."*")
                              elseif type == "weapon" then
                                   player.addWeapon(name, count)
                                   TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de prendre ~b~"..label.." "..count.."munition(s)~s~ dans le coffre .")
                                   SendLogs(15158332, "Take Weapon", "Le joueur **"..GetPlayerName(source).."**, viens de prendre dans le coffre **"..label.." avec "..ammo.."munition(s)** avec la plaque *"..plate.."*")
                              elseif type == "money" then
                                   player.addAccountMoney("black_money", count)
                                   TriggerClientEvent(cfg_coffreServer.Events.Notification, player.source, "Vous venez de prendre "..count.."$ d'argent "..label.." dans le coffre .")
                                   SendLogs(15158332, "Take Money", "Le joueur **"..GetPlayerName(source).."**, viens de prendre dans le coffre **"..count.."$** d'argent sale avec la plaque *"..plate.."*")
                              end
                              nameItem = ""
                              countItem = 0
                              beforeCount = 0
                              totalTake = 0
                         end) 
                    end
               end)
          end
     end
end)

--
-- Script finish 
-- Created by Kadir
--