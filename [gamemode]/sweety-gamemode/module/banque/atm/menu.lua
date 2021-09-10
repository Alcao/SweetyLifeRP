ESX = nil

CreateThread(function()
    while ESX == nil do 
        TriggerEvent("SwLife:initObject", function(obj) ESX = obj end)
        Wait(10)
    end
end)


local mdp,amountt,to,sommme5s,sommme,sommmeperso,sommme5k = nil,nil,nil,nil,nil,nil,nil
local PlayerMoney,PlayerMoneys = 0, 0
local cb1,cb2,cb3,password = false,false,false,false
local atmcompte = RageUIv2.CreateMenu('Compte Bancaire', 'Information Compte Bancaire')
local menutrans = RageUIv2.CreateSubMenu(atmcompte, "Transfère", "Faire un Transfère")
local transmenuinfo = RageUIv2.CreateSubMenu(atmcompte, "Transfère", "Faire un Transfère")
local retraitmenu = RageUIv2.CreateSubMenu(atmcompte, "Retrait", "Faire un Retrait")
local password = RageUIv2.CreateSubMenu(atmcompte, "Mot de Passe", "Faire son Mot de Passe")
local depotmenu = RageUIv2.CreateSubMenu(atmcompte, "Dépôt", "Faire un Dépôt")
atmcompte.Display.Header = true
atmcompte.Closed = function()
  openatmenu = false
end

