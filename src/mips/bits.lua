bits = {}

local bin2hex = {
    [ "0000" ] = "0",
    [ "0001" ] = "1",
    [ "0010" ] = "2",
    [ "0011" ] = "3",
    [ "0100" ] = "4",
    [ "0101" ] = "5",
    [ "0110" ] = "6",
    [ "0111" ] = "7",
    [ "1000" ] = "8",
    [ "1001" ] = "9",
    [ "1010" ] = "A",
    [ "1011" ] = "B",
    [ "1100" ] = "C",
    [ "1101" ] = "D",
    [ "1110" ] = "E",
    [ "1111" ] = "F"
}

local bool2bin = {
    [ 0 ] = "0",
    [ 1 ] = "1"
}

local bin2bool = {
    [ "0" ] = 0,
    [ "1" ] = 1
}

-- convert a binary string to a hex string
function bits.bin2hex( s )
	local l = 0
	local h = ""
	local b = ""
	local rem
	l = string.len( s )
	rem = l % 4
	l = l - 1
	h = ""
    -- need to prepend zeros to eliminate mod 4
    if ( rem > 0 ) then
        s = string.rep( "0", 4 - rem ) .. s
    end
    for i = 1, l, 4 do
        b = string.sub( s, i, i + 3 )
        h = h .. bin2hex[ b ]
    end
    return h
end

-- convert an unsigned int to a bitstring
function bits.uint2bin( n, numbits )
    numbits = numbits or select( 2, math.frexp( n ) )
    local t = {}       
    for b = numbits, 1, -1 do
        t[ b ] = math.floor( math.fmod( n, 2 ) )
        n = ( n - t[ b ] ) / 2
    end
    return table.concat( t )
end

-- convert a signed int to a bitstring
function bits.int2bin( n, numbits )
	-- first makes our number positive then convert it to a bitstring
	s = bits.uint2bin( math.abs( n ), numbits )
	-- if negative number, convert to 2's complement otherwise, we're done
	if ( n < 0 ) then
		-- invert binary string
		s = bits.invertbin( s )
		-- add "1"
		s = bits.add( s, bits.padleft( "1", numbits - 1, "0" ) )
	end
    return s
end

function bits.invertbin( s )
	r = ''
	for i = 1, s:len() do 
		if ( s:sub( i, i ) == '0' ) then
			c = '1'
		else
			c = '0'
		end
		r = r .. c
	end
	return r
end

-- add two bitstrings (same length assumed)
function bits.add( a, b )
	local cin = 0
	local r   = ''
	local l   = a:len()
	for i = l, 1, -1 do
		ai   = a:sub( i, i )
		bi   = b:sub( i, i )
		vai  = bin2bool[ ai ]
		vbi  = bin2bool[ bi ]
		xor1 = bit32.bxor(  vai,  vbi )
		xor2 = bit32.bxor( xor1,  cin ) -- adder result output
		and1 = bit32.band( xor1,  cin )
		and2 = bit32.band(  vai,  vbi )
		or1  = bit32.bor ( and1, and2 ) -- adder carry output
		cin  = or1
		r = bool2bin[ xor2 ] .. r
	end
	cout = bin2bool[ cin ]
	return r, cout
end

function bits.andd( a, b )
	r = ''
	l = a:len()
	for i = l, 1, -1 do
		ai = a:sub( i, i )
		bi = b:sub( i, i )
		r = bool2bin[ bit32.band( bin2bool[ ai ], bin2bool[ bi ] ) ].. r
	end
	return r
end

-- convert a binary string to a signed int
function bits.bin2int( s )
	l    = s:len()
	-- get sign bit
	n 	 = s:sub( 1, 1 )
	-- positive number by default
	sign = 1 
	-- if negative number
	if ( n == "1" ) then
		-- convert the 2's complement number to natural binary
		s = bits.invertbin( s )
		-- add "1"
		s = bits.add( s, bits.padleft( "1", l - 1, "0" ) )
		-- negate the number
		sign = -1
	end
	return tonumber( s, 2 ) * sign
end

-- pad a binary string
function bits.padleft( str, length, ptrn )
	p = ''
	for m = 1, length do 
		p = p .. ptrn
	end
	return p .. str
end

-- perform a left shift on a binary string
function bits.shiftleft( str, shamt )
	local z = ''
	for m = 1, shamt do
		z = z .. '0'
	end
	l = string.len( str )
	s = string.sub( str, shamt, l )
	o = s .. z
	return o
end

-- extend the sign of a binary string
function bits.extendsign( str, length )
	s = bits.padleft( str, length - string.len( str ), string.sub( str, 1, 1 ) )
	return s
end

-- return a given range of a binary string
function bits.getrange( str, first, last )
	l = string.len( str )
	s = string.sub( str, l - last, l - first )
	return s
end