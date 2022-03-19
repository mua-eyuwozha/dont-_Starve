--lua的基本数据类型
--nil--空类型
--无效值，没有任何有效值的类型


--boolean--布尔类型
--只有false和nil在lua中视为假，其他任何值则为真，包括""和0都为真


--number--数字类型
--可以表示任何32位整数和实数
--[[
a = 4.57e-3
print(a)--数学中等效于4.57*10^(-3)
--]]


--string--字符串类型
---[[
a = "one 1"--a = 'one 1'使用单引号和双引号都是可以的
--区别在于在双引号中使用单引号不需要使用转义符，即反斜杠。同理在单引号中使用双引号也是同样的
b = "one '1'"
c = 'one \'1\''
d = 'one "1"'
e = string.gsub(a,"one","two")--gsub函数,将a变量中有one的字符串的子串替换为two的字符串的子串
f = [["two 111"]]
--"[[]]"之间的也是字符串
print(a)
print(b)
print(c)
print(d)
print(e)
print(f)
--]]

--lua中的一些转义字符
--"\a"响铃
--"\b"退格符,将当前位置移到前一列
print("one\b1")
--"\f"换页符，将当前位置移到下页开头
--"\n"换行符，执行完光标显示在下一行再继续输出
print("one \nuu")
--[[
one
uu
--]]
--"\r"回车符，执行完光标显示在当前行的开头。\r后的字符会覆盖前面的字符
print("one1 \rfd")--fde1
--"\t"水平制表符
--"\v"垂直制表符
--"\0"空字符null,而非nil，写在其后的字符串也将为null
print("one\0two")
--"\97"		a的ascii码
--"\ddd"1到3位八进制数所代表的任意字符
--"\xhh"1到2位十六进制所代表的任意字符

print('10'+2)--12,lua会自动转换字符串为整数类型，不需要使用函数进行类型转换
print(10 .. 30)--1030，..连接整数，整数将自动转换为字符串类型，注意要空格

print(tonumber("10") == 10)--数字类型转换，将字符串转换为数字类型
print(tostring(10) == "10")--字符串类型转换，将数字类型转换为字符串类型

--#操作符，用于获得字符串的长度
a = "hello"
print(#a)
print("-----------------------------------------------------------------------------")

--userdata--用户自定义类型



--function--函数类型
function m(x,y)
	return x*y
end
print(m(2,3))

p = function (x,y)
	return x*y
end
k = p
print(p(2,3))
print(k(2,3))
print("-----------------------------------------------------------------------------")


--thread--线程类型

--table--表类型
--实现了关联数组，关联数组是一种具有特殊索引的数组，可以使用字符串或其他类型的值，除了nil来作为索引。
--表没有固定的大小，可以动态的添加任意的数量元素到一个table中。
--也通过table来完成模块、包、对象的。并且lua中的table类型是一个对象类型。
print("-----------------------------------------------------------------------------")
a = {}--全局变量，table类型
k = "x"
a[k] = 10
a[20] = "hello"
b = a[k]
print(a[k])
print(a["x"])
print(a[20])
a[k] = nil
print(b)--当a[k] = nil的时候，b打印出的值依然是10.这说明lua中没有指针的概念。即并不是b指向a[k]而是将a[k]中的地址赋值给了变量b
--所以当a[k]的值变为nil的时候，b的值却不会因a[k]的变化而变化
--注意：在lua中赋值给b的数字10是赋值的10这个数据在内存上的地址，而不是b在内存上重新开辟地址再存放一个10
--即a[k]和b对应同一个地址，a[k] = nil,是重新开辟一个区域存放值nil，a对应的地址发生改变。所以并不影响b 

c = {}
c[k] = 1000
d = c
c = nil
print(d)--结果：table。同样说明d是直接被赋予了一个表（c表所对应的地址），而不是指向c的指针
print(d[k])--相同的键和值也会连同赋予表时，赋予变量
d = nil
print(d)--这样才能彻底消除d的值

a1 = {}
for i = 1,1000
do
	a[i] = i * 2
end
a["x"] = 1000
print(a[100])
print(a["x"])
print(a["y"])--nil
print(a.x)--这种写法相当于x为一个字符串，来作为a这个表的键。和print(a["x"])是一样的。

e = {1,2,3,4,5}
for i = 1,#e--遍历e表中的所有元素(值)，而不是遍历e中的键
--lus中表的下标是从1开始，而不是从0开始
do
	print(e[i])
end

e[#e] = nil--删除表中的最后一个值
for i = 1,#e
do
	print(e[i])
end
--#e取得table类型的总数(长度)，其总数对应的表中最后一个值的键，e[#e] = nil即删除最后一个值。


--lua中将空值（空隙）作为认定表结尾的标志
--当一个表中有空值时，长度操作符会认为空隙处就是结尾，所以可能会产生一些错误或者意想不到的结果。
f = {1,2,3,4,5}
f[2] = nil
print(#f)--结果仍然为5
--这是因为nil没有被认定为null，注意两者的区分
f[7] = 7
print(#f)--此时结果仍然为5
--这就说明当长度检测到f[6]时，没有检测到值(有空隙)，就默认表结束了，从而导致了错误的结果。同时也说明#f在检测nil和空值时是不一样的。


--如何取table元素的最大一个下标
print(table.maxn(f))--此时可以取到最大小标不会因为空值而发生错误




