function ATMACCESS()
     if openatmenu then 
      openatmenu = false
        RageUIv2.Visible(atmcompte, false)
        return
     else
      openatmenu = true 
         RageUIv2.Visible(atmcompte, true)
         CreateThread(function()
         while openatmenu do

          RageUIv2.IsVisible(atmcompte,function()

              RageUIv2.Button("Mon Solde Bancaire :", nil, {RightLabel = "~b~"..PlayerMoney.."$~s~"}, true , {
                onSelected = function()
                end
              })
              RageUIv2.Button("Mon argent de Poche :", nil, {RightLabel = "~g~"..PlayerMoneys.."$~s~"}, true , {
                onSelected = function()
                end
              })
              RageUIv2.Button("Faire un ~r~Retrait", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                  mytypecompte = nil
                  gettypecompte()
                end
              },retraitmenu)
              RageUIv2.Button("Faire un ~g~Dépôt", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                  mytypecompte = nil
                  gettypecompte()
                end
              },depotmenu)
              RageUIv2.Button("Faire un ~y~Transfère", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                end
              },menutrans)
              RageUIv2.Button("Historique des Transactions", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                end
              },transmenuinfo)
          end)

          RageUIv2.IsVisible(retraitmenu,function()
            if mytypecompte then
                  if mytypecompte.type == "1" then
                      RageUIv2.Button("Faire un retrait de 1000$", "Cette Action est automatique", {RightLabel = "→→"}, true , {
                        onSelected = function()
                          SwLife.InternalToServer("BBanque:moins1000")
                          AddBankTransaction("Retrait de ~g~1000$~w~")
                          GetPlayerMoney()
                          GetPlayerMoneySolde()
                        end
                      })
                      RageUIv2.Button("Faire un retrait personnalisé", "Libre à vous de choisir le montant, maximum de 1000$", {RightLabel = "→→"}, true , {
                        onSelected = function()
                          local retr1000max = KeyboardInput("ret1000max", 'Indiquez la somme à retirer', '', 4)
                          if tonumber(retr1000max) == nil then
                              return false
                          else
                            sommme = (tonumber(retr1000max))
                                if sommme < 1001 then
                                    SwLife.InternalToServer("BBanque:retraitperso", sommme)
                                    AddBankTransaction("Retrait de ~r~"..sommme.."$~w~")
                                    GetPlayerMoney()
                                    GetPlayerMoneySolde()
                                else
                                    if sommme > 1001 then
                                      ESX.ShowNotification("Vous n'avez pas la permission de faire un retrait de plus de 1000$.")
                                    end
                                end
                          end
                        end
                      })
                  end
                    if mytypecompte.type == "2" then
                        RageUIv2.Button("Faire un retrait de 5000$", "Cette Action est automatique", {RightLabel = "→→"}, true , {
                          onSelected = function()
                            SwLife.InternalToServer("BBanque:moins5000")
                            AddBankTransaction("Retrait de ~r~5000$~w~")
                            GetPlayerMoney()
                            GetPlayerMoneySolde()
                          end
                        })
                        RageUIv2.Button("Faire un retrait personnalisé", "Libre à vous de choisir le montant, maximum de 5000$", {RightLabel = "→→"}, true , {
                          onSelected = function()
                            local retr5000max = KeyboardInput("ret5000max", 'Indiquez la somme à retirer', '', 4)
                            if tonumber(retr5000max) == nil then
                                return false
                            else
                              sommme5k = (tonumber(retr5000max))
                                  if sommme5k < 5001 then
                                      SwLife.InternalToServer("BBanque:retraitperso5k", sommme5k)
                                      AddBankTransaction("Retrait de ~r~"..sommme5k.."$~w~")
                                      GetPlayerMoney()
                                      GetPlayerMoneySolde()
                                  else
                                      if sommme5k > 5001 then
                                        ESX.ShowNotification("Vous n'avez pas la permission de faire un retrait de plus de 5000$.")
                                      end
                                  end
                            end
                          end
                        })
                    end
                    if mytypecompte.type == "3" then
                      RageUIv2.Button("Faire un retrait personnalisé", "Libre à vous de choisir le montant", {RightLabel = "→→"}, true , {
                        onSelected = function()
                          local retrait = KeyboardInput("retrait", 'Indiquez la somme à retirer', '', 10)
                          if tonumber(retrait) == nil then
                              return false
                          else
                            sommmeperso = (tonumber(retrait))
                            SwLife.InternalToServer("BBanque:retraitpersocb3", sommmeperso)
                            AddBankTransaction("Retrait de ~r~"..sommmeperso.."$~w~")
                            GetPlayerMoney()
                            GetPlayerMoneySolde()
                          end
                        end
                      })
                    end
              end
          end)
          RageUIv2.IsVisible(depotmenu,function()
            if mytypecompte then
                if mytypecompte.type == "1" then
                    RageUIv2.Button("Faire un Dépôt de 1000$", "Cette Action est automatique", {RightLabel = "→→"}, true , {
                      onSelected = function()
                        SwLife.InternalToServer("BBanque:dep1000")
                        AddBankTransaction("Dépot de ~g~1000$~w~")
                        GetPlayerMoney()
                        GetPlayerMoneySolde()
                      end
                    })
                    RageUIv2.Button("Faire un Dépôt personnalisé", "Libre à vous de choisir le montant, maximum de 1000$", {RightLabel = "→→"}, true , {
                      onSelected = function()
                        local depde1000max = KeyboardInput("dep1000max", 'Indiquez la somme à déposer', '', 4)
                        if tonumber(depde1000max) == nil then
                            return false
                        else
                          sommme = (tonumber(depde1000max))
                              if sommme < 1001 then
                                  SwLife.InternalToServer("BBanque:depotperso", sommme)
                                  AddBankTransaction("Dépot de ~g~"..sommme.."$~w~")
                                  GetPlayerMoney()
                                  GetPlayerMoneySolde()
                              else
                                  if sommme > 1001 then
                                    ESX.ShowNotification("Vous n'avez pas la permission de faire un dépôt de plus de 1000$.")
                                  end
                              end
                        end
                      end
                    })
                end
                    if mytypecompte.type == "2" then
                        RageUIv2.Button("Faire un Dépôt de 5000$", "Cette Action est automatique", {RightLabel = "→→"}, true , {
                          onSelected = function()
                            SwLife.InternalToServer("BBanque:dep5000")
                            AddBankTransaction("Dépot de ~g~5000$~w~")
                            GetPlayerMoney()
                            GetPlayerMoneySolde()
                          end
                        })
                        RageUIv2.Button("Faire un Dépôt personnalisé", "Libre à vous de choisir le montant, maximum de 5000$", {RightLabel = "→→"}, true , {
                          onSelected = function()
                            local depde5000max = KeyboardInput("dep5000max", 'Indiquez la somme à déposer', '', 4)
                            if tonumber(depde5000max) == nil then
                                return false
                            else
                              sommme5s = (tonumber(depde5000max))
                                  if sommme5s < 5001 then
                                      SwLife.InternalToServer("BBanque:depotperso5k", sommme5s)
                                      AddBankTransaction("Dépot de ~g~"..sommme5s.."$~w~")
                                      GetPlayerMoney()
                                      GetPlayerMoneySolde()
                                  else
                                      if sommme5s > 5001 then
                                        ESX.ShowNotification("Vous n'avez pas la permission de faire un dépôt de plus de 1000$.")
                                      end
                                  end
                            end
                          end
                        })                    
                    end
                    if mytypecompte.type == "3" then
                      RageUIv2.Button("Faire un Dépôt personnalisé", "Libre à vous de choisir le montant", {RightLabel = "→→"}, true , {
                        onSelected = function()
                          local depot = KeyboardInput("depot", 'Indiquez la somme à déposer', '', 10)
                          if tonumber(depot) == nil then
                              return false
                          else
                              sommme5s = (tonumber(depot))
                              SwLife.InternalToServer("BBanque:depotcb3", sommme5s)
                              AddBankTransaction("Dépot de ~g~"..sommme5s.."$~w~")
                              GetPlayerMoney()
                              GetPlayerMoneySolde()
                          end
                        end
                      })
                    end
                  end
              end)

          RageUIv2.IsVisible(menutrans,function()

            RageUIv2.Button("ID de la personne", nil, {RightLabel = to}, true , {
              onSelected = function()
                local idperso = KeyboardInput("ids", 'Indiquez l\'ID de la personne', '', 20)
                if idperso ~= nil then
                  to = (tostring(idperso))
                end 
              end
            })
            RageUIv2.Button("Somme du Transfère", nil, {RightLabel = amountt}, true , {
              onSelected = function()
                local somme = KeyboardInput("moneysoms", 'Indiquez la somme du transfère', '', 20)
                if somme ~= nil then
                  amountt = (tostring(somme))
                end 
              end
            })
            RageUIv2.Button("Valider le Transfère", nil, {RightLabel = "→→", Color = {BackgroundColor = RageUIv2.ItemsColour.Green}}, true , {
              onSelected = function()
                SwLife.InternalToServer('bank:transfer', to, amountt)
                GetPlayerMoney()
                GetPlayerMoneySolde()
              end
            })
          end)

          RageUIv2.IsVisible(transmenuinfo,function()
            if #bankTransaction > 0 then
                RageUIv2.Button("~r~Effacer Toutes Les Transactions~s~", nil, {RightBadge = RageUIv2.BadgeStyle.Alert}, true , {
                  onSelected = function()
                    ClearTransaction() 
                  end
                })
            end
            if #bankTransaction == 0 then
                RageUIv2.Button("~r~Aucune Transaction~s~", nil, {}, true , {
                  onSelected = function()
                  end
                })
            end
            for k,v in pairs(bankTransaction) do
                RageUIv2.Button(v, nil, {}, true , {
                  onSelected = function()
                  end
                })
            end
          end)

          Wait(1)
         end
      end)
   end
