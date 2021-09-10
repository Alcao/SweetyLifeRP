ESX = nil 
SwLife.newThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        TriggerEvent("::{razzway.xyz}::esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end
end)

payAmount = 0
nshops = {}

_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

DeleteCashier = function()
    for i=1, #ConfigShop.Locations do
        local cashier = ConfigShop.Locations[i]["cashier"]
        if DoesEntityExist(cashier["entity"]) then
            DeletePed(cashier["entity"])
            SetPedAsNoLongerNeeded(cashier["entity"])
        end
    end
end

SwLife.newThread(function()
    local defaultHash = 416176080
    for i=1, #ConfigShop.Locations do
        local cashier = ConfigShop.Locations[i]["cashier"]
        if cashier then
            cashier["hash"] = cashier["hash"] or defaultHash
            _RequestModel(cashier["hash"])
            if not DoesEntityExist(cashier["entity"]) then
                cashier["entity"] = CreatePed(4, cashier["hash"], cashier["x"], cashier["y"], cashier["z"], cashier["h"])
                SetEntityAsMissionEntity(cashier["entity"])
                SetBlockingOfNonTemporaryEvents(cashier["entity"], true)
                FreezeEntityPosition(cashier["entity"], true)
                SetEntityInvincible(cashier["entity"], true)
            end
            SetModelAsNoLongerNeeded(cashier["hash"])
        end
    end
end)

