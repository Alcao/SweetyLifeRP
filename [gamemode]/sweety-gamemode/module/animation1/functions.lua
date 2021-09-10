ESX = nil
SwLife.newThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

local playerCurrentlyAnimated = false
local playerCurrentlyHasProp = false
local playerCurrentlyHasWalkstyle = false
local surrendered = false
local firstAnim = true
local playerPropList = {}
local LastAD

Anims = {
    {name = 'phonecall', data = {type = 'anim', ad = "cellphone@", anim = "cellphone_call_listen_base", prop = 'prop_player_phone_01', proptwo = 0, boneone = 57005, bonetwo = nil, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'brastendu', data = {type = 'anim', ad = "nm@hands", anim = "flail", prop = nil, proptwo = 0, boneone = nil, bonetwo = 57005, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'radio', data = {type = 'anim', ad = "random@arrests", anim = "generic_radio_chatter", prop = nil, proptwo = 0, boneone = nil, bonetwo = 57005, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'chemise1', data = {type = 'anim', ad = "clothingtie", anim = "try_tie_neutral_d", prop = nil, proptwo = 0, boneone = nil, bonetwo = 57005, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'chemise2', data = {type = 'anim', ad = "clothingtie", anim = "try_tie_positive_a", prop = nil, proptwo = 0, boneone = nil, bonetwo = 57005, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'siffler', data = {type = 'anim', ad = "rcmnigel1c", anim = "hailing_whistle_waive_a", prop = nil, proptwo = 0, boneone = nil, bonetwo = 57005, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'execution', data = {type = 'anim', ad = "oddjobs@suicide", anim = "bystander_pointinto", prop = nil, proptwo = nil, boneone = nil, bonetwo = nil, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'armepointe', data = {type = 'anim', ad = "random@arrests", anim = "cop_gunaimed_door_open_idle", prop = nil, proptwo = nil, boneone = nil, bonetwo = nil, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'montrersesfesses', data = {type = 'anim', ad = "switch@trevor@mocks_lapdance", anim = "001443_01_trvs_28_idle_stripper", prop = nil, proptwo = nil, boneone = nil, bonetwo = nil, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'inspecterseslunettes', data = {type = 'anim', ad = "clothingspecs", anim = "try_glasses_positive_a", prop = nil, proptwo = nil, boneone = nil, bonetwo = nil, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'leplusfort', data = {type = 'anim', ad = "rcmbarry", anim = "base", prop = nil, proptwo = nil, boneone = nil, bonetwo = nil, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'onarretetous', data = {type = 'anim', ad = "anim@heists@ornate_bank@chat_manager", anim = "fail", prop = nil, proptwo = nil, boneone = nil, bonetwo = nil, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'patience', data = {type = 'anim', ad = "special_ped@impotent_rage@base", anim = "base", prop = nil, proptwo = nil, boneone = nil, bonetwo = nil, body = 49, x = 0.15, y = 0.02, z = -0.01, xa = 105.0, yb = -20.0, zc = 90.0}},
    {name = 'ceinturions', data = {type = 'anim', ad = "amb@code_human_wander_idles_cop@male@static", anim = "static", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'respect', data = {type = 'anim', ad = "mp_player_int_upperbro_love", anim = "mp_player_int_bro_love_fp", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'reflexion', data = {type = 'anim', ad = "misscarsteal4@aliens", anim = "rehearsal_base_idle_director", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'salutmilitaire', data = {type = 'anim', ad = "anim@mp_player_intuppersalute", anim = "idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'signeballas', data = {type = 'anim', ad = "mp_player_int_uppergang_sign_b", anim = "mp_player_int_gang_sign_b", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'signegsf', data = {type = 'anim', ad = "amb@code_human_in_car_mp_actions@gang_sign_b@low@ps@base", anim = "idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'signelocura', data = {type = 'anim', ad = "mp_player_int_uppergang_sign_a", anim = "mp_player_int_gang_sign_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'signevagos', data = {type = 'anim', ad = "amb@code_human_in_car_mp_actions@v_sign@std@rds@base", anim = "idle_a", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'allezviens', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_come_here_soft", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'aucuneidee', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_shrug_hard", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'aucuneideesoft', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_shrug_soft", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'cestca', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_pleased", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'cassetoi', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_bye_hard", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'damn', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_damn", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'droite', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_hand_right", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'gauche', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_hand_left", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'heycalme', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_easy_now", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'heytoi', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_hello", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'ici', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_hand_down", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'lourd', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_i_will", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'moi', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_me", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'moi2', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_me_hard", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'mouai', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_nod_yes_soft", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'myman', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_point", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'nonnon', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_nod_no_hard", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'nonsoft', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_nod_no_soft", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'ohnon', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_head_no", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'ouifonce', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_nod_yes_hard", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'pasmoyen', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_no_way", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'quoi', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_bring_it_on", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'quoi2', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_what_hard", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'quoi3', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_what_soft", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'salut', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_bye_soft", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'toi', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_you_hard", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'toi2', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_you_soft", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'tsss', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_displeased", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'viensvoir', data = {type = 'anim', ad = "gestures@f@standing@casual", anim = "gesture_come_here_hard", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'doigtdhonneur', data = {type = 'anim', ad = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'doigtsolo', data = {type = 'anim', ad = "anim@mp_player_intselfiethe_bird", anim = "enter", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'securezlenez', data = {type = 'anim', ad = "anim@mp_player_intcelebrationmale@nose_pick", anim = "nose_pick", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'segratterlecul', data = {type = 'anim', ad = "mp_player_int_upperarse_pick", anim = "mp_player_int_arse_pick", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'segratterlescouilles', data = {type = 'anim', ad = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'attente1', data = {type = 'anim', ad = "timetable@amanda@ig_9", anim = "ig_9_base_amanda", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'attente2', data = {type = 'anim', ad = "random@shop_tattoo", anim = "_idle", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'brascroise', data = {type = 'anim', ad = "random@street_race", anim = "_car_b_lookout", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'brascroiselourd', data = {type = 'anim', ad = "anim@heists@heist_corona@single_team", anim = "single_team_loop_boss", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'brasdansledos', data = {type = 'anim', ad = "anim@miss@low@fin@vagos@", anim = "idle_ped06", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'dormirsurplace', data = {type = 'anim', ad = "mp_sleep", anim = "sleep_loop", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'fairedustop', data = {type = 'anim', ad = "random@hitch_lift", anim = "idle_f", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'holster', data = {type = 'anim', ad = "reaction@intimidation@cop@unarmed", anim = "intro", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'poseguarde', data = {type = 'anim', ad = "amb@world_human_stand_guard@male@base", anim = "base", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},
    {name = 'mainssurlatete', data = {type = 'anim', ad = "busted", anim = "idle_b", prop = 0, proptwo = 0, boneone = nil, bonetwo = nil, body = 49, x = 0.0, y = 0.0, z = 0.0, xa = 0.0, yb = 0.0, zc = 0.0}},

}

function DestroyAllProps()
	for _,v in pairs(playerPropList) do
		DeleteEntity(v)
	end

	playerCurrentlyHasProp = false
end

RegisterNetEvent('Radiant_Animations:KillProps')
AddEventHandler('Radiant_Animations:KillProps', function()
	for _,v in pairs(playerPropList) do
		DeleteEntity(v)
	end

	playerCurrentlyHasProp = false
end)

RegisterNetEvent('Radiant_Animations:AttachProp')
AddEventHandler('Radiant_Animations:AttachProp', function(prop_one, boneone, x1, y1, z1, r1, r2, r3)
	local player = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(player))

	if not HasModelLoaded(prop_one) then
		loadPropDict(prop_one)
	end

	prop = CreateObject(GetHashKey(prop_one), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, player, GetPedBoneIndex(player, boneone), x1, y1, z1, r1, r2, r3, true, true, false, true, 1, true)
	SetModelAsNoLongerNeeded(prop_one)
	table.insert(playerPropList, prop)
	playerCurrentlyHasProp = true
end)

RegisterNetEvent('Radiant_Animations:Animation')
AddEventHandler('Radiant_Animations:Animation', function(ad, anim, body)
	local player = PlayerPedId()
	if playerCurrentlyAnimated then -- Cancel Old Animation

		loadAnimDict(ad)
		TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, body, 0, 0, 0, 0 )
		Wait(750)
		ClearPedSecondaryTask(player)
		RemoveAnimDict(LastAD)
		RemoveAnimDict(ad)
		LastAD = ad
		playerCurrentlyAnimated = false
		TriggerEvent('Radiant_Animations:KillProps')
		return
	end

	if firstAnim then
		LastAD = ad
		firstAnim = false
	end

	loadAnimDict(ad)
	TaskPlayAnim(player, ad, anim, 4.0, 1.0, -1, body, 0, 0, 0, 0 )  --- We actually play the animation here
	RemoveAnimDict(ad)
	playerCurrentlyAnimated = true

end)

RegisterNetEvent('Radiant_Animations:StopAnimations')
AddEventHandler('Radiant_Animations:StopAnimations', function()

	local player = PlayerPedId()
	if vehiclecheck() then
		if IsPedUsingAnyScenario(player) then
			--ClearPedSecondaryTask(player)
			ClearPedTasks(player)
		end

		if playerCurrentlyHasWalkstyle then
			ResetPedMovementClipset(player, 0.0)
			playerCurrentlyHasWalkstyle = false
		end

		if playerCurrentlyAnimated then
			if LastAD then
				RemoveAnimDict(LastAD)
			end

			if playerCurrentlyHasProp then
				TriggerEvent('Radiant_Animations:KillProps')
				
				playerCurrentlyHasProp = false
			end

			if surrendered then
				surrendered = false
			end

			--ClearPedSecondaryTask(player)
			ClearPedTasks(player)
			playerCurrentlyAnimated = false
		end
	end
end)

RegisterNetEvent('Radiant_Animations:Scenario')
AddEventHandler('Radiant_Animations:Scenario', function(ad)
	local player = PlayerPedId()
	TaskStartScenarioInPlace(player, ad, 0, 1)   
end)

RegisterNetEvent('Radiant_Animations:Walking')
AddEventHandler('Radiant_Animations:Walking', function(ad)
	local player = PlayerPedId()
	ResetPedMovementClipset(player, 0.0)
	RequestWalking(ad)
	SetPedMovementClipset(player, ad, 0.25)
	RemoveAnimSet(ad)
end)


RegisterCommand("e", function(source, args)

	local player = PlayerPedId()
	local argh = tostring(args[1])

	if argh == 'help' then -- List Anims in Chat Command
		TriggerEvent('chat:addMessage', { args = { '[^1Animations^0]: salute, finger, finger2, phonecall, surrender, facepalm, notes, brief, brief2, foldarms, foldarms2, damn, fail, gang1, gang2, no, pickbutt, grabcrotch, peace, cigar, cigar2, joint, cig, holdcigar, holdcig, holdjoint, dead, holster, aim, aim2, slowclap, box, cheer, bum, leanwall, copcrowd, copcrowd2, copidle, shotbar, drunkbaridle, djidle, djidle2, fdance1, fdance2, mdance1, mdance2, walk1-44' } })
	elseif argh == 'stuckprop' then -- Deletes Clients Props Command
		TriggerEvent('Radiant_Animations:KillProps')
	elseif argh == 'surrender' then -- I'll figure out a better way to do animations with this much depth later.
		TriggerEvent('Radiant_Animations:Surrender')
	elseif argh == 'stop' then -- Cancel Animations
		TriggerEvent('Radiant_Animations:StopAnimations')
	else
		for i = 1, #Anims, 1 do
			local name = Anims[i].name
			if argh == name then				
				local prop_one = Anims[i].data.prop
				local boneone = Anims[i].data.boneone
				if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 

					if Anims[i].data.type == 'prop' then
						if playerCurrentlyHasProp then --- Delete Old Prop

							TriggerEvent('Radiant_Animations:KillProps')
						end
						
						TriggerEvent('Radiant_Animations:AttachProp', prop_one, boneone, Anims[i].data.x, Anims[i].data.y, Anims[i].data.z, Anims[i].data.xa, Anims[i].data.yb, Anims[i].data.zc)

					elseif Anims[i].data.type == 'brief' then

						if name == 'brief' then
							GiveWeaponToPed(player, 0x88C78EB7, 1, false, true)
						else
							GiveWeaponToPed(player, 0x01B79F17, 1, false, true)
						end
						return
					elseif Anims[i].data.type == 'scenario' then
						local ad = Anims[i].data.ad

						if vehiclecheck() then
							if IsPedActiveInScenario(player) then
								ClearPedTasks(player)
							else
								TriggerEvent('Radiant_Animations:Scenario', ad)
							end 
						end

					elseif Anims[i].data.type == 'walkstyle' then
						local ad = Anims[i].data.ad
						if vehiclecheck() then
							TriggerEvent('Radiant_Animations:Walking', ad)
							if not playerCurrentlyHasWalkstyle then
								playerCurrentlyHasWalkstyle = true
							end
						end
					else

						if vehiclecheck() then
							local ad = Anims[i].data.ad
							local anim = Anims[i].data.anim
							local body = Anims[i].data.body
							
							TriggerEvent('Radiant_Animations:Animation', ad, anim, body) -- Load/Start animation

							if prop_one ~= 0 then
								local prop_two = Anims[i].data.proptwo
								local bonetwo = nil

								loadPropDict(prop_one)
								TriggerEvent('Radiant_Animations:AttachProp', prop_one, boneone, Anims[i].data.x, Anims[i].data.y, Anims[i].data.z, Anims[i].data.xa, Anims[i].data.yb, Anims[i].data.zc)
								if prop_two ~= 0 then
									bonetwo = Anims[i].data.bonetwo
									prop_two = Anims[i].data.proptwo
									loadPropDict(prop_two)
									TriggerEvent('Radiant_Animations:AttachProp', prop_two, bonetwo, Anims[i].data.twox, Anims[i].data.twoy, Anims[i].data.twoz, Anims[i].data.twoxa, Anims[i].data.twoyb, Anims[i].data.twozc)
								end
							end
						end
					end
				end
			end
		end
	end
end)

function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(500)
	end
end

function loadPropDict(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(500)
	end
end

function RequestWalking(ad)
	RequestAnimSet( ad )
	while ( not HasAnimSetLoaded( ad ) ) do 
		Citizen.Wait( 500 )
	end 
end

function vehiclecheck()
	local player = PlayerPedId()
	if IsPedInAnyVehicle(player, false) then
		return false
	end
	return true
end

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end


function startDanse(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
	end)
end

function WalkMenuStart(name)
  RequestWalking(name)
  SetPedMovementClipset(PlayerPedId(), name, 0.2)
  RemoveAnimSet(name)
end



