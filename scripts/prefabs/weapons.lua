local assets1 =
{
    Asset("ANIM", "anim/awaken.zip"),  --地上的动画
    Asset("ANIM", "anim/swap_awaken.zip"), --手里的动画
	Asset("ATLAS", "images/inventoryimages/icon_awaken.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/icon_awaken.tex"), --物品栏贴图文件
}
---[[
local assets2 = 
{
	Asset("ANIM", "anim/dark.zip"),
	Asset("ANIM", "anim/swap_dark.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_dark.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_dark.tex"),
}
--]]
--[[
local assets3 = 
{
	Asset("ANIM", "anim/shine.zip"),
	Asset("ANIM", "anim/swap_shine.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_shine.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_shine.tex"),
}
--]]
local assets4 = 
{
	Asset("ANIM", "anim/quake.zip"),
	Asset("ANIM", "anim/swap_quake.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_quake.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_quake.tex"),
}

local assets5 = 
{
	Asset("ANIM", "anim/duron.zip"),
	Asset("ANIM", "anim/swap_duron.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_duron.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_duron.tex"),
}
local assets6 = 
{
	Asset("ANIM", "anim/bonenail1.zip"),
	Asset("ANIM", "anim/swap_bonenail1.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_bonenail1.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_bonenail1.tex"),
}
local assets7 = 
{
	Asset("ANIM", "anim/bonenail2.zip"),
	Asset("ANIM", "anim/swap_bonenail2.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_bonenail2.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_bonenail2.tex"),
}
local assets8 = 
{
	Asset("ANIM", "anim/bonenail3.zip"),
	Asset("ANIM", "anim/swap_bonenail3.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_bonenail3.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_bonenail3.tex"),
}
local assets9 = 
{
	Asset("ANIM", "anim/bonenail4.zip"),
	Asset("ANIM", "anim/swap_bonenail4.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_bonenail4.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_bonenail4.tex"),
}
local assets10 = 
{
	Asset("ANIM", "anim/bonenail5.zip"),
	Asset("ANIM", "anim/swap_bonenail5.zip"),
    Asset("ATLAS", "images/inventoryimages/icon_bonenail5.xml"),
    Asset("IMAGE", "images/inventoryimages/icon_bonenail5.tex"),
}
prefabs = {
	"wurt_tentacle_warning",
	"awaken",
	"dark",
	"quake",
	"duron",
	"bonenail1",
	"bonenail2",
	"bonenail3",
	"bonenail4",
	"bonenail5",
	--[[
	"shine",
	--]]
}
-- local fxassets =
-- {
	-- Asset("ANIM", "anim/lavaarena_battlestandard.zip"),
-- }

--[[
--获取等级事件人身上是否有某件物品，有则赋值给items，从而拿到这个实体
local function s()
	local items = inst:ListenForEvent("levels", function(owner, data) 
		if owner and data and data.owner.components.inventory then
			local items = data.owner.components.inventory:FindItem(function(item)
				if item == "awaken" then
					return true
				end
			end)
			return items
		end
	end, owner)
end
--]]
--begin 装备--
local function onequip(inst, owner) --装备
    owner.AnimState:OverrideSymbol("swap_object","swap_awaken","swap_awaken")
								--替换的动画部件	使用的动画	替换的文件夹（注意这里也是文件夹的名字）
	--inst.components.myth_itemskin:OverrideSymbol(owner, "swap_object")--更换皮肤
    owner.AnimState:Show("ARM_carry")-- 显示持物手
    owner.AnimState:Hide("ARM_normal") -- -- 隐藏普通手
	
	inst.components.combat.bonusdamagefn = all_function.bonusdamagefn(TUNING.AWAKEN_DAMAGE,.05,1.5)
	
	if frequency == 1 then
		TheNet:Announce("[ " .. owner.name .. " ]永恒之王拿起了" .. announce_name)
		frequency = frequency + 1
	end
end

local function onunequip(inst, owner) --解除装备
    owner.AnimState:Hide("ARM_carry") -- 隐藏持物手
    owner.AnimState:Show("ARM_normal") -- 显示普通手
	
	inst.components.combat.bonusdamagefn = TUNING.AWAKEN_DAMAGE
	
	if frequency == 2 then
		TheNet:Announce("[ " .. owner.name .. " ]永恒之王放下了" .. announce_name)
		frequency = frequency + 1
	end
end
--end 装备--

--[[播放声音
local function DoMountSound(inst, mount, sound, ispredicted)
	if mount ~= nil and mount.sounds ~= nil then
		inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, ispredicted)
	end
end
--]]
 
local function builder_onbuilt(inst,builder)
	if builder then
		inst.userid = builder.userid
		inst.components.level:GiveUserid(inst.userid)
	end
end

local function SpawnIceFx(inst,attacker,target)  --巨鹿技能
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
    local numFX = math.random(10,20)--随机在[10,20]取一个整数,
	--在lua沿用的c语言语法中math.random随机结果因算法的缘故,一直有着固定结果的问题,俗称伪随机数。
	--导致其结果的第一个数必定是10保持不变，从而导致了类似赋值等只执行一次的随机效果的失效
	--但在饥荒中或者其他ide软件中这一问题被修复,修改了算法导致原来的伪随机,在某种意义上变得更贴近真正的随机。
	--但仍然称之为伪随机,并不是真正意义上的随机
	--所以lua中新增math.randomseed这个函数通过os.time系统时间的量来达到相对更真实的随机。但同样存在，极端时间内
	--系统时间还没来记得改变的时候，随机出的结果均为同一个值。
	--这个问题始于random根本算法的问题，即使是math.random不传参数也一样是固定结果，所以即便是java或者c中也一样无法解决
    local pos = inst:GetPosition()
    local targetPos = target and target:GetPosition()
    local vec = targetPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())--指向目标的角度

    for i = 1, numFX do
        inst:DoTaskInTime(math.random() * 0.25, function(inst)
            local prefab = "icespike_fx_"..math.random(1,4)
            local fx = SpawnPrefab(prefab)
            if fx then
                local x = GetRandomWithVariance(0, 3)--随机获得方差
                local z = GetRandomWithVariance(0, 3)
                local offset = (vec * math.random(dist * 0.25, dist)) + Vector3(x,0,z)
                fx.Transform:SetPosition((offset+pos):Get())
                local x,y,z = fx.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 1,nil,{"player"},nil)
		
				for k,v in pairs(ents) do
					local health = v.components.health
					local combat = v.components.combat
					local freezable = v.components.freezable
					if v and health and not health:IsDead() and combat and v ~= inst and
                        not (v.components.follower and v.components.follower.leader == inst ) and 
                        (TheNet:GetPVPEnabled() or not v:HasTag("player")) then
						combat:GetAttacked(attacker, 35,inst) -- 第一个参数攻击者改为fx就变成每个冰锥造成伤害
						--会过于容易冰冻目标
						if freezable then
							freezable:AddColdness(3)
							freezable:SpawnShatterFX()
						end
					end
				end
            end
        end)
    end
