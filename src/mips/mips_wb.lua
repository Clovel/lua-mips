--[[
	mips_wb.lua
]]--

require("mips/bits")
require("mips/hw_mux")

function MipsSimulationInitWB()
end

function MipsSimulationUpdateWB(lmd1, alu2, rdst2, wb3)
	local mem2reg = bits.getrange(wb3, 0, 0)
	local regwr   = bits.getrange(wb3, 1, 1)
	local mux2    = Mux2to1(alu2, lmd1, mem2reg)
	local rdst3	  = rdst2
	local regwr1  = regwr

	return mux2, rdst3, regwr1
	
end