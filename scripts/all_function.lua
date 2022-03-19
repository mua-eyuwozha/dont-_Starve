GLOBAL.all_function =
{
	--暴击
	["bonusdamagefn"] = function(damage,probability,multiple)--从第二位开始传参
		local bonusdamage = damage
		if math.random() < probability then
			bonusdamage = bonusdamage * multiple
		end     
		return bonusdamage 
	end,
	--DOT伤害，周期性持续伤害。流血
	["targethp"] = function(inst, attacker, target,number)
		local owner = inst.components.inventoryitem.owner
		if owner ~= nil then
			local ownerdamage = 1
			if inst.components.inventoryitem.owner.components.combat.damagemultiplier then
				ownerdamage = inst.components.inventoryitem.owner.components.combat.damagemultiplier
			end
			local value = math.ceil(number)
			local time = 0.1
			for i = 1, math.ceil(30) do                         --每隔time*i 运行Fn
				inst:DoTaskInTime(time*i, function()            --time*i s后执行函数
					if target
						and target:IsValid() 
						and target.components.health 
						and target.components.health.currenthealth > 0 
						and target.components.combat ~= nil then
						target.components.combat:GetAttacked(attacker, value, inst)
					end
				end)
			end
		end
	end,
	--每次攻击获得扣血/回血Buff
	["ownerhp"] = function(inst, attacker, target,number) 
		local owner = inst.components.inventoryitem.owner
		local health = owner.components.health
		local time = 1
		if owner ~= nil then  --不为空值
			inst:DoTaskInTime(2, function() --2秒后扣血
			for i = 1, math.ceil(2) do --对浮点数向上取整，即2。math.ceil(2.3)，结果仍然是2
				inst:DoTaskInTime(time*i, function()
					if owner and health and health.currenthealth < health.maxhealth and health.currenthealth > 0 then
						health:DoDelta(number)
					end
				end)
			end
			end)
		end
	end,
	--召唤生物
	["makebaby"] = function(inst,attacker,baby)
		local angle = (inst.Transform:GetRotation() + 180)
		local prefab = baby
		
		--[[
		if math.random() < 0.05 then
			prefab = "gnarwail"
		end
		
		if math.random() < 0.01 then
			prefab = "pigguard" or "shark"
		end
		--]]
		if inst.components.lootdropper then
			local creat = inst.components.lootdropper:SpawnLootPrefab(prefab)
			local rad = creat:GetPhysicsRadius(0) + inst:GetPhysicsRadius(0) + .25
			local x, y, z = inst.Transform:GetWorldPosition()
			
			creat.Transform:SetPosition(x + rad * math.cos(angle), 0, z - rad * math.sin(angle))
			creat.sg:GoToState("taunt")
			-- if not creat.components.follower then--若没有跟随者组件
				-- creat:AddComponent("follower")--添加跟随者组件
			-- end
			if not inst.components.leader then
				inst:AddComponent("leader")
				inst.components.leader:AddFollower(creat)
			end
			creat.components.combat:SetTarget(attacker.components.combat.target) -- 设置攻击目标，与主人的攻击目标相同
		end
	end,
	--随机选择
	["randomchoice"] = function(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z)
		local tablem = {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}
		local tables = {}
		for key,value in ipairs(tablem) do 
			table.insert(tables,value)
		end
		return tables[math.random(#tables)]
	end,
	--密钥
	["matching"] = function()
		for i,j in ipairs(awakenuserdb) do
			for n,m in ipairs(darkuserdb) do
				if j == m then
					local id = awakeniddb[i]
					return leveldb[id]
				end
			end
		end
	end,
	--根据userid获取玩家
	["GetTheWorldPlayerById"] = function(id)
		for k,v in ipairs(AllPlayers) do
			if v.userid == id then
				return v
			end
		end
		return nil
	end,
	--生成物品
	["wy_spawn"] = function(inst, other, offset, mode, scale, phys, sound, fn_tar, fn_inst)

		if not inst then return end
		--local mode = mode or 0
		local tar
		
		if type(other) == "string" then
			tar = SpawnPrefab(other)
		elseif type(other) == "table" then
		
			--获取权重
			local weight = 0
			for k,v in pairs(other) do
				weight = weight + v
			end
			
			--选取物体
			local t = 0
			local ran = math.random()
			for k,v in pairs(other) do
				t = t + v
				if ran <= t/weight then
					tar = SpawnPrefab(k)
					break
				end
			end
		else
			return
		end
		
		if not tar then return end
			
		--物体的父子位置关系
		if mode == 1 then
			
			tar.entity:SetParent(inst.entity)
			if type(offset) == "table" then
				tar.Transform:SetPosition(offset[1],offset[2],offset[3])
			else
				tar.Transform:SetPosition(0,0,0)
			end
		
		--Follow Symbol的关系
		elseif type(mode) == "string" then
			
			tar.entity:SetParent(inst.entity)
			tar.entity:AddFollower()
			if type(offset) == "table" then
				tar.Follower:FollowSymbol(inst.GUID, mode, offset[1],offset[2],offset[3])
			else
				tar.Follower:FollowSymbol(inst.GUID, mode, 0,0,0)
			end
		
		--普通生成模式
		else
			local x,y,z = inst.Transform:GetWorldPosition()
			local x1,y1,z1 = x,y,z
			if type(offset) == "table" then
				x1,y1,z1 = x+offset[1], y+offset[2], z+offset[3]
			end
			tar.Transform:SetPosition(x1,y1,z1)
		end
		
		--新事物的体积,多用于调试特效
		if scale then
			tar.Transform:SetScale(scale,scale,scale)
		end
		
		--新事物飞出的速度,多用于弹道类物体,也可用于掉落物
		if type(phys) == "table" and tar.Physics then

			--获取方向, 以自己为起点的方向
			if phys[1] then
				local angle = tar:GetAngleToPoint( phys[1]:Get() )	
				
				--偏离角度
				local angel_d = phys[2] or 0
				angle = angle + angel_d
				
				--获得最终面向角度
				while (angle < 0) do
					angle = angle + 360
				end
				while (angle >= 360) do
					angle = angle - 360
				end
				
				--设置最终面向
				tar.Transform:SetRotation(angle)
			end
			
			--获取速度, 如果速度小于0则倒退方向运行
			local vel = phys[3]
			if vel then
				tar.Physics:SetMotorVelOverride(vel[1],vel[2],vel[3])
			end
			
		end
		
		--新事物的音效,用于生成时的声音效果
		if type(sound) == "table" then
			if not tar.SoundEmitter then
				tar.entity:AddSoundEmitter()
			end
			tar:DoTaskInTime(sound[2] or 0, function()
				tar.SoundEmitter:PlaySound(sound[1])
			end)
		elseif type(sound) == "string" then
			if not tar.SoundEmitter then
				tar.entity:AddSoundEmitter()
				tar.SoundEmitter:PlaySound(sound)
			end
		end
		
		-------------------------------------------一般情况是用不着的----------------
		--新事物的其他初始化
		if type(fn_tar) == "function" then
			fn_tar(tar)
		end
		
		--旧事物的操作
		if type(fn_inst) == "function" then
			fn_inst(inst)
		end

		return tar
	end,
	--离自己前方的某个位置的 Vetor3
	["tw_getforwardpos_offset"] = function(inst, dist, theta, other, height)
		local basic_angle = other and inst:GetAngleToPoint(other.Transform:GetWorldPosition()) or inst.Transform:GetRotation()
		local heading_angle = -( basic_angle + (theta or 0) )
		local dist = dist or 0
		local offset = Vector3(math.cos(heading_angle*DEGREES) * dist, height or 0, math.sin(heading_angle*DEGREES) * dist)
		return offset
	end,
	--获取前方的相对位置的表
	["wy_getoffset"] = function(inst, dist, theta, other, height)
		local offset=tw_getforwardpos_offset(inst, dist, theta, other, height)
		return {offset.x,offset.y,offset.z}
	end,

	["tw_getforwardpos"] = function(inst, dist, theta, other, height)
		local pt = inst:GetPosition()
		local offset = tw_getforwardpos_offset(inst, dist, theta, other, height)
		return pt + offset
	end,

	--离自己前方的某个位置是否在陆地上
	["tw_getforwardposisonland"] = function(inst, dist, theta, other)
		local x0,y0,z0 = tw_getforwardpos(inst, dist, theta, other):Get()
		return tw_isonland(inst, x0,y0,z0)
	end,

	--是否和自己前方某个位置在联通地形
	["tw_iscontinuous"] = function(inst, dist, theta, other)
		local x0,y0,z0 = tw_getforwardpos(inst, dist, theta, other):Get()
		return tw_isonland(inst) == tw_isonland(inst, x0,y0,z0)
	end,

}