end

--[[
local function JX(inst)

	local redsword_jx = SpawnPrefab("redsword_jx")
	local container = inst.components.inventoryitem:GetContainer()
	if container ~= nil then
		local slot = inst.components.inventoryitem:GetSlotNum()
		inst:Remove()
		container:GiveItem(redsword_jx, slot)
	else
		local x, y, z = inst.Transform:GetWorldPosition()
		inst:Remove()
		redsword_jx.Transform:SetPosition(x, y, z)
	end

end
--]]

local function hollow_knight(inst,owner,target,damage)
	local equip = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if equip and equip:HasTag("hollow_knight") then
		local slots = inst.components.container.slots
		if slots then
			for k,v in pairs(slots) do
				for i,j in pairs(knight_function) do
					if v:HasTag("fragile_heart") then
						print("lll")
						j(inst,owner,target,v)
					end
				end
			end
		end
		--[[
		if inst.components.container:IsFull() then
		
		end
		--]]
	end
end

local function hollow_attack(inst,attacker,target)
	local fragile = inst.components.container:FindItem(function(item)
		if item:HasTag("fragile_heart") then
			return true
		end
	end)
	local strong = inst.components.container:FindItem(function(item)
		if item:HasTag("strong_heart") then
			return true
		end
	end)
	if fragile and strong then
		if target.components.health:IsDead() and target:HasTag("epic") and strong.maxhealth < 100 then
			strong.maxhealth = strong.maxhealth + 1
			attacker.components.health:SetMaxHealth(attacker.components.health.maxhealth + 1)
		end
	elseif fragile then
		if target.components.health:IsDead() and target:HasTag("epic") and fragile.maxhealth < 50 then
			fragile.maxhealth = fragile.maxhealth + 1
			attacker.components.health:SetMaxHealth(attacker.components.health.maxhealth + 1)
		end
	elseif strong then
		if target.components.health:IsDead() and target:HasTag("epic") and strong.maxhealth < 100 then
			strong.maxhealth = strong.maxhealth + 1
			attacker.components.health:SetMaxHealth(attacker.components.health.maxhealth + 1)
		end
	end
	local fragile1 = inst.components.container:FindItem(function(item)
		if item:HasTag("fragile_greedy") then
			return true
		end
	end)
	local strong1 = inst.components.container:FindItem(function(item)
		if item:HasTag("strong_greedy") then
			return true
		end
	end)
	if strong1 then
		if math.random < .05 and target.components.health:IsDead() then
			if attacker.components.inventory then
				attacker.components.inventory:GiveItem("pig_coin")
			end
		end
	elseif fragile1 then
		if math.random < .1 and target.components.health:IsDead() then
			if attacker.components.inventory then
				attacker.components.inventory:GiveItem("pig_coin")
			end
		end
	end
end

local function onattack(inst, attacker, target)
	attacker.SoundEmitter:PlaySound("error/fight/fight", nil, 0.7) -- 攻击音效
	
	--[[
	inst.components.equippable:Equip(attacker,nil)--equip中会执行setonequip函数,所有不可以写在setonequip函数中，否则会递归
	inst:ListenForEvent("equipped", function(inst,data)
		--data.owner.AnimState:FastForward(1.2,"atk")--快进
	end) -- 监听上述事件,并执行函数
	
	--inst:RemoveEventCallback("equipped")

	--]]
	--给实体增加移速和攻击
	--v.components.combat.externaldamagemultipliers:SetModifier("mk_battle_flag", 1.15) 
	--v.components.locomotor:SetExternalSpeedMultiplier(v, "mk_battle_flag", 1.15)
	--[[
	if not v.components.locomotor._externalspeedmultipliers["mk_battle_flag"] then
		v.components.locomotor:SetExternalSpeedMultiplier(v, "mk_battle_flag", 1.15)
	end
	if not v.components.combat.externaldamagemultipliers._modifiers["mk_battle_flag"] then
		v.components.combat.externaldamagemultipliers:SetModifier("mk_battle_flag", 1.15)
	end
	--]]
	-- if lock > 1 then	
		-- owner.components.talker:Say("恭喜你已经解锁全部技能!")
		-- owner.SoundEmitter:PlaySound("dontstarve/rain/thunder_close")
		-- --JX(inst)
	-- end
	--splash_snow_fx
	local fx = SpawnPrefab("firesplash_fx")
	fx.Transform:SetPosition( target.Transform:GetWorldPosition() )
	fx.Transform:SetScale( 1.5, 1.5, 1.5 )
	local tb = all_function.matching()
	
	if not target:IsValid() then--如果目标无效
		return
	end
	
	if not target.hit then
		target.hit = 1
	elseif target.hit == 5 then
		attacker.components.hunger:DoDelta(-2) -- 饥饿值减2
		if attacker and tb and tb.lock > 1 then
			--当san值低于30%的时候,回复2点san值
			if attacker.components.sanity and attacker.components.sanity:GetPercent() < 0.3 and not target:HasTag("wall") then
				attacker.components.sanity:DoDelta(1)
			end
			if inst and tb.lock > 2 then 
				--[[
				--local death_kill_ground = SpawnPrefab("explosivehit")--添加金色爆炸特效moonpulse2_fx
				local death_kill_ground = SpawnPrefab("moonpulse2_fx")
				death_kill_ground.Transform:SetPosition( target.Transform:GetWorldPosition() )
				death_kill_ground.Transform:SetScale( 1.5, 1.5, 1.5 )
				--]]
				all_function.targethp(inst, attacker, target,2)
				all_function.ownerhp(inst, attacker, target,-2)
				if inst and tb.lock > 3 then
					local ok = math.random()
					if not target:HasTag("shadowchesspiece") then
						if ok < 0.01 then 
							all_function.makebaby(inst, attacker,"shadow_knight")
							all_function.makebaby(inst, attacker,"shadow_rook")
							all_function.makebaby(inst, attacker,"shadow_bishop")
							attacker.components.talker:Say("Come On!\r\nBaby大狂欢!")
						elseif 0.01 < ok and ok < 0.10 then
							local baby = all_function.randomchoice("shadow_knight","shadow_rook","shadow_bishop","gnarwail","shark")
							all_function.makebaby(inst, attacker,baby)
							attacker.components.talker:Say("我可没有说他是你的小Baby哟!")
						end
					end
					if inst and tb.lock > 4 then	
						SpawnIceFx(inst, target,attacker)
					end
				end
			end
		end
		
		target.hit = 0
	else
		target.hit = target.hit + 1
	end
