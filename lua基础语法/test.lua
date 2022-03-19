function funct(a,b,c)
	sum = a+b+c
	d = 'x'
	print("I'm a function")
	return sum,d
end

--[[
a,b = funct(1,2,3)
print(a,b)
print(funct(1,2,3))
--require未赋值给变量时，可直接使用
--]]

--return funct--require赋值给变量时需返回函数

function xuu()
	print("666")
end

local function huuu(x)
	print(x .. "233")
end

return huuu

	