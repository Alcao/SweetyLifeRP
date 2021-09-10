ESX = nil
SwLife.newThread(function()
    while ESX == nil do
        TriggerEvent('SwLife:initObject', function(obj)
            ESX = obj
        end)
        ESX.PlayerData = ESX.GetPlayerData()
        Citizen.Wait(10)
    end
end)

local Animations = {}
local IsInAnimation = false
local demarche = {
	index = 1,
	list = {'Normale', 'Gangster 1', 'Gangster 2', 'Gangster 3', 'Gangster 4', 'Sexy', 'Efféminé 1', 'Efféminé 2', 'Efféminé 3', 'Efféminé 4', 'Clochard', 'Brave 1', 'Brave 2', 'Casu 1', 'Casu 2', 'Casu 3', 'Casu 4', 'Casu 5', 'Casu 6', 'Déprimé', 'Bourré 1', 'Bourré 2', 'Bourré 3', 'Hipster', 'Pressé 1', 'Blessé', 'Jogging 1', 'Riche', 'Hautain', 'Coincé', 'Triste 1', 'Triste 2', 'Triste 3', 'Triste 4', 'Shady 1', 'Swag 1', 'Swag 2', 'Brute', 'Franklin 1', 'Trevor 1', 'Michael 1', 'Lent', 'Jimmy 1', 'Grooving F1', 'Grooving F2', 'Grooving H1', 'Grooving H2'},
}

local humeur = {
	index = 1,
	list = {'Normale', 'Blessé', 'Chic', 'Colère', 'Concentration', 'Dormir', 'Heureux', 'Milou', 'Soul', 'Stressé',},
}

function EmoteCancel()
    if IsInAnimation then
        ClearPedTasksImmediately(PlayerPedId())
        IsInAnimation = false
        if IsInAnimation then
            ClearPedTasks(PlayerPedId())
            DestroyAllProps()
            IsInAnimation = false
        end
    end
end

