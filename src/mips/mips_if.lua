--[[
	mips_if.lua
	etage de fetch (lecture) de l'instruction à executer
]]--

require("mips/bits")
require("mips/hw_adder")
require("mips/hw_imem")
require("mips/hw_mux")

function MipsSimulationInitIF(file)
	InstructionMemoryInit(file)
end


-- Fonction de maj de l'étage de fetch de l'instruction (IF)
-- pc : 	compteur programme
-- pcbt :	cible de branchement (branch target)
-- pcsrc: 	source du compteur programme
-- npc :	prochaine valeur du compteur programme (next program counter)

function MipsSimulationUpdateIF(pc, pcbt, pcsrc)
	print( "PCCCCCCCCCCCCC")
	print( pc )
	local pc1 = Adder (pc, bits.int2bin( 4, 32))
	local npc = Mux2to1(pc1, pcbt, pcsrc)
	local ir1 = InstructionMemory(pc)
	return npc, pc1, ir1
end