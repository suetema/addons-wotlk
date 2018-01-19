function BC.Repair()
	if not CanMerchantRepair() then return end
	local cost = GetRepairAllCost()
	cost = floor(cost / 10000)
	if cost > 100 then BC.m("You're poor, i'm not going to repair your gear.", BC.prep) return end
	RepairAllItems()
	BC.m("Repair costs: ~"..cost.." gold.", BC.prep)
end

function BC.ReportCritCap(hit,exp)
	if hit == "" then
		BC.m("You must specify your current hit rate.", BC.prep)
		return
	end
    if exp == "" then
        BC.m("You must specify your current expertise rating.", BC.prep)
        return
    end

	local missRate = 27
	local hitRate = hit
	local dodgeRate = 5.6
	local glancingRate = 40
	local critCap = 100 - (missRate - hitRate) - dodgeRate - glancingRate

	# MAKE FORMULA

	BC.m("NOT IMPLEMENTED YET")
end

function BC.m(msg, prepend, r, g, b)
	prepend = prepend or ""
	r = r or 0.7
	g = g or 1
	b = b or 0.7
	if msg then
		DEFAULT_CHAT_FRAME:AddMessage("|cffFF8888"..tostring(prepend).."|r"..tostring(msg), r, g, b)
	end
end

function BC.TeaBag()
	if sitFrame == nil then
		sitFrame = CreateFrame("frame")
	end
	local function sos() SitOrStand() end
	if breakSit == nil then
		breakSit = 1
		sitFrame:SetScript("OnUpdate", sos)
	else
		breakSit = nil
		sitFrame:SetScript("OnUpdate", nil)
	end
end

function BC.IsShieldEquipped()
	if (GetInventoryItemLink("player", 17)) then
		local _, _, itemCode = strfind(GetInventoryItemLink("player", 17), "(%d+):")
		local _, _, _, _, _, itemType = GetItemInfo(itemCode)
		if (itemType == "Shields" and not GetInventoryItemBroken("player", 17)) then
			return true
		end
	end
	return nil
end
