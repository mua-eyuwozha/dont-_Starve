local G = GLOBAL
local ACTIONS = G.ACTIONS -- 动作相关预制变量
local ActionHandler = G.ActionHandler -- 动作相关的预制变量
local FRAMES = G.FRAMES
local TUNING = G.TUNING
--[[
local id = "ATK_AWAKEN" --必须大写，动作会被加入到AinstTIONS表中，key就是id。
local name = "aaa" --随意不可为nil，会在游戏中能执行动作时，显示出动作的名字
local fn = 
function(act)
	local inst = act.target -- target就是动作的目标
    local player = act.doer -- doer就是动作的执行方
	--invobject就是动作执行时对应的物品，比如说EAT这个动作，invobject就是要吃的东西
	--pos就是动作执行的地点，对地面执行的动作会用到这个数据
	if not player.components.inventory:GetEquippedItem(G.EQUIPSLOTS.HANDS):HasTag("awaken") then
	--获取装备槽手部有没有标签awaken，没有则执行
		return "atk_attack"
	end
end

AddAction(id,name,fn) -- 将上面编写的内容传入MOD API,添加动作，即id，name，fn
--]]
---[[
--所有玩家
AddPlayerPostInit(function(self)
    self:AddComponent("buffable")
    if not self.components.colourfader then 
		self:AddComponent("colourfader") 
	end
end)
--开启预测就是先播放动画后向主机获取伤害请求
AddStategraphPostInit("wilson", function(self) -- 这里sg其实是wilson
	local oldSGstate = self.actionhandlers[ACTIONS.ATTACK].deststate -- 目的地的状态
	self.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
		local equip = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)--获取装备槽手部.主机是inventory客机replica
		local weapon = inst.components.combat:GetWeapon()
		if inst and (weapon and not weapon:HasTag("exclusive")) or (equip and equip:HasTag("nopunch")) then
			return oldSGstate(inst, action)	
		else
			return "atk_awaken"
		end
	end
	
	self.states["atk_awaken"] = State{
        name = "atk_awaken",
        tags = {"attack", "notalking", "abouttoattack", "autopredict","nointerrupt"},
        onenter = function(inst)	
			local equip = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			
			if inst.components.combat:InCooldown() then -- 冷却
				inst.sg:RemoveStateTag("abouttoattack")
				inst:ClearBufferedAction()
				inst.sg:GoToState("idle", true)
				return
			end
			local buffaction = inst:GetBufferedAction() -- 获取缓冲操作
	        local target = buffaction ~= nil and buffaction.target or nil
			local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
			
			inst.components.combat:SetTarget(target) -- 设置攻击对象
	        inst.components.combat:StartAttack() -- 开始攻击
			inst.components.locomotor:Stop() -- 运动停止		
            inst.Physics:Stop() -- 物理暂停
			
			
			if inst.components.rider:IsRiding() then
				if equip ~= nil and (equip.components.projectile ~= nil or equip:HasTag("rangedweapon")) then -- 射程武器
					inst.AnimState:PlayAnimation("player_atk_pre")
					inst.AnimState:PushAnimation("player_atk", false)
					if (equip.projectiledelay or 0) > 0 then -- 射程延迟
						inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
						if inst.sg.statemem.projectiledelay > FRAMES then
							inst.sg.statemem.projectilesound =
								(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
								(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
								"dontstarve/wilson/attack_weapon"
						elseif inst.sg.statemem.projectiledelay <= 0 then
							inst.sg.statemem.projectiledelay = nil
						end
					end
					if inst.sg.statemem.projectilesound == nil then
						inst.SoundEmitter:PlaySound(
							(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
							(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
							"dontstarve/wilson/attack_weapon",
							nil, nil, true
						)
					end
					cooldown = math.max(cooldown, 13 * FRAMES)
				else
					inst.AnimState:PlayAnimation("atk_pre")
					inst.AnimState:PushAnimation("atk", false)
					DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
					cooldown = math.max(cooldown, 16 * FRAMES)
				end
			elseif equip ~= nil and equip:HasTag("awaken") then
				inst.AnimState:SetDeltaTimeMultiplier(2) -- 加速
				inst.AnimState:PlayAnimation("lunge_pst")--lunge_pst
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
				cooldown = 11 * FRAMES
			elseif equip ~= nil and equip:HasTag("dark") then
				inst.AnimState:SetDeltaTimeMultiplier(0.8)
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
				cooldown = 11 * FRAMES
			elseif equip ~= nil and equip:HasTag("shine") then
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
				cooldown = 11 * FRAMES
			elseif equip ~= nil and equip:HasTag("whip") then
				inst.AnimState:PlayAnimation("whip_pre")
				inst.AnimState:PushAnimation("whip", false)
				inst.sg.statemem.iswhip = true
				inst.SoundEmitter:PlaySound("dontstarve/common/whip_large", nil, nil, true)
				cooldown = math.max(cooldown, 17 * FRAMES)
			elseif equip ~= nil and equip:HasTag("book") then
				inst.AnimState:PlayAnimation("attack_book")
				inst.sg.statemem.isbook = true
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
				cooldown = math.max(cooldown, 19 * FRAMES)
			elseif equip ~= nil and equip:HasTag("chop_attack") and inst:HasTag("woodcutter") then
				inst.AnimState:PlayAnimation(inst.AnimState:IsCurrentAnimation("woodie_chop_loop") and inst.AnimState:GetCurrentAnimationTime() < 7.1 * FRAMES and "woodie_chop_atk_pre" or "woodie_chop_pre")
				inst.AnimState:PushAnimation("woodie_chop_loop", false)
				inst.sg.statemem.ischop = true
				cooldown = math.max(cooldown, 11 * FRAMES)
			elseif equip ~= nil and equip.components.weapon ~= nil and not equip:HasTag("punch") then
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				if (equip.projectiledelay or 0) > 0 then
					inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
					if inst.sg.statemem.projectiledelay > FRAMES then
						inst.sg.statemem.projectilesound =
							(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
							(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
							"dontstarve/wilson/attack_weapon"
					elseif inst.sg.statemem.projectiledelay <= 0 then
						inst.sg.statemem.projectiledelay = nil
					end
				end
				if inst.sg.statemem.projectilesound == nil then
					inst.SoundEmitter:PlaySound(
						(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
						(equip:HasTag("shadow") and "dontstarve/wilson/attack_nightsword") or
						(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
						"dontstarve/wilson/attack_weapon",
						nil, nil, true
					)
				end
				cooldown = math.max(cooldown, 13 * FRAMES)
			elseif equip ~= nil and (equip:HasTag("light") or equip:HasTag("nopunch")) then
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
				cooldown = math.max(cooldown, 13 * FRAMES)
			elseif inst:HasTag("beaver") then
				inst.sg.statemem.isbeaver = true
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
				cooldown = math.max(cooldown, 13 * FRAMES)
			elseif inst:HasTag("weremoose") then
				inst.sg.statemem.ismoose = true
				inst.AnimState:PlayAnimation(
					((inst.AnimState:IsCurrentAnimation("punch_a") or inst.AnimState:IsCurrentAnimation("punch_c")) and "punch_b") or
					(inst.AnimState:IsCurrentAnimation("punch_b") and "punch_c") or
					"punch_a")
				cooldown = math.max(cooldown, 15 * FRAMES)
			else
				inst.AnimState:PlayAnimation("punch")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
				cooldown = math.max(cooldown, 24 * FRAMES)
			end

			inst.sg:SetTimeout(cooldown)

			if target ~= nil then
				inst.components.combat:BattleCry()
				if target:IsValid() then
					inst:FacePoint(target:GetPosition())-- 面向攻击对象
					inst.sg.statemem.attacktarget = target
				end
			end
        end,
		
		onupdate = function(inst, dt)
            if (inst.sg.statemem.projectiledelay or 0) > 0 then -- 抛射物延期
                inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
                if inst.sg.statemem.projectiledelay <= FRAMES then
                    if inst.sg.statemem.projectilesound ~= nil then
                        inst.SoundEmitter:PlaySound(inst.sg.statemem.projectilesound, nil, nil, true)
                        inst.sg.statemem.projectilesound = nil
                    end
                    if inst.sg.statemem.projectiledelay <= 0 then
                        inst:PerformBufferedAction()
                        inst.sg:RemoveStateTag("abouttoattack")
                    end
                end
            end
        end,
		
        timeline = {
            TimeEvent(3 * FRAMES, function(inst)
				local target = inst.components.combat.target
                if inst.components.combat and not inst.components.inventory:EquipHasTag("dark") then
                    inst:ForceFacePoint(target:GetPosition())
					inst:PerformBufferedAction() 
					inst.SoundEmitter:PlaySound(
							"dontstarve/common/lava_arena/spell/elemental/attack") -- 音效
                end
            end),  
			TimeEvent(9 * FRAMES, function(inst)
				local target = inst.components.combat.target
				if inst.components.inventory:EquipHasTag("awaken") then
					if target then
						inst:PerformBufferedAction()-- 添加缓冲使得加速后的动作被完整保存，从而让游戏正常检测到动作
						--正常检测到动作后才可以让游戏得知你攻击的动作动画已经执行完，可以进行下一步onexit和event
						--两部分的触发，这样完整的攻击动作，让游戏可以判断你攻击动作已经执行完成，可以继续下一个
						--指令，从而使得鼠标攻击可以连续
						inst:ForceFacePoint(target:GetPosition())
						
						local number = all_function.bonusdamagefn(TUNING.AWAKEN_DAMAGE,0.05,2.5)
						if number ~= TUNING.AWAKEN_DAMAGE then
							local death_kill_ground = SpawnPrefab("explosivehit")
							death_kill_ground.Transform:SetPosition(target.Transform:GetWorldPosition() )
							death_kill_ground.Transform:SetScale( 1.5, 1.5, 1.5 )
							target.components.health:DoDelta(-number)-- 暴击
						end
					end
				end
				if inst.components.inventory:EquipHasTag("shine") then
					if math.random() < .25 then -- 额外二段伤害
						if target ~= nil then
							inst:PerformBufferedAction()
							inst:ForceFacePoint(target:GetPosition())
							inst.components.combat:DoAttack(target) -- 造成伤害
						end
					end
				end
				if inst:HasTag("weremoose") then -- 加强吴迪麋鹿形态
					if target ~= nil then
						inst:PerformBufferedAction()
						inst:ForceFacePoint(target:GetPosition())
						inst.components.combat:DoAttack(target) -- 造成伤害
					end
				end
            end),
			TimeEvent(13 * FRAMES, function(inst)
				local target = inst.components.combat.target
                if inst.components.inventory:EquipHasTag("dark") then
					if target then
						inst:PerformBufferedAction()
						inst:ForceFacePoint(target:GetPosition())
						inst.SoundEmitter:PlaySound(
								"dontstarve/common/lava_arena/spell/elemental/attack") -- 音效
						--inst.components.combat:DoAttack(target)
					end
                end
            end), 
        },
		
		ontimeout = function(inst)
			inst.AnimState:SetDeltaTimeMultiplier(1)
			inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,
		
        events =
        {
			EventHandler("equip", function(inst) 
				inst.AnimState:SetDeltaTimeMultiplier(1)
				inst.sg:GoToState("idle") 
			end),
            EventHandler("unequip", function(inst) 
				inst.AnimState:SetDeltaTimeMultiplier(1)
				inst.sg:GoToState("idle") 				
			end),
            EventHandler("animqueueover", function(inst)--animqueueover
                if inst.AnimState:AnimDone() then
					inst.AnimState:SetDeltaTimeMultiplier(1)
                    inst.sg:GoToState("idle")
                end
            end),
        },
		---[[ -- 使得攻击连贯,并且攻击不会滑步
		onexit = function(inst)
            inst.components.combat:SetTarget(nil)
            if inst.sg:HasStateTag("abouttoattack") then
				inst.AnimState:SetDeltaTimeMultiplier(1) -- 都添加一下，因为有时候会出现没有恢复的bug
                inst.components.combat:CancelAttack()
            end
        end,
		--]]
    }
	self.states["jump"] = State{
		name = "jump",
		tags = {"aoe", "doing", "noattack", "nopredict", "nomorph","superjump"},
		onenter = function(inst, pos)
			inst.sg.statemem.pos = pos
			inst.AnimState:PlayAnimation("superjump")
			inst.sg:SetTimeout(3)
		end,
		timeline = {
			TimeEvent(8 * FRAMES, function(inst)
				local x, y, z = inst.sg.statemem.pos:Get()
				inst.Transform:SetPosition(x, y, z)
				inst.AnimState:PlayAnimation("superjump_land")
				local x,y,z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 3,nil,{"player"},nil)
				
				for k,v in pairs(ents) do
					local health = v.components.health
					local combat = v.components.combat
					local fx = SpawnPrefab("superjump_fx")
					local fx1 = SpawnPrefab("firesplash_fx")
					fx1.Transform:SetPosition( x, 0, z )
					fx1.Transform:SetScale( 1.5, 1.5, 1.5 )
					fx.Transform:SetPosition(x, 0, z)
					fx.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
					if v and health and not health:IsDead() and combat and v ~= inst and
                        not (v.components.follower and v.components.follower.leader == inst) and 
                        (TheNet:GetPVPEnabled() or not v:HasTag("player")) then
						combat:GetAttacked(inst, 88)
					end
				end
				ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, inst, 40) -- 屏幕晃动
			end)
		},
		onexit = function(inst)
			inst.components.locomotor:Stop()
		end,
		ontimeout = function(inst)
			inst.sg:GoToState("idle", true)
		end
	}
	---[[
	self.states["hammer_jump"] = State{
        name = "hammer_jump",
        tags = { "aoe", "doing","busy","prehammer", "hammering", "working","combat_leap_start" },
        onenter = function(inst, pos)
			inst.sg.statemem.pos = pos
			inst.AnimState:PlayAnimation("jumpout")
            inst.sg.statemem.action = inst:GetBufferedAction()
            inst.AnimState:PlayAnimation("pickaxe_loop")
			--inst.sg.statemem.action = inst.bufferedaction
			inst.sg:SetTimeout(.7)
        end,
        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
				local x, y, z = inst.sg.statemem.pos:Get()
				inst.Transform:SetPosition(x, y, z)
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("prehammer")
                
            end),

            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("prehammer")
				local x,y,z = inst.Transform:GetWorldPosition()				
				local fx = {
					--SpawnPrefab("lavaarena_creature_teleport_medium_fx"),
					SpawnPrefab("lightning"),
					SpawnPrefab("hammer_mjolnir_crackle"),
					SpawnPrefab("hammer_mjolnir_cracklebase"),
					SpawnPrefab("hammer_mjolnir_cracklehit"),
				}
				for k,v in pairs(fx) do
					v.Transform:SetPosition( x, 0, z )
					v.Transform:SetScale( 1.5, 1.5, 1.5 )
				end
				ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, inst, 40)
            end),

            TimeEvent(14 * FRAMES, function(inst)
                if inst.components.playercontroller ~= nil and
                    inst.components.playercontroller:IsAnyOfControlsPressed(
                        CONTROL_SECONDARY,
                        CONTROL_ACTION,
                        CONTROL_CONTROLLER_ALTACTION) and
                    inst.sg.statemem.action ~= nil and
                    inst.sg.statemem.action:IsValid() and
                    inst.sg.statemem.action.target ~= nil and
                    inst.sg.statemem.action.target.components.workable ~= nil and
                    inst.sg.statemem.action.target.components.workable:CanBeWorked() and
                    inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action, true) and
                    CanEntitySeeTarget(inst, inst.sg.statemem.action.target) then
                    inst:ClearBufferedAction()
                    inst:PushBufferedAction(inst.sg.statemem.action)
                end
				local x,y,z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 4,nil,{"player"},nil)
				for k,v in pairs(ents) do
					local health = v.components.health
					local combat = v.components.combat
					if v and health and not health:IsDead() and combat and v ~= inst and
                        not (v.components.follower and v.components.follower.leader == inst) and 
                        (TheNet:GetPVPEnabled() or not v:HasTag("player")) then
						combat:GetAttacked(inst, 50)
					end
				end
				inst.components.talker:Say("雷神！索尔！")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
            end),
        },
        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.AnimState:PlayAnimation("pickaxe_pst")
                    inst.sg:GoToState("idle", true)
                end
            end),
        },
    }
	--]]
	--[[
	self.states["hollow_knight_cloak_dash"] = State{
		name = "hollow_knight_cloak_dash",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph"},
        onenter = function(inst)
			inst.components.locomotor:Stop()
            --inst.components.locomotor:StopMoving()
            if inst.bonenail1 then
                if inst.bonenail1:HasTag("bonenail1") then
                    inst.AnimState:PlayAnimation("hollow_knight_shade_cloak_dash")
                    inst.bonenail1:RemoveTag("shade_cloak")
                    inst.sg.statemem.shade_cloak = true
                    inst.bonenail1.components.fueled:DoDelta(-5)
                    if inst.bonenail1.components.cooldown.onchargedfn ~= nil then
                        inst.bonenail1.components.cooldown:StartCharging()
                    end
                else
                    if inst.bonenail1:HasTag("hollow_knight_mothwing_cloak") then
                        inst.bonenail1.components.fueled:DoDelta(-5)
                    end
                    inst.AnimState:PlayAnimation("hollow_knight_cloak_dash")
                end
            end
        end,
        onupdate = function(inst,dt)
            inst.Physics:SetMotorVel(35, 0, 0)
        end,
        timeline =
        {
            TimeEvent(0*FRAMES, function(inst)
                if inst.sg.statemem.shade_cloak then
                    inst.SoundEmitter:PlaySound("hollow_knight/sfx/hollow_knight_player_shade_dash")
                else
                    inst.SoundEmitter:PlaySound("hollow_knight/sfx/hollow_knight_player_dash")
                end
            end),
		
            TimeEvent(1*FRAMES, function(inst)
                Spawn_shadow_granule_fx(inst)
            end),
			TimeEvent(2*FRAMES, function(inst)
                Spawn_shadow_granule_fx(inst)
            end),
			TimeEvent(3*FRAMES, function(inst)
                Spawn_shadow_granule_fx(inst)
            end),
			TimeEvent(4*FRAMES, function(inst)
                Spawn_shadow_granule_fx(inst)
            end),
			TimeEvent(5*FRAMES, function(inst)
                Spawn_shadow_granule_fx(inst)
            end),
			TimeEvent(6*FRAMES, function(inst)
                Spawn_shadow_granule_fx(inst)
            end),
			TimeEvent(7*FRAMES, function(inst)
                Spawn_shadow_granule_fx(inst)
            end),
		
        },
        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
        onexit = function(inst)
            inst.components.locomotor:Stop()
            if inst.sg.statemem.shade_cloak then
                inst.sg.statemem.shade_cloak = nil
            end
        end,
	}
	--]]