end

local motpasseme = RageUIv2.CreateMenu('Mot de Passe', 'Saisir son Mot de Passe')
motpasseme.Display.Header = true
motpasseme.Closed = function()
  openpassmenu = false
end

function MenuPassWord()
  if openpassmenu then 
    openpassmenu = false
     RageUIv2.Visible(motpasseme, false)
     return
  else
    openpassmenu = true 
      RageUIv2.Visible(motpasseme, true)
      CreateThread(function()
      while openpassmenu do

              RageUIv2.IsVisible(motpasseme,function()

                    RageUIv2.Button("Saisir son Mot de Passe", nil, {RightLabel = mdp}, true , {
                      onSelected = function()
                        local saisimdp = KeyboardInput("dazda", 'Indiquez votre Mot de Passe', '', 5)
                          if saisimdp ~= nil then
                              mdp = (tostring(saisimdp))
                          end
                          myverifmdp = nil
                          getmotpasse() 
                      end
                    })
                    RageUIv2.Button("Valider son Mot de Passe", nil, {RightLabel = "→→", Color = {BackgroundColor = RageUIv2.ItemsColour.Green}}, true , {
                      onSelected = function()
                        if myverifmdp then
                            if myverifmdp.motdpasse == mdp then
                                ATMACCESS()
                                GetPlayerMoney()
                                GetPlayerMoneySolde()
                            else
                                ESX.ShowNotification("Mot de Passe ~r~Incorrect~s~")
                            end
                        end 
                      end
                    })
              end)
       Wait(1)
      end
   end)
