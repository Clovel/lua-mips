--[[
	hw_alucontrol.lua
]]--

function AluControl()
	local r = "000"
	if aluop == "000" then
	    r = "010"  --lw/sw sont des instructions qui ont besoin que l'addition fasse une addition
	
	elseif aluop == "01" then
		r = "110"  --beq -> sub

	elseif aluop == "10" then
	    if funct == "100000" then -- R-type (add)
	        r = "010"
	    end
	    if funct == "100010" then -- R-type (sub)
	        r = "110"
	   	end
	    if funct == "100100" then -- R-type (and)
	        r = "000"
	   	end
	    if funct == "100101" then -- R-type (or)   
	        r = "001"
	   	end
	end
end