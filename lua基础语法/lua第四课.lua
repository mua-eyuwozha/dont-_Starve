function test()
--arg程序列表
--在cmd中执行的.lua为arg[0],在其之前的命令依次赋值给arg[-1],arg[-2]...,在其之后的命令则赋值给arg[1],arg[2]...
--如果前后没有值，则为nil
--eg：lua -l "test" lua第四课.lua a b
--[[
I'm a function
6       x
I'm a function
6       x
arg[-3]=        lua
arg[-2]=        -l
arg[-1]=        test
arg[0]= lua第四课.lua
arg[1]= a
arg[2]= b
--]]
--eg：lua -l "test" lua第四课.lua
--[[
I'm a function
6       x
I'm a function
6       x
arg[-3]=        lua
arg[-2]=        -l
arg[-1]=        test
arg[0]= lua第四课.lua
arg[1]= nil
arg[2]= nil
--]]
	print("arg[-3]=",arg[-3])
	print("arg[-2]=",arg[-2])
	print("arg[-1]=",arg[-1])
	print("arg[0]=",arg[0])
	print("arg[1]=",arg[1])
	print("arg[2]=",arg[2])
end
test()