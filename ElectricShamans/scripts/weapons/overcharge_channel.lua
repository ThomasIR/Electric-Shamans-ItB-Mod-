local wt2 = {
	Overcharge_Channel_Upgrade1 = "Boost",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

----- OVERCHARGE CHANNEL -----
Overcharge_Channel = Skill:new{ 
	Class = "TechnoVek",
	Icon = "weapons/cyborg_overcharger.png",
	LaunchSound = "/weapons/science_enrage_launch",
	ImpactSound = "/impact/generic/enrage",
	AttackSound = "/weapons/science_enrage_attack",
	Damage = 0,
	SelfDamage = 2,
	PowerCost = 0,
	Upgrades = 1,
	UpgradeCost = { 2 },
	Boost = false,
	TipImage = {
		Unit = Point(2,3),
		Friendly = Point(3,1),
		Target = Point(3,1),
	},
}

function Overcharge_Channel:GetTargetArea(point)
	local ret = PointList()
	
	local board_size = Board:GetSize()
	for i = 0, board_size.x - 1 do
		for j = 0, board_size.y - 1  do
			if Board:IsPawnSpace(Point(i,j)) and Board:GetPawn(Point(i,j)):IsPlayer() and Board:GetPawn(Point(i,j)):IsMech()
			    and (Board:GetSize() == Point(6,6) or not Board:GetPawn(Point(i,j)):IsActive()) then
				ret:push_back(Point(i,j))
			end
		end
	end
	
	return ret
end

function Overcharge_Channel:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	ret:AddSound("/props/lightning_strike")
	local dummy_damage = SpaceDamage(p2,0)
	dummy_damage.sAnimation = "LightningBolt1"
	
	if Board:GetSize() == Point(6,6) or not Board:GetPawn(p2):IsActive() then
		local mark = "combat/icons/overcharge_icon"
		if self.Boost then mark = mark.."_boost" end
		dummy_damage.sImageMark = mark..".png"
	end

	ret:AddDamage(dummy_damage)
	
	if Board:GetSize() == Point(6,6) or not Board:GetPawn(p2):IsActive() then
		ret:AddScript(string.format("Board:GetPawn(%s):SetActive(true)", p2:GetString()))
		ret:AddScript(string.format("Board:GetPawn(%s):SetMovementSpent(false)", p2:GetString()))
		ret:AddScript(string.format("Board:Ping(%s,GL_Color(0,255,0))", p2:GetString())) -- cool animation
		ret:AddSound("/ui/map/sell")
	end
	
	if self.Boost then
		ret:AddScript(string.format("Board:GetPawn(%s):SetBoosted(true)", p2:GetString()))
	end
	
	ret:AddScript(string.format("Board:GetPawn(%s):SetActive(false)", p1:GetString())) -- needed to save that the skill was used when reloading the game
	--ret:AddDamage(damage)

	local selfDamage = SpaceDamage(p1 , self.SelfDamage)
	selfDamage.sAnimation = "Lightning_Hit"
	ret:AddDamage(selfDamage)

	local dummy_selfDamage = SpaceDamage(p1 , 0)
	dummy_selfDamage.sAnimation = "ExploAir1"
	ret:AddDamage(dummy_selfDamage)
	
	return ret
end

Overcharge_Channel_A = Overcharge_Channel:new{
		Boost = true, UpgradeDescription = "Boosts the target, increasing its next attack damage."
}
