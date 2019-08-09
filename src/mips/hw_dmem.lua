-- Clovis Durand



-- hw_dmem.lua

require("mips/bits")

local g_dmem = {}

-- initialisation de la memoire de données
function DataMemoryInit()
	-- Remplissage de la memoire de données avec
	-- des zeros
	for i = 0, 512 - 2, 4 do
		g_dmem[bits.int2bin(i, 32)] = bits.int2bin(0, 32)
	end
end

function DataMemory(addr, val, rd, wr)
	-- rd veux dire "read"
	-- rien a voir avec le registre destination rd
	local dout = bits.int2bin(0, 32)
	
	if(wr == "1") then
		g_dmem[addr] = val
	elseif(rd == "1") then
		dout = g_dmem[addr]
	end
	return dout
end