end

local function gaswave(inst,attacker,target) -- 顺序不可以改变！！！
	if math.random() < 0.05 then -- 对自己造成掏心伤害
		local fx = SpawnPrefab("statue_transition")
		local x, y, z = attacker.Transform:GetWorldPosition()
		local time = 0.3
		fx.Transform:SetPosition(x, y, z)
		for k = 1,3 do 
			inst:DoTaskInTime(time*k, function() -- 当前计时可以造成三次伤害，共60点
				attacker.components.combat:GetAttacked(target, 20, inst)
			end)
		end
	end
	
	if target then
		-- 如果获得某件物品则执行下面的语句
		if math.random() < 0.05 then -- 对单个敌人造成掏心伤害
			local fx = SpawnPrefab("statue_transition")
			local x, y, z = target.Transform:GetWorldPosition()
			local time = 0.3
			fx.Transform:SetPosition(x, y, z)
			for k = 1,3 do 
				inst:DoTaskInTime(time*k, function() -- 当前计时可以造成三次伤害，共60点
					target.components.combat:GetAttacked(attacker, 20, inst)
				end)
			end
		end
		if math.random() < 0.5 then-- 对范围内所有敌人造成掏心伤害
			local x, y, z = target.Transform:GetWorldPosition() -- target
			local ents = TheSim:FindEntities(x, y, z, 6,nil,{"player","follower"},nil)
			local time = 0.15
			for k,v in pairs(ents) do
				local fx = SpawnPrefab("statue_transition")
				local health = v.components.health
				local combat = v.components.combat
				local px, py, pz = v.Transform:GetWorldPosition()
				if v and health and not health:IsDead() and combat and v ~= inst and
					not (v.components.follower and v.components.follower.leader == inst ) and 
					(TheNet:GetPVPEnabled() or not v:HasTag("player")) then
					fx.Transform:SetPosition(px, py, pz)
					for k = 1,3 do
						inst:DoTaskInTime(time*k, function()
							combat:GetAttacked(attacker, 20, inst)
						end)
					end
				end
			end
		end
	end
end

local function MakeBaby(inst,attacker, target)
	if not target:IsValid() then--如果目标无效
		return
	end
	if not target.hit then
		target.hit = 1
	elseif target.hit == 5 then
		all_function.makebaby(inst, attacker,"pigman")
		attacker.components.talker:Say("召唤猪哥")
		SpawnIceFx(inst,attacker, target)
		target.hit = 0
	else
		target.hit = target.hit + 1
	end
end

