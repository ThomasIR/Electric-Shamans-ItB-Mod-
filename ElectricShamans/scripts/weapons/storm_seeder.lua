local wt2 = {
	Storm_Seeder_Upgrade1 = "+1 Damage",
	Storm_Seeder_Upgrade2 = "Bonus Action",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

----- STORM SEEDER -----
Storm_Seeder = Grenade_Base:new{ 
	Class = "TechnoVek",
	Icon = "weapons/cyborg_storm_seeder.png",
	DamageInner = 1,
	Damage = 1,
	SelfDamage = 3,
	InnerAnimation = "ExploArt2",
	LaunchSound = "/weapons/electric_whip",
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = { 2,3 },
	BonusAction = false,
	TipImage = {
		Unit = Point(4,2),
		Enemy = Point(1,1),
		Enemy2 = Point(2,1),
		Target = Point(1,1)
	}
}

function Storm_Seeder:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dam = SpaceDamage(p2,self.Damage)
	dam.sAnimation = "LightningBolt1"
	dam.sSound = "/props/lightning_strike"
	ret:AddDamage(dam)
	ret:AddBounce(p2, 2)

	local dummy_damage = SpaceDamage(p2,0)
	dummy_damage.sAnimation = "ExploAir1"
	ret:AddDamage(dummy_damage)
	
	for i = DIR_START, DIR_END do
		dam = SpaceDamage(p2 + DIR_VECTORS[i],0,i)
		dam.sAnimation = PUSH_ANIMS[i]
		ret:AddDamage(dam)
	end

	if self.BonusAction and Board:GetSize() ~= Point(6,6) then
		local mission = GetCurrentMission()
		if mission then
			if not mission.LastStormSeedTurn then 
				mission.LastStormSeedTurn = 0
			end
			local mission = GetCurrentMission()
			LOG("Before Script: ", mission.LastStormSeedTurn)
			if Board:GetPawn(p1):IsActive() then
				LOG("Before Script: Active.")
			end
			if mission.LastStormSeedTurn ~= Game:GetTurnCount() then
				ret:AddDelay(0.2)
				ret:AddScript([[
					local self = Point(]].. p1:GetString() .. [[)
					Board:GetPawn(self):SetActive(true)
					if Board:GetPawn(self):IsActive() then
						LOG("Start of Script: Reactivated.")
					end
					Game:TriggerSound("/ui/map/flyin_rewards");
					Board:Ping(self, GL_Color(255, 255, 255));
					LOG("Start of Script: ", GetCurrentMission().LastStormSeedTurn)
					GetCurrentMission().LastStormSeedTurn = Game:GetTurnCount();
					LOG("End of Script: ", GetCurrentMission().LastStormSeedTurn)
					if Board:GetPawn(self):IsActive() then
						LOG("End of Script: Reactivated.")
					end
				]])
			end
			LOG("After Script: ", mission.LastStormSeedTurn)
			if Board:GetPawn(p1):IsActive() then
				LOG("After Script: Reactivated.")
			end
		end
	end

	local selfDamage = SpaceDamage(p1, self.SelfDamage)
	selfDamage.sAnimation = "Lightning_Hit"
	ret:AddDamage(selfDamage)
	
	local dummy_selfDamage = SpaceDamage(p1 , 0)
	dummy_selfDamage.sAnimation = "ExploAir1"
	ret:AddDamage(dummy_selfDamage)
	
	return ret
end

Storm_Seeder_A = Storm_Seeder:new{ DamageInner = 2, Damage = 2, BonusAction = false, }
Storm_Seeder_B = Storm_Seeder:new{ DamageInner = 1, Damage = 1, BonusAction = true, 
	TipImage = {
		Unit = Point(4,2),
		Enemy = Point(1,1),
		Enemy2 = Point(2,1),
		Target = Point(1,1),
		Second_Origin = Point(4,2),
		Second_Target = Point(3,1),
	}, 
}
Storm_Seeder_AB = Storm_Seeder:new{ DamageInner = 2, Damage = 2, BonusAction = true, 
	TipImage = {
		Unit = Point(4,2),
		Enemy = Point(1,1),
		Enemy2 = Point(2,1),
		Target = Point(1,1),
		Second_Origin = Point(4,2),
		Second_Target = Point(3,1),
	}, 
}