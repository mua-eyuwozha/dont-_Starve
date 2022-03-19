--表达式
--算术运算符：+(加)、-(减)、*(乘)、/(除)、^(幂)、%(取模/求余)、-(负号)
a = 1 + 2
print(a)

b = 2 - 1
print(b)

c = 2 * 4
print(c)

d = 6 / 3
print(d)
d = 4 / 3
print(d)--除不尽，会精确到小数点后多少位，具体没数

e = 2 ^ 3
print(e)

f = 5.3 % 4.1
print(f)

g = -4 
print(g)


--关系操作符：<、>、<=、>=、==、~=
a = {}
b = {}
a.x = 1 --a["x"]=1
a.y = 0
b.x = 1
b.y = 0
print(a == b)--false
--只有当两个变量同时引用同一个对象结果才会为真
--因为引用同一个对象时，所赋予给变量的地址是相同的，lua中比较的是地址，而不是对数据的比较
--a和b分别指向两个不同的引用，即所对应的地址不同，所以结果为false
--在python中仍然认为两者相等，所以python中比较的是数据而不是数据所对应的地址
--这个结论只对表有用，a，b同为数字10的时候，比较的结果还是true

a  = {}
b = a
a.x = 1
a.y = 0
print(a == b)--true

a = 'x'
b = 'y'
print(a > b)--false 
--字符串的比较是与之对应的ascii码进行比较


--逻辑操作符:and、or、not
--false和nil为假，其他为真
print(4 and 5)--lua中进行短路和求值,即当第一个值为真时，直接输出第二个值。当第一个值为假时，直接输出第一个值
print(4 or 5)--lua中进行短路或求值,即当第一个值为假时，直接输出第二个值。当第一个值为真时，直接输出第一个值
print(not 0)
print(not nil)


--字符串连接
print("hello" .. "world")
print(0 .. "1")--自动将0转换为字符串


--优先级
--[[
^
not、#、-(负号)
*、/、%
+、-
..
<、>、<=、>=、~=、==
and
or
--]]
a = 6 + 2^3
b = 6 + (2^3)
print(a)

--table构造式
--初始化
a = {"x","y"}
print(a[1],a[2])

a = {x=10,y=20}
--a[x] or a["x"]
print(a[x])--nil
print(a["x"])--10

--添加元素
a[1] = "hello"
print(a["x"] .. " " .. a["y"] .. " " .. a[1])

--使用表构造一个链表结构
--链表的每个元素由两部分组成。值和指向下一个元素地址的指针。
list = nil--定义首元素的指针为空
--之后的元素指针指向首元素，而不是从首元素开始指向下一个元素。...c-->b-->a。
for line in io.lines()--io.lines()输入框输入，输入的值赋值给line
do
	list = {next = list,value = line}
	--按ctrl+z退出循环，并继续执行下面的程序
end

local l = list--指向上面的最后一个元素
while l do--当l不为nil时将一直循环，直到line链表的首元素指针list为nil的时候终止循环
	print(l.value)
	l = l.next
end

--表中表
p = {color = "red",{x=0,y=1},name = "bag",{x=3,y=4}}
print(p[1].x)--print(p[1][x])
--没有键的值默认从1开始作为键，依次赋予后面没有键的值

--如何让表的下标从0开始
p = {[0] = 1,2,3,4,5}
print(p[1])










































