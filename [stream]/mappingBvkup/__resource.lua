resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

this_is_a_map 'yes'

data_file 'TIMECYCLEMOD_FILE' 'gabz_mrpd_timecycle.xml'
data_file 'TIMECYCLEMOD_FILE' 'gabz_bennys_timecycle'
data_file 'TIMECYCLEMOD_FILE' 'timecycle_mods_1.xml'
date_file 'pausemenu.xml'
date_file 'mapzoomdata.meta'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'
data_file "SCALEFORM_DLC_FILE" "stream/cayomap/int3232302352.gfx"

files {
	'gabz_mrpd_timecycle.xml',
	'interiorproxies.meta',
	'stream/cayomap/int3232302352.gfx'
}

client_script {
    "gabz_mrpd_entitysets.lua"
}

client_script {
    "client/client.lua",
	"client/main.lua",
	"client/client2.lua"
}

ui_page 'hud-job/html/ui.html'

client_scripts {
	'hud-job/client.lua'
}

server_scripts {
	'hud-job/server.lua'
}

files {
	'hud-job/html/ui.html',
	'hud-job/html/style.css',
	'hud-job/html/grid.css',
	'hud-job/html/main.js',
	'hud-job/html/img/bank.png',
	'hud-job/html/img/dirtymoney.png',
	'hud-job/html/img/money.png',
	'hud-job/html/img/jobs/unemployed.png',
	'hud-job/html/img/jobs/unemployed2.png',
	'hud-job/html/img/jobs/police.png',
	'hud-job/html/img/jobs/ambulance.png',
	'hud-job/html/img/jobs/mechanic.png',
	'hud-job/html/img/jobs/cardealer.png',
	'hud-job/html/img/jobs/immo.png',
	'hud-job/html/img/jobs/sheriff.png',
	'hud-job/html/img/jobs/drusillas.png',
	'hud-job/html/img/jobs/ballas.png',
	'hud-job/html/img/jobs/families.png',
	'hud-job/html/img/jobs/vagos.png',
	'hud-job/html/img/jobs/marabunta.png',
	'hud-job/html/img/jobs/biker.png',
	'hud-job/html/img/jobs/bratva.png'
}
