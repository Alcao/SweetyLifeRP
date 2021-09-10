cfg_coffre = {}
cfg_coffre.Table = "k_coffre"
cfg_coffre.esxEvent = "SwLife:initObject"
cfg_coffre.Banner = true
cfg_coffre.Touche = "L"
cfg_coffre.ColorChange = "~b~"
cfg_coffre.weightCoffre = 0
cfg_coffre.Vehicle = {
     maxWeight = {
          [0] = 150000, --Compact
          [1] = 150000, --Sedan
          [2] = 150000, --SUV
          [3] = 150000, --Coupes
          [4] = 150000, --Muscle
          [5] = 150000, --Sports Classics
          [6] = 150000, --Sports
          [7] = 150000, --Super
          [8] = 150000, --Motorcycles
          [9] = 150000, --Off-road
          [10] = 150000, --Industrial
          [11] = 150000, --Utility
          [12] = 150000, --Vans
          [13] = 150000, --Cycles
          [14] = 150000, --Boats
          [15] = 150000, --Helicopters
          [16] = 150000, --Planes
          [17] = 150000, --Service
          [18] = 150000, --Emergency
          [19] = 150000, --Military
          [20] = 150000, --Commercial
          [21] = 150000, --Trains,
     },
     itemWeight = { -- C'est en GRAMME (2000g = 2kg)
          -- Money
          ["dirty"] = 0,
          -- Weapons
          ["WEAPON_PISTOL"] = 5000,
          ["WEAPON_SMG"] = 8000,
          ["WEAPON_MUSKET"] = 1500,
          -- Items
          ["bread"] = 1500,
          ["water"] = 1000,
          ["weed"] = 1000,
          ["coke"] = 1000,
          ["meth"] = 1000,
          ["opium"] = 1000,
          ["phone"] = 1000
     },
}
--
-- Script finish 
-- Created by Kadir
--