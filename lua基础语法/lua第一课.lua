print("hello Don\'t starve")
a="string"--字符串类型，自动赋予类型，全局变量(成员变量)
b=2.10--自动赋予浮点数类型?
c={"a",b,{},func}--table表的数据类型，每一个表都有一个单一的项组成

function func(n)
	for i = 1,n do
		print("I love Don\'t Starve for "..tostring(i).." time")--将数字转换成字符串类型再连接字符串类型才可以输出。所以这里使用lua自带的函数tostring()进行类型转换。lua连接字符串使用“..”进行连接，不是常用的“+”
	end
end

local j = 0--局部变量
while j<10 do
	j=j+1
	print(j)
end

func(5)
func(20)

do
	local d=.2--local强调这个变量是有一个作用域的，作用域即do和end之间的范围。可以理解为局部变量。而前面的a,b都可以理解为成员变量。
	print(d)
end
print(d)--结果：nil。意思是没有这个值，为空值?

t={["key"]="value","value2",["key3"]="value3",[2]=2,[3]=3,5}--["key"]为键,冒号后面的为值
--指定了键的值存储在键中，没有指定的值："value"就是从数1开始往后赋值，[2]就是赋值给数字2，[3]就是赋值给数字3
--最后的5也没有指定，2先赋值给了[2]，后来再赋值给5，所以最后显示的[2]的位置为5.
--lua的遍历顺序使用的是哈希算法，而非按照数字有序的排列。
for k,v in pairs(t) do
	print(k..":"..v)
end

print(t["key"])

y={["key"]="value","value2",["key3"]="value3",func,{1,2,3,4,["key5"]="5"}}--表中也可以存放函数
y[2](5)--如何在表中使用函数
print(y[3][2])--也可以在表中嵌套一个表
print(y[3]["key5"])

_G.item = {}--会将所有的全局变量挂载到这个表中，注意使用_G
print(item)--暂时没有成功，等成功再做修改

a = nil--将变量回收，清理，删除