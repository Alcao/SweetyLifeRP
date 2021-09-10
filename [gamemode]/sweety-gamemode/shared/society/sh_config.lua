pSocietyCFG = {

    --[[ Script  ]]

    Language = "fr",

    ESX = "SwLife:initObject",
    AddonAccount = "::{razzway.xyz}::esx_addonaccount:getSharedAccount",
    BlackMoney = "dirtycash",

    --[[ Menu  ]]

    Title = "Gestion Société",

    SubTitle = "~b~Gestion de votre entreprise",

    Banner = {
        Display = true,
        Texture = nil,
        Name = nil,
    },

    Marker = {
        Type = 6,
        Scale = {0.9, 0.9, 0.9},
        Color = {243, 255, 0},
    },

    --[[ Zone ]]

    Zone = {

       --[[  EXEMPLE
        {
            pos = vector3(0.0, 0.0, 0.0),
            name = "jobname",
            label = "Label Of Job",
            salary_max = 1200,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 
        ]]

        {
            pos = vector3(463.37, -985.41, 30.73),
            name = "police",
            label = "Los Santos Police Departement",
            salary_max = 5000,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        },

        {
            pos = vector3(311.75, -597.2, 43.28),
            name = "ambulance",
            label = "Los Santos EMS",
            salary_max = 5000,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        },

        {
            pos = vector3(-29.65, -1107.39, 26.42),
            name = "carshop",
            label = "Los Santos Concessionaire",
            salary_max = 5000,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        },

        {
            pos = vector3(-207.6, -1341.34, 34.89),
            name = "mecano",
            label = "Mécano",
            salary_max = 5000,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        },

        {
            pos = vector3(94.326438903809,-1292.9617919922,29.26876449585),
            name = "unicorn",
            label = "Vanilla Unicorn",
            percent = 50,
            salary_max = 2500,
            options = {
                money = true, 
                wash = true, 
                employees = true, 
                grades = true
            },
        },
        
    },
}