BLW = {}
if UnitClass("player") ~= "Warrior" then return end

BLW.debug = false
BLW.prep = "[BLW] "

function BLW.OnLoad()
	if UnitClass("player") ~= "Warrior" then return end
	-- for loading vars.
	this:RegisterEvent("PLAYER_LOGIN")
	-- for changing specs.
	this:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	-- misc.
	this:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function BLW.OnEvent()
	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_LOGIN" then
		BLW.InitVariables()
		if BC.GetSpellId("Devastate") then
			BLW.prot = true
		else
			BLW.prot = false
		end
		BLW.mainAbility, BLW.mainAbilityCost = "Shield Slam", 20
		if not BLW.prot then
			BLW.mainAbility, BLW.mainAbilityCost = "Whirlwind", 25
		end
	end
end


function BLW.InitVariables()
	BLW.lastStanceChange = 0
	BLW.targetCasting = 0
	BLW.revengeTimer = 0

	BLW.lastAbility = 0
	BLW.bloodthirst = 0
	BLW.whirlwind = 0
	BLW.revenge = 0
	BLW.shieldBash = 0
	BLW.pummel = 0
	BLW.sunder = 0
	BLW.execute = 0

	BINDING_HEADER_BLW = "BoldLazyWarrior"
	BINDING_NAME_BLW_DPS = "DPS rotation"
	BINDING_NAME_BLW_TANK = "Tank rotation"
	BINDING_NAME_BLW_AOE = "Multi-target rotation"

end

SLASH_BLW_ROTATION1 = '/blw'
function SlashCmdList.BLW_ROTATION(type)
	if type == "dps" then
		BLW.DPS()
	elseif type == "tank" then
		BLW.Tank()
	elseif type == "aoe" then
		BLW.AoE()
	elseif type == "mm" then
		BLW.MakeMacros()
	else
		BC.my("BoldLazyWarrior has the following warrior rotations:", BLW.prep)
		BC.mb("/blw dps", BLW.prep)
		BC.m("A dps rotation (fury).", BLW.prep)
		BC.mb("/blw tank", BLW.prep)
		BC.m("A tank rotation (prot).", BLW.prep)
		BC.mb("/blw aoe", BLW.prep)
		BC.m("A multi-target rotation.", BLW.prep)
		BC.mb("/blw mm", BLW.prep)
		BC.m("Make macros for the rotations.", BLW.prep)
	end
end

function BLW.DPS()
		BLW.FuryDPSRotation()
end

function BLW.FuryDPSRotation()

	if not BLW.TargetAndAttack() then return end
	local battle, _, berserk = BLW.GetStances()
	local name, _, _, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo("target")
	local channelName, _, _, _, channelStartTime, channelEndTime, _, _, channelNotInterruptible = UnitCastingInfo("target")


	if battle then
		if not BLW.SpellOnCD("Rend") and not BC.HasDebuff("target", "Rend") then
			CastSpellByName("Rend")
		else
			CastSpellByName("Berserker Stance")
			BLW.lastStanceChange = GetTime()
		end
	elseif berserk then
		if notInterruptible or channelNotInterruptible then
			if UnitClassification("target") ~= "worldboss" and not BLW.SpellOnCD("Pummel") then
				CastSpellByName("Pummel")
			end
		end
		if not BLW.SpellOnCD("Whirlwind") then
			CastSpellByName("Whirlwind")
			if BLW.SpellOnCD("Whirlwind") then
				BLW.whirlwind = GetTime()
			end
		end
		if not BLW.SpellOnCD("Bloodthirst") and (GetTime() - BLW.whirlwind) > 0.5 then
			CastSpellByName("Bloodthirst")
			if BLW.SpellOnCD("Bloodthirst") then
				BLW.bloodthirst = GetTime()
			end
		end
		if BC.HasBuff("player", "Slam!") then
			if (GetTime() - BLW.whirlwind) > 0.5 and (GetTime() - BLW.bloodthirst) > 0.5 then
				CastSpellByName("Slam")
			end
		end -- No slam available

		if BLW.HP() > 20 then
			if (GetTime() - BLW.whirlwind) > 1 and (GetTime() - BLW.bloodthirst) > 1 and not BC.HasDebuff("target", "Rend") then
				CastSpellByName("Battle Stance")
			else
				CastSpellByName("Sunder Armor")
			end
		else
			if (GetTime() - BLW.whirlwind) > 1 and (GetTime() - BLW.bloodthirst) > 1 and not BC.HasBuff("player", "Slam!") then
				CastSpellByName("Battle Stance")
			end
		end

		if BLW.Rage() > 35 then
			CastSpellByName("Heroic Strike")
		end

	else
		CastSpellByName("Berserker Stance")
	end
end

function BLW.AoE()
	if not BLW.TargetAndAttack() then return end
	local _, _, berserk = BLW.GetStances()

	if berserk then
		if CheckInteractDistance("target", 3) then
			CastSpellByName("Whirlwind")
		end
		if BLW.SpellOnCD("Whirlwind") and (GetTime() - BLW.whirlwind) > 1.5 then
			CastSpellByName("Bloodthirst")
		end
		if BLW.Rage() > 45 then
			CastSpellByName("Cleave")
		end
	else
		CastSpellByName("Berserker Stance")
	end
end

