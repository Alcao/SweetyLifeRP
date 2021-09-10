-- This file is a private content. Create for SweetyLife Roleplay Server. You don't have to rename anything.
-- File created at [29/03/2021 16:05]

fx_version('bodacious')
game('gta5')

author 'Razzway'
contributor 'Alcao'
description 'rz-core is an powerfull core wich can manage jobs and other cools functionalities (compatible w/ESX)'
version '2.6.3'

dependency 'Sw-Framework'

shared_scripts {

	-----------------------
	------- SHARED --------
	-----------------------

	'shared/sw.lua',
    'shared/leboncoin/coords.lua',
	'shared/society/sh_*.lua',
}

client_scripts {

	-----------------------
	-------- Libs ---------
	-----------------------

    'vendors/RageUI/RMenu.lua',
    'vendors/RageUI/menu/RageUI.lua',
    'vendors/RageUI/menu/Menu.lua',
    'vendors/RageUI/menu/MenuController.lua',

    'vendors/RageUI/components/*.lua',

    'vendors/RageUI/menu/elements/*.lua',

    'vendors/RageUI/menu/items/*.lua',

    'vendors/RageUI/menu/panels/*.lua',

    'vendors/RageUI/menu/panels/*.lua',
    'vendors/RageUI/menu/windows/*.lua',

	-----------------------
	----- Context UI ------
	-----------------------

	'vendors/ContextUI/components/*.lua',
    'vendors/ContextUI/ContextUI.lua',

	-----------------------
	------ RageUIv2 -------
	-----------------------

	'vendors/RageUIv2/RMenu.lua',
    'vendors/RageUIv2/menu/RageUI.lua',
    'vendors/RageUIv2/menu/Menu.lua',
    'vendors/RageUIv2/menu/MenuController.lua',

    'vendors/RageUIv2/components/*.lua',

    'vendors/RageUIv2/menu/elements/*.lua',

    'vendors/RageUIv2/menu/items/*.lua',

    'vendors/RageUIv2/menu/panels/*.lua',

    'vendors/RageUIv2/menu/panels/*.lua',
    'vendors/RageUIv2/menu/windows/*.lua',
}

