-- Clovis Durand



-- hw_shift.lua

require("mips/bits")

-- n le mot pour chiffrer
-- shamt : le shift a gauche
-- (shift amount)
function Shift(n, shamt)
	return bits.shiftleft(n, shamt)
end