ESX = nil
SwLife.newThread(function()
    while ESX == nil do
        TriggerEvent('SwLife:initObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
end)

local Clothes = {}
Components = {}
ComponentsMax = {}
sLoaded = nil
sData = {}
sCharEnd = true
sIdentityEnd = true
local TenueTable = {}


local cam, isCameraActive
local firstSpawn, zoomOffset, camOffset, heading = true, 0.0, 0.0, 90.0

sClothescomponents = {
    "arms",	
    "arms_2",
    "tshirt_1", 
    "tshirt_2", 
    "torso_1", 
    "torso_2", 
    "decals_1", 
    "decals_2", 
    "pants_1",
    "pants_2",
    "shoes_1",
    "shoes_2",
    "bproof_1",
    "bproof_2"
}

function GetComponents()
	TriggerEvent('::{razzway.xyz}::skinchanger:getData', function(data, max)
		Components = data
		ComponentsMax = max
	end)
end

RegisterNetEvent("OpenClothesMenu")
AddEventHandler("OpenClothesMenu",function()
    OpenClothesMenu()
end)

local vetementActions = {
    "Mettre",
    "Supprimer",
    "Renommer"
}
vetementActionsIndex = 1

function OpenClothesMenu()

    if Clothes.Menu then 
        Clothes.Menu = false 
        RageUI.Visible(RMenu:Get('clothes', 'main'), false)
        sCharacter = nil
        KillCreatorCam()
        FreezeEntityPosition(GetPlayerPed(-1), true)
        return
    else
        RMenu.Add('clothes', 'main', RageUI.CreateMenu("Vêtements", "Que souhaitez vous changer ?")) --Menu principal
        RMenu.Add('clothes', 'playerclothes', RageUI.CreateSubMenu(RMenu:Get("clothes", "main"),"Vêtements", "~b~Que souhaitez vous changer ?"))
        RMenu.Add('clothes', 'characteroptionshead', RageUI.CreateSubMenu(RMenu:Get("clothes", "main"),"Vêtements", "~b~Que souhaitez vous changer ?"))
        RMenu.Add('clothes', 'characteroptions_s', RageUI.CreateSubMenu(RMenu:Get("clothes", "character"),"Vêtements", "~b~Que souhaitez vous changer ?")) -- validé
        RMenu.Add('clothes', 'characteroptions_h', RageUI.CreateSubMenu(RMenu:Get("clothes", "characteroptionshead"),"Vêtements", "~b~Que souhaitez vous changer ?")) -- validé
        RMenu:Get('clothes', 'main'):SetSubtitle("~b~Que souhaitez vous changer ?")
        RMenu:Get('clothes', 'main').EnableMouse = false
        RMenu:Get('clothes', 'main').Closable = true
        RMenu:Get('clothes', 'main').Closed = function()
            Clothes.Menu = false
            KillCreatorCam()
            FreezeEntityPosition(GetPlayerPed(-1), false)
            ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin) 
            end)
        end
        GetComponents()
        CreateCreatorCam()
        sCharEnd = true
        sIdentityEnd = true
        SwitchCam(false, 'default')
        Clothes.Menu = true 
        RageUI.Visible(RMenu:Get('clothes', 'main'), true)
        SwLife.newThread(function()
			while Clothes.Menu do
                RageUI.IsVisible(RMenu:Get('clothes', 'main'), true, true, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    RageUI.ButtonWithStyle("Mes vêtements", "~b~Que souhaitez vous changer ?", {RightLabel = "→"}, true,function(h,a,s)
                        if s then
                            ESX.TriggerServerCallback("::{razzway.xyz}::esx_clotheshop:saveOutfit", function(result) 
                                resultClothes = result
                            end)
                        end
                    end,RMenu:Get("clothes","playerclothes"))
                    RageUI.ButtonWithStyle("Vêtements", "~b~Que souhaitez vous changer ?", {RightLabel = "→"}, true,function(h,a,s)
                        if s then
                            GetComponents()
                        end
                    end,RMenu:Get("clothes","characteroptionshead"))
                    RageUI.ButtonWithStyle("Valider le changement", nil, {RightLabel = "→ ~b~500$"}, true,function(h,a,s)
                        if s then
                            local label = CKeyboardInput("Nom de votre ~b~tenue~s~ :", "", 20)
                            SwLife.InternalToServer('Razzway#1337:clotheshop:pay', function(ok)
                                if ok then
                                    if label ~= nil then
                                        TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
                                            SwLife.InternalToServer('::{razzway.xyz}::esx_skin:save', skin)
                                            SwLife.InternalToServer('::{razzway.xyz}::esx_clotheshop:saveOutfit', skin)
                                        end)
                                        ESX.ShowNotification("Vous avez bien enregistré la tenue : ~b~"..label)
                                        Clothes.Menu = false
                                        KillCreatorCam()
                                        FreezeEntityPosition(GetPlayerPed(-1), false)
                                    else
                                        ESX.ShowNotification("~r~Nom de tenue invalide")
                                    end
                                else
                                    ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas assez d'argent")
                                end
                            end,100)
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('clothes', 'playerclothes'), true, true, true, function()
                    if resultClothes == nil then
                        RageUI.Separator("")
                        RageUI.Separator("~b~Chargement ...")
                        RageUI.Separator("")
                    else
                        if #resultClothes == 0 then
                            RageUI.Separator("")
                            RageUI.Separator("~b~Vous n'avez pas de vêtements !")
                            RageUI.Separator("")
                        else
                            RageUI.Separator("↓ ~b~Vos vêtements~s~ ↓")
                            for k,v in pairs(resultClothes) do
                                RageUI.List("Vêtement - ~y~"..label, vetementActions, vetementActionsIndex, nil, {}, true, function(h,a,s, Index)
                                    if s then 
                                        if Index == 1 then
                                            TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
                                                TriggerEvent('::{razzway.xyz}::skinchanger:loadClothes', skin, json.decode(v.clothes))
                                                    TriggerEvent('::{razzway.xyz}::skinchanger:getSkin', function(skin)
                                                    SwLife.InternalToServer('::{razzway.xyz}::esx_skin:save', skin)
                                                end)
                                            end)    
                                        elseif Index == 2 then
                                            SwLife.InternalToServer("::{razzway.xyz}::esx_clotheshop:deleteOutfit", v)
                                            RageUI.GoBack()
                                        elseif Index == 3 then
                                            local NewName = CKeyboardInput("Veuillez saisir le nouveau nom de votre tenue :", "", 20)
                                            if NewName == nil or NewName == "" then
                                                ESX.ShowNotification("~r~Valeurs invalide !")
                                            else
                                                SwLife.InternalToServer("Clothes:renomeTenue", NewName, v)
                                                RageUI.GoBack()
                                            end
                                        end
                                    end
                                    vetementActionsIndex = Index
                                end)
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('clothes', 'characteroptionshead'), true, true, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for k,v in pairs(Components) do
                        for _, s_head in pairs(sClothescomponents) do
                            if zoomOffset ~= v.zoomOffset and camOffset ~= v.camOffset then 
                                zoomOffset = v.zoomOffset
                                camOffset = v.camOffset
                            end
                            if label == s_head then
                                RageUI.ButtonWithStyle(v.label, "~b~Que souhaitez vous changer ?", {RightLabel = "→"}, true,function(h,a,s)
                                    if a then
                                        sData = label
                                        SwitchCam(false, label)
                                    end
                                    if s then
                                        GetComponents()
                                    end
                                end,RMenu:Get("clothes","characteroptions_h"))
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('clothes', 'characteroptions_h'), true, true, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for _,v in pairs(Components) do
                        if label == sData then
                            for i = 0, ComponentsMax[sData] do
                                RageUI.ButtonWithStyle(v.label.." ~b~(N°"..i..")", "~b~Que souhaitez vous changer ?", {RightLabel = "→"}, true,function(h,a,s)
                                    if a then
                                        if sLoaded ~= i then
                                            sLoaded = i
                                            TriggerEvent('::{razzway.xyz}::skinchanger:change', label, i)
                                        end
                                    end
                                end)
                            end
                        end
                    end 
                end)
				Wait(0)
			end
		end)
	end