local function OnBuff(inst)
	inst.addbuff = {}
	if prefab == "lostumbrella" then
		inst.buffs = inst:DoPeriodicTask(0.5, function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x,y,z,10,{"player"})
			for k,v in pairs(ents) do
				if v and v.components.health  and v.components.combat and v.components.locomotor then 
					if inst.addbuff[v] == nil then
						if not v.components.health:IsDead() then 
							inst.addbuff[v] = v
							if not v.fx then
								v.fx = SpawnPrefab("flower_fx")
								v.fx.entity:SetParent(v.entity)
								--[[
								local fx = SpawnPrefab("flower_fx")
								fx.Transform:SetPosition( v.Transform:GetWorldPosition() )
								fx.Transform:SetScale( 1.5, 1.5, 1.5 )
								--v.fx.entity:SetParent(v.entity)
								--]]
							end
						end
					end
				end
			end
			if inst.addbuff then
				for k, v in pairs(inst.addbuff) do
					if  v  and v:IsValid() and v.components.health  and v.components.combat and v.components.locomotor  then 
					
						if v.components.health and v.components.health:IsDead() or v:GetDistanceSqToInst(inst) > 225 then
							
							inst.addbuff[v] = nil
							if v.fx then
								v.fx:Remove()
								v.fx = nil
							end
						elseif not v.fx then
							v.fx = SpawnPrefab("flower_fx")
							v.fx.entity:SetParent(v.entity)
							--[[
							local fx = SpawnPrefab("flower_fx")
							fx.Transform:SetPosition( v.Transform:GetWorldPosition() )
							fx.Transform:SetScale( 1.5, 1.5, 1.5 )
							--v.fx.entity:SetParent(v.entity)
							--]]
						end
					end
				end
			end
		end)
	elseif prefab == "lostumbrella_gai" then
		inst.buffs = inst:DoPeriodicTask(0.5, function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x,y,z,24,{"player"})
			for k,v in pairs(ents) do
				print("rrr")
				if v  and v.components.health  and v.components.combat and v.components.locomotor  then 
					if inst.addbuff[v] == nil then
						if not v.components.health:IsDead() then 
							inst.addbuff[v] = v
							if not v.fx then
								v.fx = SpawnPrefab("flower_fx")
								v.fx.entity:SetParent(v.entity)
								--[[
								local fx = SpawnPrefab("flower_fx")
								fx.Transform:SetPosition( v.Transform:GetWorldPosition() )
								fx.Transform:SetScale( 1.5, 1.5, 1.5 )
								--]]
							end
						end
					end
				end
			end
			if inst.addbuff then
				for k, v in pairs(inst.addbuff) do
					if  v  and v:IsValid() and v.components.health  and v.components.combat and v.components.locomotor  then 
						if v.components.health and v.components.health:IsDead() or  v:GetDistanceSqToInst(inst) > 225 then
							inst.addbuff[v] = nil
							if v.fx  then
								v.fx:Remove()
								v.fx = nil
							end			
						else
							if not v.fx then
								--[[reticuleaoesmall
								local fx = SpawnPrefab("flower_fx")
								fx.Transform:SetPosition( v.Transform:GetWorldPosition() )
								fx.Transform:SetScale( 1.5, 1.5, 1.5 )
								--]]
								v.fx = SpawnPrefab("flower_fx")
								v.fx.entity:SetParent(v.entity)
							end
						end
					end
				end
			end
		end)
	end
end

local skill = {
	[2] = "恢复理智",
	[3] = "流血",
	[4] = "正义集结",
	[5] = "严寒冰霜",
}
	
local goods = {
	[1] = {
		[1] = "hivehat",
		[2] = "蜂王帽",
	},
	[2] = {
		[1] = "trident",
		[2] = "刺耳三叉戟",
	},
	[3] = {
		[1] = {
			[1] = "chesspiece_guardianphase3_builder",
			[2] = "骑士玩具",
		},
		[2] = {
			[1] = "chesspiece_guardianphase3_builder",
			[2] = "战车玩具",
		},
		[3] = {
			[1] = "chesspiece_guardianphase3_builder",
			[2] = "主教玩具",
		},
		[4] = {
			[1] = "lavae_cocoon",
			[2] = "冷冻虫卵",
		},
	},
	[4] = {
		[1] = "alterguardianhat",
		[2] = "启迪之冠",
	},
}
		
local help = 
{
	name = 
	{
		[1] = "awaken",
		[2] = "dark",
		[3] = "shine",
		[4] = "quake",
		[5] = "duron",
		[6] = "bonenail1",
		[7] = "bonenail2",
		[8] = "bonenail3",
		[9] = "bonenail4",
		[10] = "bonenail5",
	},
	damage = 
	{
		[1] = TUNING.AWAKEN_DAMAGE,
		[2] = TUNING.DARK_DAMAGE,
		[3] = TUNING.SHINE_DAMAGE,
		[4] = TUNING.QUAKE_DAMAGE,
		[5] = TUNING.DURON_DAMAGE,
		[6] = TUNING.BONENAIL1_DAMAGE,
		[7] = TUNING.BONENAIL1_DAMAGE + 10,
		[8] = TUNING.BONENAIL1_DAMAGE + 20,
		[9] = TUNING.BONENAIL1_DAMAGE + 30,
		[10] = TUNING.BONENAIL1_DAMAGE + 40,
	},
	damage1 = 
	{
		[1] = "0.8",
		[2] = "1",
		[3] = "1",
		[4] = "0.5",
		[5] = "0.8",
		[6] = "0.5",
		[7] = "0.5",
		[8] = "0.5",
		[9] = "0.5",
		[10] = "0.5",
	},
	damage2 = 
	{
		[1] = "1.2",
		[2] = "1.2",
		[3] = "1.2",
		[4] = "1.2",
		[5] = "1.2",
		[6] = "1.2",
		[7] = "1.2",
		[8] = "1.2",
		[9] = "1.2",
		[10] = "1.2",
	},
	swap_name = 
	{
		[1] = "swap_awaken",
		[2] = "swap_dark",
		[3] = "swap_shine",
		[4] = "swap_quake",
		[5] = "swap_duron",
		[6] = "swap_bonenail1",
		[7] = "swap_bonenail2",
		[8] = "swap_bonenail3",
		[9] = "swap_bonenail4",
		[10] = "swap_bonenail5",
	},
	icon_name = 
	{
		[1] = "icon_awaken",
		[2] = "icon_dark",
		[3] = "icon_shine",
		[4] = "icon_quake",
		[5] = "icon_duron",
		[6] = "icon_bonenail1",
		[7] = "icon_bonenail2",
		[8] = "icon_bonenail3",
		[9] = "icon_bonenail4",
		[10] = "icon_bonenail5",
	},
	announce_name = 
	{
		[1] = "契约胜利之剑：觉醒",
		[2] = "契约胜利之剑：黑暗",
		[3] = "契约胜利之剑：光芒",
		[4] = "Mjolnir",
		[5] = "毒龙裁决",
		[6] = "旧骨钉",
		[7] = "锋利骨钉",
		[8] = "开槽骨钉",
		[9] = "螺纹骨钉",
		[10] = "纯粹骨钉",
	}
}

