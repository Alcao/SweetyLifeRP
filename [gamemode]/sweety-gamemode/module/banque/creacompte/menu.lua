ESX = nil

CreateThread(function()
    while ESX == nil do 
        TriggerEvent("SwLife:initObject", function(obj) ESX = obj end)
        Wait(10)
    end
end)

local prenomInput, nameInput, DateInput = nil, nil, nil
local playerPed = PlayerPedId()

local open = false 
local cracompte = RageUIv2.CreateMenu('Création du Compte', 'CrÉer votre compte Bancaire')
cracompte.Display.Header = true
cracompte.Closed = function()
  open = false
end

local prenom,mdp,nom,dates = nil,nil,nil,nil
local infocomptes = RageUIv2.CreateMenu('Information Bancaire', 'Information Compte Bancaire')
local cdmenus = RageUIv2.CreateSubMenu(infocomptes, "Choix de la CB", "Choisir votre Carte Bancaire")
local persoinfo = RageUIv2.CreateSubMenu(infocomptes, "Information", "Information Personnelle")
local modiftype = RageUIv2.CreateSubMenu(infocomptes, "Modification", "Modification sur le compte")
local mdpmodif = RageUIv2.CreateSubMenu(infocomptes, "Mot de Passe", "Gestion du Mot de Passe")
local transac = RageUIv2.CreateSubMenu(infocomptes, "Historique", "Historique des Transactions")
infocomptes.Display.Header = true
infocomptes.Closed = function()
  openinfo = false
end

function InfoCompte()
     if openinfo then 
        openinfo = false
        RageUIv2.Visible(infocomptes, false)
        return
     else
      openinfo = true 
         RageUIv2.Visible(infocomptes, true)
         CreateThread(function()
         while openinfo do 

          RageUIv2.IsVisible(infocomptes,function()


            RageUIv2.Button("Information du compte", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
                myidentity = nil
                getidentitymec()
                mytypecompte = nil
                gettypecompte()
              end
            },persoinfo)
            RageUIv2.Button("Faire une demande de Carte Bancaire", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
              end
            },cdmenus)
            RageUIv2.Button("Modification de niveau de compte", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
              end
            },modiftype)
            RageUIv2.Button("Gestion du Mot de Passe", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
              end
            },mdpmodif)
            RageUIv2.Button("Regarder les dernières Transactions", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
              end
            },transac)
            RageUIv2.Button("~r~Supprimer mon compte bancaire", nil, {RightBadge = RageUIv2.BadgeStyle.Alert}, true , {
              onSelected = function()
                local deletecompte = KeyboardInput("delete", 'Voulez vous vraiment supprimer votre compte ? oui ou non', '', 20)
                if tostring(deletecompte) == nil then
                    return false
                else
                      if tostring(deletecompte) == "oui" then
                          SwLife.InternalToServer("BBanque:deletecompte")
                          ESX.ShowNotification("Demande de suppression de compte ~g~effectuée~s~.")
                          openinfo = false
                      elseif tostring(deletecompte) == "non" then
                          ESX.ShowNotification("Demande de suppression de compte ~r~annulée~s~.")
                      else
                          ESX.ShowNotification("Demande refusée, veuillez réponde par ~r~oui~s~ ou ~r~non~s~.")
                      end
                      prenom = (tostring(deletecompte))
                end
              end
            })
          end)

          RageUIv2.IsVisible(persoinfo,function()
            if myidentity then
                if mytypecompte then
                      RageUIv2.Button("Nom :", nil, {RightLabel = myidentity.nom}, true , {
                        onSelected = function()
                        end
                      })
                      RageUIv2.Button("Prénom :", nil, {RightLabel = myidentity.prenom}, true , {
                        onSelected = function()
                        end
                      })
                      RageUIv2.Button("Date de naissance :", nil, {RightLabel = myidentity.naissance}, true , {
                        onSelected = function()
                        end
                      })
                      RageUIv2.Button("Compte de Niveau :", nil, {RightLabel = mytypecompte.type}, true , {
                        onSelected = function()
                        end
                      })
                      if myidentity.statemotpasse == true then
                          RageUIv2.Button("Status Mot de Passe", nil, {RightLabel = "~g~Activé~s~"}, true , {
                            onSelected = function()
                            end
                          })
                      else
                          RageUIv2.Button("Status Mot de Passe", nil, {RightLabel = "~r~Désactivé~s~"}, true , {
                            onSelected = function()
                            end
                          })
                      end
                      RageUIv2.Button("Mot de Passe actuel", nil, {RightLabel = myidentity.motpasse}, true , {
                        onSelected = function()
                        end
                      })
                end
              end
          end)

          RageUIv2.IsVisible(mdpmodif,function()
                RageUIv2.Button("Activer le Mot de Passe", nil, {}, true , {
                  onSelected = function()
                    SwLife.InternalToServer("BBanque:activemdp", GetPlayerServerId(playerPed))
                    ESX.ShowNotification("~g~Le mot de passe est désormais actif.")
                  end
                })
                RageUIv2.Button("Désactiver le Mot de Passe", nil, {}, true , {
                  onSelected = function()
                    SwLife.InternalToServer("BBanque:desacmdp", GetPlayerServerId(playerPed))
                    ESX.ShowNotification("~r~Le mot de passe est désormais inactif.")
                  end
                })
                RageUIv2.Button("Changer de Mot de Passe", "Choisir votre Mot de Passe", {RightLabel = mdp}, true , {
                  onSelected = function()
                    local Mdpvali = KeyboardInput("mdpvd", 'Indiquez votre Mot de Passe', '', 5)
                    if Mdpvali ~= nil then
                        mdp = (tostring(Mdpvali))
                    end 
                  end
                })
                RageUIv2.Button("Valider le Mot de Passe", nil, {RightLabel = "→→", Color = {BackgroundColor = RageUIv2.ItemsColour.Blue}}, true , {
                  onSelected = function()
                    local Mdpvali = mdp
                
                    if not Mdpvali then
                        ESX.ShowNotification("Mot de Passe Invalide")
                    else
                        SwLife.InternalToServer("BBanque:setpassword", GetPlayerServerId(playerPed), Mdpvali)
                        ESX.ShowNotification("~g~Le mot de passe a été modifié avec succès.")
                        openinfo = false
                    end
                  end
                })
          end)

          RageUIv2.IsVisible(transac,function()
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

          RageUIv2.IsVisible(cdmenus,function()
              RageUIv2.Button("Carte Bancaire", "Acheter une Carte Bancaire", {RightLabel = "~g~250$~s~"}, true , {
                  onSelected = function()
                    SwLife.InternalToServer("BBanque:BuyCB")
                  end
              })
          end)

          RageUIv2.IsVisible(modiftype,function()
              RageUIv2.Button("Compte de Niveau 1", "Somme maximale : ~g~1000 $", {RightLabel = "~g~1250$~s~"}, true , {
                  onSelected = function()
                    SwLife.InternalToServer("BBanque:buycb1", GetPlayerServerId(playerPed))
                  end
              })
              RageUIv2.Button("Compte de Niveau 2", "Somme maximale : ~g~5000 $", {RightLabel = "~g~2500$~s~"}, true , {
                onSelected = function()
                  SwLife.InternalToServer("BBanque:buycb2", GetPlayerServerId(playerPed))
                end
              })
              RageUIv2.Button("Compte de Niveau 3", "Somme maximale : ~b~Illimité", {RightLabel = "~g~5000$~s~"}, true , {
                onSelected = function()
                  SwLife.InternalToServer("BBanque:buycb3", GetPlayerServerId(playerPed))
                end
              })
          end)
          Wait(1)
         end
      end)
   end
