fx_version('bodacious')
game('gta5')

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/static/css/app.css',
	'html/static/js/app.js',
	'html/static/js/manifest.js',
	'html/static/js/vendor.js',
	'html/static/config/config.json',
	-- Coque
	'html/static/img/coque/*.png',
	'html/static/img/coque/*.jpg',
	-- Background
	'html/static/img/background/*.jpg',
	'html/static/img/background/*.png',
	'html/static/img/icons_app/*.png',
	'html/static/img/icons_app/*.jpg',
	'html/static/img/app_bank/*.jpg',
	'html/static/img/app_bank/*.png',
	'html/static/img/app_tchat/*.png',
	'html/static/img/app_tchat/*.jpg',
	'html/static/img/twitter/*.png',
	'html/static/img/twitter/*.jpg',
	'html/static/sound/*.ogg',
	'html/static/img/*.png',
	'html/static/img/*.jpg',
	'html/static/fonts/fontawesome-webfont.ttf',
	'html/static/fonts/SF-Pro-Display-Bold.otf',
	'html/static/fonts/SF-Pro-Display-Regular.otf',
	'html/static/fonts/SF-Pro-Display-Semibold.otf',
	'html/static/fonts/SF-Pro-Text-Bold.otf',
	'html/static/fonts/SF-Pro-Text-Light.ttf',
	'html/static/fonts/SF-Pro-Text-Medium.otf',
	'html/static/fonts/SF-Pro-Text-Regular.otf',
	'html/static/fonts/SF-Pro-Text-Semibold.otf',
	'html/static/sound/*.ogg',
	'html/static/sound/*.mp3',
}

--client_script('@korioz/lib.lua')
client_script {
	'config.lua',
	'client/animation.lua',
	'client/main.lua',
	'client/photo.lua',
	'client/app_tchat.lua',
	'client/bank.lua',
	'client/twitter.lua'
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua',
	'server/app_tchat.lua',
	'server/twitter.lua'
}








