-- Clovis Durand
-- Enseirb-Matmeca
-- Cours MI201 - Microinformatique

--[[
	mips.lua
	fichier principal du simulateur MIPS
]]--

require("mips/bits")
require("mips/mips_if")
require("mips/mips_id")
require("mips/mips_ex")
require("mips/mips_mem")
require("mips/mips_wb")

local g_regs = {ifif  = {pc   = ""},
        		ifid  = {pc   = "", 
        				 ir   = ""},
        		idex  = {pc   = "", 
        				 a    = "", 
        				 b    = "", 
        				 imm  = "", 
        				 rt   = "", 
        				 rd   = "", 
        				 ex   = "", 
        				 mem  = "", 
        				 wb   = ""},
        		exmem = {bt   = "", 
        				 z    = "", 
        				 alu  = "", 
        				 b    = "", 
        				 rdst = "", 
        				 mem  = "", 
        				 wb   = ""},
        		memwb = {alu  = "", 
        				 lmd  = "", 
        				 rdst = "", 
        				 wb   = ""}} --Barrière de registres

local g_sigs = {membt    = "",
        		mempcsrc = "",
        		wbmux    = "",
        		wbrdst    = "",
        		wbregwr  = ""}  --Signaux


--Initialise la simulation du processeur MIPS
function MipsSimulationInit(file)
	--Registres de l'étage if
	g_regs.ifif.pc = bits.int2bin(0, 32)
	--Registres de l'étage if/id
	g_regs.ifid.pc = bits.int2bin(0, 32)
	g_regs.ifid.ir = bits.int2bin(0, 32)
	--Registres de l'étage id/ex
	g_regs.idex.pc  = bits.int2bin(0, 32)
	g_regs.idex.a   = bits.int2bin(0, 32)
	g_regs.idex.b   = bits.int2bin(0, 32)
	g_regs.idex.imm = bits.int2bin(0, 32)
	g_regs.idex.rt  = bits.int2bin(0, 32)
	g_regs.idex.rd  = bits.int2bin(0, 32)
	g_regs.idex.ex  = bits.int2bin(0, 4)
	g_regs.idex.mem = bits.int2bin(0, 3)
	g_regs.idex.wb  = bits.int2bin(0, 2)
	--Registres de l'étage ex/mem
	g_regs.exmem.bt   = bits.int2bin(0, 32)
	g_regs.exmem.z    = bits.int2bin(0, 1)
	g_regs.exmem.alu  = bits.int2bin(0, 32)
	g_regs.exmem.b    = bits.int2bin(0, 32)
	g_regs.exmem.rdst = bits.int2bin(0, 32)
	g_regs.exmem.mem  = bits.int2bin(0, 3)
	g_regs.exmem.wb   = bits.int2bin(0, 2)
	--Registres de l'étage mem/wb
	g_regs.memwb.lmd  = bits.int2bin(0, 32)
	g_regs.memwb.alu  = bits.int2bin(0, 32)
	g_regs.memwb.rdst = bits.int2bin(0, 32)
	g_regs.memwb.wb   = bits.int2bin(0, 2)
	--Signaux de contrôle de l'étage de mem vers l'étage fetch
	g_sigs.membt    = bits.int2bin(0, 32)
	g_sigs.mempcsrc    = bits.int2bin(0, 1)
	--Signaux de contrôle de l'étage de wb vers l'étage decode
	g_sigs.wbmux    = bits.int2bin(0, 32)
	g_sigs.wbrdst     = bits.int2bin(0, 32)
	g_sigs.wbregwr    = bits.int2bin(0, 1)

	MipsSimulationInitIF(file)
	MipsSimulationInitID()
	MipsSimulationInitEX()
	MipsSimulationInitMEM()
	MipsSimulationInitWB()

end

function MipsSimulationSyncIF(npc)
	--MAJ des registres de la barrière IF
	g_regs.ifif.pc = npc
end

function MipsSimulationSyncID(pc1, ir1)
	--MAJ des registres de la barrière IF/ID
	g_regs.ifid.pc = pc1
	g_regs.ifid.ir = ir1
end

function MipsSimulationSyncEX(pc2, a1, b1, imm1, rt, rd, ex, mem1, wb1)
	--MAJ des registres de la barrière ID/EX
	g_regs.idex.pc  = pc2
	g_regs.idex.a   = a1
	g_regs.idex.b   = b1
	g_regs.idex.imm = imm1
	g_regs.idex.rt  = rt
	g_regs.idex.rd  = rd
	g_regs.idex.ex  = ex
	g_regs.idex.mem = mem1
	g_regs.idex.wb  = wb1