SwLife.newThread(function()
    while true do
        local wait = 750
        local coords = GetEntityCoords(PlayerPedId())
        for i=1, #ConfigShop.Locations do
            for j=1, #ConfigShop.Locations[i]["shelfs"] do
                local pos = ConfigShop.Locations[i]["shelfs"][j]
                local dist = GetDistanceBetweenCoords(coords, pos["x"], pos["y"], pos["z"], true)
                if dist <= 5.0 then
                    if dist <= 1.5 then
                        local text = ConfigShop.Locales[pos["value"]]
                        if dist <= 1.5 then
                            text = "Appuyez sur [~y~E~s~] pour accéder au " .. text
                            if IsControlJustPressed(0, 38) then
                                OpenAction(pos, ConfigShop.Items[pos["value"]], ConfigShop.Locales[pos["value"]])
                        	end
                        end
                        RageUI.Text({ message = text, time_display = 1 })
                    end
                    wait = 5
                    Marker(pos)
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

OpenAction = function(action, shelf, text)
    if action["value"] == "checkout" then
        if payAmount > 0 and #nshops then
            CashRegister(text)
        else
            vide(text)
        end
    else
        ShelfMenu(text, shelf)
    end
end

RMenu.Add('paniervide', 'main', RageUI.CreateMenu("~b~Super-Marché", "Finalisez vos achat(s) !", 10,80))
RMenu:Get('paniervide', 'main'):SetRectangleBanner(0,0,0, 90)
RMenu.Add('paniervide', 'npayement', RageUI.CreateSubMenu(RMenu:Get('paniervide', 'main'), "~b~Super-Marché", "~g~Finalisez vos achat(s) !"))
RMenu:Get('paniervide', 'main').Closed = function()
	nehcovide = false
end;

            vide = function(titel)
                if not nehcovide then
                    nehcovide = true
                    RageUI.Visible(RMenu:Get('paniervide', 'main'), true)
                    SwLife.newThread(function()
                    local nehcotqt = {}
                    while nehcovide do
                    Citizen.Wait(1)
                    RageUI.IsVisible(RMenu:Get('paniervide', 'main'), true, true, true, function()
                    RageUI.Separator("")
                    RageUI.Separator("~r~Aucun article dans le panier")
                    RageUI.Separator("")
                end)
            end
        end)
    end
end

RMenu.Add('nshops', 'main', RageUI.CreateMenu("~b~Super-Marché", "Finalisez vos achat(s) ! ", 10,80))
RMenu:Get('nshops', 'main'):SetRectangleBanner(0,0,0, 90)
RMenu.Add('nshops', 'npayement', RageUI.CreateSubMenu(RMenu:Get('nshops', 'main'), "~b~Super-Marché", "Finalisez vos achat(s) !"))
RMenu.Add('nshops', 'payementtotal', RageUI.CreateSubMenu(RMenu:Get('nshops', 'main'), "~b~Super-Marché", "Finalisez vos achat(s) !"))
RMenu:Get('nshops', 'main').Closed = function()
	nehcoss = false
end;

CashRegister = function(titel)
	if not nehcoss then
		nehcoss = true
		RageUI.Visible(RMenu:Get('nshops', 'main'), true)
        SwLife.newThread(function()
        local nehcotqt = {}
		while nehcoss do
        Citizen.Wait(1)
        RageUI.IsVisible(RMenu:Get('nshops', 'main'), true, true, true, function()
        RageUI.Separator("~y~Liste de vos article(s) ~s~")
        for k,v in pairs(nshops) do
        RageUI.ButtonWithStyle("Nom : ~b~".. v["label"], nil, {RightLabel = "Quantité : ~r~".. v["amount"].."  ~s~→→"}, true, function(h, a, s)
            if s then
                selec = v
                oui = k
            end
        end, RMenu:Get('nshops', 'npayement'))
    end
end)

RageUI.IsVisible(RMenu:Get("nshops",'npayement'),true,true,true,function()

                    local total = selec["price"]*selec["amount"]
                    RageUI.ButtonWithStyle("Nom de l'article : ~b~" ..selec["label"], nil, {RightLabel = ""}, true, function(h, a, s) 
                        if s then
                            
                        end
                    end)
                    RageUI.ButtonWithStyle("Quantité : ~b~x" ..selec["amount"], nil, {RightLabel = ""}, true, function(h, a, s) 
                        if s then
                            
                        end
                    end)
                    RageUI.ButtonWithStyle("Prix Total : ~b~" ..total.." $", nil, {RightLabel = ""}, true, function(h, a, s) 
                        if s then
                            
                        end
                    end)
                    RageUI.Separator("")


                    RageUI.ButtonWithStyle("Confimer et payer ses articles", nil, {RightBadge = RageUI.BadgeStyle.Tick,Color = { HightLightColor = {0, 158, 255, 160}, BackgroundColor = {0, 178, 255, 160}}}, true, function(_,_,s)
                    if s then
                        cash = "1"
                        SwLife.InternalToServer("rz-core:itemshops", selec["price"], selec["value"], selec["amount"], cash)
                        ESX.ShowAdvancedNotification('SwLife', '~y~SuperMarché', 'Merci de vos achat(s) ! ~s~à très bientot !', 'CHAR_MANUEL', 1)
                        payAmount = payAmount - (selec["price"])
                        table.remove(nshops, oui)
                        RageUI.GoBack()
                        if selec["label"] == "Bouteille d'eau" then
                            selec["label"] = "Eau"
                        end
                        AddBankTransaction("Achat: ~g~"..selec["label"].." en "..selec["amount"].." exemplaires.")
                    end
                end)
                end)
            end
        end)
    end
end

RMenu.Add('nshop', 'main', RageUI.CreateMenu("~b~Super-Marché", "Faites vos choix", 10,80))
RMenu:Get('nshop', 'main'):SetRectangleBanner(0,0,0, 90)
RMenu:Get('nshop', 'main').Closed = function()
	nehcos = false
end;

ShelfMenu = function(titel, shelf)
	if not nehcos then
		nehcos = true
		RageUI.Visible(RMenu:Get('nshop', 'main'), true)
	    SwLife.newThread(function()
		while nehcos do
        Citizen.Wait(1)
        RageUI.IsVisible(RMenu:Get('nshop', 'main'), true, true, true, function()
            for i=1, #shelf do
                local shelf = shelf[i]
                RageUI.ButtonWithStyle("Article : ~b~".. shelf["label"], "Nom : ~b~"..shelf["label"].."~s~ | Prix : ~b~" ..shelf["price"].. " $", {RightLabel = "[ ~y~+ Panier~s~ ]"}, true, function(h, a, s)
                    if s then
                        local alreadyHave, nshopsItem = ChecknshopsItem(shelf.item)
                        if alreadyHave then
                            nshopsItem.amount = nshopsItem["amount"] + 1
                        else
                            table.insert(nshops, {
                                label = shelf["label"],
                                value = shelf["item"],
                                amount = 1,
                                price = shelf["price"]
                            })
                            ESX.ShowAdvancedNotification('~r~SwLife', '~y~SuperMarché', 'Votre article à été ajouté à votre panier !', 'CHAR_MANUEL', 1)
                        end
                        payAmount = payAmount + shelf["price"] * 1         
                    end
                end)
            end
        end)
    end
    end)
end
end

ChecknshopsItem = function(item)
    for i=1, #nshops do
        if item == nshops[i]["value"] then
            return true, nshops[i]
        end
    end
    return false, nil
end

-- Position des shops --
local rShops = {
    {x = 373.87, y = 325.89, z = 103.36},
    {x = 2557.45, y = 382.28, z = 108.42},
    {x = -3038.93, y = 585.95, z = 7.7},
    {x = -3241.92, y = 1001.46, z = 12.63},
    {x = 547.43, y = 2671.71, z = 41.95},
    {x = 1961.46, y = 3740.67, z = 32.14},
    {x = 1729.21, y = 6414.13, z = 34.83},
    {x = 2678.91, y = 3280.67, z = 55.04},
    {x = 1135.8, y = -982.28, z = 46.21},
    {x = -1222.91, y = -906.98, z = 12.12},
    {x = -1487.55, y = -379.10, z = 39.96},
    {x = -2968.24, y = 390.91, z = 14.84},
    {x = 1166.02, y = 2708.93, z = 37.95},
    {x = 1392.56, y = 3604.68, z = 34.78},
    {x = -48.51, y = -1757.51, z = 29.22},
    {x = 1163.37, y = -323.80, z = 69.0},
    {x = -707.5, y = -914.26, z = 19.01},
    {x = -1820.52, y = 792.51, z = 137.91},
    {x = 1698.38, y = 4924.40, z = 41.86},
    {x = 25.77, y = -1347.58, z = 29.4},
    {x = 190.01, y = -889.62, z = 30.71}
}  

-- Blips & Marker --
SwLife.newThread(function()
    for k in pairs(rShops) do
       local bliprShops = AddBlipForCoord(rShops[k].x, rShops[k].y, rShops[k].z)
       SetBlipSprite(bliprShops, 52)
       SetBlipColour(bliprShops, 2)
       SetBlipScale(bliprShops, 0.6)
       SetBlipAsShortRange(bliprShops, true)

       BeginTextCommandSetBlipName('STRING')
       AddTextComponentString("Supérette")
       EndTextCommandSetBlipName(bliprShops)
   end
end)

Marker = function(pos)
    DrawMarker(6, pos["x"], pos["y"], pos["z"], 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
    DrawMarker(6, pos["x"], pos["y"], pos["z"], 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteCashier()
    end
end)