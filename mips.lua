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
	
	print( "  mem bt     " .. g_sigs.membt 	  )
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
