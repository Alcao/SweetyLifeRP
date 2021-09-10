ESX = nil

SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end


function CustomAmount()
    local montant = nil
    AddTextEntry("BANK_CUSTOM_AMOUNT", "Entrez le montant")
    DisplayOnscreenKeyboard(1, "BANK_CUSTOM_AMOUNT", '', "", '', '', '', 15)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        montant = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return tonumber(montant)
end

RegisterNetEvent('rRazzway:requestClothes')
AddEventHandler('rRazzway:requestClothes', function(clothesType)
    if clothesType == "haut" then
        ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skina)
            TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.torso_1 ~= skinb.torso_1 then
                    vethaut = true
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['torso_1'] = skina.torso_1, ['torso_2'] = skina.torso_2, ['tshirt_1'] = skina.tshirt_1, ['tshirt_2'] = skina.tshirt_2, ['arms'] = skina.arms})
                else
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
                    vethaut = false
                end
    
            end)
        end)    
    elseif clothesType == "bas" then
        ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skina)
            TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingtrousers', 'try_trousers_neutral_c'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.pants_1 ~= skinb.pants_1 then
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['pants_1'] = skina.pants_1, ['pants_2'] = skina.pants_2})
                    vetbas = true
                else
                    vetbas = false
                    if skina.sex == 1 then
                        TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['pants_1'] = 15, ['pants_2'] = 0})
                    else
                        TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['pants_1'] = 14, ['pants_2'] = 0})
                    end
                end
            end)
        end)
    elseif clothesType == "chaussures" then
        ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skina)
            TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingshoes', 'try_shoes_positive_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.shoes_1 ~= skinb.shoes_1 then
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['shoes_1'] = skina.shoes_1, ['shoes_2'] = skina.shoes_2})
                    vetch = true
                else
                    vetch = false
                    if skina.sex == 1 then
                        TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['shoes_1'] = 41, ['shoes_2'] = 0})
                    else
                        TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['shoes_1'] = 43, ['shoes_2'] = 0})
                    end
                end
            end)
        end)
    elseif clothesType == "sac" then
        ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skina)
            TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.bags_1 ~= skinb.bags_1 then
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['bags_1'] = skina.bags_1, ['bags_2'] = skina.bags_2})
                    vetsac = true
                else
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['bags_1'] = 0, ['bags_2'] = 0})
                    vetsac = false
                end
            end)
        end)    
    elseif clothesType == "masque" then
        ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skina)
            TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skinb)
                local lib, anim = 'missfbi4', 'takeoff_mask'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.mask_1 ~= skinb.mask_1 then
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['mask_1'] = skina.mask_1, ['mask_2'] = skina.mask_2})
                    vetmasque = true
                else
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['mask_1'] = 0, ['mask_2'] = 0})
                    vetmasque = false
                end
            end)
        end)  
    elseif clothesType == "gilet" then
        ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skina)
            TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.bproof_1 ~= skinb.bproof_1 then
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['bproof_1'] = skina.bproof_1, ['bproof_2'] = skina.bproof_2})
                    vetgilet = true
                else
                    TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skinb, {['bproof_1'] = 0, ['bproof_2'] = 0})
                    vetgilet = false
                end
            end)
        end)    
    end
end)
