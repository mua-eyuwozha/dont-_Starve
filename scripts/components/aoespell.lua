local AoeSpell = Class(function(self, inst)
    self.inst = inst
    self.spell_type = nil
    self.aoe_cast = nil
end)

function AoeSpell:SetAOESpell(cast)
    self.aoe_cast = cast
end

function AoeSpell:CanCast(inst, pos)
    local x, y, z = pos:Get()
    return self.inst.components.aoetargeting and self.inst.components.aoetargeting.alwaysvalid
            or TheWorld.Map:IsPassableAtPoint(x,y,z) and not TheWorld.Map:IsGroundTargetBlocked(pos)
end

function AoeSpell:CastSpell(inst, e)
    if self.inst.components.reticule_spawner and (self.inst.components.rechargeable and self.inst.components.rechargeable.isready) then
        self.inst.components.reticule_spawner:Spawn(e)
    end
    if self.aoe_cast then
        self.aoe_cast(self.inst, inst, e)
    end
    self.inst:PushEvent("aoe_casted", {caster = inst, pos = e})
end

function AoeSpell:SetSpellType(type)
    self.spell_type = type
end

function AoeSpell:OnSpellCast(inst, j)
    inst:PushEvent("spell_complete", { spell_type = self.spell_type })
end

return AoeSpell