end
end

RegisterNetEvent("solde:argent")
AddEventHandler("solde:argent", function(money)
  PlayerMoney = tonumber(money)
end)

RegisterNetEvent("solde2:argent2")
AddEventHandler("solde2:argent2", function(money)
  PlayerMoneys = tonumber(money)
end)



local Banquee = {
  ATM = {
      {posi = vector3(237.3406, 217.8895, 106.2868)}, --- pacifique
      {posi = vector3(149.92, -1040.83, 29.37)},
      {posi = vector3(-1212.980,-330.841,37.56)},
      {posi = vector3(-2962.582, 482.627,15.703)},
      {posi = vector3(-112.202, 6469.295, 31.626)},
      {posi = vector3(314.187, -278.621, 54.170)},
      {posi = vector3(-351.534, -49.529, 49.042)},
      {posi = vector3(1175.0643310547, 2706.6435546875, 38.094036102295)},
  }
}


Citizen.CreateThread(function()
  while true do
      local PlyCoord = GetEntityCoords(PlayerPedId())
      local interval = 850
      local dst = GetDistanceBetweenCoords(PlyCoord, true)
      for k,v in pairs(Banquee.ATM) do
          if #(PlyCoord - v.posi) < 2.0 then
            interval = 1
            ShowHelpNotification("Appuyez sur ~b~E~s~ pour insérer votre carte")
              if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("BBanque:getstate", function(statecompte)
                  if statecompte then
                      SwLife.InternalToServer("BBanque:getcardecompte")
                  else
                      ESX.ShowNotification("~g~Vous n'avez pas de compte bancaire d'ouvert ! Allez en créer-un à la banque centrale.")
                  end 
              end)
              end
          end
      end
      Citizen.Wait(interval)
  end
end)

RegisterNetEvent("BBanque:acceptedopen")
AddEventHandler("BBanque:acceptedopen", function()
    RequestAnimDict("amb@prop_human_atm@male@enter")
    while (not HasAnimDictLoaded("amb@prop_human_atm@male@enter")) do
        Citizen.Wait(1) 
    end
    TaskPlayAnim(PlayerPedId(),"amb@prop_human_atm@male@enter", "enter", 1.0, 1.0, 3000, 0, 1, true, true, true)
    Citizen.Wait(3000)			
    RequestAnimDict("amb@prop_human_atm@male@idle_a")
    while (not HasAnimDictLoaded("amb@prop_human_atm@male@idle_a")) do
        Citizen.Wait(1)
    end
    TaskPlayAnim(PlayerPedId(),"amb@prop_human_atm@male@idle_a", "idle_c", 1.0, -1.0, -1, 0, 1, true, true, true)
    ClearPedTasks(GetPlayerPed(-1))
    Citizen.Wait(6500)
    ESX.TriggerServerCallback("BBanque:getstatemdp", function(statemdpo)
      if statemdpo then
        MenuPassWord()
      else
          ATMACCESS()
          GetPlayerMoney()
          GetPlayerMoneySolde()
      end 
    end)
end)

RegisterCommand("getpos", function(source, args, raw)
  local ped = GetPlayerPed(PlayerId())
  local coords = GetEntityCoords(ped, false)
  local heading = GetEntityHeading(ped)
  Citizen.Trace(tostring("X: " .. coords.x .. " Y: " .. coords.y .. " Z: " .. coords.z .. " HEADING: " .. heading))
end, false)