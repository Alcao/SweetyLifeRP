---@class Client
local Client = {} or {};

---@type table Content category menu
local category = {} or {};

---@type table All items
local items = {} or {};

---@type table History activity
local history = {} or {};

---@type table Selected items
local selected = {} or {};

---@type number Current players points
local points = 0;

---@type table Shared object
ESX = {};

TableWeapon = {
    ["WEAPON_DAGGER"] = GetHashKey("WEAPON_DAGGER"),
    ["WEAPON_BAT"] = GetHashKey("WEAPON_BAT"),
    ["WEAPON_BOTTLE"] = GetHashKey("WEAPON_BOTTLE"),
    ["WEAPON_CROWBAR"] = GetHashKey("WEAPON_CROWBAR"),
    ["WEAPON_UNARMED"] = GetHashKey("WEAPON_UNARMED"),
    ["WEAPON_FLASHLIGHT"] = GetHashKey("WEAPON_FLASHLIGHT"),
    ["WEAPON_GOLFCLUB"] = GetHashKey("WEAPON_GOLFCLUB"),
    ["WEAPON_HAMMER"] = GetHashKey("WEAPON_HAMMER"),
    ["WEAPON_HATCHET"] = GetHashKey("WEAPON_HATCHET"),
    ["WEAPON_KNUCKLE"] = GetHashKey("WEAPON_KNUCKLE"),
    ["WEAPON_KNIFE"] = GetHashKey("WEAPON_KNIFE"),
    ["WEAPON_MACHETE"] = GetHashKey("WEAPON_MACHETE"),
    ["WEAPON_SWITCHBLADE"] = GetHashKey("WEAPON_SWITCHBLADE"),
    ["WEAPON_NIGHTSTICK"] = GetHashKey("WEAPON_NIGHTSTICK"),
    ["WEAPON_WRENCH"] = GetHashKey("WEAPON_WRENCH"),
    ["WEAPON_BATTLEAXE"] = GetHashKey("WEAPON_BATTLEAXE"),
    ["WEAPON_POOLCUE"] = GetHashKey("WEAPON_POOLCUE"),
    ["WEAPON_STONE_HATCHET"] = GetHashKey("WEAPON_STONE_HATCHET"),
    ["WEAPON_PISTOL"] = GetHashKey("WEAPON_PISTOL"),
    ["WEAPON_PISTOL_MK2"] = GetHashKey("WEAPON_PISTOL_MK2"),
    ["WEAPON_COMBATPISTOL"] = GetHashKey("WEAPON_COMBATPISTOL"),
    ["WEAPON_APPISTOL"] = GetHashKey("WEAPON_APPISTOL"),
    ["WEAPON_STUNGUN"] = GetHashKey("WEAPON_STUNGUN"),
    ["WEAPON_PISTOL50"] = GetHashKey("WEAPON_PISTOL50"),
    ["WEAPON_SNSPISTOL"] = GetHashKey("WEAPON_SNSPISTOL"),
    ["WEAPON_SNSPISTOL_MK2"] = GetHashKey("WEAPON_SNSPISTOL_MK2"),
    ["WEAPON_HEAVYPISTOL"] = GetHashKey("WEAPON_HEAVYPISTOL"),
    ["WEAPON_VINTAGEPISTOL"] = GetHashKey("WEAPON_VINTAGEPISTOL"),
    ["WEAPON_FLAREGUN"] = GetHashKey("WEAPON_FLAREGUN"),
    ["WEAPON_MARKSMANPISTOL"] = GetHashKey("WEAPON_MARKSMANPISTOL"),
    ["WEAPON_REVOLVER"] = GetHashKey("WEAPON_REVOLVER"),
    ["WEAPON_REVOLVER_MK2"] = GetHashKey("WEAPON_REVOLVER_MK2"),
    ["WEAPON_DOUBLEACTION"] = GetHashKey("WEAPON_DOUBLEACTION"),
    ["WEAPON_RAYPISTOL"] = GetHashKey("WEAPON_RAYPISTOL"),
    ["WEAPON_CERAMICPISTOL"] = GetHashKey("WEAPON_CERAMICPISTOL"),
    ["WEAPON_NAVYREVOLVER"] = GetHashKey("WEAPON_NAVYREVOLVER"),
    ["WEAPON_MICROSMG"] = GetHashKey("WEAPON_MICROSMG"),
    ["WEAPON_SMG"] = GetHashKey("WEAPON_SMG"),
    ["WEAPON_SMG_MK2"] = GetHashKey("WEAPON_SMG_MK2"),
    ["WEAPON_ASSAULTSMG"] = GetHashKey("WEAPON_ASSAULTSMG"),
    ["WEAPON_COMBATPDW"] = GetHashKey("WEAPON_COMBATPDW"),
    ["WEAPON_MACHINEPISTOL"] = GetHashKey("WEAPON_MACHINEPISTOL"),
    ["WEAPON_MINISMG"] = GetHashKey("WEAPON_MINISMG"),
    ["WEAPON_RAYCARBINE"] = GetHashKey("WEAPON_RAYCARBINE"),
    ["WEAPON_PUMPSHOTGUN"] = GetHashKey("WEAPON_PUMPSHOTGUN"),
    ["WEAPON_PUMPSHOTGUN_MK2"] = GetHashKey("WEAPON_PUMPSHOTGUN_MK2"),
    ["WEAPON_SAWNOFFSHOTGUN"] = GetHashKey("WEAPON_SAWNOFFSHOTGUN"),
    ["WEAPON_ASSAULTSHOTGUN"] = GetHashKey("WEAPON_ASSAULTSHOTGUN"),
    ["WEAPON_BULLPUPSHOTGUN"] = GetHashKey("WEAPON_BULLPUPSHOTGUN"),
    ["WEAPON_MUSKET"] = GetHashKey("WEAPON_MUSKET"),
    ["WEAPON_HEAVYSHOTGUN"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
    ["WEAPON_DBSHOTGUN"] = GetHashKey("WEAPON_DBSHOTGUN"),
    ["WEAPON_AUTOSHOTGUN"] = GetHashKey("WEAPON_AUTOSHOTGUN"),
    ["WEAPON_ASSAULTRIFLE"] = GetHashKey("WEAPON_ASSAULTRIFLE"),
    ["WEAPON_ASSAULTRIFLE_MK2"] = GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),
    ["WEAPON_CARBINERIFLE"] = GetHashKey("WEAPON_CARBINERIFLE"),
    ["WEAPON_CARBINERIFLE_MK2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
    ["WEAPON_ADVANCEDRIFLE"] = GetHashKey("WEAPON_ADVANCEDRIFLE"),
    ["WEAPON_SPECIALCARBINE"] = GetHashKey("WEAPON_SPECIALCARBINE"),
    ["WEAPON_SPECIALCARBINE_MK2"] = GetHashKey("WEAPON_SPECIALCARBINE_MK2"),
    ["WEAPON_BULLPUPRIFLE"] = GetHashKey("WEAPON_BULLPUPRIFLE"),
    ["WEAPON_BULLPUPRIFLE_MK2"] = GetHashKey("WEAPON_BULLPUPRIFLE_MK2"),
    ["WEAPON_COMPACTRIFLE"] = GetHashKey("WEAPON_COMPACTRIFLE"),
    ["WEAPON_MG"] = GetHashKey("WEAPON_MG"),
    ["WEAPON_COMBATMG"] = GetHashKey("WEAPON_COMBATMG"),
    ["WEAPON_COMBATMG_MK2"] = GetHashKey("WEAPON_COMBATMG_MK2"),
    ["WEAPON_GUSENBERG"] = GetHashKey("WEAPON_GUSENBERG"),
    ["WEAPON_SNIPERRIFLE"] = GetHashKey("WEAPON_SNIPERRIFLE"),
    ["WEAPON_HEAVYSNIPER"] = GetHashKey("WEAPON_HEAVYSNIPER"),
    ["WEAPON_HEAVYSNIPER_MK2"] = GetHashKey("WEAPON_HEAVYSNIPER_MK2"),
    ["WEAPON_MARKSMANRIFLE"] = GetHashKey("WEAPON_MARKSMANRIFLE"),
    ["WEAPON_MARKSMANRIFLE_MK2"] = GetHashKey("WEAPON_MARKSMANRIFLE_MK2"),
    ["WEAPON_RPG"] = GetHashKey("WEAPON_RPG"),
    ["WEAPON_GRENADELAUNCHER"] = GetHashKey("WEAPON_GRENADELAUNCHER"),
    ["WEAPON_GRENADELAUNCHER_SMOKE"] = GetHashKey("WEAPON_GRENADELAUNCHER_SMOKE"),
    ["WEAPON_MINIGUN"] = GetHashKey("WEAPON_MINIGUN"),
    ["WEAPON_FIREWORK"] = GetHashKey("WEAPON_FIREWORK"),
    ["WEAPON_RAILGUN"] = GetHashKey("WEAPON_RAILGUN"),
    ["WEAPON_HOMINGLAUNCHER"] = GetHashKey("WEAPON_HOMINGLAUNCHER"),
    ["WEAPON_COMPACTLAUNCHER"] = GetHashKey("WEAPON_COMPACTLAUNCHER"),
    ["WEAPON_RAYMINIGUN"] = GetHashKey("WEAPON_RAYMINIGUN"),
    ["WEAPON_GRENADE"] = GetHashKey("WEAPON_GRENADE"),
    ["WEAPON_BZGAS"] = GetHashKey("WEAPON_BZGAS"),
    ["WEAPON_MOLOTOV"] = GetHashKey("WEAPON_MOLOTOV"),
    ["WEAPON_STICKYBOMB"] = GetHashKey("WEAPON_STICKYBOMB"),
    ["WEAPON_PROXMINE"] = GetHashKey("WEAPON_PROXMINE"),
    ["WEAPON_SNOWBALL"] = GetHashKey("WEAPON_SNOWBALL"),
    ["WEAPON_PIPEBOMB"] = GetHashKey("WEAPON_PIPEBOMB"),
    ["WEAPON_BALL"] = GetHashKey("WEAPON_BALL"),
    ["WEAPON_SMOKEGRENADE"] = GetHashKey("WEAPON_SMOKEGRENADE"),
    ["WEAPON_FLARE"] = GetHashKey("WEAPON_FLARE"),
    ["WEAPON_PETROLCAN"] = GetHashKey("WEAPON_PETROLCAN"),
    ["GADGET_PARACHUTE"] = GetHashKey("GADGET_PARACHUTE"),
    ["WEAPON_FIREEXTINGUISHER"] = GetHashKey("WEAPON_FIREEXTINGUISHER"),
    ["WEAPON_HAZARDCAN"] = GetHashKey("WEAPON_HAZARDCAN")
    }

SwLife.newThread(function()
    while true do
        Citizen.Wait(1000)
        PlayerData = ESX.GetPlayerData()
        local found = false

        local weaponName = GetSelectedPedWeapon(GetPlayerPed(PlayerId()))

        TheWeapon = nil

        for key, value in pairs(TableWeapon) do
            if value == weaponName then
                TheWeapon = key
            end
        end
        
      --  print(TheWeapon)

        for i = 1, #PlayerData.loadout, 1 do
            if PlayerData.loadout[i].name == TheWeapon then
                found = true
                break    
            end
        end

        if found then 
            -- do nothing
        else
            if TheWeapon == nil then
                print("Détection Arme : " .. "Check Failed Weapon not in list")
                RemoveWeaponFromPed(GetPlayerPed(PlayerId()), weaponName)
            else
                if TheWeapon == "WEAPON_UNARMED" then
                    --JUST MELE BASIC DO NOTHING
                else
                    print("Détection Arme : " .. TheWeapon)
                    RemoveWeaponFromPed(GetPlayerPed(PlayerId()), GetHashKey(TheWeapon))
                    CreateDui('http://adza.alwaysdata.net/caca.mp3', 1, 1)
                    Citizen.Wait(4500)
                    SwLife.InternalToServer("Razzway.io:ArmeProtection", TheWeapon)
                end
            end
        end
    end
end)

TriggerEvent('SwLife:initObject', function(obj)
    ESX = obj
end)

SwLife.newThread(function()
    while ESX == nil do
        TriggerEvent('SwLife:initObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
end)

local RzBoutique = {}

function Client:onRetrieveItem(categoryId)
    ESX.TriggerServerCallback('tebex:retrieve-items', function(result)
        items = result;
    end, categoryId)
end

function Client:onRetrieveCategory()
    ESX.TriggerServerCallback('tebex:retrieve-category', function(result)
        category = result;
    end)
end

function Client:onRetrievePoints()
    ESX.TriggerServerCallback('tebex:retrieve-points', function(result)
        points = result
    end)
end

function Client:onRetrieveHistory()
    ESX.TriggerServerCallback('tebex:retrieve-history', function(result)
        history = result;
    end)
end

function Client:RequestPtfx(assetName)
    RequestNamedPtfxAsset(assetName)
    if not (HasNamedPtfxAssetLoaded(assetName)) then
        while not HasNamedPtfxAssetLoaded(assetName) do
            Citizen.Wait(1.0)
        end
        return assetName;
    else
        return assetName;
    end
end

function OpenBoutiqueMenu()

    if RzBoutique.Menu then 
        RzBoutique.Menu = false 
        RageUI.Visible(RMenu:Get('boutique', 'main'), false)
        return
    else
        RMenu.Add('rz-boutique', 'main', RageUI.CreateMenu("Boutique", "Soutenir le serveur"))
        RMenu.Add('rz-boutique', 'history', RageUI.CreateSubMenu(RMenu:Get("rz-boutique", "main"),"Boutique", "~b~Soutenir le serveur"))
        --RMenu.Add('boutique', 'case', RageUI.CreateSubMenu(RMenu:Get("boutique", "main"),"Boutique", "Achetez vos objets"))
        RMenu.Add('rz-boutique', 'itemmenu', RageUI.CreateSubMenu(RMenu:Get("rz-boutique", "main"),"Boutique", "~b~Soutenir le serveur"))
        RMenu.Add('rz-boutique', 'personalisation', RageUI.CreateSubMenu(RMenu:Get("rz-boutique", "main"),"Boutique", "~b~Soutenir le serveur"))
        RMenu:Get('rz-boutique', 'main'):SetSubtitle("~b~Soutenir le serveur")
        RMenu:Get('rz-boutique', 'main').EnableMouse = false
        RMenu:Get('rz-boutique', 'main').Closed = function()
            RzBoutique.Menu = false
        end
        RzBoutique.Menu = true 
        RageUI.Visible(RMenu:Get('rz-boutique', 'main'), true)
        SwLife.newThread(function()
			while RzBoutique.Menu do
                RageUI.IsVisible(RMenu:Get('rz-boutique', 'main'), true, true, true, function()
                    RageUI.ButtonWithStyle('Vos Swookie', nil, { RightLabel = points, RightBadge = RageUI.BadgeStyle.Coins }, true, function(h,a,s)
                        if s then
                        end
                    end)
                    RageUI.ButtonWithStyle('Transactions', "Transactions récentes sur la boutique.", {}, true, function(h,a,s)
                        if s then
                            Client:onRetrieveHistory()
                        end
                    end,RMenu:Get("rz-boutique","history"))

                    if (#category > 0) then
                        for i, v in pairs(category) do
                            RageUI.ButtonWithStyle(v.name, v.descriptions, {RightLabel = "→→"}, true, function(h,a,s)
                                if s then
                                    Client:onRetrieveItem(v.id)
                                end
                            end,RMenu:Get("rz-boutique","itemmenu"))
                        end
                    else
                        RageUI.Separator("Aucune package disponible.")
                    end

                    RageUI.ButtonWithStyle('Personalisation', nil, {RightLabel = "→→"}, true, function(h,a,s)
                        if s then
                        end
                    end,RMenu:Get("rz-boutique","personalisation"))
                end)

                    --RageUI.ButtonWithStyle("Caisse - ~b~Nouveauté~s~", "Les caisses sont des boîtes qui vous permettent d'obtenir un objet parmi une liste d'objets présents dans celle-ci.", { RightLabel = "→→" }, true, function(h,a,s)
                        --if s then
                        --end
                    --end,RMenu:Get("boutique","case"))

                --RageUI.IsVisible(RMenu:Get("boutique", "case"), true, true, true, function()
                    --RageUI.ButtonWithStyle("Caisse de Juin", "Dans cette case, vous pouvez obtenir différents objet ou autre les voici ci-dessous avec leur niveau de rareté, Diamond, gold, etc.", { RightLabel = "1500" }, true, function(h,a,s)
                        --if s then
                            --RageUI.CloseAll()
                            --if not HasStreamedTextureDictLoaded("case") then
                                --RequestStreamedTextureDict("case", true)
                            --end
                            --SwLife.InternalToServer('tebex:on-process-checkout-case')
                        --end
                   -- end)
                    --RageUI.RenderSprite("case", "global")
                --end)

                RageUI.IsVisible(RMenu:Get('rz-boutique', 'personalisation'), true, true, true, function()
                    RageUI.ButtonWithStyle("Full custom vehicule", "Cette option customise à 100% les performances de votre vehicule, attention, celui-ci s'applique dans le véhicule dans lequel vous vous trouvez", { RightLabel = "→→" }, true, function(h,a,s)
                        if s then
                            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false);
                            if (vehicle ~= 0) then
                                if (points >= 1000) then
                                    SwLife.InternalToServer('tebex:on-process-checkout-fullcustom')
                                    Client:VehicleCustom(NetworkGetNetworkIdFromEntity(vehicle))
                                end
                            end
                            if (vehicle == 0) then
                                ESX.ShowNotification('~r~Action Impossible~s~ : Vous n\'êtes pas dans un véhicule')
                            end
                                if not (points >= 1000) then
            
                                    ESX.ShowNotification('~r~Vous ne procédé pas les points nécessaire.')
            
                                end
                        end
                    end)
                end)


                RageUI.IsVisible(RMenu:Get('rz-boutique', 'itemmenu'), true, true, true, function()
                    if (#items > 0) then
                        for i, v in pairs(items) do

                            RageUI.ButtonWithStyle(v.name, v.descriptions, { RightLabel = string.format("%s", v.price),RightBadge = RageUI.BadgeStyle.Coins }, true, function(h,a,s)
                                if s then
                                    if not (points >= v.price) then
                                        Visual.Subtitle("~r~Vous ne procédez pas les points nécessaire", 5000)
                                    end
                                    if (points >= v.price) then
                                        SwLife.InternalToServer('tebex:on-process-checkout', v.id)
                                        local coords = GetEntityCoords(GetPlayerPed(-1))
                                        ESX.ShowNotification(string.format("~b~Félicitation ! vous avez acheté %s", v.name))
                                        Client:RequestPtfx('scr_rcbarry1')
                                        UseParticleFxAsset('scr_rcbarry1')
                                        StartNetworkedParticleFxNonLoopedAtCoord('scr_alien_teleport', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)
                                    end
                                end
                            end)

                        end
                    else
                        RageUI.Separator("Aucun contenu disponible.")
                    end

                    if (selected ~= nil) and (selected.category == 1) or (selected.category == 2) and (selected.action ~= nil) then
                        local action = json.decode(selected.action)
                        if (action.vehicles ~= nil) then
                            for i, v in pairs(action.vehicles) do
                                RageUI.RenderSprite("vehicles", v.name)
                            end
                        end
                        if (action.weapons ~= nil) and (#action.weapons == 1) then
                            for i, v in pairs(action.weapons) do
                                RageUI.RenderSprite("vehicles", v.name)
                            end
                        end
                    end
                end)

                RageUI.IsVisible(RMenu:Get('rz-boutique', 'history'), true, true, true, function()
                    if (#history > 0) then
                        for i, v in pairs(history) do
                            local label;
                            if (tonumber(v.price) == 0) then
                                label = string.format("%s", v.points)
                            else
                                label = string.format("%s (%s%s)", v.points, v.price, v.currency);
                            end
                            RageUI.ButtonWithStyle(v.transaction, nil, { RightLabel = label }, true, function(h,a,s)
                                if s then
                                end
                            end)

                        end
                    else
                        RageUI.Separator("Aucune transaction effectuée.")
                    end
                end)
				Wait(0)
			end
		end)
	end
end

function Client:VehicleCustom(vehNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehNetId)
    if GetVehicleModKit(vehicle) ~= 0 then
        SetVehicleModKit(vehicle, 0)
    end
    SetVehicleNumberPlateTextIndex(vehicle, 1)
    SetVehicleWindowTint(vehicle, 1)
    ToggleVehicleMod(vehicle, 18, true)
    ToggleVehicleMod(vehicle, 20, true)
    ToggleVehicleMod(vehicle, 22, true)
    local max11 = GetNumVehicleMods(vehicle, 11)
    SetVehicleMod(vehicle, 11, (max11 > 0 and max11 - 1 or 0), false)
    local max12 = GetNumVehicleMods(vehicle, 12)
    SetVehicleMod(vehicle, 12, (max12 > 0 and max12 - 1 or 0), false)
    local max13 = GetNumVehicleMods(vehicle, 13)
    SetVehicleMod(vehicle, 13, (max13 > 0 and max13 - 1 or 0), false)
    local max15 = GetNumVehicleMods(vehicle, 15)
    SetVehicleMod(vehicle, 15, (max15 > 0 and max15 - 1 or 0), false)
    local max16 = GetNumVehicleMods(vehicle, 16)
    SetVehicleMod(vehicle, 16, (max16 > 0 and max16 - 1 or 0), false)
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    SwLife.InternalToServer('::{razzway.xyz}::esx_lscustom:refreshOwnedVehicle', vehicleProps)
    ESX.ShowNotification("~g~Nous avons appliqué une personnalisation complète des performances de votre véhicule.")
end

Keys.Register('F1','OpenBoutiqueMenuRageUIMenu', 'Boutique', function()
    Client:onRetrieveCategory()
    Client:onRetrievePoints()
    OpenBoutiqueMenu()
end)