client_scripts {

	-----------------------
	-------- Main ---------
	-----------------------

	'@Sw-Framework/locale.lua',
	'fr.lua',

	-----------------------
	------- InitESX -------
	-----------------------

	'initESX/basicneeds/cfg_basic.lua',
    'initESX/basicneeds/client/main.lua',
	'initESX/addons_gcphone/client/main.lua',
	'initESX/instance/client/main.lua',

	-----------------------
	-------- Jobs ---------
	-----------------------

	------- Police --------
    'jobs/police/event.lua',
	'jobs/police/cl_main.lua',

    ------ Ambulance ------
    'jobs/ambulance/cfg_ambulance.lua',
    'jobs/ambulance/event.lua',
    'jobs/ambulance/cl_main.lua',

    ------- Unicorn -------
    'jobs/unicorn/cl_main.lua',

	------- Concess -------
	'jobs/concess/cl_main.lua',

	-----------------------
	-------- Asset --------
	-----------------------

	'asset/spawnmanager/client/main.lua',

	--------- IPL ---------
	'asset/bob74_ipl/lib/common.lua',
	'asset/bob74_ipl/client.lua',

	'asset/bob74_ipl/gtav/base.lua',
	'asset/bob74_ipl/gtav/ammunations.lua',
	'asset/bob74_ipl/gtav/floyd.lua',
	'asset/bob74_ipl/gtav/franklin.lua',
	'asset/bob74_ipl/gtav/franklin_aunt.lua',
	'asset/bob74_ipl/gtav/graffitis.lua',
	'asset/bob74_ipl/gtav/lester_factory.lua',
	'asset/bob74_ipl/gtav/michael.lua',
	'asset/bob74_ipl/gtav/north_yankton.lua',
	'asset/bob74_ipl/gtav/red_carpet.lua',
	'asset/bob74_ipl/gtav/simeon.lua',
	'asset/bob74_ipl/gtav/stripclub.lua',
	'asset/bob74_ipl/gtav/trevors_trailer.lua',
	'asset/bob74_ipl/gtav/ufo.lua',
	'asset/bob74_ipl/gtav/zancudo_gates.lua',

	'asset/bob74_ipl/gta_online/apartment_hi_1.lua',
	'asset/bob74_ipl/gta_online/apartment_hi_2.lua',
	'asset/bob74_ipl/gta_online/house_hi_1.lua',
	'asset/bob74_ipl/gta_online/house_hi_2.lua',
	'asset/bob74_ipl/gta_online/house_hi_3.lua',
	'asset/bob74_ipl/gta_online/house_hi_4.lua',
	'asset/bob74_ipl/gta_online/house_hi_5.lua',
	'asset/bob74_ipl/gta_online/house_hi_6.lua',
	'asset/bob74_ipl/gta_online/house_hi_7.lua',
	'asset/bob74_ipl/gta_online/house_hi_8.lua',
	'asset/bob74_ipl/gta_online/house_mid_1.lua',
	'asset/bob74_ipl/gta_online/house_low_1.lua',

	'asset/bob74_ipl/dlc_high_life/apartment1.lua',
	'asset/bob74_ipl/dlc_high_life/apartment2.lua',
	'asset/bob74_ipl/dlc_high_life/apartment3.lua',
	'asset/bob74_ipl/dlc_high_life/apartment4.lua',
	'asset/bob74_ipl/dlc_high_life/apartment5.lua',
	'asset/bob74_ipl/dlc_high_life/apartment6.lua',

	'asset/bob74_ipl/dlc_heists/carrier.lua',
	'asset/bob74_ipl/dlc_heists/yacht.lua',

	'asset/bob74_ipl/dlc_executive/apartment1.lua',
	'asset/bob74_ipl/dlc_executive/apartment2.lua',
	'asset/bob74_ipl/dlc_executive/apartment3.lua',

	'asset/bob74_ipl/dlc_finance/office1.lua',
	'asset/bob74_ipl/dlc_finance/office2.lua',
	'asset/bob74_ipl/dlc_finance/office3.lua',
	'asset/bob74_ipl/dlc_finance/office4.lua',
	'asset/bob74_ipl/dlc_finance/organization.lua',

	'asset/bob74_ipl/dlc_bikers/cocaine.lua',
	'asset/bob74_ipl/dlc_bikers/counterfeit_cash.lua',
	'asset/bob74_ipl/dlc_bikers/document_forgery.lua',
	'asset/bob74_ipl/dlc_bikers/meth.lua',
	'asset/bob74_ipl/dlc_bikers/weed.lua',
	'asset/bob74_ipl/dlc_bikers/clubhouse1.lua',
	'asset/bob74_ipl/dlc_bikers/clubhouse2.lua',
	'asset/bob74_ipl/dlc_bikers/gang.lua',

	'asset/bob74_ipl/dlc_import/garage1.lua',
	'asset/bob74_ipl/dlc_import/garage2.lua',
	'asset/bob74_ipl/dlc_import/garage3.lua',
	'asset/bob74_ipl/dlc_import/garage4.lua',
	'asset/bob74_ipl/dlc_import/vehicle_warehouse.lua',

	'asset/bob74_ipl/dlc_gunrunning/bunkers.lua',
	'asset/bob74_ipl/dlc_gunrunning/yacht.lua',

	'asset/bob74_ipl/dlc_smuggler/hangar.lua',

	'asset/bob74_ipl/dlc_doomsday/facility.lua',

	'asset/bob74_ipl/dlc_afterhours/nightclubs.lua',

	------- Location ------
	'config.lua',
	'asset/location/CSpawn.lua',
	'asset/location/CPrison.lua',
	'asset/location/CPerico.lua',
	'asset/location/CBateau.lua',
	'asset/location/CKarting.lua',
	'asset/location/CPort.lua',

	------- Travel -------
	'asset/travel/dlc_loader.lua',
	'asset/travel/CTravelCayo.lua',
	'asset/travel/CTravelLS.lua',

	----- Réparation -----
	'asset/repair/config.lua',
	'asset/repair/CMain.lua',

	------- Armure -------
	'asset/armour/main.lua',
	'asset/spawn/client.lua',

	-------- Vente -------
	'asset/vente/CVendeur.lua',
	'asset/vente/CVendeur2.lua',

	'asset/rz-cmd/client/main.lua',
	'asset/mapload/client.lua',

	------- Society ------
	'module/society/cl_*.lua',

	----- LeBonCoin -----
	'module/leboncoin/CBoncoin.lua',
	'module/leboncoin/CMenuBonCoin.lua',

	----- Parachute -----
	'module/parachute/CParachute.lua',
	'module/parachute/CParachute1.lua',

	------ Blips -----*
	'module/blips/blipsRadius.lua',

	----- Jail Sys -----
	'module/jail/cfg_jail.lua',
	'module/jail/cl_main.lua',

	------ Drogues -----
	'module/drugs/cfg_drugs.lua',
	'module/drugs/main.lua',

	--- Blanchiement ---
	'module/blanchiment/CBlanchiment.lua',
	'module/blanchiment/client.lua',

	---- Skinchanger ----
	'module/skinchanger/cfg_changer.lua',
	'module/skinchanger/cl_main.lua',
	'module/skinchanger/module.lua',

	----- Cargaison -----
	'module/event/cl_main.lua',
	'module/event/AC-Sync.lua',
	'module/event/EventModule/package.lua',
	'module/event/EventModule/fourgon.lua',

	---- Auto Ecole ----
	'module/auto-ecole/CMain.lua',

	----- Interact -----
	'module/interact/CMain.lua',
	'module/interact/functions.lua',
	'module/interact/other.lua',

	------ Banque ------
	'module/banque/cfg_banking.lua',
	'module/banque/atm/menu.lua',
	'module/banque/creacompte/menu.lua',
	'module/banque/function.lua',

	------ Carwash ------
	'module/carwash/client/main.lua',

	------ Garage ------
	'module/garage/cfg_garage.lua',
	'module/garage/cl_main.lua',

	------ Context ------
	'module/context/cl_menu.lua',

	------ GoFast ------
	'module/GoFast/client/cl_GoFast.lua',

	------ Coffre -------
	'module/coffre/cfg_coffre.lua',
	'module/coffre/cl_coffre.lua',

	--- Peds & SeatBelt ---
	'module/peds/cl_ped.lua',
	'module/seatbelt/client/main.lua',

	----- Identité -----
	'module/cardinal/creator/cfg_creator.lua',
	'module/cardinal/creator/CMain.lua',

	---- Animation ----
	'module/animation/CMain.lua',
	'module/animation/functions.lua',

	--- Speedometer ---
	'module/speedometer/client.lua',

	------ Shops ------
	'module/shops/cfg_shops.lua',
	'module/shops/cl_main.lua',

	------ Barber -----
	'module/barber/CMain.lua',

	----- Clothes -----
	'module/clothes/CMain.lua',

	---- Ammunation ---
	'module/ammunation/cfg_ammu.lua',
	'module/ammunation/cl_main.lua',

	------ Utils ------
	'module/vSync/cl_main.lua',
	'module/utils/carkill.lua',
	'module/safe/safe.lua',
	'module/utils/utils_cl.lua',
	'module/xp/xp.lua',
	
	----- Boutique -----
	'module/boutique/cl_boutique.lua',

	---- Robberies -----
	'module/robberies/cfg_robb.lua',
	'module/robberies/cl_main.lua',
}

