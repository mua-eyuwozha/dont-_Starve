AddPrefabPostInit("moonpulse2_fx",function(inst)
	----物理
	local period = 1/30
	inst.collide_task_table = {}
	inst:DoPeriodicTask(period, function() -- 定期任务：反复生效
	--period是1/10，特效持续10s则一秒造成六次伤害，执行十次，共六十次伤害。上面的表就是为了排除已经攻击过的对象防止流血伤害
		local pt = inst:GetPosition()
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 6,nil,{"player","follower"},nil)
		
		for k,v in pairs(ents) do
			local health = v.components.health
			local combat = v.components.combat
			local freezable = v.components.freezable
			if v and health and not health:IsDead() and combat and v ~= inst and
				not (v.components.follower and v.components.follower.leader == inst ) and 
				(TheNet:GetPVPEnabled() or not v:HasTag("player")) then
				if not table.contains(inst.collide_task_table, v.GUID) then
					combat:GetAttacked(inst, 50)
					table.insert(inst.collide_task_table, v.GUID)
				end
			end
		end
	end)
	
	inst:DoTaskInTime(1, function()
		if inst then 
			inst:Remove()
		end
	end)
end)

AddPrefabPostInit("hammer_mjolnir_cracklehit",function(inst)
	inst:ListenForEvent("animover", inst.Remove)
end)