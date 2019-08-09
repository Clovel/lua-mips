-- Clovis Durand



-- mips_id.lua

require("mips/bits")
require("mips/hw_rf")
require("mips/hw_signext")
require("mips/hw_decode")

function MipsSimulationInitID()
	RegistersFileInit()
end

function MipsSimulationUpdateID(pc1, ir1, rdst, mux2, regwr)
	local rs 		  = bits.getrange(ir1, 21, 25) -- addr du reg rs
	local rt 		  = bits.getrange(ir1, 16, 20) -- addr du reg rt
	local rd 		  = bits.getrange(ir1, 11, 15) -- addr du reg rd
	local val 		  = mux2 -- valeur de wb (write back)
	local ex, mem, wb = Decode(ir1)
	local a1, b1	  = RegistersFile(rs, rt, rdst, val, regwr)
	local imm1		  = SignExtend(bits.getrange(ir1, 0, 15))
	local pc2		  = pc1

	return pc2, a1, b1, imm1, rt, rd, ex, mem, wb

end