local function fn(i) 
    local inst = CreateEntity()
    inst.entity:AddTransform()--添加变换组件，即可以移动位置
    inst.entity:AddAnimState()--添加动画组件
	inst.entity:AddNetwork()--添加网络组件
    inst.entity:AddSoundEmitter()--添加声音组件
	--inst.entity:AddLight()--光照组件，添加该组件可使得Prefab成为一个光源
	--inst.entity:AddMapEntity()--地图实体组件，使用该组件可以为Prefab在小地图上创建一个图标。
	
	MakeInventoryPhysics(inst)--设置物品拥有一般物品栏物体的物理特性，这是一个系统封装好的函数，内部已经含有对物理引擎的设置
	
	inst.entity:SetPristine()--主客机代码分界线
	--这几句是设置网络状态的，并且作为一个分界线，往下是只限于主机使用的代码，只会在主机上运行。此外主客机都可以使用
	if not TheWorld.ismastersim then  --用来判断主/客机
        return inst
    end
	--添加组件可以写在主机中，组件的调用就是从主机处调用的，包括sg，brian都是主机端自定义处理。客户端可以没有
	
	MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8})--可以漂浮的
	
	inst.AnimState:SetBank(help.name[i])  --确定预制物的动画文件名(设置动画属性Bank为awaken)
	inst.AnimState:SetBuild(help.name[i])  --确定预制物的动画名(设置动画属性Build为awaken)
	inst.AnimState:PlayAnimation("idle")  --确定在SP中的名字(设置默认播放动画为idle)
	
	inst:AddTag("sharp")--武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
	inst:AddTag("pointy")
	inst.frequency = 1
	inst.door = 1
	
	inst:AddComponent("weapon") --增加武器组件 有了这个才可以打人
	inst.components.weapon:SetDamage(help.damage[i]) --设置伤害
	inst.components.weapon:SetRange(help.damage1[i], help.damage2[i])	--攻击距离,脱离距离。设置攻击范围
	
	inst:AddComponent("named")--鼠标放在装备栏的物品上显示介绍
	inst.components.named:SetName(help.announce_name[i])
	
	inst:AddComponent("talker") -- 添加组件讲话者
    inst.components.talker.fontsize = 28 -- 字体大小
    inst.components.talker.font = TALKINGFONT -- 字体
	inst.components.talker.colour = Vector3(.9, .4, .4) -- 字体颜色
    inst.components.talker.offset = Vector3(0, 0, 0) -- 重叠颜色
    inst.components.talker.symbol = "swap_object" -- 特殊符号
	--[[
	inst:AddComponent("finiteuses") --添加物品有限组件（叫耐久也可以），这个属于使用掉耐久，包括攻击或者作为工具的时候
	--当有攻击组件的时候，攻击掉耐久，没有则攻击不掉耐久
    inst.components.finiteuses:SetMaxUses(200)--总耐久，攻击2次掉1%
    inst.components.finiteuses:SetUses(200)--制作出来时的初始耐久，200就是100%，100就是50%
	inst.components.finiteuses:SetOnFinished(inst.Remove) --没有耐久了移除武器
	--]]
	
	inst:AddComponent("combat")--战斗组件
	inst:AddComponent("inspectable")   --检查组件，可以通过按住alt+鼠标左键进行检查
	inst:AddComponent("inventory")
	inst:AddComponent("inventoryitem")  --inst预制物，Add添加，Component组件.添加一个名为inventoryitem（库存物品）的组件。有了这个组件你的物品才可以放进背包里。
	inst.components.inventoryitem.imagename = help.icon_name[i]
    inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. help.icon_name[i] .. ".xml"  --16,17行让物品拿到物品栏中有图标
	
	inst:AddComponent("equippable") --可装备组件
	inst:AddComponent("resistance") --骨甲的抵抗
	inst.components.equippable:SetOnEquip(function(inst,owner,target,damage)
		owner.AnimState:OverrideSymbol("swap_object",help.swap_name[i],help.swap_name[i])
									--替换的动画部件	使用的动画	替换的文件夹（注意这里也是文件夹的名字）
		--inst.components.myth_itemskin:OverrideSymbol(owner, "swap_object")--更换皮肤
		owner.AnimState:Show("ARM_carry")-- 显示持物手
		owner.AnimState:Hide("ARM_normal") -- 隐藏普通手
		owner.DynamicShadow:SetSize(1.7, 1) -- 设置阴影大小，你可以仔细观察装备荷叶伞时，人物脚下的阴影变化
		--因为攻速的原因，这里的暴击无法触发
		-- if inst:HasTag("awaken") then
			-- inst.components.combat.bonusdamagefn = all_function.bonusdamagefn(help.damage[i],1,1.5)
		-- end
		if inst:HasTag("quake") then
			inst.thunder_fx = SpawnPrefab("thunder_fx")
			inst.thunder_fx.entity:AddFollower()
            inst.thunder_fx.Follower:FollowSymbol(owner.GUID, "swap_object", 1, -180, 0)
			inst.thunder_fx.entity:SetParent(owner.entity)
		end
		if inst:HasTag("hollow_knight") then
			owner.bonenail1 = inst
			-- inst.buffeds = inst:DoPeriodicTask(0.5, function(inst)
				-- hollow_knight(inst,owner,target,damage)
			-- end,0,inst)
			inst.heart = function(inst,owner)
				local fragile = inst.components.container:FindItem(function(item)
					if item:HasTag("fragile_heart") then
						return true
					end
				end)
				local strong = inst.components.container:FindItem(function(item)
					if item:HasTag("strong_heart") then
						return true
					end
				end)
				if inst.door == 1 then
					if fragile and strong then
						owner.components.health.maxhealth = owner.components.health.maxhealth + strong.maxhealth
						inst.door = inst.door + 1
						return true
					elseif fragile then
						owner.components.health.maxhealth = owner.components.health.maxhealth + fragile.maxhealth
						inst.door = inst.door + 1
						return true
					elseif strong then
						owner.components.health.maxhealth = owner.components.health.maxhealth + strong.maxhealth
						inst.door = inst.door + 1
						return true
					end
					return nil
				end
			end
			local fragile1 = inst.components.container:FindItem(function(item)
				if item:HasTag("fragile_damage") then
					return true
				end
			end)
			local strong1 = inst.components.container:FindItem(function(item)
				if item:HasTag("strong_damage") then
					return true
				end
			end)
			if fragile1 and strong1 then
				inst.components.weapon:SetDamage(help.damage[i] + 15)
			elseif fragile1 then
				inst.components.weapon:SetDamage(help.damage[i] + 10)
			elseif strong1 then
				inst.components.weapon:SetDamage(help.damage[i] + 15)
			end
		end
		if inst.frequency == 1 then
			TheNet:Announce("[ " .. owner.name .. " ]永恒之王拿起了" .. help.announce_name[i])
			inst.frequency = inst.frequency + 1
		end
	end)
    inst.components.equippable:SetOnUnequip(function(inst,owner)
		owner.AnimState:Hide("ARM_carry") -- 隐藏持物手
		owner.AnimState:Show("ARM_normal") -- 显示普通手
		owner.DynamicShadow:SetSize(1.3, 0.6) -- 设置阴影大小，你可以仔细观察装备荷叶伞时，人物脚下的阴影变化
		
		--inst.components.combat.bonusdamagefn = help.damage[i]
		if inst.thunder_fx then
			inst.thunder_fx:Remove()
		end
		if inst:HasTag("hollow_knight") then
			owner.bonenail1 = nil
			inst.buffeds = nil
			if inst.heart ~= nil then
				local fragile = inst.components.container:FindItem(function(item)
					if item:HasTag("fragile_heart") then
						return true
					end
				end)
				local strong = inst.components.container:FindItem(function(item)
					if item:HasTag("strong_heart") then
						return true
					end
				end)
				if fragile and strong then
					owner.components.health.maxhealth = owner.components.health.maxhealth - strong.maxhealth
				elseif fragile then
					owner.components.health.maxhealth = owner.components.health.maxhealth - fragile.maxhealth
				elseif strong then
					owner.components.health.maxhealth = owner.components.health.maxhealth - strong.maxhealth
				end
			end
			local fragile1 = inst.components.container:FindItem(function(item)
				if item:HasTag("fragile_damage") then
					return true
				end
			end)
			local strong1 = inst.components.container:FindItem(function(item)
				if item:HasTag("strong_damage") then
					return true
				end
			end)
			if fragile1 or strong1 then
				inst.components.weapon:SetDamage(help.damage[i])
			end
		end
		if inst.frequency == 2 then
			TheNet:Announce("[ " .. owner.name .. " ]永恒之王放下了" .. help.announce_name[i])
			inst.frequency = inst.frequency + 1
		end
	end)
	
	
	inst:AddComponent("level")
	inst.components.level:SetMaxlevel(help.damage[i])
	
	
	MakeHauntableLaunch(inst)--设置可以被作祟
	
	return inst  --给预制物打个戳，让游戏可以识别