files {

	-----------------------
	----- Speedometer -----
	-----------------------

	'module/speedometer/ui/index.html',
	'module/speedometer/ui/script.js',
	'module/speedometer/ui/style.css',

	-----------------------
	---- LoadingScreen ----
	-----------------------

    'module/lscreen/index.html',
    'module/lscreen/music/load.mp3',
    'module/lscreen/img/logo.png',
	'module/lscreen/img/bg-1.jpg',
    'module/lscreen/img/bg-2.jpg',
    'module/lscreen/img/bg-3.jpg',
    'module/lscreen/img/bg-4.jpg',
    'module/lscreen/img/bg-5.jpg',
    'module/lscreen/img/bg-6.jpg',
    'module/lscreen/img/bg-7.jpg',
    'module/lscreen/img/bg-8.jpg',
    'module/lscreen/img/bg-9.jpg',
    'module/lscreen/img/bg-10.jpg',
    'module/lscreen/img/timeout.png',
	'module/lscreen/css/bootstrap.css',
    'module/lscreen/css/owl.carousel.css',
	'module/lscreen/css/style.css',
    'module/lscreen/js/jquery.ajaxchimp.js',
	'module/lscreen/js/jquery.backstretch.min.js',
    'module/lscreen/js/jquery-1.11.0.min.js',
	'module/lscreen/js/lj-safety-first.js',
    'module/lscreen/js/owl.carousel.min.js',
}

