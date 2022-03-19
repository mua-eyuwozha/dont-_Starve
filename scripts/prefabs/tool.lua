--工具
--贝爷的小刀
local assets =
{
	Asset("ANIM", "anim/tool.zip"),
	Asset("ANIM", "anim/swap_tool.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_tool.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_tool.tex"),
}

prefabs =
{
	"tool",
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tool", "swap_tool")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end


local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

--耐久为零，物品消失函数:雨伞，不知是否有普遍使用性
local function onperish(inst)
    local equippable = inst.components.equippable
    if equippable ~= nil and equippable:IsEquipped() then
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        if owner ~= nil then
            local data =
            {
                prefab = inst.prefab,
                equipslot = equippable.equipslot,
            }
            inst:Remove()
            owner:PushEvent("umbrellaranout", data)
            return
        end
    end
    inst:Remove()
end

local function changemonster(inst)
	if inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner ~= nil then
        inst.components.inventoryitem.owner:PushEvent("toolbroke", { tool = inst })
    end

    inst:Remove()
	--生成一个怪物
end

local function fn(name,icon_name) 
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	
	MakeInventoryPhysics(inst)
	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddTag("nopunch") -- 添加标签不用拳头，可以让人物在持有雨伞攻击时不是用拳头攻击，
	--而是类似持有武器的高频攻击。当一个物品不具备武器组件的时候，
	--就可以通过这种方式让人物在装备该物品时能做出武器攻击的动作
	
	inst:AddComponent("tradable")
	
	inst.AnimState:SetBank(name)
	inst.AnimState:SetBuild(name)
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddComponent("tool")--工具组件
	
	inst:AddComponent("named")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = icon_name
    inst.components.inventoryitem.atlasname = "images/inventoryimages/" ..icon_name.. ".xml" 
	
	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	MakeHauntableLaunch(inst)
	
	
	return inst
end

local function toolfn()
	local inst = fn("tool","icon_tool")
	if not TheWorld.ismastersim then
        return inst
    end
    inst.components.tool:SetAction(ACTIONS.CHOP, TUNING.MOONGLASSAXE.EFFECTIVENESS)--设置一个动作,砍树,后面的参数为速度
	
	inst.components.tool:SetAction(ACTIONS.MINE, 1)--镐子
	
    inst.components.tool:SetAction(ACTIONS.DIG, 1)--铲子
	
	inst.components.tool:SetAction(ACTIONS.HAMMER, 1)--锤子
	
	inst.components.tool:SetAction(ACTIONS.NET, 1)--网兜
	

	
	inst:AddComponent("farmtiller")--园艺锄，使用的就是一个挖掘机组件完成的
	inst:AddInherentAction(ACTIONS.TILL)--猜测本意是使下面的语句可以生效，但实际不加也可以，不知道是否会有bug
	--inst.components.finiteuses:SetConsumption(ACTIONS.TILL, 1)--设置园艺锄使用消耗耐久，一次消耗1点耐久
	
	inst.components.named:SetName("万能工具")
	
	--[[腐烂的耐久组件,像花伞那样
	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.GRASS_UMBRELLA_PERISHTIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(onperish)--耐久为零执行operish函数
	inst:AddTag("show_spoilage")--显示损坏
	--]]
	
	
	return inst
end

return Prefab("tool", toolfn,assets,prefabs)