end

local function awakenfn()
	local inst = fn(1)
	inst:AddTag("awaken")
	inst:AddTag("exclusive")
	inst:AddTag("rechargeable")
	inst:AddTag("superjump")
	inst:AddTag("aoeweapon_leap") -- 快速跳跃
	inst:AddComponent("aoetargeting")
	inst.components.aoetargeting:SetRange(20)
	inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoesmall"
	inst.components.aoetargeting.reticule.pingprefab = "reticuleaoesmallping"
	inst.components.aoetargeting.reticule.targetfn = function()
		local player = ThePlayer
		local ground = TheWorld.Map
		local pos = Vector3()
		for r = 7, 0, -.25 do
			pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
			if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
				return pos
			end
		end
		return pos
	end
	inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
	inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
	inst.components.aoetargeting.reticule.ease = true
	inst.components.aoetargeting.reticule.mouseenabled = true
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")--战利品掉落组件
	inst:AddComponent("leader")--领导者组件
	inst.components.level:OnLoad()
	inst.components.level:OnSave()
	inst.components.level:GetLevel(inst)
		
	inst:AddComponent("trader") -- 交易者组件
	inst:AddComponent("aoespell")
	inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetRechargeTime(8)
	
	inst.components.weapon:SetOnAttack(function(inst,attacker,target)
	
		-- halloween_firepuff_cold_3 lavaarena_portal_player_fx mastupgrade_lightningrod_fx electricchargedfx 
		local fx = SpawnPrefab("mastupgrade_lightningrod_fx")
		fx.Transform:SetPosition( target.Transform:GetWorldPosition() )
		fx.Transform:SetScale( 1.5, 1.5, 1.5 )
		--self.fx.entity:SetParent(self.entity)跟随人物
		if attacker.components.health and attacker.components.health:GetPercent() < 0.3 and not target:HasTag("wall") then
			all_function.ownerhp(inst, attacker, target,1)
		end
		if target and target.components.health and not target:HasTag("wall")then
			inst.components.level:GetExp(attacker,target)		
		end
	end)
	--发起攻击SetOnAttack(fn)，fn为函数，在攻击的时候执行填入的函数
	inst.components.equippable.walkspeedmult = 1.15--设置步行速度
	inst.components.trader:SetAcceptTest(function(inst, item) -- 接受测试
		if inst.levels.level < inst.levels.maxlevel and inst.levels.level == inst.levels.blocklevel then
			for k,v in ipairs(goods) do
				if k == inst.levels.lock and item.prefab == v[1] then
					return true
				elseif inst.levels.lock == 3 then
					if (item.prefab == "trinket_31" or item.prefab == "trinket_30") and inst.levels.injection == 1 then
						return true
					elseif (item.prefab == "trinket_29" or item.prefab == "trinket_28") and inst.levels.injection == 2 then
						return true
					elseif (item.prefab == "trinket_16" or item.prefab == "trinket_15") and inst.levels.injection == 3 then
						return true
					elseif item.prefab == "lavae_cocoon" and inst.levels.injection == 4 then
						return true
					end
				end
			end
			return false
		else
			return false
		end
	end)
	
	inst.components.trader.onaccept = function(inst, owner, item )
		local ok = math.random()
		if inst.levels.lock == 3 then
			if item.prefab == "trinket_31" or item.prefab == "trinket_30" then
				inst.components.level:BreachInjection()
				owner.components.talker:Say("骑士正义已经注入!")
				return
			elseif item.prefab == "trinket_29" or item.prefab == "trinket_28" then
				inst.components.level:BreachInjection()
				owner.components.talker:Say("战车正义已经注入!")
				return
			elseif item.prefab == "trinket_16" or item.prefab == "trinket_15" then
				inst.components.level:BreachInjection()
				owner.components.talker:Say("主教正义已经注入!")
				return
			elseif ok < 0.5 then
				if item.prefab == "lavae_cocoon" then
					inst.components.level:BreachLevel()
					owner.components.talker:Say("恭喜！进阶成功！\r\n解锁主动技能\r\n解锁新技能:" .. skill[inst.levels.lock])
					return
				end	
			elseif 0.5 <= ok and ok < 1 then
				owner.components.talker:Say("运气不好,升级失败!")
			end
		elseif ok < 0.5 then
			inst.components.level:BreachLevel()
			owner.components.talker:Say("恭喜！进阶成功！\r\n解锁主动技能\r\n解锁新技能:" .. skill[inst.levels.lock])
			return
		elseif 0.5 <= ok and ok < 1 then
			owner.components.talker:Say("运气不好,升级失败!")
		end
	end
	inst.components.trader.onrefuse = function(inst, owner, item) -- 拒绝
		if inst.levels.level < inst.levels.blocklevel then
			owner.components.talker:Say("还未满足突破等级")
		elseif inst.levels.level == inst.levels.maxlevel then
			owner.components.talker:Say("已经满级无需突破")
		else
			for k,v in ipairs(goods) do
				if k == inst.levels.lock and item.prefab then
					if inst.levels.lock == 3 then
						for k,v in ipairs(goods[3]) do
							if k == inst.levels.injection then
								owner.components.talker:Say("注入材料不对\r\n正确的材料为:" .. v[2])
							end
						end
						return
					end
					owner.components.talker:Say("突破材料不对\r\n正确的材料为:" .. v[2])
				end
			end
		end
	end
	
	inst.components.aoespell:SetAOESpell(function(inst, owner, pos)
		if inst.levels.lock > 1 then
			if owner.components.sanity and owner.components.sanity.current >= 5 then
				owner.sg:GoToState("jump", pos)--执行跳跃动作
				owner.components.sanity:DoDelta(-5)
				inst.components.rechargeable:StartRecharge()
			else
				owner.components.talker:Say("好家伙，你没脑子了")
			end
		else
			owner.components.talker:Say("等级不足,升级以解锁主动技能。")
		end
	end)
	
	inst.OnBuiltFn = builder_onbuilt
	
	return inst
