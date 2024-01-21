local wt2 = {
  Draining_Scythe_Upgrade1 = "+1 Damage",
  Draining_Scythe_Upgrade2 = "+1 Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

----- DRAINING SCYTHE -----
Draining_Scythe = Skill:new{
    Class = "Prime",
    Damage = 1,
	PathSize = 1,
    PowerCost = 0,
    Icon = "weapons/prime_draining_scythe.png",
    LaunchSound = "/weapons/sword",
	OnKill = "Mechs heal 1 HP",
    Upgrades = 2,
    UpgradeCost = { 2,2 },
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Friendly_Damaged = Point(3,3),
		CustomEnemy = "Leaper1",
	}
}

function Draining_Scythe:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local damage = SpaceDamage(p2, self.Damage, direction)
	damage.sAnimation = "para_scythe_attack_"..direction

	local boost = 0
	if Board:GetPawn(p1):IsBoosted() then
		boost = boost + 1
	end
	if Board:IsPawnSpace(p2) and Board:GetPawn(p2):IsBoosted() then
		boost = boost - 1
	end

	local deadlierTrigger = false
	if Board:IsPawnSpace(p2) and self:IsDeadlier(damage, Board:GetPawn(p2), boost) then
		damage.bKO_Effect = true
		deadlierTrigger = true
	end
	ret:AddMelee(p2 - DIR_VECTORS[direction], damage)
	--ret:AddBounce(target,8)

	if deadlierTrigger then
		local board_size = Board:GetSize()
		local repaired_units = {}
		for i = 0, board_size.x - 1 do
			for j = 0, board_size.y - 1  do
				if Board:IsPawnTeam(Point(i,j),TEAM_PLAYER) and Board:GetPawn(Point(i,j)):IsMech() then
					local pawn_id = Board:GetPawn(Point(i,j)):GetId()
					if not repaired_units[pawn_id] then--prevents healing the same unit twice if it's large
						ret:AddDamage(SpaceDamage(Point(i,j),-1))
						repaired_units[pawn_id] = true
					end
				end
			end
		end
	end

	return ret

end

function Draining_Scythe:IsDeadlier(damage,pawn,boost)
	--Variables
	--local boost = 0 or boost
	if damage.iDamage <= 0 then boost = 0 end
	local dir = damage.iPush
	local nextPoint = damage.loc + DIR_VECTORS[dir]
	local bump = Board:IsValid(nextPoint) and Board:IsBlocked(nextPoint,PATH_PROJECTILE) and not pawn:IsGuarding()
	local falseCrack = Board:IsCracked(damage.loc) and Board:IsValid(nextPoint)
		and not Board:IsBlocked(nextPoint, PATH_PROJECTILE) and not pawn:IsGuarding()
	local pushD = 1
	if IsPassiveSkill("Passive_ForceAmp") then pushD = 2 end --consider 2 bump damage if Force Amps
	--local armor = armorDetection.IsArmor(pawn) --I'll implement this later if I need to
	-- armor = nil
	--if armor and not pawn:IsAcid() then armor = 1 else armor = 0 end

	--Deadly on boost, armor and acid
	dam = SpaceDamage(damage.loc, damage.iDamage, damage.iPush)
	dam.iDamage = dam.iDamage + boost
	if Board:IsDeadly(dam,pawn) and (pawn:GetHealth() <= dam.iDamage or not falseCrack) then
		return true
	end

	if not bump then
		local acid = 0
		if pawn:IsAcid() then acid = 2 end 
		if pawn:GetHealth() <= dam.iDamage*acid then -- Subtract armor from dam.iDamage if necessary
			return true
		end
	end
	
	--Deadly on mines
	if _G[Board:GetItem(nextPoint)] ~= nil then
		local mineDamage = _G[Board:GetItem(nextPoint)].Damage.iDamage
		dam.iDamage = dam.iDamage + mineDamage
		if pawn:IsBoosted() then dam.iDamage = dam.iDamage - 1 end -- weird boost + ice mine interaction
		if Board:IsDeadly(dam,pawn) and not pawn:IsGuarding() then
			return true
		end
	end
	
	--Deadly on bump
	local noPush = dam.iDamage
	dam.iDamage = dam.iDamage + pushD
	if Board:IsDeadly(dam,pawn) and bump == true then
		if not pawn:IsAcid() then
			return true
		elseif pawn:GetHealth() <= pushD + noPush * 2 then
			return true
		end
	end
	
	--Deadly on bump with shields / ice
	if pawn:GetHealth() <= pushD and bump == true then
		return true
	end
	
	--Deadly on terrain bump (Water, Lava or Chasm)
	terrainDeadly = {[TERRAIN_LAVA]=true, [TERRAIN_WATER]=true}
	if not pawn:IsFlying() and not pawn:IsGuarding() then
		if Board:GetTerrain(nextPoint) == TERRAIN_HOLE then
			return true
		elseif terrainDeadly[Board:GetTerrain(nextPoint)] and not _G[pawn:GetType()].Massive then
			return true
		end
	end
	
	return false
end

Draining_Scythe_A = Draining_Scythe:new{ Damage = 2, UpgradeDescription = "Increases damage by 1.", 
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Friendly_Damaged = Point(3,3),
		CustomEnemy = "Digger1",
	}
}
Draining_Scythe_B = Draining_Scythe:new{ Damage = 2, UpgradeDescription = "Increases damage by 1.",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Friendly_Damaged = Point(3,3),
		CustomEnemy = "Digger1",
	}
}
Draining_Scythe_AB = Draining_Scythe:new{ Damage = 3,
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Friendly_Damaged = Point(3,3),
		CustomEnemy = "Scorpion1",
	}
}
