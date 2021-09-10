cfg_ambulance = {}
cfg_ambulance.Locale = 'fr'

cfg_ambulance.DrawDistance = 25.0
cfg_ambulance.MarkerColor = { r = 102, g = 0, b = 102 }
cfg_ambulance.MarkerSize = vector3(1.5, 1.5, 1.0)

cfg_ambulance.ReviveReward = 800
cfg_ambulance.AntiCombatLog = true

cfg_ambulance.RespawnDelay = 10 * 60000

cfg_ambulance.EnablePlayerManagement = true
cfg_ambulance.EnableSocietyOwnedVehicles = false

cfg_ambulance.RemoveWeaponsAfterRPDeath = true
cfg_ambulance.RemoveCashAfterRPDeath = false
cfg_ambulance.RemoveItemsAfterRPDeath = false

cfg_ambulance.ShowDeathTimer = true

cfg_ambulance.HelicopterSpawner = {
	SpawnPoint = vector3(351.83, -588.41, 73.11),
	Heading = 338.14
}

cfg_ambulance.AuthorizedVehicles = {
	{
		model = 'ambulance',
		label = 'Ambulance'
	},
	{
		model = 'dodgeems',
		label = 'Dodge Ambulance'
	}
}

cfg_ambulance.Tenues = {
	ems_service_wear = {
		male = {
			['tshirt_1'] = 21,  ['tshirt_2'] = 0,
			['torso_1'] = 33,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 91,
			['pants_1'] = 19,   ['pants_2'] = 11,
			['shoes_1'] = 96,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 46,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	}
}

cfg_ambulance.Zones = {
	HospitalInteriorEntering1 = {
		Pos = vector3(294.2, -1448.60, -1029.0),
		Type = 1
	},
	HospitalInteriorInside1 = {
		Pos = vector3(301.37, -585.52, 43.28),
		Type = -1
	},
	HospitalInteriorExit1 = {
		Pos = vector3(275.7, -1361.5, -1023.5),
		Type = 1
	},
	HospitalInteriorOutside1 = {
		Pos = vector3(299.91, -578.22, 43.26),
		Type = -1
	},
	HospitalInteriorEntering2 = {
		Pos = vector3(326.97, -603.62, 42.23),
		Type = 1
	},
	HospitalInteriorInside2 = {
		Pos = vector3(340.88, -584.68, 73.11),
		Type = -1
	},
	HospitalInteriorExit2 = {
		Pos = vector3(339.04, -584.04, 73.11),
		Type = 1
	},
	HospitalInteriorOutside2 = {
		Pos = vector3(327.78, -601.64, 42.23),
		Type = -1
	},
	AmbulanceActions = {
		Pos = vector3(299.07, -598.04, 42.23),
		Type = 1
	},
	VehicleSpawner = {
		Pos = vector3(299.28, -603.99, 42.26),
		Type = 1
	},
	VehicleSpawnPoint = {
		Pos = vector3(294.29, -611.38, 42.31),
		Type = -1
	},
	VehicleDeleter = {
		Pos = vector3(295.86, -602.95, 42.25),
		Type = 1
	},
	Pharmacy = {
		Pos = vector3(307.04, -601.66, 42.23),
		Type = 1
	}
}

cfg_ambulance.RestockItems = {
	{label = _U('pharmacy_take'), rightlabel = {_('medikit')}, value = 'medikit'},
	{label = _U('pharmacy_take'), rightlabel = {_('bandage')}, value = 'bandage'},
	{label = _U('pharmacy_take'), rightlabel = {'GHB'}, value = 'piluleoubli'}
}

cfg_ambulance.VIPWeapons = {
	--['WEAPON_ASSAULTRIFLE'] = false,
	--['WEAPON_HEAVYSNIPER'] = false
}