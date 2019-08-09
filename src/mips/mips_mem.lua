--[[
	mips_mem.lua

]]--

require("mips/bits")
require("mips/hw_and")
require("mips/hw_dmem")

function MipsSimulationInitMEM( )
	-- body
end


function MipsSimulationUpdateMEM(bt, z, alu1, b2, rdst1, mem2, wb2)
	local memwr = bits.getrange (mem2, 0, 0)
	local memrd = bits.getrange (mem2, 1, 1)
	local br    = bits.getrange (mem2, 2, 2)
	local pcsrc = And(br, z)
	local lmd1  = DataMemory (alu1, b2, memrd, memwr)
	local alu2  = alu1
	local rdst2 = rdst1
	local wb3   = wb2

	return pcsrc, lmd1, alu2, rdst2, wb3 

end