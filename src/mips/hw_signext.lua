-- Clovis Durand



-- hw_signext.lua

require("mips/bits")

function SignExtend(a)
	return bits.extendsign(a, 32)
end
