-- Clovis Durand
-- Enseirb-Matmeca
-- Cours MI201 - Microinformatique

-- Memoire d'instructions contenant le programme mips a executer

require("mips/bits")

local g_imem = {}

function InstructionMemoryInit(file)
	local filein = io.open(file, "r")
	local cursor = 0
	for line in filein:lines() do
		g_imem[bits.int2bin(cursor, 32)] = line
		cursor = cursor + 4
		print(line)
	end
	filein:close()
end

function InstructionMemory(addr)
	return g_imem[addr]
end