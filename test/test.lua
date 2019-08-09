-- Clovis Durand
-- Enseirb-Matmeca
-- Cours MI201 - Microinformatique
-- Seance 1

print("Hello World")

a = 1
--[[

-- introduction a la syntaxe
print(a)

print("\n")

if a == 1 then
	print("=1")
elseif a == 2 then
	print("=1")
end

print("\n")

i = 0
while i <= 5 do
	print(i)
	i = i + 1
end 

--print("\n")

i = 0
for i =1, 12, 1 do
	print(i)
end]]--

-- Focntion en lua
-- rmq : une fonction peut ne rien retourner
-- il faut tjr déclarer une fonction avant de faire l'appel a celle-ci
function mafonction(a, b)
	return a + b, (a + b)*2
end

r = mafonction(10, 5)

print (r)
print('\n')

--local b --asigner une case a une variable sans lui donner de valeur. 
--C'est comme la déclarer sans lui donner de val. 

-- les tables/tableaux commencent a 1
--On peut indexer une table avec une chaine de caractères
--[[t["test"] = 1
print(t[1])
print(t[2])
print(t[3])
print(t[4])]]--

function returntab(t)
	print(t)
	return t
end

t2 = {1, 3, 5, 7}
for i = 1, #t2, 1 do
	print(t2[i])
end

a = {}

-- On associe une valeur a une cle ("key")
a["number1"] = 1
a["number2"] = 2
a["number3"] = 3
a["number4"] = 4

for key, value in pairs(a) do
	print(key, value)
end