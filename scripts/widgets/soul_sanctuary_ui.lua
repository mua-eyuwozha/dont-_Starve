--[[
local Badge = require "widgets/badge"

local soul_sanctuary_ui = Class(Badge, function(self, owner)
	Badge._ctor(self, "soul_sanctuary", owner)
	self.anim:GetAnimState():SetBank("health")
    self.anim:GetAnimState():SetBuild("soul_sanctuary")
    self.anim:GetAnimState():PlayAnimation("anim")
	self:StartUpdating()
end)

function soul_sanctuary_ui:OnUpdate(dt)
	local soul = self.owner.net_soul:value()
	local maxsoul = self.owner.net_maxsoul:value()
	self:SetPercent(soul/maxsoul, maxsoul)
end

return soul_sanctuary_ui
--]]