end

local function darkfn()
	local inst = fn(2)
	if not TheWorld.ismastersim then
        return inst
    end
	inst:AddTag("dark")
	inst:AddComponent("lootdropper")--战利品掉落组件
	inst:AddComponent("leader")--领导者组件
	inst.components.weapon:SetOnAttack(onattack) -- 发起攻击SetOnAttack(fn)
	
	inst.components.equippable.walkspeedmult = 1 -- 设置步行速度
	inst.components.level:OnLoad()
	inst.components.level:OnSave()
	inst.components.level:GetLevel(inst)
	
	inst.OnBuiltFn = builder_onbuilt
	
	
	return inst 
end

local function shinefn()
	local inst = fn(3)
	if not TheWorld.ismastersim then
        return inst
    end
	inst:AddTag("shine")
	inst:AddTag("exclusive")
	inst.components.weapon:SetOnAttack(MakeBaby)--发起攻击SetOnAttack(fn)
	
	inst.components.equippable.walkspeedmult = 0.9--设置步行速度
	
	return inst 
end

local function quakefn()
	local inst = fn(4)
	inst:AddTag("quake")
	inst:AddTag("rechargeable")
	inst:AddTag("hammer")
	inst:AddTag("aoeweapon_leap") -- 快速跳跃
	inst:AddComponent("aoetargeting")
	inst.components.aoetargeting:SetRange(12)
	inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoe"
	inst.components.aoetargeting.reticule.pingprefab = "reticuleaoeping"
	inst.components.aoetargeting.reticule.targetfn = function()
		local player = ThePlayer
		local ground = TheWorld.Map
		local pos = Vector3()
		for r = 7, 0, -.25 do
			pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
			if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
				return pos
			end
		end
		return pos
	end
	inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
	inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
	inst.components.aoetargeting.reticule.ease = true
	inst.components.aoetargeting.reticule.mouseenabled = true
	
	
	if not TheWorld.ismastersim then
        return inst
    end
	inst.components.weapon:SetOnAttack(onattack)
	inst:AddComponent("aoespell")
	inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetRechargeTime(5)
	
	inst.components.aoespell:SetAOESpell(function(inst, owner, pos)
		if owner.components.sanity and owner.components.sanity.current >= 5 then
			owner.sg:GoToState("hammer_jump", pos)--执行跳跃动作
			owner.components.sanity:DoDelta(-10)
			inst.components.rechargeable:StartRecharge()
		else
			owner.components.talker:Say("好家伙，你没脑子了")
		end
	end)
	return inst
end

