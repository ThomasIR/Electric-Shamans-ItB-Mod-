local path = mod_loader.mods[modApi.currentMod].resourcePath
modApi:appendAsset("img/portraits/pilots/Pilot_LivingBattery.png",path.."img/pilots/Pilot_LivingBattery.png")
CreatePilot{
    Id = "Pilot_LivingBattery",
    Personality = "Vek",
    Sex = SEX_VEK,
    Name = "Living Battery",
    Skill = "Survive_Death",
    Rarity = 0,
    Blacklist = {"Invulnerable", "Popular"},
}

HarvestMech = {
	Name = "Harvest Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 4,
	Image = "MechHarvest",
	ImageOffset = FURL_COLORS.ElectricShamans,
	SkillList = { "Draining_Scythe" },
	SoundLocation = "/mech/prime/laser_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}
AddPawn("HarvestMech")

BalanceMech = {
	Name = "Balance Mech",
	Class = "Brute",
	Health = 2,
	MoveSpeed = 4,
	Image = "MechBalance",
	ImageOffset = FURL_COLORS.ElectricShamans,
	SkillList = { "Radiant_Beam" },
	SoundLocation = "/mech/prime/laser_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}
AddPawn("BalanceMech")

LivingBattery = {
	Name = "Living Battery",
	Class = "TechnoVek",
	Health = 4,
	MoveSpeed = 1,
	Image = "BatteryLiving",
	ImageOffset = FURL_COLORS.ElectricShamans,
	SkillList = { "Overcharge_Channel", "Storm_Seeder" },
	SoundLocation = "/mech/prime/laser_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Armor = true
}
AddPawn("LivingBattery")