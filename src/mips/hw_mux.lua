-- Clovis Durand
-- Enseirb-Matmeca
-- Cours MI201 - Microinformatique

-- Multiplexeur

require("mips/bits")

function Mux2to1(a, b, sel)
	if sel == 0 then
		return a
	else
		return b
	end
end