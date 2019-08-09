-- Clovis Durand



-- hw_decode.lua

require("mips/bits")

local blank = {ex = {regdst="0", aluop1="0", aluop0="0", alusrc="0"},
			   mem = {branch ="0", memrd="0", memwr="0"},
			   wb = {regwr="0", mem2reg="0"}} --Tous les signaux de l'étage d'exécution

local r = {ex = {regdst="1", aluop1="1", aluop0="0", alusrc="0"},
		   mem = {branch ="0", memrd="0", memwr="0"},
		   wb = {regwr="1", mem2reg="0"}} --Instruction de type R

local i = {ex = {regdst="0", aluop1="0", aluop0="0", alusrc="0"},
		   mem = {branch ="0", memrd="0", memwr="0"},
		   wb = {regwr="1", mem2reg="0"}} --Instruction de type I

local lw = {ex = {regdst="0", aluop1="0", aluop0="0", alusrc="1"},
		    mem = {branch ="0", memrd="1", memwr="0"},
		    wb = {regwr="1", mem2reg="1"}} --Instruction de type J

local sw = {ex = {regdst="0", aluop1="0", aluop0="0", alusrc="1"},
		    mem = {branch ="0", memrd="0", memwr="1"},
		    wb = {regwr="0", mem2reg="0"}} --Instruction de type J

local beq = {ex = {regdst="0", aluop1="0", aluop0="1", alusrc="0"},
		     mem = {branch ="1", memrd="0", memwr="0"},
		     wb = {regwr="0", mem2reg="0"}} --Instruction de type J

function Decode(ir1)
	local opcode = bits.getrange(ir1, 26, 31) --On récupère les bits 26 à 31, opcode de l'instruction
	local funct = bits.getrange(ir1, 0, 5) --Champ funct présent dans les bits 0 à 5
	local ctrl = blank
	if (opcode == "000000") then		--Instruction de type R
		if (funct == "100000") then
			ctrl = r 					--"add"
		end
	elseif (opcode == "001000") then	--Instruction de type I
		ctrl = i 	 					--"addi"
	elseif (opcode == "100011") then
		ctrl = lw						--"lw"
	elseif (opcode == "101011") then
		ctrl = sw						--"sw"
	end

	local ctrlex = ctrl.ex.regdst .. ctrl.ex.aluop1 .. ctrl.ex.aluop0 .. ctrl.ex.alusrc
	local ctrlmem = ctrl.mem.branch .. ctrl.mem.memrd .. ctrl.mem.memwr
	local ctrlwb = ctrl.wb.regwr .. ctrl.wb.mem2reg

	return ctrlex, ctrlmem, ctrlwb
end


