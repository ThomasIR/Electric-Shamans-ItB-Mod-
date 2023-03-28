local wt2 = {
	Radiant_Beam_Upgrade1 = "Unlimited Range",
	Radiant_Beam_Upgrade2 = "+1 Damage/Healing",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

----- RADIANT BEAM -----
Radiant_Beam = Skill:new{
	Class = "Brute",
    name = "Radiant Beam",
	Damage = 1,
	Range = 3,
	PathSize = 3,
    Push = 1,
	PowerCost = 0,
	LaunchSound = "/weapons/burst_beam",
	ImpactSound = "",
	Icon = "weapons/brute_radiant_beam.png",
	Upgrades = 2,
	UpgradeCost = { 1,3 },
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Building = Point(2,2),
		Friendly_Damaged = Point(2,3)
	}
}

function Radiant_Beam:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		for k = 1, self.PathSize do
			local curr = DIR_VECTORS[i]*k + point
			ret:push_back(curr)
			if not Board:IsValid(curr) then  -- AE change or Board:GetTerrain(curr) == TERRAIN_MOUNTAIN 
				break
			end
		end
	end
	
	return ret
end

function Radiant_Beam:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2)

	for i = 1, distance do
		local curr = p1 + DIR_VECTORS[direction]*i
		local push = (i == distance) and direction*self.Push or DIR_NONE

		if Board:IsPawnSpace(curr) then
			local damage = self.Damage
			if Board:IsPawnTeam(curr, TEAM_PLAYER) then
				damage = -damage
			end

			local spaceDamage = SpaceDamage(curr, damage, push)
			spaceDamage.sAnimation = "Lightning_Hit"
			if i == distance then 	
				spaceDamage.sAnimation = "flamethrower"..distance.."_"..direction 
			end
			ret:AddDamage(spaceDamage)

			if spaceDamage.iDamage > 0 then
				local dummy_damage = SpaceDamage(curr, 0)
				dummy_damage.sAnimation = "ExploAir1"
				ret:AddDamage(dummy_damage)
			end
		end
	end

	return ret
end

Radiant_Beam_A = Radiant_Beam:new{Damage = 1, Range = 7, PathSize = 7, UpgradeDescription = "This attack can now be fired any distance.",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,0),
		Target = Point(2,0),
		Building = Point(2,2),
		Friendly_Damaged = Point(2,3)
	},
}
Radiant_Beam_B = Radiant_Beam:new{Damage = 2, Range = 3, PathSize = 3, UpgradeDescription = "Increases damage and healing by 1.",}
Radiant_Beam_AB = Radiant_Beam:new{Damage = 2, Range = 7, PathSize = 7, 
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,0),
		Target = Point(2,0),
		Building = Point(2,2),
		Friendly_Damaged = Point(2,3)
	},
}