end

function CKeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) 
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

local ClothesShop = {
    {x = 72.254, y = -1399.102, z = 28.376},
    {x = 4489.3681640625, y = -4451.9497070313, z = 4.3664598464966},
    {x = -703.776, y = -152.258, z = 36.415},
    {x = -167.863, y = -298.969, z = 38.733},
    {x = 428.694, y = -800.106, z = 28.491},
    {x = -829.413, y = -1073.710, z = 10.328},
    {x = -1447.797, y = -242.461, z = 48.820},
    {x = 11.632, y = 6514.224, z = 30.877},	
    {x = 123.646, y = -219.440, z = 53.557},	
    {x = 1696.291, y = 4829.312, z = 41.063},	
    {x = 618.093, y = 2759.629, z = 41.088},	
    {x = 1190.550, y = 2713.441, z = 37.222},	
    {x = -1193.429, y = -772.2621, z = 16.324},	
    {x = -3172.496, y = 1048.133, z = 19.863},	
    {x = -1108.441, y =  2708.923, z = 18.107}
}  

-- Blips
SwLife.newThread(function()
    for k in pairs(ClothesShop) do
       local blipClothesShop = AddBlipForCoord(ClothesShop[k].x, ClothesShop[k].y, ClothesShop[k].z)
       SetBlipSprite(blipClothesShop, 73)
       SetBlipColour(blipClothesShop, 61)
       SetBlipScale(blipClothesShop, 0.6)
       SetBlipAsShortRange(blipClothesShop, true)

       BeginTextCommandSetBlipName('STRING')
       AddTextComponentString("Magasin de Vêtements")
       EndTextCommandSetBlipName(blipClothesShop)
   end
end)

