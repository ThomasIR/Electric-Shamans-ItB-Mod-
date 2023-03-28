local function init(self)
    require(self.scriptPath.."FURL")(self, {
    {
        Type = "mech",
        Name = "MechHarvest",
        Filename = "mech_harvest",
        Path = "img/units/player",
        ResourcePath = "units/player",

        Default =           { PosX = -22, PosY = -13 },
        Animated =          { PosX = -22, PosY = -13, NumFrames = 4 },
        Submerged =         { PosX = -22, PosY = -5 },
        Broken =            { PosX = -22, PosY = -13 },
        SubmergedBroken =   { PosX = -22, PosY = -5 },
        Icon =              {},
    },
    {
        Type = "mech",
        Name = "MechBalance",
        Filename = "mech_balance",
        Path = "img/units/player",
        ResourcePath = "units/player",

        Default =           { PosX = -19, PosY = -10 },
        Animated =          { PosX = -19, PosY = -10, NumFrames = 4 },
        Submerged =         { PosX = -19, PosY = -3 },
        Broken =            { PosX = -19, PosY = -10 },
        SubmergedBroken =   { PosX = -19, PosY = -3 },
        Icon =              {},
    },
    {
        Type = "mech",
        Name = "BatteryLiving",
        Filename = "living_battery",
        Path = "img/units/player",
        ResourcePath = "units/player",

        Default =           { PosX = -20, PosY = -18 },
        Animated =          { PosX = -20, PosY = -18, NumFrames = 4 },
        Submerged =         { PosX = -20, PosY = -12 },
        Broken =            { PosX = -20, PosY = -18 },
        SubmergedBroken =   { PosX = -20, PosY = -12 },
        Icon =              {},
    },
    {
    		Type = "color",
    		Name = "ElectricShamans",
    		PawnLocation = self.scriptPath.."pawns",

    		PlateHighlight = {235,255,125},
    		PlateLight = {172,199,86},
    		PlateMid = {74,96,33},
    		PlateDark = {48,56,24},
    		PlateOutline = {15,22,16},
    		PlateShadow = {34,36,34},
    		BodyColor = {74,77,70},
    		BodyHighlight = {120,128,104},
    },
    {
        Type = "base",
        Filename = "prime_draining_scythe",
        Path = "img/weapons",
        ResourcePath = "weapons",
    },
    {
        Type = "base",
        Filename = "brute_radiant_beam",
        Path = "img/weapons",
        ResourcePath = "weapons",
    },
    {
        Type = "base",
        Filename = "cyborg_overcharger",
        Path = "img/weapons",
        ResourcePath = "weapons",
    },
    {
        Type = "base",
        Filename = "cyborg_storm_seeder",
        Path = "img/weapons",
        ResourcePath = "weapons",
    },
});

require(self.scriptPath.."pawns")
require(self.scriptPath.."weapons/draining_scythe")
require(self.scriptPath.."weapons/radiant_beam")
require(self.scriptPath.."weapons/overcharge_channel")
require(self.scriptPath.."weapons/storm_seeder")
modApi:addWeapon_Texts(require(self.scriptPath.."weapon_texts"))

end

local function load(self,options,version)
  modApi:addSquadTrue({"Electric Shamans","HarvestMech","BalanceMech","LivingBattery"},"Electric Shamans","Linked to an innovative biomechanical energy source, these Mechs have been hailed as the first step toward a fighting force not reliant on the Grid.",self.resourcePath.."/squad.png")
end

return {
    id = "Electric Shamans",
    name = "Electric Shamans",
    version = "033119",
    init = init,
    load = load
}
