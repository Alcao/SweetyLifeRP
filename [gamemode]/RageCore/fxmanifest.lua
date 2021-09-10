fx_version 'adamant'

game 'gta5'

------------ RAGEUI ------------

dependency 'Sw-Framework'



client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",

    "src/components/*.lua",

    "src/menu/elements/*.lua",

    "src/menu/items/*.lua",

    "src/menu/panels/*.lua",

    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

}

client_scripts({
	'esx_shops/dependenciesdushop/RMenu.lua',
	'esx_shops/dependenciesdushop/menu/RageUI.lua',
	'esx_shops/dependenciesdushop/menu/Menu.lua',
	'esx_shops/dependenciesdushop/menu/MenuController.lua',
	'esx_shops/dependenciesdushop/components/*.lua',
	'esx_shops/dependenciesdushop/menu/elements/*.lua',
	'esx_shops/dependenciesdushop/menu/items/*.lua',
	'esx_shops/dependenciesdushop/menu/panels/*.lua',
	'esx_shops/dependenciesdushop/menu/windows/*.lua',
})

client_scripts {
    "banquecouille/srccouille/RMenu.lua",
    "banquecouille/srccouille/menu/RageUI.lua",
    "banquecouille/srccouille/menu/Menu.lua",
    "banquecouille/srccouille/menu/MenuController.lua",

    "banquecouille/srccouille/components/*.lua",

    "banquecouille/srccouille/menu/elements/*.lua",

    "banquecouille/srccouille/menu/items/*.lua",

    "banquecouille/srccouille/menu/panels/*.lua",

    "banquecouille/srccouille/menu/windows/*.lua"

}

client_scripts {
    "rz-admin/internal/RageUIRZ/RMenu.lua",
    "rz-admin/internal/RageUIRZ/menu/RageUI.lua",
    "rz-admin/internal/RageUIRZ/menu/Menu.lua",
    "rz-admin/internal/RageUIRZ/menu/MenuController.lua",
    "rz-admin/internal/RageUIRZ/components/*.lua",
    "rz-admin/internal/RageUIRZ/menu/elements/*.lua",
    "rz-admin/internal/RageUIRZ/menu/items/*.lua",
    "rz-admin/internal/RageUIRZ/menu/panels/*.lua",
    "rz-admin/internal/RageUIRZ/menu/windows/*.lua",

    --RZ ADMIN
    'rz-admin/config.lua',
    'rz-admin/client/client.lua',
}


client_scripts {
    '@Sw-Framework/locale.lua',
    'fr.lua',
	
    -- esx_shops
    'esx_shops/config.lua',
    'esx_shops/client/main.lua',

    -- Robberies
   -- 'robberies/Cambriolage/client.lua',
   --- 'robberies/Cambriolage/client2.lua',
   -- 'robberies/Objet/*.lua',

   -- Kart
   'kart/client.lua',

   --Parachute
   'parachute/client.lua',

    -- Blanchiment
    'blanchiment/client/client.lua',

    --Guns illégaux
    'gunsblack/config.lua',
    'gunsblack/client.lua',

    -- Weashops
    'weashops/config.lua',
    'weashops/client.lua',

    --RZ ADMIN
    --'rz-admin/config.lua',
    --'rz-admin/client/client.lua',

    -- ECOLE
    'auto-ecole/client.lua',

    -- Leboncoin
    'leboncoin/client/main.lua',
    'leboncoin/client/menu.lua',
    
    -- localocaloca
    --'localocaloca/client/spawn.lua',
   -- 'localocaloca/client/prison.lua',
   -- 'localocaloca/client/cayo.lua',
    --'localocaloca/client/bateau.lua',
  --  'localocaloca/client/karting.lua',

    -- Banque
    'banquecouille/client.lua'

    -- KRZ
--	'krz_personalmenu/config.lua',
	--'krz_personalmenu/client/main.lua',
	--'krz_personalmenu/client/other.lua'
}