end)
AddStategraphPostInit("wilson_client", function(self)
	local oldSGstate = self.actionhandlers[ACTIONS.ATTACK].deststate -- 目的地的状态
	self.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
		local equip = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)--获取装备槽手部.主机是inventory客机replica
		local weapon = inst.replica.combat:GetWeapon()
		if inst and (weapon and not weapon:HasTag("exclusive")) or (equip and equip:HasTag("nopunch")) then 
			return oldSGstate(inst, action)--hook
		else
			return "atk_awaken"		
		end
	end
	
	
	self.states["atk_awaken"] = State {
        name = "atk_awaken",
        tags = {"attack", "notalking", "abouttoattack", "autopredict","nointerrupt"}, -- busy动作不可被打断标签，加了之后不可以走A
		onenter = function(inst)
			local equip = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			local buffaction = inst:GetBufferedAction() -- 获取缓冲操作
			local cooldown = 0
			if inst.replica.combat ~= nil then
				if inst.replica.combat:InCooldown() then
					inst.sg:RemoveStateTag("abouttoattack")
					inst:ClearBufferedAction()
					inst.sg:GoToState("idle", true)
					return
				end
				inst.replica.combat:StartAttack()
				cooldown = inst.replica.combat:MinAttackPeriod() + .5 * FRAMES
			end
			
			--inst.components.locomotor:Stop()
			local rider = inst.replica.rider
			if rider ~= nil and rider:IsRiding() then
				if equip ~= nil and (equip:HasTag("rangedweapon") or equip:HasTag("projectile")) then
					inst.AnimState:PlayAnimation("player_atk_pre")
					inst.AnimState:PushAnimation("player_atk", false)
					if (equip.projectiledelay or 0) > 0 then
						inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
						if inst.sg.statemem.projectiledelay > FRAMES then
							inst.sg.statemem.projectilesound =
								(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
								(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
								"dontstarve/wilson/attack_weapon"
						elseif inst.sg.statemem.projectiledelay <= 0 then
							inst.sg.statemem.projectiledelay = nil
						end
					end
					if inst.sg.statemem.projectilesound == nil then
						inst.SoundEmitter:PlaySound(
							(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
							(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
							"dontstarve/wilson/attack_weapon",
							nil, nil, true
						)
					end
					if cooldown > 0 then
						cooldown = math.max(cooldown, 13 * FRAMES)
					end
				else
					inst.AnimState:PlayAnimation("atk_pre")
					inst.AnimState:PushAnimation("atk", false)
					DoMountSound(inst, rider:GetMount(), "angry")
					if cooldown > 0 then
						cooldown = math.max(cooldown, 16 * FRAMES)
					end
				end
			elseif equip ~= nil and equip:HasTag("awaken") then
				inst.AnimState:PlayAnimation("lunge_pst")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
				cooldown = 11 * FRAMES
			elseif equip ~= nil and equip:HasTag("dark") then
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
				cooldown = 11 * FRAMES
			elseif equip ~= nil and equip:HasTag("shine") then
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
				cooldown = 11 * FRAMES
			elseif equip ~= nil and equip:HasTag("whip") then
				inst.AnimState:PlayAnimation("whip_pre")
				inst.AnimState:PushAnimation("whip", false)
				inst.sg.statemem.iswhip = true
				inst.SoundEmitter:PlaySound("dontstarve/common/whip_pre", nil, nil, true)
				if cooldown > 0 then
					cooldown = math.max(cooldown, 17 * FRAMES)
				end
			elseif equip ~= nil and equip:HasTag("book") then
				inst.AnimState:PlayAnimation("attack_book")
				inst.sg.statemem.isbook = true
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
				if cooldown > 0 then
					cooldown = math.max(cooldown, 19 * FRAMES)
				end
			elseif equip ~= nil and equip:HasTag("chop_attack") and inst:HasTag("woodcutter") then
				inst.AnimState:PlayAnimation(inst.AnimState:IsCurrentAnimation("woodie_chop_loop") and inst.AnimState:GetCurrentAnimationTime() < 7.1 * FRAMES and "woodie_chop_atk_pre" or "woodie_chop_pre")
				inst.AnimState:PushAnimation("woodie_chop_loop", false)
				inst.sg.statemem.ischop = true
				cooldown = math.max(cooldown, 11 * FRAMES)
			elseif equip ~= nil and
				equip.replica.inventoryitem ~= nil and
				equip.replica.inventoryitem:IsWeapon() and
				not equip:HasTag("punch") then
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				if (equip.projectiledelay or 0) > 0 then
					inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
					if inst.sg.statemem.projectiledelay > FRAMES then
						inst.sg.statemem.projectilesound =
							(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
							(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
							"dontstarve/wilson/attack_weapon"
					elseif inst.sg.statemem.projectiledelay <= 0 then
						inst.sg.statemem.projectiledelay = nil
					end
				end
				if inst.sg.statemem.projectilesound == nil then
					inst.SoundEmitter:PlaySound(
						(equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
						(equip:HasTag("shadow") and "dontstarve/wilson/attack_nightsword") or
						(equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
						"dontstarve/wilson/attack_weapon",
						nil, nil, true
					)
				end
				if cooldown > 0 then
					cooldown = math.max(cooldown, 13 * FRAMES)
				end
			elseif equip ~= nil and
				(equip:HasTag("light") or
				equip:HasTag("nopunch")) then
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
				if cooldown > 0 then
					cooldown = math.max(cooldown, 13 * FRAMES)
				end
			elseif inst:HasTag("beaver") then
				inst.sg.statemem.isbeaver = true
				inst.AnimState:PlayAnimation("atk_pre")
				inst.AnimState:PushAnimation("atk", false)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
				if cooldown > 0 then
					cooldown = math.max(cooldown, 13 * FRAMES)
				end
			elseif inst:HasTag("weremoose") then
				inst.sg.statemem.ismoose = true
				inst.AnimState:PlayAnimation(
					((inst.AnimState:IsCurrentAnimation("punch_a") or inst.AnimState:IsCurrentAnimation("punch_c")) and "punch_b") or
					(inst.AnimState:IsCurrentAnimation("punch_b") and "punch_c") or
					"punch_a"
				)
				if cooldown > 0 then
					cooldown = math.max(cooldown, 15 * FRAMES)
				end
			else
				inst.AnimState:PlayAnimation("punch")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
				if cooldown > 0 then
					cooldown = math.max(cooldown, 24 * FRAMES)
				end
			end

			if buffaction ~= nil then
				inst:PerformPreviewBufferedAction()

				if buffaction.target ~= nil and buffaction.target:IsValid() then
					inst:FacePoint(buffaction.target:GetPosition())
					inst.sg.statemem.attacktarget = buffaction.target
				end
			end

			if cooldown > 0 then
				inst.sg:SetTimeout(cooldown)
			end
			--]]
        end,
		
		onupdate = function(inst, dt)
            if (inst.sg.statemem.projectiledelay or 0) > 0 then -- 抛射物延期
                inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
                if inst.sg.statemem.projectiledelay <= FRAMES then
                    if inst.sg.statemem.projectilesound ~= nil then
                        inst.SoundEmitter:PlaySound(inst.sg.statemem.projectilesound, nil, nil, true)
                        inst.sg.statemem.projectilesound = nil
                    end
                    if inst.sg.statemem.projectiledelay <= 0 then
                        inst:PerformBufferedAction()
                        inst.sg:RemoveStateTag("abouttoattack")
                    end
                end
            end
        end,
		
        timeline = {
            TimeEvent(3 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(
                    "dontstarve/common/lava_arena/spell/elemental/attack")
            end),
			
			TimeEvent(9 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(
                    "dontstarve/common/lava_arena/spell/elemental/attack")
			end),
			
			TimeEvent(13 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(
                    "dontstarve/common/lava_arena/spell/elemental/attack")
			end),
        },
		ontimeout = function(inst)
			inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,
		
        events =
        {
			EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
		---[[ -- 使得攻击连贯,并且攻击不会滑步
		onexit = function(inst)
            inst.replica.combat:SetTarget(nil)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.replica.combat:CancelAttack()
            end
        end,
		--]]
    }
	
	self.states["jump"] = State{
		name = "jump",
		tags = {"aoe", "doing","noattack", "nopredict", "nomorph","superjump"},
		onenter = function(inst, pos)
			inst.sg.statemem.pos = pos
			inst.AnimState:PlayAnimation("superjump")
			inst.sg:SetTimeout(1.5)
		end,
		timeline = {
			TimeEvent(2 * FRAMES, function(inst)
				local x, y, z = inst.sg.statemem.pos:Get()
				inst.Transform:SetPosition(x, y, z)
				local x,y,z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 5,nil,{"player"},nil)
				
				for k,v in pairs(ents) do
					local fx = SpawnPrefab("superjump_fx")
					local fx1 = SpawnPrefab("firesplash_fx")
					fx1.Transform:SetPosition( x, 0, z )
					fx1.Transform:SetScale( 1.5, 1.5, 1.5 )
					fx.Transform:SetPosition(x, 0, z)
				end
				inst.AnimState:PlayAnimation("superjump_land")
				ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, inst, 40) -- 屏幕晃动
			end)
		},
		onexit = function(inst)
			inst.replica.locomotor:Stop()
		end,
		ontimeout = function(inst)
			inst.sg:GoToState("idle", true)
		end
	}
	self.states["hammer_jump"] = State{
        name = "hammer_jump",
        tags = { "aoe", "doing","busy","prehammer", "hammering", "working","combat_leap_start" },
        onenter = function(inst, pos)
			inst.sg.statemem.pos = pos
			inst.AnimState:PlayAnimation("jumpout")
            inst.sg.statemem.action = inst:GetBufferedAction()
            inst.AnimState:PlayAnimation("pickaxe_loop")
			inst.sg:SetTimeout(.7)
        end,
        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
				local x, y, z = inst.sg.statemem.pos:Get()
				inst.Transform:SetPosition(x, y, z)
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("prehammer")
                
            end),

            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("prehammer")
            end),

            TimeEvent(14 * FRAMES, function(inst)
                if inst.replica.playercontroller ~= nil and
                    inst.replica.playercontroller:IsAnyOfControlsPressed(
                        CONTROL_SECONDARY,
                        CONTROL_ACTION,
                        CONTROL_CONTROLLER_ALTACTION) and
                    inst.sg.statemem.action ~= nil and
                    inst.sg.statemem.action:IsValid() and
                    inst.sg.statemem.action.target ~= nil and
                    inst.sg.statemem.action.target.replica.workable ~= nil and
                    inst.sg.statemem.action.target.replica.workable:CanBeWorked() and
                    inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action, true) and
                    CanEntitySeeTarget(inst, inst.sg.statemem.action.target) then
                    inst:ClearBufferedAction()
                    inst:PushBufferedAction(inst.sg.statemem.action)
                end
				
				inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
				ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, inst, 40)
            end),
        },
        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.AnimState:PlayAnimation("pickaxe_pst")
                    inst.sg:GoToState("idle", true)
                end
            end),
        },
    }
