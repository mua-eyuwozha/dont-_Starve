GLOBAL.knight_function = {
	--[[
	["green_son"] = function 
	
	end,
	["rapidcoagulation"] = function
	
	end,
	--]]
	--生命值大于50在战斗时自动消耗10点生命值产生一个小虫子，可以为人物免疫一次伤害，然后消失
	["luminousuterus"] = function (inst,owner,target,badge)
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z,10,{"stalkerminion"})
		for k,v in pairs(ents) do
			print("999")
			if v and v:HasTag("stalkerminion") then
				print("aaa")
				return
			elseif v == nil or (v and not v:HasTag("stalkerminion")) then
				print("sss")
				if owner.components.health.currenthealth > 50 then
					owner.components.health:DoDelta(-10)
					local minion = SpawnPrefab("stalker_minion")
					minion.Transform:SetPosition(owner.Transform:GetWorldPosition())
					minion:ForceFacePoint(x,y,z)
					minion:OnSpawnedBy(inst)
				else
					owner.components.talker:Say("你是想死了吗？")
				end
				owner:ListenForEvent("attacked", function()
					if minion and owner.components.health and owner.components.combat and inst.components.rechargeable.isready == true then
						minion.components.health:IsDead()
						inst.components.rechargeable:StartRecharge()
						inst.components.resistance:SetShouldResistFn(function(inst,owner)
							--获取武器主人
							--local owner = inst.components.inventoryitem.owner
							return owner ~= nil
								and not (owner.components.inventory ~= nil and
										owner.components.inventory:EquipHasTag("forcefield"))
						end)
						inst.components.resistance:SetOnResistDamageFn(function(inst,owner)
							--获取武器主人
							--local owner = inst.components.inventoryitem:GetGrandOwner() or inst
							local fx = SpawnPrefab("shadow_shield"..tostring(PickShield(inst)))
							fx.entity:SetParent(owner.entity)
							--inst.components.resistance:SetOnResistDamageFn(nil)
						end)
					end
				end)
			end
		end
	end,
	--[[
	[""] = function()
		
	end,
	--]]
	--[[
	--消耗大量的灵魂值，产生出大量的小虫子，概率会诞生后直接死亡，剩下的可以为人物免疫一次伤害。
	["trematodenest"] = function
	
	end,
	--]]
}
