Map = {

    {name="Commissariat",color=77, id=60, x=425.130, y=-979.558, z=30.711},

    {name="Hopitâl",color=2, id=61, scale=0.8,x=301.37, y =-585.52, z= 43.28},

    {name="Sherrif",color=56, id=60, x=-443.08, y = 6016.76, z = 31.4},

    {name="Mécano",color=5, id=72, x=-211.27, y = -1323.20, z= 30.89},

    --{name="Vanilla Unicorn",color=50, id=121,x=129.246, y = -1299.363, z= 29.501},

    {name="Territoire | Bloods",color=1, id=437,x=-1159.92, y = -1514.06, z= 4.16},

    {name="Gouvernement",color=0, id=419,x=-538.7, y = -215.15, z= 37.65},

    --{name="Territoire | Bratva",color=0, id=484,x=1364.97, y = -578.8, z= 74.38},

    {name="Territoire | Madrazo",color=22, id=437,x=1387.5, y = 1141.64, z= 114.33},

    --{name="Territoire | Los Gitanos",color=0, id=484,x=67.61, y = 3706.08, z= 39.75},

    {name="Territoire | Marabunta",color=26, id=437,x=1436.14, y = -1496.44, z= 63.22},

    {name="Territoire | Vagos",color=5, id=437,x=324.73, y = -2031.74, z= 20.87}, 

    {name="Territoire | Ballas",color=27, id=437,x=88.05, y = -1925.59, z= 20.79},

    {name="Territoire | Families",color=2, id=437,x=-24.34, y = -1511.94, z= 30.68},

    --{name="Hopital",color=2, id=61,x=286.6, y = -582.8, z= 43.3},

    --{name="Commissariat de Police",color=29, id=60,x=425.1, y = -979.5, z= 30.7},

    --{name="Quartier Yakuza",color=68, id=378,x=-1059.5769, y = -1028.1550, z= 30.7},

  }









Citizen.CreateThread(function()

	

	for i=1, #Map, 1 do

		local blip = AddBlipForCoord(Map[i].x, Map[i].y, Map[i].z) 

    	SetBlipSprite (blip, Map[i].id)

    	SetBlipDisplay(blip, 4)

    	SetBlipScale  (blip, 0.6)

    	SetBlipColour (blip, Map[i].color)

    	SetBlipAsShortRange(blip, true)

  		BeginTextCommandSetBlipName("STRING") 

  		AddTextComponentString(Map[i].name)

		EndTextCommandSetBlipName(blip)



		local zoneblip = AddBlipForRadius(Map[i].x, Map[i].y, Map[i].z, 800.0)

		SetBlipSprite(zoneblip,1)

		SetBlipColour(zoneblip,Map[i].color)

		SetBlipAlpha(zoneblip,100)

	end

end)