local function duronfn()
	local inst = fn(5)
	inst:AddTag("duron")
	inst:AddTag("rechargeable")
	inst:AddTag("parryweapon") -- 招架武器
	inst:AddComponent("aoetargeting")
	inst.components.aoetargeting:SetAlwaysValid(true)
	inst.components.aoetargeting.reticule.reticuleprefab = "reticulearc"
	inst.components.aoetargeting.reticule.pingprefab = "reticulearcping"
	inst.components.aoetargeting.reticule.targetfn = function()
		return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
	end
	
	inst.components.aoetargeting.reticule.mousetargetfn = function(inst, owner)
		if owner ~= nil then
			local x, y, z = inst.Transform:GetWorldPosition()
			local x1 = owner.x - x
			local z1 = owner.z - z
			local square = x1 * x1 + z1 * z1
			if square <= 0 then
				return inst.components.reticule.targetpos
			end 
			local l = 6.5 / math.sqrt(square)
			return Vector3(x + x1 * l, 0, z + z1 * l)
		end
	end
    inst.components.aoetargeting.reticule.updatepositionfn = function(inst, attacker, target, skipsanity, owner, r)
		local x, y, z = inst.Transform:GetWorldPosition()
		target.Transform:SetPosition(x, 0, z)
		local tans = -math.atan2(attacker.z - z, attacker.x - x) / DEGREES
		if skipsanity and r ~= nil then
			local t = target.Transform:GetRotation()
			local u = tans - t
			tans = Lerp(u > 180 and t + 360 or u < -180 and t - 360 or t, tans, r * owner)
		end 
		target.Transform:SetRotation(tans)
	end
	inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true;
    inst.components.aoetargeting.reticule.mouseenabled = true;
    inst.entity:SetPristine()
	if not TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("aoespell")
	inst:AddComponent("rechargeable")
	inst:AddComponent("parryweapon")
	inst:AddComponent("helmsplitter")
	inst.components.aoespell:SetAOESpell(function(inst, owner,target)
		if owner.components.sanity and owner.components.sanity.current >= 5 then
			owner:PushEvent("combat_parry", { 
				direction = inst:GetAngleToPoint(target), 
				duration = inst.components.parryweapon.duration, 
				weapon = inst
			})
			owner.components.sanity:DoDelta(-5)
		else
			owner.components.talker:Say("好家伙，你没脑子了")
		end
	end)
	
    inst.components.helmsplitter:SetOnHelmSplitFn(SpawnPrefab("superjump_fx"):SetTarget(inst))
    inst.components.helmsplitter.damage = 0
    inst.components.rechargeable:SetRechargeTime(10)
    inst.components.parryweapon.duration = 3
    inst.components.parryweapon:SetOnParryStartFn(function(inst,owner)
		owner.components.health:SetAbsorptionAmount(1) 
		inst.components.rechargeable:StartRecharge()
	end)
	inst.components.parryweapon:SetOnParryEndFn(function(inst,owner)
		owner.components.health:SetAbsorptionAmount(0)
	end)
	-- inst.components.combat.redirectdamagefn = function(inst, attacker, damage, weapon, stimuli)
		-- damage = 0
		-- return damage
	-- end
	return inst
end

local function bonenail1fn()
	local inst = fn(6)
	inst:AddTag("bonenail1")
	inst:AddTag("hollow_knight")
	if not TheWorld.ismastersim then
        return inst
    end
	inst.components.weapon:SetOnAttack(hollow_attack)
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("bonenail1")
	return inst
end

local function bonenail2fn()
	local inst = fn(7)
	inst:AddTag("bonenail2")
	inst:AddTag("hollow_knight")
	if not TheWorld.ismastersim then
        return inst
    end
	inst.components.weapon:SetOnAttack(hollow_attack)
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("bonenail2")
	return inst
end

local function bonenail3fn()
	local inst = fn(8)
	inst:AddTag("bonenail3")
	inst:AddTag("hollow_knight")
	if not TheWorld.ismastersim then
        return inst
    end
	inst.components.weapon:SetOnAttack(hollow_attack)
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("bonenail3")
	return inst
end

local function bonenail4fn()
	local inst = fn(9)
	inst:AddTag("bonenail4")
	inst:AddTag("hollow_knight")
	if not TheWorld.ismastersim then
        return inst
    end
	inst.components.weapon:SetOnAttack(hollow_attack)
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("bonenail4")
	return inst
end

local function bonenail5fn()
	local inst = fn(10)
	inst:AddTag("bonenail5")
	inst:AddTag("hollow_knight")
	if not TheWorld.ismastersim then
        return inst
    end
	inst.components.weapon:SetOnAttack(hollow_attack)
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("bonenail5")
	return inst
end
local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst:AddTag("FX")
    inst.entity:SetCanSleep(false)
    
    inst.AnimState:SetBank("lavaarena_battlestandard")
    inst.AnimState:SetBuild("lavaarena_battlestandard")
    inst.AnimState:PlayAnimation("heal_fx",true)
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder(3)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("insulator")
	inst.components.insulator:SetSummer()
    inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
    inst.persists = false
    return inst
end

return Prefab("awaken", awakenfn,assets1,prefabs),--用来告诉游戏你添加的预制物是个什么东西。awaken的资源在assets，相关的东西在prefabs，具体的详细信息在fn
		Prefab("dark", darkfn,assets2,prefabs),
		Prefab("quake", quakefn,assets4,prefabs),
		Prefab("duron", duronfn,assets5,prefabs),
		Prefab("bonenail1", bonenail1fn,assets6,prefabs),
		Prefab("bonenail2", bonenail2fn,assets7,prefabs),
		Prefab("bonenail3", bonenail3fn,assets8,prefabs),
		Prefab("bonenail4", bonenail4fn,assets9,prefabs),
		Prefab("bonenail5", bonenail5fn,assets10,prefabs)
		--Prefab("flower_fx", fxfn, fxassets)
		--Prefab("shine", shinefn,assets3,prefabs),
		--Prefab("common/inventory/lotus_umbrella", fn, assets) -- 这里第一项参数是物体名字，写成路径的形式是为了能够清晰地表达这个物体的分类，common也就是普通物体，
		--inventory表明这是一个可以放在物品栏中使用的物体，最后的lotus_umbrella则是真正的Prefab名。游戏在识别的时候只会识别最后这一段Prefab名，
		--也就是lotus_umbrella。前面的部分只是为了代码可读性，对系统而言并没有什么特别意义