loadscreen 'module/lscreen/index.html'
ui_page 'module/speedometer/ui/index.html'
max_speed '250'

server_scripts {

	-----------------------
	-------- Main ---------
	-----------------------

	'@mysql-async/lib/MySQL.lua',
    '@Sw-Framework/locale.lua',
	'fr.lua',

	-----------------------
	------- InitESX -------
	-----------------------

    'initESX/license/main.lua',
    'initESX/addoninventory/server/classes/addoninventory.lua',
    'initESX/addoninventory/server/main.lua',
    'initESX/addonaccount/server/classes/addonaccount.lua',
    'initESX/addonaccount/server/main.lua',
	'initESX/addons_gcphone/server/main.lua',
    'initESX/datastore/server/classes/datastore.lua',
    'initESX/datastore/server/main.lua',
	'initESX/basicneeds/cfg_basic.lua',
    'initESX/basicneeds/server/main.lua',
	'initESX/instance/cfg_instance.lua',
	'initESX/instance/server/bite.lua',

	-----------------------
	-------- Jobs ---------
	-----------------------

	'jobs/ambulance/cfg_ambulance.lua',
    'server/jobs/SAmbulance.lua',
	'server/jobs/SPolice.lua',
	'server/jobs/SConcess.lua',

	-----------------------
	------- Global --------
	-----------------------

	'config.lua',
	'module/shops/shops/cfg_shops.lua',
	'module/cardinal/creator/cfg_creator.lua',
	'module/jail/cfg_jail.lua',
	'module/skinchanger/cfg_changer.lua',
	'module/robberies/cfg_robb.lua',
	'module/drugs/cfg_drugs.lua',
	'module/GoFast/server/main.lua',
	'module/coffre/cfg_coffre.lua',
	'module/ammunation/cfg_ammu.lua',
	'module/banque/cfg_banking.lua',
	'module/garage/cfg_garage.lua',
	'module/garage/sv_main.lua',
	'module/banque/atm/menuv.lua',
	'module/banque/creacompte/menuv.lua',
	'module/carwash/server/main.lua',
	'module/vSync/sv_main.lua',
	'asset/repair/config.lua',
	'asset/logger/cfg_logs.lua',
	'asset/logger/main.lua',
	'asset/banSQL/cfg_ban.lua',
	'asset/banSQL/server/main.lua',
	'asset/ratelimit/cfg_ratelimit.lua',
	'asset/ratelimit/server/server.lua',
	'asset/rz-cmd/server/main.lua',
	'server/SDrugs.lua',
    'server/SGlobal.lua',
	'server/SJail.lua',
	'server/SCoffre.lua',
	'server/society/sv_*.lua',
	'server/LiteMySQL.lua',
	'server/SMain.lua',
	'server/SEvent.lua'
}