-- Clovis Durand
-- Enseirb-Matmeca
-- Cours MI201 - Microinformatique

-- hw_and.lua

require("mips/bits")

function And(a, b)
	return bits.andd(a, b)
end