--表的遍历
--这其中有泛型for的无状态迭代器的应用
--遍历table中的值，忽略nil，k为其键或下标，v为其值
--并且有序的输出,是一种基于哈希算法的排序，并不完全有序。指定键值为数字时就无法有序排列
--for k,v in pairs(table) do

--end


--遍历table里第一个nil前没有键或未分配下标的值
--for i,v in ipairs(table) do

--end

t = {a = 100,10,20,[5] = 30,nil,nil,b = 200,"sss"}

for key,value in pairs(t) do
	print(key,value)
end

--[[
1       10
2       20
5       sss
a       100
b       200
--]]

for key,value in ipairs(t) do
	print(key,value)
end

--[[
1       10
2       20
--]]

t = {a = 100,10,20,[5] = 30,b = 200,"sss"}
for key,value in pairs(t) do
	print(key,value)
end
--rawget(t,k)
--返回t表里k键所对应的值

--rawset(t,k,v)
--将t表中k键对应的值设置成v

--table.concat (table [, sep [, start [, end]]]):
--concat是concatenate(连锁, 连接)的缩写. table.concat()函数列出参数中指定table的数组部分从start位置到end位置的所有元素, 元素间以指定的分隔符(sep)隔开

fruits = {"banana","orange","apple"}
-- 返回 table 连接后的字符串
print("连接后的字符串 ",table.concat(fruits))

-- 指定连接字符
print("连接后的字符串 ",table.concat(fruits,", "))

-- 指定索引来连接 table
print("连接后的字符串 ",table.concat(fruits,", ", 2,3))

--table.insert (table, [pos,] value):
--在table的数组部分指定位置(pos)插入值为value的一个元素. pos参数可选, 默认为数组部分末尾.


-- 在末尾插入
table.insert(fruits,"mango")
print("索引为 4 的元素为 ",fruits[4])

-- 在索引为 2 的键处插入
--并且不会覆盖原本2的值，而是插入位置后的元素先向后移动一位，再将插入的元素插入到指定位置上
table.insert(fruits,2,"grapes")
print("索引为 2 的元素为 ",fruits[2])


--table.remove (table [, pos])
--返回table数组部分位于pos位置的元素. 其后的元素会被前移. pos参数可选, 默认为table长度, 即从最后一个元素删起。

print("最后一个元素为 ",fruits[5])
table.remove(fruits)
print("移除后最后一个元素为 ",fruits[5])

--table.sort (table [, comp])
--对给定的table进行升序排序。

fruits = {"banana","orange","apple","grapes"}
print("排序前")
for k,v in ipairs(fruits) do
        print(k,v)
end

table.sort(fruits)
print("排序后")
for k,v in ipairs(fruits) do
        print(k,v)
end

--table.maxn()在lua5.2后已经移除，我们定义了 table_maxn 方法来实现。
--指定table中所有正数key值中最大的key值. 如果不存在key值为正数的元素, 则返回0。
function table_maxn(t)
  local mn=nil;
  for k, v in pairs(t) do
    if(mn==nil) then
      mn=v
    end
    if mn < v then
      mn = v
    end
  end
  return mn
end
tbl = {[1] = 2, [2] = 6, [3] = 34, [26] =5}
print("tbl 最大值：", table_maxn(tbl))
print("tbl 长度 ", #tbl)

--[[
注意：

当我们获取 table 的长度的时候无论是使用 # 还是 table.getn 其都会在索引中断的地方停止计数，而导致无法正确取得 table 的长度。

可以使用以下方法来代替：
--]]
function table_leng(t)
  local leng=0
  for k, v in pairs(t) do
    leng=leng+1
  end
  return leng;
end




--元表
--这是饥荒实现类的lua结构基础，元表的本质还是表，不过多了一些固定的特殊的键
--有两个重要的函数来处理元表：
--setmetatable(table,metatable)
	--将metatable表设置为table表的元表，并返回table，如果元表中存在__metatable键值，这个函数就会失效

--getmetatable(table)
	--返回table表的元素
	
--元表里有一些固定的有特殊意义的键，可缺省，如果将一个函数赋给特殊的键，称此函数为元函数
--__index
--当你通过键来访问table的时候，如果没有这个键，那么lua就会寻找该table的元表（如果有的话）中的__index键
--如果__index键对应的是一个表，lua会在该表中查找相应的键

a = {}
b = {}
c = {x = "123"}
setmetatable(a,b)
b.__index = c
print(a.x)--123

--如果__index键对应的值是一个函数，lua就会调用那个函数，table和键会作为两个参数传递给函数
b.__index = function(t,k)
	return k
end
print(a.y)--y
--[[
lua查找一个表元素时的规则，其实就是如下3个步骤：
1.在表中查找，如果找到，返回该元素，找不到则继续
2.判断该表是否有元表，如果没有元表，返回nil，有元表则继续
3.判断元表有没有__index方法，如果__index方法为nil，则返回nil；如果__index方法是一个表，则重复1、2、3；如果__index方法是一个函数，则返回该函数的返回值
--]]

--__newindex
--当你对table里的键赋值时，如果没有这个键，那么lua就会寻找该table的元表（如果有的话）中的__newindex键
--如果__newindex键对应的值是一个表，lua会在此表中新建一个键，然后赋值
--如果__newindex键对应的值是一个函数，lua就会调用那个函数，table和键和赋值会作为三个参数传递给函数
a = {}
b = {}
c = {}
setmetatable(a,b)
b.__newindex = c
a.x  = 233
print(c.x)--233

b.__newindex = function(t,k,v)
	rawset(t,k,v)
	--rawset设置值不会调用元函数，切忌递归
end
a.y = 233
print(a.y)

--__call
--当你将table名当函数一样使用时，那么lua就会寻找该table的元表（如果有的话）中的__call键。
--调用__call对应的函数，并相应传参，会默认将table作为第一个参数传进去，在设计对应函数的时候要预留这一个参数位
a = {}
b = {}
setmetatable(a,b)
b.__call = function(t)
	print("666")
end
a()--666

b.__call = function(t,p)
	print(p)
end
a("233")--233

--__tostring
--当你print一个表时，那么lua就会寻找该table的元表（如果有的话）中的__tostring键。会调用__tostring键对应的函数，并print返回值
a = {}
b = {}
setmetatable(a,b)
b.__tostring = function()
	return "2333"
end
print(a)--2333