end

function MipsSimulationSyncMEM(z, alu1, b2, rdst1, mem2, wb2, bt, pcsrc)
	--MAJ des registres de la barrière EX/MEM
	g_regs.exmem.z     = z
	g_regs.exmem.alu   = alu1
	g_regs.exmem.b     = b2
	g_regs.exmem.rdst  = rdst1
	g_regs.exmem.mem   = mem2
	g_regs.exmem.wb    = wb2
	-- MAJ signaux
	g_sigs.membt	   = bt
	g_sigs.mempcsrc	   = pcsrc

end

function MipsSimulationSyncWB(lmd1, alu2, rdst2, wb3, mux2, rdst3, regwr)
	--MAJ des registres de la barrière MEM/WB
	g_regs.memwb.lmd    = lmd1
	g_regs.memwb.alu    = alu2
	g_regs.memwb.rdst   = rdst2
	g_regs.memwb.wb     = wb3
	--MAJ des signaux de contrôle
	g_sigs.wbmux    	= mux2
	g_sigs.wbrdst       = rdst3
	g_sigs.wbregwr      = regwr
end

--Simule le comportement du MIPS en avançant d'un pas de simulation
function MipsSimulationNextStep()
	--Il faut propager les signaux de rétropropagation (combinatoire)
	--Pour ce faire on effectue la MAJ en sens inverse des tranches du pipeline 
	mux2, rdst3, regwr 						 = MipsSimulationUpdateWB (g_regs.memwb.lmd, g_regs.memwb.alu, g_regs.memwb.rdst, g_regs.memwb.wb)
	pcsrc, lmd1, alu2, rdst2, wb3 			 = MipsSimulationUpdateMEM(g_regs.exmem.bt, g_regs.exmem.z, g_regs.exmem.alu, g_regs.exmem.b, g_regs.exmem.rdst, g_regs.exmem.mem, g_regs.exmem.wb)
	bt, z, alu1, b2, rdst1, mem2, wb2		 = MipsSimulationUpdateEX(g_regs.idex.pc, g_regs.idex.a, g_regs.idex.b, g_regs.idex.imm, g_regs.idex.rt, g_regs.idex.rd, g_regs.idex.ex, g_regs.idex.mem, g_regs.idex.wb)
	pc2, a1, b1, imm1, rt, rd, ex, mem1, wb1 = MipsSimulationUpdateID(g_regs.ifid.pc, g_regs.ifid.ir, rdst3, mux2, regwr)
	npc, pc1, ir1							 = MipsSimulationUpdateIF(g_regs.ifif.pc, bt, pcsrc)

	MipsSimulationUpdateIF(npc)
	MipsSimulationUpdateID(pc1, ir1)
	MipsSimulationUpdateEX(pc2, a1, b1, imm1, rt, rd, ex, mem1, wb1)
	MipsSimulationUpdateMEM(z, alu1, b2, rdst1, mem2, wb2, bt, pcsrc)
	MipsSimulationUpdateWB(lmd1, alu2, rdst2, wb3, mux2, rdst3, regwr)
end

function MipsPrintIFID()

	print( "ifif.pc    " .. g_regs.ifif.pc    )

	print( "-------------------------------------------" )
	print( "Fetch/Decode registers" )
	print( "-------------------------------------------" )

	print( "  ifid.pc    " .. g_regs.ifid.pc    )
	print( "  ifid.ir    " .. g_regs.ifid.ir    )

end

