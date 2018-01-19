function BLW.MakeMacros()
	BC.MakeMacro("BLWTank", "/blw tank", 0, "Ability_Warrior_DefensiveStance", nil, 1, 1)
	BC.MakeMacro("BLWDPS", "/blw dps", 0, "Spell_Nature_BloodLust", nil, 1, 1)
	BC.MakeMacro("BLWAoE", "/blw aoe", 0, "Ability_Creature_Cursed_04", nil, 1, 1)
end

function BLW.Hp(unit)
	local unit = unit or "target"
	local percent = (UnitHealth(unit) / UnitHealthMax(unit)) * 100
	return percent
end

function BLW.Rage(unit)
	return UnitMana("player")
end

function BLW.SpellOnCD(spellName)
	local id = BC.GetSpellId(spellName)
	if id then
		local start, duration = GetSpellCooldown(id, 0)
		if start == 0 and duration == 0 then
			return nil
		end
	end
	return true
end

function BLW.shout(hp)
	if hp == nil then
		hp = 99
	end

	hasCom = BC.HasBuff("player", "Commanding Shout"
	hasBat = BC.HasBuff("player", "Batle Shout"
	hasMight = BC.HasBuff("player", "Blessing of Might"

	if UnitMana("player") >= 10 and BLW.Hp() <= hp
	    if not hasCom and not hasMight then
            CastSpellByName("Battle Shout")
	    end

	end

	if UnitMana("player") >= 10 and BLW.Hp() <= hp and not BC.HasBuff("player", "Blessing Of Might") or BC.HasBuff("player", "Battleshout") then
		CastSpellByName("Battle Shout")
	end
end

function BLW.TargetAndAttack()
	if UnitExists("target") then
		BC.EnableAttack()
		return true
	end
	TargetNearestEnemy()
	local counter = 0
	while counter < 10 and BLW.UnwantedTarget() do
		TargetNearestEnemy()
		counter = counter + 1
	end
	if BLW.UnwantedTarget() then
		ClearTarget()
		return false
	else
		BC.EnableAttack()
		return true
	end
end

function BLW.UnwantedTarget()
	for k,v in pairs(BLW.doNotTarget) do
		if UnitName("target") == v then
			return true
		end
	end
	return false
end

function BLW.GetStances()
	local _,_,battle,_ = GetShapeshiftFormInfo(1)
	local _,_,defensive, _ = GetShapeshiftFormInfo(2)
	local _,_,berserk, _ = GetShapeshiftFormInfo(3)
	return battle, defensive, berserk
end



--TODO crit cap
-- Crit Cap = 100 - 24 - ([214 - X] * 0.0305) - ([722 - Y] * 0.0305)
--
-- Where X = your current expertise rating and Y = your current hit rating. This is unless you are Combat.
-- If you are Combat and you have the weapon expertise talent the 214 figure should be changed to 132.
-- Also if you are Alliance and you have Heroic Presence (Draenei racial aura) active, then be sure to add 32.79 to whatever hit rating you have.
--This formula assumes 5/5 Precision