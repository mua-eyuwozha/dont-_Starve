--package.cpath = "C:/Users/pc/Desktop/?.so;"..package.cpath--�����ƶ�·������.so��β���ļ�
--package.path=[[C:\Users\pc\Desktop\��Ϸ\mod����\?.lua;]] .. package.path--cmd�޷�ʶ��utf-8��ת��ΪGB2312(unicode)����
--package.path=[[C:\Users\pc\Desktop\?.lua;]] .. package.path--����Ŀ¼,[[]]���Ա��ⷴб��ת��
--package.path = "C:/Users/pc/Desktop/?.lua;"..package.path--����Ŀ¼��ע��ʹ�õ�б�ܷ����෴
package.path = "D:/mod����/lua�����﷨/?.lua;"--ֻ������Ҫ��Ŀ¼
--require "test" --require("test")--ȡ�����еĴ���飬��#include�������ơ�����д�������ԡ�
--Ҳ���Ը�ֵ��������ͨ���������ִ�к���ʱ�����õ��ļ�����Ҫreturn ����
local file = require "test"
print(file("chenyifan"))--test.lua��Ҫreturn ����
print(funct(2,2,3))--���Բ�return����
xuu()--666
--ǰ����test�еĺ������Ǿֲ�����������Ǿֲ�������Ҫ���ã�����Ҫreturn �����ſ���ʹ�á�
--����ж��������Ҫreturn�����Խ���Щ�������Ϊһ����ͨ��������ٵ�����Ӧ�ĺ���

--Ҳ����ʹ��dofile�����������ļ�,�÷���require������ͬ
dofile([[D:\mod����\lua�����﷨\test.lua]])
m,l = funct(2,2,5)
print(m,l)


function func(n)
	print(string.format("%d lua",n))--ת��Ϊ�ַ��������һ�ָ�ʽ
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
	local i--����nil��falseΪ��������Ϊ��
	i = not 0--false
	i = not nil--true
	i = nil--nil
		print(i)
end

func3()

function fact(n)--�ݹ麯����ʹ�õ���ջ��ѹջ�͵�ջ��������ʹ���ڽϴ������
	if n == 1 then
		return 1
	else
		return n*fact(n-1)
	end
end
print("enter a number")
a = io.read("*number")--�ȴ���ȡ�û��������
print(fact(a))