--ui_page('html/ui.html')

--files({
	--'krz_personalmenu/html/ui.html',
	--'krz_personalmenu/html/css/app.css',
	--'krz_personalmenu/html/js/app.js',
	--'krz_personalmenu/html/img/*.png'
--})

shared_scripts {
    "leboncoin/shared/coords.lua",
}


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@Sw-Framework/locale.lua',

    'fr.lua',
    -- esx_shops
    'esx_shops/config.lua',
    'esx_shops/server/main.lua',

    --Robberies
   -- 'robberies/server.lua',

    -- Kart
    'kart/server.lua',

   --Parachute
   'parachute/server.lua',

    -- Blanchiment
    'blanchiment/server.lua',

    --Guns illégaux
    'gunsblack/config.lua',
    'gunsblack/server.lua',

    -- Weashops
    'weashops/config.lua',
    'weashops/server.lua',

    --RZ
    'rz-admin/config.lua',
    'rz-admin/server/server.lua',

    -- Leboncoin
    'leboncoin/server/main.lua',
    'leboncoin/server/menu.lua',

    -- ECOLE
    'auto-ecole/server.lua',

    -- localocaloca
  --  'localocaloca/server/server.lua',

    --Banque
    'banquecouille/server.lua'

    --KRZ
	--'krz_personalmenu/config.lua',
	--'krz_personalmenu/server/main.lua'
}

-- KRZ

server_scripts({
	'@mysql-async/lib/MySQL.lua',
	'@Sw-Framework/locale.lua',
	'fr.lua',
	'krz_personalmenu/config.lua',
	'krz_personalmenu/server/main.lua'
})

--client_script('@korioz/lib.lua')
client_scripts({
	--'krz_personalmenu/src/RMenu.lua',
	--'krz_personalmenu/src/menu/RageUI.lua',
	--'krz_personalmenu/src/menu/Menu.lua',
	--'krz_personalmenu/src/menu/MenuController.lua',
	---'krz_personalmenu/src/components/*.lua',
	--'krz_personalmenu/src/menu/elements/*.lua',
	--'krz_personalmenu/src/menu/items/*.lua',
	'krz_personalmenu/KRZRageUI/RMenuKRZ.lua',
	'krz_personalmenu/KRZRageUI/menu/RageUIKRZ.lua',
	'krz_personalmenu/KRZRageUI/menu/MenuKRZ.lua',
	'krz_personalmenu/KRZRageUI/menu/MenuControllerKRZ.lua',

	'krz_personalmenu/KRZRageUI/components/*.lua',

	'krz_personalmenu/KRZRageUI/menu/elements/*.lua',
	'krz_personalmenu/KRZRageUI/menu/items/*.lua',

	'@Sw-Framework/locale.lua',
	'fr.lua',
	'krz_personalmenu/config.lua',
	'krz_personalmenu/client/main.lua',
	'krz_personalmenu/client/other.lua'
})

ui_page('krz_personalmenu/html/ui.html')

files({
	'krz_personalmenu/html/ui.html',
	'krz_personalmenu/html/css/app.css',
	'krz_personalmenu/html/js/app.js',
	'krz_personalmenu/html/img/*.png'
})

-- Robberies

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'robberies/server.lua'
}

client_scripts {
    'robberies/RageUI/RMenu.lua',
    'robberies/RageUI/menu/RageUI.lua',
    'robberies/RageUI/menu/Menu.lua',
    'robberies/RageUI/menu/MenuController.lua',
    'robberies/RageUI/components/*.lua',
    'robberies/RageUI/menu/elements/*.lua',
    'robberies/RageUI/menu/items/*.lua',
    'robberies/RageUI/menu/panels/*.lua',
    'robberies/RageUI/menu/windows/*.lua',


    'robberies/Cambriolage/client.lua',
    'robberies/Cambriolage/client2.lua',
    'robberies/Objet/*.lua'
}






