-- Clovis Durand


-- Seance 2, 3

package.path = package.path .. ";../src/mips/bits.lua"
require("mips/bits")

local g_code = {}
local g_instructions = {}
local g_registers = {}
local g_instcnt = 0

-- Recuperation de l'argument pour ouvir le programme
local filename = ''
if nil ~= arg[1] and '' ~= arg[1] then
    filename = arg[1]
else
    print("No program has been given to translate !")
    return
end

local filein = io.open(filename, "r")
-- on ouvre le fichier program.txt, en mode read. 
-- local pour reserver de la memoire a cette action

for line in filein:lines() do --on parcourt l'ensemble des lignes du fichier
    --print(line) -- Pour afficher les lignes du fichier, sert a tester
    g_code[#g_code + 1] = line --#variable est la taille de la variable
end

--fermeture de filein (c'est une méthode)
filein:close()
-- On vient d'enregistre l'ensembles des commandes asembles du fichier
-- On a donc plus besoin de le garder ouvert

-- Exemple                "add"   "001010" 
function NewInstructionR(mnemonic, opcode, funct)
    -- Les entrees sont des chaines de caracteres
    g_instructions[mnemonic] = {} 
    g_instructions[mnemonic].opcode = opcode
    g_instructions[mnemonic].funct = funct
end

function NewInstructionI(mnemonic, opcode)
    -- Les entrees sont des chaines de caracteres
    g_instructions[mnemonic] = {} 
    g_instructions[mnemonic].opcode = opcode
end

function NewInstructionJ(mnemonic, opcode)
    -- Les entrees sont des chaines de caracteres
    g_instructions[mnemonic] = {} 
    g_instructions[mnemonic].opcode = opcode
end

-- New...I et J ont le meme code, mais ce ne sont pas les memes types d'argument. 

function NewRegister(reg, addr)
    g_registers[reg] = addr
end

NewInstructionR("add", "000000", "100000")
NewInstructionI("addi", "001000")
NewInstructionI("sw", "101011")
NewInstructionI("beq", "000100")
NewInstructionJ("j", "000010")

NewRegister("$t0", "01000")
NewRegister("$t1", "01001")
NewRegister("$t2", "01010")
NewRegister("$t3", "01011")
NewRegister("$t4", "01100")
NewRegister("$t5", "01101")
NewRegister("$t6", "01110")
NewRegister("$t7", "01111")

-- print(#g_code) -- verif

filout = io.open("./program.dat", "w")
-- On passe en mode ecriture

for i = 1, #g_code do
    local line = g_code[i] -- ici l'utilisation de local declare la variable localement dans la boucle
    local inst = {}

    g_instcnt = g_instcnt + 1

    for j in string.gmatch(line, "([^ ,]+)") do
        -- gmatch : mechanisme qui permet de verifier si on a un element de string 
        -- On cherche une correspondance entre la chaine de carctere, line, et un espace  ou une virgule
        -- mnemonic s'arrete a l'espace et registres separes par virgule
        inst[#inst + 1] = j
        -- print(j)
    end

    local a = inst[1] -- "add" -- commentaires sont des exemples, 
    local b = inst[2] -- "$t1" -- ne pas retenir
    local c = inst[3] -- "$t2"
    local d = inst[4] -- "$t3"


    -- Controle des valeurs
    -- print(a)
    -- print(b)
    -- print(c)
    -- print(d)

    local opcode = g_instructions[a].opcode 

    -- print(opcode)

    if (a == "add") then
        -- la fonction
        funct = g_instructions[a].funct
        -- les registres
        rd = g_registers[b]
        rs = g_registers[c]
        rt = g_registers[d]

        out = opcode .. rs .. rt .. rd .. "00000" .. funct -- deux points pour concatener
            -- On vient de creer le "mot" de l'instruction
                -- slide "Instruction Formats" MI201
        --print(out)

    elseif (a == "addi") then

        rs = g_registers[c]
        rt = g_registers[b]

        imm = bits.int2bin(tonumber(d, 10), 16)
            -- Prends la chaine, la convertit en entier
            -- On reconvertit en binaire
            -- deuxieme argument : base dans laquelle on cherche a convertir d

        out = opcode .. rs .. rt .. imm

        --print(out)

    elseif (a == "sw") then

        idx = string.match(c, "%d+") -- on recupere le nombre qui precede la parenthese
        reg = string.match(c, "%((.-)%)") --on recupere le nom du registre $s

        -- print(idx)
        -- print(reg)

        rs = g_registers[reg]
        rt = g_registers[b]
        offset = bits.int2bin(tonumber(idx, 10), 16)

        out = opcode .. rs .. rt .. offset

        --print(out)

    elseif (a == "beq") then

        rs = g_registers[b]
        rt = g_registers[c]

        offset = bits.int2bin(tonumber(d, 10), 16)

        out = opcode .. rs .. rt .. offset
        --print(out)

    elseif (a == "j") then

        imm = bits.int2bin(tonumber(b, 10), 26)

        out = opcode .. imm
        --print(out)
    end

    output = string.format("%20s | %32s | %8s", line, out, bits.bin2hex(out))
    -- On sort la ligne d'instructions, son encodage en binaire, puis son encodage en hexadecimal
    -- <=> a "printf" en C
    
    filout:write(out .. "\n")

    print(output)

end

for i = g_instcnt, 512 - 1 do
    filout:write(bits.int2bin(0, 32) .. "\n")
    -- On ecrit des zeros la ou il n'y a pas d'instructions
        -- On ne laisse jamais des valeurs a des valeurs indeterminees
    -- 512 car nos lignes font 32 bits, soit 4 o, donc 512 * 4 = 2 ko
end

filout:close()