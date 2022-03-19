--��ı���
--�������з���for����״̬��������Ӧ��
--����table�е�ֵ������nil��kΪ������±꣬vΪ��ֵ
--������������,��һ�ֻ��ڹ�ϣ�㷨�����򣬲�����ȫ����ָ����ֵΪ����ʱ���޷���������
--for k,v in pairs(table) do

--end


--����table���һ��nilǰû�м���δ�����±��ֵ
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
--����t����k������Ӧ��ֵ

--rawset(t,k,v)
--��t����k����Ӧ��ֵ���ó�v

--table.concat (table [, sep [, start [, end]]]):
--concat��concatenate(����, ����)����д. table.concat()�����г�������ָ��table�����鲿�ִ�startλ�õ�endλ�õ�����Ԫ��, Ԫ�ؼ���ָ���ķָ���(sep)����

fruits = {"banana","orange","apple"}
-- ���� table ���Ӻ���ַ���
print("���Ӻ���ַ��� ",table.concat(fruits))

-- ָ�������ַ�
print("���Ӻ���ַ��� ",table.concat(fruits,", "))

-- ָ������������ table
print("���Ӻ���ַ��� ",table.concat(fruits,", ", 2,3))

--table.insert (table, [pos,] value):
--��table�����鲿��ָ��λ��(pos)����ֵΪvalue��һ��Ԫ��. pos������ѡ, Ĭ��Ϊ���鲿��ĩβ.


-- ��ĩβ����
table.insert(fruits,"mango")
print("����Ϊ 4 ��Ԫ��Ϊ ",fruits[4])

-- ������Ϊ 2 �ļ�������
--���Ҳ��Ḳ��ԭ��2��ֵ�����ǲ���λ�ú��Ԫ��������ƶ�һλ���ٽ������Ԫ�ز��뵽ָ��λ����
table.insert(fruits,2,"grapes")
print("����Ϊ 2 ��Ԫ��Ϊ ",fruits[2])


--table.remove (table [, pos])
--����table���鲿��λ��posλ�õ�Ԫ��. ����Ԫ�ػᱻǰ��. pos������ѡ, Ĭ��Ϊtable����, �������һ��Ԫ��ɾ��

print("���һ��Ԫ��Ϊ ",fruits[5])
table.remove(fruits)
print("�Ƴ������һ��Ԫ��Ϊ ",fruits[5])

--table.sort (table [, comp])
--�Ը�����table������������

fruits = {"banana","orange","apple","grapes"}
print("����ǰ")
for k,v in ipairs(fruits) do
        print(k,v)
end

table.sort(fruits)
print("�����")
for k,v in ipairs(fruits) do
        print(k,v)
end

--table.maxn()��lua5.2���Ѿ��Ƴ������Ƕ����� table_maxn ������ʵ�֡�
--ָ��table����������keyֵ������keyֵ. ���������keyֵΪ������Ԫ��, �򷵻�0��
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
print("tbl ���ֵ��", table_maxn(tbl))
print("tbl ���� ", #tbl)

--[[
ע�⣺

�����ǻ�ȡ table �ĳ��ȵ�ʱ��������ʹ�� # ���� table.getn �䶼���������жϵĵط�ֹͣ�������������޷���ȷȡ�� table �ĳ��ȡ�

����ʹ�����·��������棺
--]]
function table_leng(t)
  local leng=0
  for k, v in pairs(t) do
    leng=leng+1
  end
  return leng;
end




--Ԫ��
--���Ǽ���ʵ�����lua�ṹ������Ԫ��ı��ʻ��Ǳ���������һЩ�̶�������ļ�
--��������Ҫ�ĺ���������Ԫ��
--setmetatable(table,metatable)
	--��metatable������Ϊtable���Ԫ��������table�����Ԫ���д���__metatable��ֵ����������ͻ�ʧЧ

--getmetatable(table)
	--����table���Ԫ��
	
--Ԫ������һЩ�̶�������������ļ�����ȱʡ�������һ��������������ļ����ƴ˺���ΪԪ����
--__index
--����ͨ����������table��ʱ�����û�����������ôlua�ͻ�Ѱ�Ҹ�table��Ԫ������еĻ����е�__index��
--���__index����Ӧ����һ����lua���ڸñ��в�����Ӧ�ļ�

a = {}
b = {}
c = {x = "123"}
setmetatable(a,b)
b.__index = c
print(a.x)--123

--���__index����Ӧ��ֵ��һ��������lua�ͻ�����Ǹ�������table�ͼ�����Ϊ�����������ݸ�����
b.__index = function(t,k)
	return k
end
print(a.y)--y
--[[
lua����һ����Ԫ��ʱ�Ĺ�����ʵ��������3�����裺
1.�ڱ��в��ң�����ҵ������ظ�Ԫ�أ��Ҳ��������
2.�жϸñ��Ƿ���Ԫ�����û��Ԫ������nil����Ԫ�������
3.�ж�Ԫ����û��__index���������__index����Ϊnil���򷵻�nil�����__index������һ�������ظ�1��2��3�����__index������һ���������򷵻ظú����ķ���ֵ
--]]

--__newindex
--�����table��ļ���ֵʱ�����û�����������ôlua�ͻ�Ѱ�Ҹ�table��Ԫ������еĻ����е�__newindex��
--���__newindex����Ӧ��ֵ��һ����lua���ڴ˱����½�һ������Ȼ��ֵ
--���__newindex����Ӧ��ֵ��һ��������lua�ͻ�����Ǹ�������table�ͼ��͸�ֵ����Ϊ�����������ݸ�����
a = {}
b = {}
c = {}
setmetatable(a,b)
b.__newindex = c
a.x  = 233
print(c.x)--233

b.__newindex = function(t,k,v)
	rawset(t,k,v)
	--rawset����ֵ�������Ԫ�������мɵݹ�
end
a.y = 233
print(a.y)

--__call
--���㽫table��������һ��ʹ��ʱ����ôlua�ͻ�Ѱ�Ҹ�table��Ԫ������еĻ����е�__call����
--����__call��Ӧ�ĺ���������Ӧ���Σ���Ĭ�Ͻ�table��Ϊ��һ����������ȥ������ƶ�Ӧ������ʱ��ҪԤ����һ������λ
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
--����printһ����ʱ����ôlua�ͻ�Ѱ�Ҹ�table��Ԫ������еĻ����е�__tostring���������__tostring����Ӧ�ĺ�������print����ֵ
a = {}
b = {}
setmetatable(a,b)
b.__tostring = function()
	return "2333"
end
print(a)--2333
