--[[
local function onmaxsoul(self)
	self.inst.net_maxsoul:set(self.maxsoul)
end

local function onsoul(self)
	self.inst.net_soul:set(self.soul)
end

local function onhpup(self)
	if self.hpup then
		local health = self.inst.components.health
		health.maxhealth = 300
		health:SetPercent(health:GetPercent())
	end
end

local Soul_sanctuary = Class(function(self, inst)
    self.inst = inst
    self.maxsoul = 1000		
	self.soul = 0
	self.hpup = false			--生命提升
end,
nil,
{
	maxsoul = onmaxsoul,
	soul = onsoul,
	hpup = onhpup
})

function Soul_sanctuary:GetSoul()
	return self.soul or 0
end

function Soul_sanctuary:SetMaxsoul(number)
	self.maxsoul = number
end

function Soul_sanctuary:SetVal(val)
	self.soul = math.clamp(val, 0, self.maxsoul)
end

function Soul_sanctuary:DoDelta(number)
	self:SetVal(self.soul + number)
end

function Soul_sanctuary:GetPercent()
    return self.soul / self.maxsoul
end

function Soul_sanctuary:SetPercent(percent)
    self:SetVal(self.maxsoul * percent)
end

function Soul_sanctuary:OnSave()
	return {
		loadsoul = self.soul,
		loadmaxsoul = self.maxsoul,
		loadhpup = self.hpup
	}
end

function Soul_sanctuary:OnLoad(data)
	if data then
        self.soul = data.loadsoul
		self.maxsoul = data.loadmaxsoul
		self.hpup = data.loadhpup
    end
end

return Soul_sanctuary
--]]