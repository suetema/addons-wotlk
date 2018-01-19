BC = {}
BC.debug = false
BC.prep = "[BoldCommon] "

BINDING_HEADER_BC = "BoldCommon"
BINDING_NAME_BC_TEABAG = "Teabag"

function BC.OnLoad()
	this:RegisterEvent("MERCHANT_SHOW")

	SlashCmdList["BOLDCOMMON"] = BC.SlashCommand
	SLASH_BOLDCOMMON1, SLASH_BOLDCOMMON2 = "/bc", "/boldcommon"

	SlashCmdList["BCUSE"] = BC.UseItemByName
	SLASH_BCUSE1 = "/use"
end

function BC.OnEvent()
	if event == "MERCHANT_SHOW" then
		BC.Repair()
	end
end

function BC.SlashCommand(msg)
	local _, _, c, options = string.find(msg, "([%w%p]+)%s*(.*)$");
	if c then
		c = string.lower(c);
	end
	if c == nil or c == "" or c == "help" or c == "help1" then
		BC.Help()
	elseif c == "cc" or c == "critcap" then
		BC.ReportCritCap(options)
	elseif c == "ss" then
		BC.TeaBag()
	end
end

function BC.Help()
	BC.my("BoldCommon serves as both a library and an assortment of useful commands.", BC.prep)
	BC.m("Passive: Automatically repairs your equipment at vendor.", BC.prep)
	BC.mb("/use", BC.prep)
	BC.m("Use item by name.", BC.prep)
	BC.mb("/bc cc (hitRate) - /bc critcap (hitRate)", BC.prep)
	BC.m("Reports your crit cap based on the hitRate and expertise input.", BC.prep)
	BC.mb("/bc ss", BC.prep)
	BC.m("Sit/stand up repeatedly for no good reason.", BC.prep)
end
