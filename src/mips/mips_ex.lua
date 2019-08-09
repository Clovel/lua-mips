-- Clovis Durand
-- Enseirb-Matmeca
-- Cours MI201 - Microinformatique

-- mips_ex.lua

require("mips/bits")
require("mips/hw_mux")
require("mips/hw_shift")
require("mips/hw_adder")
require("mips/hw_alucontrol")
require("mips/hw_alu")

function MipsSimulationInitEX()
	-- Ici on ne fait rien a l'initialisation
end

function MipsSimulationUpdateEX(pc2, a1, b1, imm1, rt, rd, ex1, mem1, wb1)
	local alusrc  = bits.getrange(ex1, 0, 0)
	local aluop   = bits.getrange(ex1, 1, 2)
	local regdst  = bits.getrange(ex1, 3, 3)
	local funct   = bits.getrange(imm1, 0, 5)

	local val 	  = Mux2to1(b1, imm1, alusrc)
	local rdst    = Mux2to1(rt, rd, regdst)

	local aluctrl = AluControl(aluop, funct)
	local alu1, z = Alu(a1, val, aluctrl)

	local sh1 	  = Shift(imm1, 2)
	local bt 	  = Adder(pc2, sh1)

	local b2	  = b1
	local mem2	  = mem1
	local wb2	  = wb1

	return bt, z, alu1, b2, rdst, mem2, wb2
end