function MipsPrintIDEX()

	print( "-------------------------------------------" )
	print( "Decode/Execute registers" )
	print( "-------------------------------------------" )

	print( "  idex.pc    " .. g_regs.idex.pc    )
	print( "  idex.a     " .. g_regs.idex.a     )
	print( "  idex.b     " .. g_regs.idex.b     )
	print( "  idex.imm   " .. g_regs.idex.imm   )
	print( "  idex.rt    " .. g_regs.idex.rt    )
	print( "  idex.rd    " .. g_regs.idex.rd    )
	print( "  idex.ex    " .. g_regs.idex.ex    )
	print( "    alusrc   " .. bits.getrange( g_regs.idex.ex, 0, 0 ) )
	print( "    aluop0   " .. bits.getrange( g_regs.idex.ex, 1, 1 ) )
	print( "    aluop1   " .. bits.getrange( g_regs.idex.ex, 2, 2 ) )
	print( "    regdst   " .. bits.getrange( g_regs.idex.ex, 3, 3 ) )
	print( "  idex.mem   " .. g_regs.idex.mem   )
	print( "    memwr    " .. bits.getrange( g_regs.idex.mem, 0, 0 ) )
	print( "    memrd    " .. bits.getrange( g_regs.idex.mem, 1, 1 ) )
	print( "    branch   " .. bits.getrange( g_regs.idex.mem, 2, 2 ) )
	print( "  idex.wb    " .. g_regs.idex.wb    )
	print( "    mem2reg  " .. bits.getrange( g_regs.idex.wb, 0, 0 ) )
	print( "    regwr    " .. bits.getrange( g_regs.idex.wb, 1, 1 ) )

end

function MipsPrintEXMEM()

	print( "-------------------------------------------" )
	print( "Execute/Memory registers" )
	print( "-------------------------------------------" )

	print( "  exmem.bt   " .. g_regs.exmem.bt   )
	print( "  exmem.z    " .. g_regs.exmem.z    )
	print( "  exmem.alu  " .. g_regs.exmem.alu  )
	print( "  exmem.b    " .. g_regs.exmem.b    )
	print( "  exmem.rdst " .. g_regs.exmem.rdst )
	print( "  exmem.mem  " .. g_regs.exmem.mem  )
	print( "    memwr    " .. bits.getrange( g_regs.exmem.mem, 0, 0 ) )
	print( "    memrd    " .. bits.getrange( g_regs.exmem.mem, 1, 1 ) )
	print( "    branch   " .. bits.getrange( g_regs.exmem.mem, 2, 2 ) )
	print( "  exmem.wb   " .. g_regs.exmem.wb   )
	print( "    mem2reg  " .. bits.getrange( g_regs.exmem.wb, 0, 0 ) )
	print( "    regwr    " .. bits.getrange( g_regs.exmem.wb, 1, 1 ) )

end


function MipsPrintMEMWB()

	print( "-------------------------------------------" )
	print( "Memory/Writeback registers" )
	print( "-------------------------------------------" )

	print( "  memwb.lmd  " .. g_regs.memwb.lmd  )
	print( "  memwb.alu  " .. g_regs.memwb.alu  )
	print( "  memwb.rdst " .. g_regs.memwb.rdst )
	print( "  memwb.wb   " .. g_regs.memwb.wb   )
	print( "    mem2reg  " .. bits.getrange( g_regs.memwb.wb, 0, 0 ) )
	print( "    regwr    " .. bits.getrange( g_regs.memwb.wb, 1, 1 ) )

end

function MipsPrintSignals()

	print( "-------------------------------------------" )
	print( "Signals" )
	print( "-------------------------------------------" )

	print( "  mem bt     " .. g_sigs.membt     )
	print( "  mem pcsrc  " .. g_sigs.mempcsrc   )

	print( "  wb mux     " .. g_sigs.wbmux      )
	print( "  wb rdst    " .. g_sigs.wbrdst     )
	print( "  wb regwr   " .. g_sigs.wbregwr    )

end

-- Affiche le contenu des registres et des signaux
function MipsPrint()
	MipsPrintIFID ()
	MipsPrintIDEX ()
	MipsPrintEXMEM()
	MipsPrintMEMWB()

	MipsPrintSignals()

	RegistersFilePrint()

end

function MipsPrintIFID()
	
	print( "ifif.pc    " .. g_regs.ifif.pc    )
	
	print( "-------------------------------------------" )
	print( "Fetch/Decode registers" )
	print( "-------------------------------------------" )
	
	print( "  ifid.pc    " .. g_regs.ifid.pc    )
	print( "  ifid.ir    " .. g_regs.ifid.ir    )
	
end

