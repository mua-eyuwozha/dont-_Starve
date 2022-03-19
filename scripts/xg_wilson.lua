--[[
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
AddPlayerPostInit(function(self) 
	local equip = self.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
	if equip and equip:HasTag("hollow_knight") then
		if not self.components.soul_sanctuary then
			self:AddComponent("soul_sanctuary")
		end
	end
	self:ListenForEvent("onremove", function(inst,data)
		local equip = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if equip:HasTag("hollow_knight") then
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
				fragile:Remove
			elseif strong then
				owner.components.health.maxhealth = owner.components.health.maxhealth - strong.maxhealth
			end
			local fragile1 = inst.components.container:FindItem(function(item)
				if item:HasTag("fragile_greedy") then
					return true
				end
			end)
			if fragile1 then
				fragile1:Remove
			end
		end
	end)
end)
--]]