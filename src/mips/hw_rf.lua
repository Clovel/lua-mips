-- Clovis Durand



-- hw_rf.lua

require("mips/bits")

local g_rf = {}

function RegistersFileInit()
	g_rf["01000"] = bits.int2bin(0, 32)	--On remplit de 32x0 le premier registre $t0
	g_rf["01001"] = bits.int2bin(0, 32)	--$t1
	g_rf["01010"] = bits.int2bin(0, 32)	--$t2
	g_rf["01011"] = bits.int2bin(0, 32)	--$t3
	g_rf["01100"] = bits.int2bin(0, 32)	--$t4
	g_rf["01101"] = bits.int2bin(0, 32)	--$t5
	g_rf["01110"] = bits.int2bin(0, 32)	--$t6
	g_rf["01111"] = bits.int2bin(0, 32)	--$t7
end

function RegistersFilePrint()
	print("Registers file content")
	print("$t0 " .. g_rf["01000"] .. " " .. bits.bin2int(g_rf["01000"], 32)) --Affichage du contenu de $t0 et on concatène 
																			 --la conversion vers la valeur décimale
    print("$t1 " .. g_rf["01001"] .. " " .. bits.bin2int(g_rf["01001"], 32))
    print("$t2 " .. g_rf["01010"] .. " " .. bits.bin2int(g_rf["01010"], 32))
    print("$t3 " .. g_rf["01011"] .. " " .. bits.bin2int(g_rf["01011"], 32))
    print("$t4 " .. g_rf["01100"] .. " " .. bits.bin2int(g_rf["01100"], 32))
    print("$t5 " .. g_rf["01101"] .. " " .. bits.bin2int(g_rf["01101"], 32))
    print("$t6 " .. g_rf["01110"] .. " " .. bits.bin2int(g_rf["01110"], 32))
    print("$t7 " .. g_rf["01111"] .. " " .. bits.bin2int(g_rf["01111"], 32))
end

--Fonction de lectrure et d'écriture depuis/vers la file de registres
--La file de registres possède 2 ports en lecture et 1 en écriture
--rs  : adresse de lecture du premier registre
--rt  : adresse de lecture du seconde registre
--rd  : adresse d'écriture du registre
--val : mot à écrire dans le registre à l'adresse rd
--rw  : signal de contrôle pour soit l'écriture soit la lecture
function RegistersFile(rs, rt, rd, val, rw)
	local rsval = g_rf[rs]
	local rtval = g_rf[rt]
	if (rw == "1") then
		g_rf[rd] = val --On écrit val à l'adresse rd
	end
	return rsval, rtval
end