function MipsPrintIDEX()

	print( "-------------------------------------------" )
	print( "Decode/Execute registers" )
	print( "-------------------------------------------" )
	
	print( "  idex.pc    " .. g_regs.idex.pc    )
	print( "  idex.a     " .. g_regs.idex.a     )
	print( "  idex.b     " .. g_regs.idex.b     )
	print( "  idex.imm   " .. g_regs.idex.imm   )
	print( "  idex.rt    " .. g_regs.idex.rt    )
	print( "  idex.rd    " .. g_regs.idex.rd    )
	print( "  idex.ex    " .. g_regs.idex.ex    )
	print( "    alusrc   " .. bits.getrange( g_regs.idex.ex, 0, 0 ) )
	print( "    aluop0   " .. bits.getrange( g_regs.idex.ex, 1, 1 ) )
	print( "    aluop1   " .. bits.getrange( g_regs.idex.ex, 2, 2 ) )
	print( "    regdst   " .. bits.getrange( g_regs.idex.ex, 3, 3 ) )
	print( "  idex.mem   " .. g_regs.idex.mem   )
	print( "    memwr    " .. bits.getrange( g_regs.idex.mem, 0, 0 ) )
	print( "    memrd    " .. bits.getrange( g_regs.idex.mem, 1, 1 ) )
	print( "    branch   " .. bits.getrange( g_regs.idex.mem, 2, 2 ) )
	print( "  idex.wb    " .. g_regs.idex.wb    )
	print( "    mem2reg  " .. bits.getrange( g_regs.idex.wb, 0, 0 ) )
	print( "    regwr    " .. bits.getrange( g_regs.idex.wb, 1, 1 ) )

end

function MipsPrintEXMEM()

	print( "-------------------------------------------" )
	print( "Execute/Memory registers" )
	print( "-------------------------------------------" )
	
	print( "  exmem.bt   " .. g_regs.exmem.bt   )
	print( "  exmem.z    " .. g_regs.exmem.z    )
	print( "  exmem.alu  " .. g_regs.exmem.alu  )
	print( "  exmem.b    " .. g_regs.exmem.b    )
	print( "  exmem.rdst " .. g_regs.exmem.rdst )
	print( "  exmem.mem  " .. g_regs.exmem.mem  )
	print( "    memwr    " .. bits.getrange( g_regs.exmem.mem, 0, 0 ) )
	print( "    memrd    " .. bits.getrange( g_regs.exmem.mem, 1, 1 ) )
	print( "    branch   " .. bits.getrange( g_regs.exmem.mem, 2, 2 ) )
	print( "  exmem.wb   " .. g_regs.exmem.wb   )
	print( "    mem2reg  " .. bits.getrange( g_regs.exmem.wb, 0, 0 ) )
	print( "    regwr    " .. bits.getrange( g_regs.exmem.wb, 1, 1 ) )

end


function MipsPrintMEMWB()
	
	print( "-------------------------------------------" )
	print( "Memory/Writeback registers" )
	print( "-------------------------------------------" )
	
	print( "  memwb.lmd  " .. g_regs.memwb.lmd  )
	print( "  memwb.alu  " .. g_regs.memwb.alu  )
	print( "  memwb.rdst " .. g_regs.memwb.rdst )
	print( "  memwb.wb   " .. g_regs.memwb.wb   )
	print( "    mem2reg  " .. bits.getrange( g_regs.memwb.wb, 0, 0 ) )
	print( "    regwr    " .. bits.getrange( g_regs.memwb.wb, 1, 1 ) )
	
end

function MipsPrintSignals()

	print( "-------------------------------------------" )
	print( "Signals" )
	print( "-------------------------------------------" )
	
	print( "  mem bt     " .. g_sigs.membt 	    )
	print( "  mem pcsrc  " .. g_sigs.mempcsrc   )
	
	print( "  wb mux     " .. g_sigs.wbmux      )
	print( "  wb rdst    " .. g_sigs.wbrdst     )
	print( "  wb regwr   " .. g_sigs.wbregwr    )
	
end

-- Affiche le contenu des registres et des signaux
function MipsPrint()

	MipsPrintIFID ()
	MipsPrintIDEX ()
	MipsPrintEXMEM()
	MipsPrintMEMWB()
	
	MipsPrintSignals()
	
	RegistersFilePrint()

end

function MipsSimulationRun(step)
	print("-------------------------------------------")
	print("cycle 0")
	print("-------------------------------------------")
	MipsPrint()
	for i = 1, step do
		MipsSimulationNextStep()
		print("-------------------------------------------")
		print("cycle " .. i)
		print("-------------------------------------------")
		MipsPrint()
	end
end

file = arg[1]
if nil == file or '' == file then
	print("Filename is nil or empty")
	return
end

MipsSimulationInit(file)
MipsSimulationRun(10)