end

function CreaCompte()
     if open then 
         open = false
         RageUIv2.Visible(cracompte, false)
         return
     else
         open = true 
         RageUIv2.Visible(cracompte, true)
         CreateThread(function()
         while open do 
            RageUIv2.IsVisible(cracompte,function()
            
                    RageUIv2.Button("Prénom", "Indiquez votre Prénom", {RightLabel = prenom}, true , {
                        onSelected = function()
                          local prenomInput = KeyboardInput("prenom", 'Indiquez Votre Prénom', '', 20)
                          if tostring(prenomInput) == nil then
                              return false
                          else
                              prenom = (tostring(prenomInput))
                          end
                        end
                    })
                    RageUIv2.Button("Nom", "Indiquez votre Nom", {RightLabel = nom}, true , {
                        onSelected = function()
                          local nameInput = KeyboardInput("nom", 'Indiquez Votre Nom', '', 20)
                          if nameInput ~= nil then
                              nom = (tostring(nameInput))
                          end 
                        end
                    })
                    RageUIv2.Button("Date de Naissance", "Indiquez votre Date de Naissance", {RightLabel = dates}, true , {
                      onSelected = function()
                        local DateInput = KeyboardInput("daten", 'Indiquez Votre Date de Naissance type : jour/mois/année', '', 12)
                        if DateInput ~= nil then
                            dates = (tostring(DateInput))
                        end
                      end
                    })
                    RageUIv2.Button("Ouvrir son compte", "Valider vos informations", {RightLabel = "→→", Color = {BackgroundColor = RageUIv2.ItemsColour.Blue}}, true , {
                      onSelected = function()
                        local prenomInput = prenom
                        local nameInput = nom
                        local DateInput = dates
                        local mdp = "Aucun"

                        if not prenomInput then
                            ESX.ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Prénom")
                        elseif not nameInput then
                            ESX.ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Nom")
                        elseif not DateInput then
                            ESX.ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Date de naissance") 
                        else
                          SwLife.InternalToServer("BBanque:setname", GetPlayerServerId(playerPed), prenomInput, nameInput, DateInput, mdp)
                          SwLife.InternalToServer("BBanque:setstatecompte", true)
                          ESX.ShowNotification("~g~Votre compte bancaire a été ouvert avec succès !")
                          open = false
                        end
                      end
                    })
            end)
          Wait(1)
         end
      end)
   end
end

local creacompte = {
  crapose = {
      {pos = vector3(243.08926, 224.2578, 106.2869)}
  }
}

Citizen.CreateThread(function()
  while true do
      local pCoords2 = GetEntityCoords(PlayerPedId())
      local interval = 500
      local dst = GetDistanceBetweenCoords(pCoords2, true)
      for k,v in pairs(creacompte.crapose) do
          if #(pCoords2 - v.pos) < 2.0 then
            interval = 1
            ShowHelpNotification("Appuyez sur ~b~E~s~ pour parler au monsieur")
              if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("BBanque:getstate", function(statecompte)
                  if statecompte then
                    InfoCompte()
                  else
                    CreaCompte()
                  end 
              end)
              end
          end
      end
      Citizen.Wait(interval)
  end
end)