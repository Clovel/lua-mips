--[[
	hw_alu.lua
]]--

require("mips/bits")
require("mips/hw_adder")

function Alu(a, b, aluctrl)
	local r = bits.int2bin( 0, 32)
    local z = bits.int2bin( 0, 32)

	if (aluctrl=="010") then
	    r = Adder( a, b )
	end
	return r,z
end