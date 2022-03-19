prefabs = 
{
	"steel",
	--"soul",
	--格林之子
	"green_son",
	--快速凝聚
	"rapidcoagulation",
	--发光子宫
	"luminousuterus",
	--吸虫之巢
	"trematodenest",
	--易碎心脏
	"fragile_heart",
	--坚固心脏
	"strong_heart",
	--易碎贪婪
	"fragile_greedy",
	--坚固贪婪
	"strong_greedy",
	--易碎力量
	"fragile_damage",
	--坚固力量
	"strong_damage",
}

local function OnLoad(inst,data)
	if data then
		inst.maxhealth = data.loadmaxhealth
	end
end

local function OnSave(inst,data)
	return 
	{
		loadmaxhealth = inst.maxhealth,
	}
end

local function MakePrefab(name,func)
	local assets =
	{
		Asset("ANIM", "anim/"..name..".zip"),
		Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
		Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
	}
	local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("idle")

		inst.entity:SetPristine()
		inst:AddTag(name)
		if not TheWorld.ismastersim then
			return inst
		end

		--inst:AddTag("cattoy")

		inst:AddComponent("inspectable")
		inst:AddComponent("tradable")--可交易组件

		inst:AddComponent("named")
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name
		inst.components.inventoryitem.atlasname = "images/inventoryimages/" ..name.. ".xml"
		
		
		inst:AddComponent("stackable")
		
		--[[
		STACK_SIZE_LARGEITEM = 10,
		STACK_SIZE_MEDITEM = 20,
		STACK_SIZE_SMALLITEM = 40,
		STACK_SIZE_TINYITEM = 60,
		--]]
		if func ~= nil then
			func(inst)
		end
		MakeHauntableLaunch(inst)

		return inst
	end

	return Prefab(name, fn, assets,prefabs)
end
local function steelfn(inst)
	inst.components.named:SetName("陨铁")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM--堆叠数40
	
	return inst
end
local function soulfn(inst)
	inst.components.named:SetName("灵魂")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM--堆叠数40
	
	return inst
end
local function green_sonfn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst.components.named:SetName("格林之子")
	
	return inst
end
local function rapidcoagulationfn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst.components.named:SetName("快速凝聚")
	
	return inst
end
local function luminousuterusfn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst:AddComponent("rechargeable")
	inst.components.named:SetName("发光子宫")
	inst.components.rechargeable:SetRechargeTime(5)
	return inst
end
local function trematodenestfn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst.components.named:SetName("吸虫之巢")
	
	return inst
end
local function fragile_heartfn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst.maxhealth = 0
	inst.components.named:SetName("易碎心脏")
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	return inst
end
local function strong_heartfn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst.maxhealth = 0
	inst.components.named:SetName("坚固心脏")
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	return inst
end
local function fragile_greedyfn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst.components.named:SetName("易碎贪婪")
	return inst
end
local function strong_greedyfn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst.components.named:SetName("坚固贪婪")
	return inst
end
local function fragile_damagefn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst.components.named:SetName("易碎力量")
	return inst
end
local function strong_damagefn(inst)
	inst:AddTag("badge")
	if not TheWorld.ismastersim then
		return inst
	end
	inst.components.named:SetName("坚固力量")
	return inst
end
return MakePrefab("steel",steelfn),
		--MakePrefab("soul",soulfn),
		MakePrefab("green_son",green_sonfn),
		MakePrefab("rapidcoagulation",rapidcoagulationfn),
		MakePrefab("luminousuterus",luminousuterusfn),
		MakePrefab("trematodenest",trematodenestfn),
		MakePrefab("fragile_heart",fragile_heartfn),
		MakePrefab("strong_heart",strong_heartfn),
		MakePrefab("fragile_greedy",fragile_greedyfn),
		MakePrefab("strong_greedy",strong_greedyfn),
		MakePrefab("fragile_damage",fragile_damagefn),
		MakePrefab("strong_damage",strong_damagefn)
		
	   --Prefab("", fn, assets)
