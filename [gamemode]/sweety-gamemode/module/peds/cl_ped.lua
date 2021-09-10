ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
local coordonate = {
    {-1253.35, -288.19, 36.35, "sécurité", 300.75, "", "a_m_m_stlat_02", "",  scenario = nil, lib = nil, anim = nil},
    {-1254.8, -285.41, 37.36, "docteur", 105.85, "", "a_m_m_stlat_02", "",   scenario = nil, lib = nil, anim = nil},
    {-433.55, 1144.7, 324.9, "spawn à gauche", 224.38, "", "a_m_y_beach_03", "",   scenario = "WORLD_HUMAN_AA_COFFEE", lib = nil, anim = nil},
    {-434.41, 1143.54, 324.9, "spawn à gauche", 278.05, "", "a_m_y_beach_01", "",   scenario = "WORLD_HUMAN_SMOKING_POT", lib = nil, anim = nil},
    {-418.86, 1149.99 , 324.2, "spawn à droite", 126.81, "", "ig_jimmyboston", "",   scenario = "PROP_HUMAN_SEAT_BENCH_FOOD_FACILITY", lib = nil, anim = nil},
    {-411.57, 1122.67, 324.9, "spawn à gauche", 42.82, "", "a_m_y_runner_01", "",   scenario = "WORLD_HUMAN_TOURIST_MAP", lib = nil, anim = nil},
    {-432.12, 1144.39, 324.9, "spawn à gauche", 124.54, "", "a_f_y_vinewood_04", "",   scenario = nil, lib = nil, anim = nil},
    {-389.02 , 1171.46, 324.82, "grosse chienne", 68.73, "", "s_f_y_cop_01", "",   scenario = "WORLD_HUMAN_COP_IDLES", lib = nil, anim = nil},
    {-470.87, 1146.63 , 324.86, "cop", 76.85, "", "s_f_y_cop_01", "",   scenario = "WORLD_HUMAN_BINOCULARS", lib = nil, anim = nil},
    {-386.25, 1187.79, 324.76, "cop", 117.74, "", "s_m_y_cop_01", "",   scenario = "WORLD_HUMAN_COP_IDLES", lib = nil, anim = nil},
    {-408.62, 1134.17, 324.9, "scientifique", 111.72, "", "a_f_y_beach_01", "",   scenario = "WORLD_HUMAN_PICNIC", lib = nil, anim = nil},
    {-411.9, 1131.81, 324.9, "cop", 305.03, "", "a_m_m_skater_01", "",   scenario = "WORLD_HUMAN_PAPARAZZI", lib = nil, anim = nil},
    {-408.31, 1135.64, 324.9, "prisonier", 128.26, "", "s_f_y_hooker_02", "",   scenario = "WORLD_HUMAN_PROSTITUTE_LOW_CLASS", lib = nil, anim = nil},
    {149.41, -1042.15, 28.37, "banque pc", 341.0, "", "a_m_m_business_01", "",   scenario = nil, lib = nil, anim = nil},
    {313.74, -280.42, 53.16, "banque nord ville", 340.38, "", "a_m_m_business_01", "",   scenario = nil, lib = nil, anim = nil},
    {-351.36, -51.28, 48.04, "banque ouest ville", 343.76, "", "a_m_m_business_01", "",   scenario = nil, lib = nil, anim = nil},
    {-1211.97, -332.02, 36.78, "banque ouest plage", 28.69, "", "a_m_m_business_01", "",   scenario = nil, lib = nil, anim = nil},
    {-2961.16, 482.99, 14.7, "banque ouest", 85.14, "", "a_m_m_business_01", "",   scenario = nil, lib = nil, anim = nil},
    {-112.27, 6471.03, 30.63, "banque nord", 145.25, "", "a_m_m_business_01", "",   scenario = nil, lib = nil, anim = nil},
    {-193.67718505859,-1294.5738525391,31.295980453491-1.0, "bennys", 179.24, "", "u_m_y_smugmech_01", "",   scenario = nil, lib = nil, anim = nil},
    {432.3, -986.03, 29.71, "pdp dehors", 26.84, "", "s_f_y_cop_01", "",   scenario = nil, lib = nil, anim = nil},
    {432.57, -985.09, 29.71, "pdp dehors", 143.31, "", "s_m_y_cop_01", "",   scenario = "WORLD_HUMAN_AA_COFFEE", lib = nil, anim = nil},
    {434.56, -1003.93, 29.71, "pdp derierre", 1.13, "", "s_m_y_cop_01", "",   scenario = "WORLD_HUMAN_STAND_MOBILE_CLUBHOUSE", lib = nil, anim = nil},
    {433.56, -1003.24, 29.71, "pdp derierre", 276.06, "", "s_m_y_cop_01", "",   scenario = "WORLD_HUMAN_SMOKING", lib = nil, anim = nil},
    {460.94, -999.22, 29.69, "pdp vestiaire", 125.9, "", "s_m_y_cop_01", "",   scenario = "PROP_HUMAN_BUM_BIN", lib = nil, anim = nil},
    {462.37, -997.34, 29.19, "pdp vestiaire", 2.54, "", "s_f_y_cop_01", "",   scenario = "PROP_HUMAN_SEAT_CHAIR_DRINK", lib = nil, lib = nil, anim = nil},
    {5117.9995117188,-5190.8530273438,2.3830344676971-1.0, "location_1", 92.13, "", "a_m_y_beach_01", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {5054.3408203125,-4597.2045898438,2.8794636726379-1.0, "location_2", 162.48, "", "a_m_y_beach_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {4502.6494140625,-4540.6435546875,4.1091642379761-1.0, "location_3", 20.88, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {4771.3422851562,-4771.8676757812,4.855170249939-1.0, "location_boat_1", 44.73, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {-1604.5867919922,5256.6557617188,2.0742933750153-1.0, "location_boat_2", 25.19, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {3859.9118652344,4465.4848632812,2.7424740791321-1.0, "location_boat_3", 178.20, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {-718.69055175781,-1327.7019042969,1.5962892770767-1.0, "location_boat_4", 46.75, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {4902.79296875,-5178.9291992188,2.5016989707947-1.0, "location_boat_5", 249.83, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {5118.83984375,-4631.443359375,1.4057340621948-1.0, "location_boat_6", 77.37, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {-869.48175048828,-429.43237304688,36.639865875244-1.0, "faqs", 117.67, "", "a_m_y_busicas_01", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
    {107.19481658936,-1290.171875,29.249691009521-1.0, "striptiseuse", 117.67, "", "mp_f_stripperlite", "",   scenario = nil, lib = "mini@strip_club@private_dance@part3", anim = 'priv_dance_p3'},
    {103.58868408203,-1292.4168701172,29.249706268311-1.0, "striptiseuse", 117.67, "", "s_f_y_stripper_01", "",   scenario = nil, lib = "mp_safehouse", anim = 'lap_dance_girl'},
    {120.66506195068,-1297.4426269531,29.269330978394-1.0, "striptiseuse", 26.69, "", "s_f_y_stripper_01", "",   scenario = nil, lib = "timetable@ron@ig_3_couch", anim = 'base'},
    {113.35870361328,-1303.0964355469,29.892965316772-1.0, "striptiseuse", 355.18, "", "s_f_y_stripper_01", "",   scenario = nil, lib = "mp_safehouse", anim = 'lap_dance_girl'},
    {-3023.4213867188,37.744285583496,10.117790222168-1.0, "weed 1", 332.24, "", "s_f_m_maid_01", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {-790.52362060547,14.581238746643,40.646572113037-1.0, "weed 2", 339.74, "", "cs_priest", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {-15.485158920288,6667.1298828125,31.915086746216-1.0, "weed 3", 32.54, "", "u_m_y_hippie_01", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {-293.20172119141,-2780.8122558594,6.4105372428894-1.0, "meth 1", 92.29, "", "s_m_y_dockwork_01", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {-84.272926330566,937.04162597656,233.02853393555-1.0, "meth 2", 22.59, "", "player_zero", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {3373.6142578125,5183.6337890625,1.4602421522141-1.0, "meth 3", 77.66, "", "ig_old_man2", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {-582.52178955078,-1610.6451416016,27.010787963867-1.0, "coke 1", 215.7264, "", "a_m_y_hiker_01", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {2735.8596191406,4279.1494140625,48.496280670166-1.0, "coke 2", 93.82, "", "a_m_y_beach_01", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {904.53112792969,-1686.6604003906,47.352500915527-1.0, "coke 3", 171.01, "", "a_m_m_rurmeth_01", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
    {1712.4272460938,4790.740234375,41.988807678223-1.0, "receleur", 3.30, "", "g_m_m_chicold_01", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
    {-867.41790771484,-437.10614013672,36.765110015869-1.0, "faq2", 0.87, "", "a_m_m_tourist_01", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
    {-429.11389160156,-2788.7307128906,6.5369629859924-1.0, "postop", 227.63, "", "s_m_m_ups_02", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
}
function startDansePed(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(ped, lib, anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
	end)
end
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('SwLife:initObject', function(obj) ESX = obj end)
      Citizen.Wait(10)
    end
    for _,v in pairs(coordonate) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Wait(1)
      end
      ped =  CreatePed(4, GetHashKey(v[7]),v[1],v[2],v[3], 3374176, false, true)
      TaskSetBlockingOfNonTemporaryEvents(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      if v.scenario ~= nil then
        TaskStartScenarioInPlace(ped, v.scenario, -1, true)
      end
      if v.lib ~= nil and v.anim ~= nil then
        startDansePed(v.lib, v.anim)
      end
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

