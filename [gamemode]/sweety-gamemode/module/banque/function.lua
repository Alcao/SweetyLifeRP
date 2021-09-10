function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
  
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
      Citizen.Wait(0)
    end
  
    if UpdateOnscreenKeyboard() ~= 2 then
      local result = GetOnscreenKeyboardResult()
     -- Citizen.Wait(500)
      return result
    else
      --Citizen.Wait(500)
      return nil
    end
end


bankTransaction = {}

Citizen.CreateThread(function()
    local encoded = GetResourceKvpString("transaction")
    if encoded ~= nil then
        decodeBankTransaction(encoded)
    else
        bankTransaction = {}
    end
end)

function EncodeBankTransaction(transac)
    local encoded = json.encode(transac)
    SetResourceKvp("transaction", encoded)
end

function decodeBankTransaction(transac)
    local decoded = json.decode(transac)
    bankTransaction = decoded
end

function AddBankTransaction(transaction)
    local m = GetClockMinutes()
    local h = GetClockHours()
    local s = GetClockSeconds()
    local transaction = transaction.." - ~o~Validé~w~"
    table.insert(bankTransaction, transaction)
    EncodeBankTransaction(bankTransaction)
end

function ClearTransaction()
    bankTransaction = {}
    EncodeBankTransaction(bankTransaction)
end

function getidentitymec(player)
	ESX.TriggerServerCallback('BBanque:getname', function(data)
		myidentity = data
	end, GetPlayerServerId(player))
end

function GetPlayerMoney(action)
    SwLife.InternalToServer("bank:solde", action)
end

function GetPlayerMoneySolde(action)
    SwLife.InternalToServer("money:solde", action)
end

function gettypecompte(player)
	ESX.TriggerServerCallback('BBanque:gettypecompte', function(data)
		mytypecompte = data
	end, GetPlayerServerId(player))
end

function getmotpasse(player)
	ESX.TriggerServerCallback('BBanque:getmotpasse', function(data)
		myverifmdp = data
	end, GetPlayerServerId(player))
end


------ divers

--- pnj
Citizen.CreateThread(function()
    local hash = GetHashKey("a_m_m_business_01")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("a_m_m_business_01", "a_m_m_business_01", 244.144, 226.5296, 105.2875, 160.9963, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
end)

--- blips
Citizen.CreateThread(function()
	for i=1, #cfg_banking.Bank, 1 do
		local blip = AddBlipForCoord(cfg_banking.Bank[i].x, cfg_banking.Bank[i].y, cfg_banking.Bank[i].z)
		SetBlipSprite (blip, 500)
		SetBlipScale  (blip, 0.6)
		SetBlipColour (blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("[Public] Banque")
        EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	for i=1, #cfg_banking.Bank2, 1 do
		local blip2 = AddBlipForCoord(cfg_banking.Bank2[i].x, cfg_banking.Bank2[i].y, cfg_banking.Bank2[i].z)
		SetBlipSprite (blip2, 207)
		SetBlipDisplay(blip2, 4)
		SetBlipScale  (blip2, 0.8)
		SetBlipColour (blip2, 2)
        SetBlipAsShortRange(blip2, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("[Public] Banque Centrale")
        EndTextCommandSetBlipName(blip2)
	end
end)