SwLife.newThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(ClothesShop) do
            local mPos = Vdist(pCoords.x, pCoords.y, pCoords.z, ClothesShop[k].x, ClothesShop[k].y, ClothesShop[k].z)
            if not Clothes.Menu then
                if mPos <= 10.0 then
                    DrawMarker(6, ClothesShop[k].x, ClothesShop[k].y, ClothesShop[k].z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 128, 255, 170, 0, 0, 0, 1, nil, nil, 0)
                    att = 1
                    if mPos <= 1.4 then
                        ESX.ShowHelpNotification("Appuyez sur ~b~E~s~ pour interagir avec le magasin")
                        if IsControlJustPressed(0, 51) then
                            ESX.TriggerServerCallback('::{razzway.xyz}::esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('::{razzway.xyz}::skinchanger:loadSkin', skin) 
                            end)
                            OpenClothesMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)


local CamOffset = {
	{item = "default", 		cam = {0.0, 3.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "default_face", cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 35.0},
	{item = "face",			cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 20.0},
	{item = "skin", 		cam = {0.0, 2.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 30.0},
	{item = "tshirt_1", 	cam = {0.0, 2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "tshirt_2", 	cam = {0.0, 2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "torso_1", 		cam = {0.0, 2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "torso_2", 		cam = {0.0, 2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "decals_1", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "decals_2", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "arms", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "arms_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "pants_1", 		cam = {0.0, 2.0, -0.35}, lookAt = {0.0, 0.0, -0.4}, fov = 35.0},
	{item = "pants_2", 		cam = {0.0, 2.0, -0.35}, lookAt = {0.0, 0.0, -0.4}, fov = 35.0},
	{item = "shoes_1", 		cam = {0.0, 2.0, -0.5}, lookAt = {0.0, 0.0, -0.6}, fov = 40.0},
	{item = "shoes_2", 		cam = {0.0, 2.0, -0.5}, lookAt = {0.0, 0.0, -0.6}, fov = 25.0},
	{item = "age_1",			cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "age_2",			cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "beard_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "beard_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "beard_3", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "beard_4", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "hair_1",		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "hair_2",		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "hair_color_1",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "hair_color_2",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eye_color", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eyebrows_1", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eyebrows_2", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eyebrows_3", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eyebrows_4", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "makeup_1", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "makeup_2", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "makeup_3", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "makeup_4", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "lipstick_1", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "lipstick_2", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "lipstick_3", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "lipstick_4", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blemishes_1",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blemishes_2",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blush_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blush_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blush_3", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "complexion_1",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "complexion_2",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "sun_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "sun_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "moles_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "moles_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chest_1", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chest_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chest_3", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bodyb_1", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bodyb_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "ears_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 35.0},
	{item = "ears_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 35.0},
	{item = "mask_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 20.0},
	{item = "mask_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 20.0},
	{item = "bproof_1", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bproof_2", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chain_1", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chain_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bags_1", 		cam = {0.0, -2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "bags_2", 		cam = {0.0, -2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "helmet_1", 	cam = {0.0, 1.0, 0.73}, lookAt = {0.0, 0.0, 0.68}, fov = 20.0},
	{item = "helmet_2", 	cam = {0.0, 1.0, 0.73}, lookAt = {0.0, 0.0, 0.68}, fov = 20.0},
	{item = "glasses_1", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "glasses_2", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "watches_1", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "watches_2", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bracelets_1",	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bracelets_2",	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
}

function GetCamOffset(type)
	for k,v in pairs(CamOffset) do
		if v.item == type then
			return v
		end
	end
end

function CreateCreatorCam()
    SwLife.newThread(function()
        local pPed = GetPlayerPed(-1)
        local offset = GetCamOffset("default")
        local pos = GetOffsetFromEntityInWorldCoords(pPed, offset.cam[1], offset.cam[2], offset.cam[3])
        local posLook = GetOffsetFromEntityInWorldCoords(pPed, offset.lookAt[1], offset.lookAt[2], offset.lookAt[3])

        CreatorCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
        
        SetCamActive(CreatorCam, 1)
        SetCamCoord(CreatorCam, pos.x, pos.y, pos.z)
        SetCamFov(CreatorCam, offset.fov)
        PointCamAtCoord(CreatorCam, posLook.x, posLook.y, posLook.z)

        RenderScriptCams(1, 1, 1000, 0, 0)
    end)
end

function SwitchCam(backto, type)
    if not DoesCamExist(cam2) then cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0) end
    SwLife.newThread(function()
        local pPed = GetPlayerPed(-1)
        local offset = GetCamOffset(type)
        if offset == nil then
            offset = GetCamOffset("default")
        end
        local pos = GetOffsetFromEntityInWorldCoords(pPed, offset.cam[1], offset.cam[2], offset.cam[3])
        local posLook = GetOffsetFromEntityInWorldCoords(pPed, offset.lookAt[1], offset.lookAt[2], offset.lookAt[3])

        if backto then
            SetCamActive(CreatorCam, 1)

            SetCamCoord(CreatorCam, pos.x, pos.y, pos.z)
            SetCamFov(CreatorCam, offset.fov)
            PointCamAtCoord(CreatorCam, posLook.x, posLook.y, posLook.z)
            SetCamActiveWithInterp(CreatorCam, cam2, 1000, 1, 1)
            Wait(1000)
            
        else
            SetCamActive(cam2, 1)

            SetCamCoord(cam2, pos.x, pos.y, pos.z)
            SetCamFov(cam2, offset.fov)
            PointCamAtCoord(cam2, posLook.x, posLook.y, posLook.z)
            SetCamDofMaxNearInFocusDistance(cam2, 1.0)
            SetCamDofStrength(cam2, 500.0)
            SetCamDofFocalLengthMultiplier(cam2, 500.0)
            SetCamActiveWithInterp(cam2, CreatorCam, 1000, 1, 1)
            Wait(1000)
        end
    end)
end

function KillCreatorCam()
    RenderScriptCams(0, 1, 1000, 0, 0)
    SetCamActive(CreatCam, 0)
    SetCamActive(cam2, 0)
    ClearPedTasks(GetPlayerPed(-1))
end