end)
--[[
local type = "EQUIPPED" -- 设置动作绑定的类型
local component = "combat" -- 设置动作绑定的组件
local testfn = function(inst, doer, target, actions) -- 设置动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作
--right表示是否可以右键
	--if right then
		if inst:HasTag("combat") and doer:HasTag("attacker") then -- 实体的标签有战斗，动作的执行者的标签攻击者时，插入新动作
			table.insert(actions, ACTIONS.ATK_AWAKEN) -- 在actions表中插入一个值，一共三个参数，第二参数是插入的位置，没有填写
			--默认为length+1，即在table连续下标的元素最后。
		end
	--end
end
AddcomponentAction(type, component, testfn)--一个函数，在playeractionpicker中会被执行，用于判断是否添加，以及添加什么动作。

	
--local state = states -- 设定要绑定的state
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.ATK_AWAKEN, "atk_attack"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.ATK_AWAKEN, "atk_attack"))--这个函数是用来给指定的SG添加ActionHandler的。
--SG是状态图，状态图下有状态、动作、事件
--动作也可以设定在什么状态下执行，也可以自己设定执行
--状态也有当处于什么状态时触发相应的函数，函数写在状态表中的onenter入口里
--函数里可以执行动画，动作更相当于人主动执行的，鼠标右键，左键，键盘某个按键

local old_PICKUP = G.ACTIONS.PICKUP.fn --hook武器不可被其他人使用
ACTIONS.PICKUP.fn = function(act)
	if act.target and act.target:HasTag("xe_equip") then
		if act.doer.prefab == "xuaner" then
			return old_PICKUP(act)
		end
		act.doer:DoTaskInTime(1, function()
			act.doer.components.talker:Say("此等利器，我不会使用。")
		end)
		return false
	end
	return old_PICKUP(act)
end
--]]
