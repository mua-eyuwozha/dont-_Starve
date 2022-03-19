--package.cpath = "C:/Users/pc/Desktop/?.so;"..package.cpath--搜索制定路径下以.so结尾的文件
--package.path=[[C:\Users\pc\Desktop\游戏\mod制作\?.lua;]] .. package.path--cmd无法识别utf-8，转换为GB2312(unicode)即可
--package.path=[[C:\Users\pc\Desktop\?.lua;]] .. package.path--增加目录,[[]]可以避免反斜杠转义
--package.path = "C:/Users/pc/Desktop/?.lua;"..package.path--增加目录，注意使用的斜杠方向相反
package.path = "D:/mod制作/lua基础语法/?.lua;"--只加载想要的目录
--require "test" --require("test")--取用其中的代码块，与#include作用类似。两种写法都可以。
--也可以赋值给变量，通过这个变量执行函数时，调用的文件中需要return 函数
local file = require "test"
print(file("chenyifan"))--test.lua需要return 函数
print(funct(2,2,3))--可以不return函数
xuu()--666
--前提是test中的函数不是局部函数，如果是局部函数想要调用，就需要return 函数才可以使用。
--如果有多个函数需要return，可以将这些函数打包为一个表，通过这个表再调用相应的函数

--也可以使用dofile来调用其他文件,用法与require有所不同
dofile([[D:\mod制作\lua基础语法\test.lua]])
m,l = funct(2,2,5)
print(m,l)


function func(n)
	print(string.format("%d lua",n))--转化为字符串输出的一种格式
	return string.format("%d lua",n)
end

func(5)
print(func(7))

function func1(m)
	if m ~= 0 then
		print("good")
	end
end

func1(3)

function func2(m)
	local i = m ~= 0
		print(i)
end

func2(0)--false
func2(3)--true

function func3()
	local i--除了nil和false为假其他都为真
	i = not 0--false
	i = not nil--true
	i = nil--nil
		print(i)
end

func3()

function fact(n)--递归函数，使用的是栈的压栈和弹栈，不建议使用在较大的数中
	if n == 1 then
		return 1
	else
		return n*fact(n-1)
	end
end
print("enter a number")
a = io.read("*number")--等待读取用户输入的数
print(fact(a))