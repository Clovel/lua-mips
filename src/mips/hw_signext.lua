-- Clovis Durand
-- Enseirb-Matmeca
-- Cours MI201 - Microinformatique

-- hw_signext.lua

require("mips/bits")

function SignExtend(a)
	return bits.extendsign(a, 32)
end
