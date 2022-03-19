local ParryWeapon = Class(function(self, inst)
    self.inst = inst
    self.onparrystart = nil
	self.onparryend = nil
    self.duration = 2
    inst:AddTag("parryweapon")
end)
function ParryWeapon:SetOnParryStartFn(fn)
    self.onparrystart = fn
end
function ParryWeapon:SetOnParryEndFn(fn)
	self.onparryend = fn
end
function ParryWeapon:OnPreParry(owner)
    if owner.sg then
        owner.sg:PushEvent("start_parry")
    end 
    if self.onparrystart then
        self.onparrystart(self.inst, owner)
    end
	if self.duration == 0 then
		self.onparryend(self.inst,owner)
	end
end

function ParryWeapon:TryParry(owner, e, f, g, h)
    if owner.sg then
        owner.sg:PushEvent("try_parry")
    end 
    if self.ontryparry then
        return self.ontryparry(owner, e, f, g, h)
    end 
    local i = e or g
    local j = owner.Transform:GetRotation() - owner:GetAngleToPoint(i.Transform:GetWorldPosition())
    if not (math.abs(j) <= 70) then
        return false
    end 
    local k = i.components.weapon and i.components.weapon.damagetype or i.components.combat and i.components.combat.damagetype or nil
    if not (k == 1) then
        return false
    end 
    return true
end

return ParryWeapon