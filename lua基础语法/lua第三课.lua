--语句块可以分为一条语句，多条语句（do end来开始和结束），一个文件。
do --多条语句的语句块
	print("1")
	print("2")
	print("1");
	print("2");
	print("1") print("2")--三种分隔方式都是可以的，输出也完全一样。不加分号/加分号/空格
end

--lua的交互命令
--在cmd中输入lua -i ?.lua可以在执行完lua文件后自动进入lua交互模式，而不是退出lua程序。eg：lua -i -l "lua第二课" -e "b = 3 print(b)"
--[[
Lua 5.1.5  Copyright (C) 1994-2012 Lua.org, PUC-Rio
I'm a function
6       x
I'm a function
6       x
I'm a function
9       x
5 lua
7 lua
7 lua
good
false
true
nil
enter a number
3
6
3
> >
--]]

--使用os.exit()退出lua交互模式
--"-e"直接运行后面的代码块，eg：lua -e "a=1 print(a)"-->结果为1

--"-l"先运行文件，在文件后可以增加其他命令。eg：lua -l "lua第二课" -e "b = 3 print(b)"-->结果会输出lua第二课.lua和3
--[[
I'm a function
6       x
I'm a function
6       x
I'm a function
9       x
5 lua
7 lua
7 lua
good
false
true
nil
enter a number
2
2
3
--]]

--标识符可以以字母数字及下划线组成，但不可以数字为开头
--_VERSION以下划线开头大写字母构成，一般为哑变量，是一种保留的标识符。用于一些固定的变量，用户不要自己声明这样的标识符

--lua的保留字
and break do else elseif
end false for function if
in local nil not or 
repeat return then true until while

--为行注释符
--[[
	为多行注释符(块注释符)
--]]
--写成(]])也是可以的，但是前面的"--[["如果改为下面"---[["则"]]"将不再是注释行，所以多行注释的时候还是选择--]]

---[[多加一个-当前行改为注释，中间的部分却仍可以运行
	print("a")
--]]

a = 1
print(a)
do
	print(a)
	local a = 2
	print(a)
end
print(a)