function OpenAnimationsRageUIMenu()

    if Animations.Menu then 
        Animations.Menu = false 
        RageUI.Visible(RMenu:Get('animations', 'main'), false)
        return
    else
        RMenu.Add('animations', 'main', RageUI.CreateMenu("Menu Animations", "test"))
        RMenu.Add('animations', 'actionsanim', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu.Add('animations', 'armes', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu.Add('animations', 'danses', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu.Add('animations', 'sexe', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu.Add('animations', 'expressions', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu.Add('animations', 'festives', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu.Add('animations', 'gestures', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu.Add('animations', 'insolentes', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu.Add('animations', 'poses', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu.Add('animations', 'asseoir', RageUI.CreateSubMenu(RMenu:Get("animations", "main"),"Menu Animations", "~b~Animations du personnage"))
        RMenu:Get('animations', 'main'):SetSubtitle("~b~Animations du personnage")
        RMenu:Get('animations', 'main').EnableMouse = false
        RMenu:Get('animations', 'main').Closed = function()
            Animations.Menu = false
        end
        Animations.Menu = true 
        RageUI.Visible(RMenu:Get('animations', 'main'), true)
        SwLife.newThread(function()
			while Animations.Menu do
                RageUI.IsVisible(RMenu:Get('animations', 'main'), true, true, true, function()
                    RageUI.ButtonWithStyle("Annuler l'animation", nil, { RightLabel = "→" },true, function(h,a,s)
                        if s then
                            ClearPedTasksImmediately(PlayerPedId())
                            IsInAnimation = false
                            ClearPedTasks(PlayerPedId())
                            DestroyAllProps()
                        end
                    end)
                    RageUI.ButtonWithStyle("Action anim", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'actionsanim'))
                    RageUI.ButtonWithStyle("Armes", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'armes'))
                    RageUI.ButtonWithStyle("Danses", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'danses'))
                    RageUI.ButtonWithStyle("Sexe", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'sexe'))
                    RageUI.ButtonWithStyle("Expressions", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'expressions'))
                    RageUI.ButtonWithStyle("Festives", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'festives'))
                    RageUI.ButtonWithStyle("Gestures", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'gestures'))
                    RageUI.ButtonWithStyle("Insolentes", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'insolentes'))
                    RageUI.ButtonWithStyle("Poses", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'poses'))
                    RageUI.ButtonWithStyle("S'asseoir", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('animations', 'asseoir'))
					RageUI.List("Démarche", demarche.list, demarche.index, nil, {}, true, function(Hovered, Active, Selected, Index)
						if (Selected) then
							if Index == 1 then
								ResetPedMovementClipset(PlayerPedId(),0)
							elseif Index == 2 then
								startAttitude('move_f@gangster@ng', 'move_f@gangster@ng')
							elseif Index == 3 then
								startAttitude('move_m@fire', 'move_m@fire')
							elseif Index == 4 then
								startAttitude('move_m@gangster@generic', 'move_m@gangster@generic')
							elseif Index == 5 then
								startAttitude('move_m@gangster@ng', 'move_m@gangster@ng')
							elseif Index == 6 then
								startAttitude('move_f@sexy@a', 'move_f@sexy@a')
							elseif Index == 7 then
								startAttitude('move_f@tough_guy@', 'move_f@tough_guy@')
							elseif Index == 8 then
								startAttitude('move_m@confident', 'move_m@confident')
							elseif Index == 9 then
								startAttitude('move_m@femme@', 'move_m@femme@')
							elseif Index == 10 then
								startAttitude('move_m@sassy', 'move_m@sassy')
							elseif Index == 11 then
								startAttitude('move_m@buzzed', 'move_m@buzzed')
							elseif Index == 12 then
								startAttitude('move_m@brave', 'move_m@brave')
							elseif Index == 13 then
								startAttitude('move_m@brave@b', 'move_m@brave@b')
							elseif Index == 14 then
								startAttitude('move_m@casual@a', 'move_m@casual@a')
							elseif Index == 15 then
								startAttitude('move_m@casual@b', 'move_m@casual@b')
							elseif Index == 16 then
								startAttitude('move_m@casual@c', 'move_m@casual@c')
							elseif Index == 17 then
								startAttitude('move_m@casual@d', 'move_m@casual@d')
							elseif Index == 18 then
								startAttitude('move_m@casual@e', 'move_m@casual@e')
							elseif Index == 19 then
								startAttitude('move_m@casual@f', 'move_m@casual@f')
							elseif Index == 20 then
								startAttitude('move_m@depressed@a', 'move_m@depressed@a')
							elseif Index == 21 then
								startAttitude('move_m@drunk@moderatedrunk', 'move_m@drunk@moderatedrunk')
							elseif Index == 22 then
								startAttitude('move_m@drunk@slightlydrunk', 'move_m@drunk@slightlydrunk')
							elseif Index == 23 then
								startAttitude('move_m@drunk@verydrunk', 'move_m@drunk@verydrunk')
							elseif Index == 24 then
								startAttitude('move_m@hipster@a', 'move_m@hipster@a')
							elseif Index == 25 then
								startAttitude('move_m@hurry_butch@c', 'move_m@hurry_butch@c')
							elseif Index == 26 then
								startAttitude('move_m@injured', 'move_m@injured')
							elseif Index == 27 then
								startAttitude('move_m@jog@', 'move_m@jog@')
							elseif Index == 28 then
								startAttitude('move_m@money', 'move_m@money')
							elseif Index == 29 then
								startAttitude('move_m@posh@', 'move_m@posh@')
							elseif Index == 30 then
								startAttitude('move_m@quick', 'move_m@quick')
							elseif Index == 31 then
								startAttitude('move_m@sad@a', 'move_m@sad@a')
							elseif Index == 32 then
								startAttitude('move_m@sad@b', 'move_m@sad@b')
							elseif Index == 33 then
								startAttitude('move_m@sad@c', 'move_m@sad@c')
							elseif Index == 34 then
								startAttitude('move_m@leaf_blower', 'move_m@leaf_blower')
							elseif Index == 35 then
								startAttitude('move_m@shadyped@a', 'move_m@shadyped@a')
							elseif Index == 36 then
								startAttitude('move_m@swagger', 'move_m@swagger')
							elseif Index == 37 then
								startAttitude('move_m@swagger@b', 'move_m@swagger@b')
							elseif Index == 38 then
								startAttitude('move_m@tough_guy@', 'move_m@tough_guy@')
							elseif Index == 39 then
								startAttitude('move_p_m_one', 'move_p_m_one')
							elseif Index == 40 then
								startAttitude('move_p_m_two', 'move_p_m_two')
							elseif Index == 41 then
								startAttitude('move_p_m_zero', 'move_p_m_zero')
							elseif Index == 42 then
								startAttitude('move_p_m_zero_slow', 'move_p_m_zero_slow')
							elseif Index == 43 then
								startAttitude('move_characters@jimmy@slow@', 'move_characters@jimmy@slow@')
							elseif Index == 44 then
								startAttitude('anim@move_f@grooving@slow@', 'anim@move_f@grooving@slow@')
							elseif Index == 45 then
								startAttitude('anim@move_f@grooving@', 'anim@move_f@grooving@')
							elseif Index == 46 then
								startAttitude('anim@move_m@grooving@', 'anim@move_m@grooving@')
							elseif Index == 47 then
								startAttitude('anim@move_m@grooving@slow@', 'anim@move_m@grooving@slow@')
							end
						end
						demarche.index = Index
					end)
					RageUI.List("Humeur", humeur.list, humeur.index, nil, {}, true, function(Hovered, Active, Selected, Index)
						if (Selected) then
							if Index == 1 then
								ClearPedTasksImmediately(PlayerPedId())
							elseif Index == 2 then
								PlayFacialAnim(PlayerPedId(), 'mood_injured_1')
							elseif Index == 3 then
								PlayFacialAnim(PlayerPedId(), 'mood_smug_1')
							elseif Index == 4 then
								PlayFacialAnim(PlayerPedId(), 'mood_angry_1')
							elseif Index == 5 then
								PlayFacialAnim(PlayerPedId(), 'mood_aiming_1')
							elseif Index == 6 then
								PlayFacialAnim(PlayerPedId(), 'mood_sleeping_1')
							elseif Index == 7 then
								PlayFacialAnim(PlayerPedId(), 'mood_happy_1')
							elseif Index == 8 then
								PlayFacialAnim(PlayerPedId(), 'mood_sulk_1')
							elseif Index == 9 then
								PlayFacialAnim(PlayerPedId(), 'mood_drunk_1')
							elseif Index == 10 then
								PlayFacialAnim(PlayerPedId(), 'mood_stressed_1')
							end
						end
						humeur.index = Index
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'actionsanim'), true, false, true, function()
                    RageUI.ButtonWithStyle("Acrobatie 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim('anim@arena@celeb@flat@solo@no_props@', 'cap_a_player_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Acrobatie 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim('anim@arena@celeb@flat@solo@no_props@', 'flip_a_player_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Acrobatie 3", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim('anim@arena@celeb@flat@solo@no_props@', 'pageant_a_player_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Appel téléphonique", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e phonecall")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Applaudir", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario('WORLD_HUMAN_CHEERING')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Applaudissements énervés", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim('anim@arena@celeb@flat@solo@no_props@', 'angry_clap_a_player_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Bras tendu", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e brastendu")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Encouragement", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim('mini@triathlon', 'male_one_handed_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Faire des abdos", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario("WORLD_HUMAN_SIT_UPS")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Faire des pompes", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario("WORLD_HUMAN_PUSH_UPS")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Je brûle !", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim('ragdoll@human', 'on_fire')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Je me sens pas bien", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim('missfam5_blackout', 'pass_out')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Laché moi", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@freakout", 'freakout')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Locoo", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@you_loco", 'you_loco')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Mendier", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							--startScenario("WORLD_HUMAN_BUM_FREEWAY")
							ExecuteCommand("e mendier")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Mîme", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("special_ped@mime@monologue_5@monologue_5a", '10_ig_1_wa_0')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Noter des informations", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario("WORLD_HUMAN_CLIPBOARD")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Pleure à genoux", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("mp_bank_heist_1", 'f_cower_01')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Prendre une photo", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario("WORLD_HUMAN_MOBILE_FILM_SHOCKING")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Radio", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e radio")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Reverence", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@arena@celeb@podium@no_prop@", 'regal_c_1st')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Réajuster sa chemise 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e chemise1")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Réajuster sa chemise 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e chemise2")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Réparation accroupie", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", 'machinic_loop_mechandplayer')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Réparation couchée", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@amb@garage@chassis_repair@", 'look_up_01_amy_skater_01')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Siffler", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e siffler")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Slide", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@arena@celeb@flat@solo@no_props@", 'slide_a_player_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Slow Clap", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@slow_clap", 'slow_clap')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Sortir son carnet", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario("CODE_HUMAN_MEDIC_TIME_OF_DEATH")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Sortir votre carte", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario("WORLD_HUMAN_TOURIST_MAP")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Stress HoldUp", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@move_hostages@male", 'male_idle')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Wank", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@wank", 'wank')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Yoga", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("amb@world_human_yoga@male@base", 'base_a')
                            IsInAnimation = true
						end      
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'armes'), true, false, true, function()
                    RageUI.ButtonWithStyle("Animation execution", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e execution")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Animation suicide", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("mp_suicide", 'pistol')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Arme pointé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e armepointe")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Check arme", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("mp_corona@single_team", 'single_team_intro_one')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Fight 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@deathmatch_intros@unarmed", 'intro_male_unarmed_e')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Fight 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@deathmatch_intros@unarmed", 'intro_male_unarmed_d')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Fight 3", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@deathmatch_intros@unarmed", 'intro_male_unarmed_b')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Melée 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@deathmatch_intros@melee@2h", 'intro_male_melee_2h_b')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Melée 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@deathmatch_intros@melee@1h", 'intro_male_melee_1h_b')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Melée 3", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@deathmatch_intros@melee@1h", 'intro_male_melee_1h_c')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Melée 4", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("mp_deathmatch_intros@melee@2h", 'intro_male_melee_2h_d')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Melée 5", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("mp_deathmatch_intros@melee@2h", 'intro_male_melee_2h_a_gclub')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Melée 6", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("mp_deathmatch_intros@melee@1h", 'intro_male_melee_1h_b')
                            IsInAnimation = true
						end      
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'danses'), true, false, true, function()
                    RageUI.ButtonWithStyle("Danse Disco", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@uncle_disco", 'uncle_disco')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Salsa Roll", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@salsa_roll", 'salsa_roll')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Grind", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_li_15_sexygrind_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Banale", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("rcmnigel1bnmt_1b", 'dance_loop_tyler')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Basique", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_hi_06_base_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Crazyrobot", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_hi_15_crazyrobot_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Crotchgrab", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_hi_13_crotchgrab_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de pecno", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("special_ped@mountain_dancer@monologue_3@monologue_3a", 'mnt_dnc_buttwag')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de soirée 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_facedj@", 'hi_dance_facedj_09_v1_male^4')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de soirée 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_facedj@", 'hi_dance_facedj_09_v2_female^1')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de soirée 3", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_facedj@", 'hi_dance_facedj_09_v2_female^2')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de soirée 4", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_facedj@", 'hi_dance_facedj_09_v2_male^2')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de soirée 5", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_facedj@", 'hi_dance_facedj_11_v2_male^2')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de soirée 6", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_groups@", 'hi_dance_crowd_09_v1_female^1')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de soirée 7", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_groups@", 'hi_dance_crowd_09_v1_female^3')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de soirée 8", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@djs@black_madonna@", 'dance_b_idle_a_blamadon')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse de soirée 9", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", 'high_center')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse du ventre", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mini@strip_club@private_dance@idle", 'priv_dance_idle')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse festive 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", 'med_center')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse festive 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", 'high_center_up')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse festive 3", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@solomun_entourage@", 'mi_dance_facedj_17_v1_female^1')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse festive 4", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@podium_dancers@", 'hi_dance_facedj_17_v2_male^5')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse festive 5", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_groups@", 'mi_dance_crowd_17_v1_female^6')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse festive 6", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_groups@", 'mi_dance_crowd_17_v2_female^1')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse festive 7", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@crowddance_groups@", 'mi_dance_crowd_13_v2_male^4')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Flying", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_hi_13_flyingv_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Hipswivel", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_li_13_hipswivel_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Miturn", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_mi_13_turnaround_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Point", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_mi_11_pointthrust_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Robot", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_mi_15_robot_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Shimmy", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_mi_15_shimmy_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Smack", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_hi_17_smackthat_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Spider", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_hi_17_spiderman_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse spéciale 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@tracy@ig_5@idle_a", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse spéciale 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@tracy@ig_5@idle_a", 'idle_b')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse spéciale 3", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@tracy@ig_5@idle_b", 'idle_e')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse spéciale 4", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@tracy@ig_5@idle_b", 'idle_d')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Turnaround", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@lazlow@hi_podium@", 'danceidle_hi_11_turnaround_laz')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danser", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("misschinese2_crystalmazemcs1_cs", 'dance_loop_tao')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danser Stylé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("missfbi3_sniping", 'dance_m_default')
                            IsInAnimation = true
						end      
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'sexe'), true, false, true, function()
                    RageUI.ButtonWithStyle("***** en voiture", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mini@prostitutes@sexlow_veh", 'low_car_sex_loop_player')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Twerk", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mini@strip_club@private_dance@part3", 'priv_dance_p3')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Danse Sexy", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mp_safehouse", 'lap_dance_girl')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Faire une gaterie", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("oddjobs@towing", 'f_blow_job_loop')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Fellation", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("misscarsteal2pimpsex", 'pimpsex_hooker')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Mon coeur", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mini@hookers_spvanilla", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Montrer sa poitrine", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mini@strip_club@backroom@", 'stripper_b_backroom_idle_b')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Montrer ses fesses", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e montrersesfesses")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("****** en voiture", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mini@prostitutes@sexlow_veh", 'low_car_sex_loop_female')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Se faire su*** en voiture", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("oddjobs@towing", 'm_blow_job_loop')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Se faire sucer 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("misscarsteal2pimpsex", 'pimpsex_pimp')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Se faire sucer 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("misscarsteal2pimpsex", 'pimpsex_punter')
                            IsInAnimation = true
						end      
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'expressions'), true, false, true, function()
                    RageUI.ButtonWithStyle("A Couvert", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("amb@code_human_cower@male@base", 'base')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("A vos marque ! Partez !", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("random@street_race", 'grid_girl_race_start')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Badmood 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("amb@world_human_stupor@male@base", 'base')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Badmood 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("amb@world_human_stupor@male_looking_left@base", 'base')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Bisou", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mp_ped_interaction", 'kisses_guy_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Bro love", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@bro_love", 'bro_love')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Ceinturons", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e ceinturions")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Check moi ça 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mp_ped_interaction", 'handshake_guy_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Check moi ça 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mp_ped_interaction", 'hugs_guy_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Check mon flow", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("clothingshirt", 'try_shirt_positive_d')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Clown Teubé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("move_clown@p_m_two_idles@", 'fidget_short_dance')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Craquer les poignets", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@knuckle_crunch", 'knuckle_crunch')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Envie Pressante", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("misscarsteal4@toilet", 'desperate_toilet_base_idle')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Etirement Jambes", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("rcmfanatic1maryann_stretchidle_b", 'idle_e')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Face Palm", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@face_palm", 'face_palm')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Il a gagné !", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("random@street_race", '_streetracer_accepted')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Inspecter ses lunettes", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e inspecterseslunettes")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Jouer avec un chien", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("switch@franklin@plays_w_dog", '001916_01_fras_v2_9_plays_w_dog_idle')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Le plus fort", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e leplusfort")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Loose Thumbs", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@arena@celeb@flat@solo@no_props@", 'thumbs_down_a_player_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Mal de tête", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("misscarsteal4@actor", 'stumble')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Mort de rire", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@arena@celeb@flat@solo@no_props@", 'taunt_d_player_b')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("On arrête tous !", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e onarretetous")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Patience", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e patience")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Peace", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@peace", 'peace')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Regarder au sol", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("switch@franklin@admire_motorcycle", 'base_franklin')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Respect", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e respect")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Réflexion", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e reflexion")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Salut Militaire", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e salutmilitaire")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Signe Ballas", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e signeballas")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Signe GSF", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e signegsf")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Signe Locura", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e signelocura")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Signe Vagos", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e signevagos")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Stressé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("rcmme_tracey1", 'nervous_loop')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Ta géré!", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@thumbs_up", 'thumbs_up')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Victoire", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mini@tennisexit@", 'tennis_outro_win_01_female')
                            IsInAnimation = true
						end      
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'festives'), true, false, true, function()
                    RageUI.ButtonWithStyle("Coincé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@black_madonna_entourage@", 'li_dance_facedj_15_v2_male^2')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("DJ", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@dj", 'dj')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Enchainé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@black_madonna_entourage@", 'hi_dance_facedj_09_v2_male^5')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Fausse Guitare", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@air_guitar", 'air_guitar')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Hey Man", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@club_ambientpeds@", 'mi-hi_amb_club_09_v1_male^1')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Mains Jazz", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationfemale@jazz_hands", 'jazz_hands')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intupperuncle_disco", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intuppersalsa_roll", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 3", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intupperraise_the_roof", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 4", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intupperoh_snap", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 5", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intupperheart_pumping", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 6", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intupperfind_the_fish", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 7", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intuppercats_cradle", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 8", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intupperbanging_tunes", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 9", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intupperbanging_tunes_right", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Move 10", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intupperbanging_tunes_left", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Rock'N Roll", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@mp_player_intcelebrationmale@rock", 'rock')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Suspens", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@nightclub@dancers@black_madonna_entourage@", 'li_dance_facedj_11_v1_male^1')
                            IsInAnimation = true
						end      
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'gestures'), true, false, true, function()
                    RageUI.ButtonWithStyle("Allez viens..", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e allezviens")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Aucune idée", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e aucuneidee")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Aucune idée soft", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e aucuneideesoft")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Bise au doigt", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationfemale@finger_kiss", 'finger_kiss')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("C'est à moi", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("gestures@f@standing@casual", 'getsure_its_mine')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("C'est ça", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e cestca")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Casse-toi", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e cassetoi")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Damn", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e damn")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Droite", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e droite")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Gauche", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e gauche")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Hey Calme", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e heycalme")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Hey Toi", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e heytoi")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("ICI", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e ici")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Lourd", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e lourd")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Moi", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e moi")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Moi ?!", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e moi2")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Mouai", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e mouai")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("My Man", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e myman")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Non Non", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e nonnon")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Non Soft", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e nonsoft")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Oh Non", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e ohnon")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Oui fonce", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e ouifonce")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Pas moyen", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e pasmoyen")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Quoi", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e quoi")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Quoi ?!", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e quoi2")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Quoi soft", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e quoi3")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Salut", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e salut")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Toi", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e toi")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Toi Soft", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e toi2")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Tsss", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e tsss")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Viens Voir", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e viensvoir")
                            IsInAnimation = true
						end      
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'insolentes'), true, false, true, function()
                    RageUI.ButtonWithStyle("Bouffe mon doigt", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@finger", 'finger')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Chuuuute", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@shush", 'shush')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("DTC", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@dock", 'dock')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Doigt d'honneur", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e doigtdhonneur")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Doigt Solo", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e doigtsolo")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("MDR", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@arena@celeb@flat@solo@no_props@", 'giggle_a_player_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Nananère", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@thumb_on_ears", 'thumb_on_ears')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Pluie de fric 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@arena@celeb@flat@solo@props@", 'make_it_rain_b_player_b')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Pluie de fric 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@raining_cash", 'raining_cash')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Poule Mouillé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("anim@mp_player_intcelebrationmale@chicken_taunt", 'chicken_taunt')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Prend mon fuck", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("random@shop_gunstore", '_negative_goodbye')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Se curer le nez", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e securezlenez")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Se gratter le cul", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e segratterlecul")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Se gratter les couilles", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e segratterlescouilles")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Uriner", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startAnim("misscarsteal2peeing", 'peeing_intro')
                            IsInAnimation = true
						end      
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'poses'), true, false, true, function()
                    RageUI.ButtonWithStyle("A genoux, mains en l’air", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("missheist_jewel", 'manageress_kneel_loop')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Apeuré au sol", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("rcmtmom_2leadinout", 'tmom_2_leadout_loop')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Assis mal au coeur", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@heists@prison_heistig_5_p1_rashkovsky_idle", 'idle_180')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Attente 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e attente1")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Attente 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e attente2")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Blessé au sol", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("combat@damage@rb_writhe", 'rb_writhe_loop')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Blessé Couché", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("combat@damage@writheidle_c", 'writhe_idle_g')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Bras Croisé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e brascroise")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Bras Croisé lourd", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e brascroiselourd")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Bras dans le dos", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e brasdansledos")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Dormir sur place", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e dormirsurplace")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Dos Comptoir", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@clubhouse@bar@bartender@", 'base_bartender')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Désespéré", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("rcmnigel1c", 'idle_d')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Essouffler", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("re@construction", 'out_of_breath')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Faire du stop", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e fairedustop")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Faire la statue", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario('WORLD_HUMAN_HUMAN_STATUE')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Faire le mec", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@heists@heist_corona@single_team", 'single_team_intro_two')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Holster", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e holster")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Mains sur la tête", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e mainssurlatete")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Massage Cardiaque", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("mini@cpr@char_a@cpr_str", 'cpr_pumpchest')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Montrer ses muscles", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario('WORLD_HUMAN_MUSCLE_FLEX')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("PLS", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@tracy@sleep@", 'idle_c')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Patauge", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("move_m@wading", 'walk')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Pose Garde", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							ExecuteCommand("e poseguarde")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Roule au sol", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("missfinale_a_ig_2", 'trevor_death_reaction_pt')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Se rendre, à genoux", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("random@arrests@busted", 'enter')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Zombie", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("special_ped@zombie@monologue_1@monologue_1c", 'iamundead_2')
                            IsInAnimation = true
						end      
					end)
                end)
                RageUI.IsVisible(RMenu:Get('animations', 'asseoir'), true, false, true, function()
                    RageUI.ButtonWithStyle("Accouder flow 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("missheistdockssetup1ig_12@base", 'talk_gantry_idle_base_worker2')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Accouder flow 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("missheistdockssetup1ig_12@base", 'talk_gantry_idle_base_worker4')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Genoux au sol", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("amb@medic@standing@kneel@base", 'base')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Méditation", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("rcmcollect_paperleadinout@", 'meditiate_idle')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir au sol 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@heists@fleeca_bank@ig_7_jetski_owner", 'owner_idle')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir au sol 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("rcm_barry3", 'barry_3_sit_loop')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir au sol 3", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("amb@world_human_picnic@male@idle_a", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir au sol 4", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("amb@world_human_picnic@female@idle_a", 'idle_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir au sol 5", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@jimmy@mics3_ig_15@", 'idle_a_jimmy')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir au sol 6", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@amb@business@bgen@bgen_no_work@", 'sit_phone_phoneputdown_sleeping-noworkfemale')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir chill 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@reunited@ig_10", 'base_amanda')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir chill 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@maid@couch@", 'base')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir chill 3", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("missheistpaletoscoresetupleadin", 'rbhs_mcs_1_leadin')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir cool 1", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("missfam2leadinoutmcs3", 'onboat_leadin_pornguy_a')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir cool 2", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("anim@heists@heist_safehouse_intro@phone_couch@male", 'phone_couch_male_idle')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir droit", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@ron@ig_5_p3", 'ig_5_p3_base')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir impatient", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@ron@ig_3_couch", 'base')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir par terre", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario("WORLD_HUMAN_PICNIC")
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("S'asseoir posé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startDanse("timetable@tracy@ig_14@", 'ig_14_base_tracy')
                            IsInAnimation = true
						end      
					end)
					RageUI.ButtonWithStyle("Se poser contre un mur", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							Citizen.Wait(2)
							startScenario('WORLD_HUMAN_LEANING')
                            IsInAnimation = true
						end      
					end)
                end)
				Wait(0)
			end
		end)
	end

end

Keys.Register('K','K', 'Menu Animations', function()
    OpenAnimationsRageUIMenu()
end)

Keys.Register('X','X', 'Annuler animations', function()
	if not IsPedInAnyVehicle(PlayerPedId(),false) then
		EmoteCancel()
	end
end)
