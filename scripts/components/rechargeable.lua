local Rechargeable = Class(function(self, inst)
    self.inst = inst
    self.recharge = 255
    self.rechargetime = -2
    self.maxrechargetime = 30
    self.cooldownrate = 1
    self.isready = true
    self.updatetask = nil
    self.onready = nil
    self.pickup = false
    self.onequip = function(inst, c)
        self:RecalculateRate()
    end
    self.inst:ListenForEvent("equipped", function(inst, c)
        self.owner = c.owner
        self:RecalculateRate()
        if self.updatetask == nil then
            self.pickup = true
            self:StartRecharge()
        end 
        self.inst:ListenForEvent("equip", self.onequip, self.owner)
        self.inst:ListenForEvent("unequip", self.onequip, self.owner)
    end)
    self.inst:ListenForEvent("unequipped", function(inst, c)
        self.inst:RemoveEventCallback("equip", self.onequip, self.owner)
        self.inst:RemoveEventCallback("unequip", self.onequip, self.owner)
        if self.pickup and self.updatetask ~= nil then
            self.pickup = false;
            self.updatetask:Cancel()
            self.updatetask = nil
        end
        self.cooldownrate = 1
        self.owner = nil
    end)
end)

function Rechargeable:SetRechargeTime(number)
    self.maxrechargetime = number
end

function Rechargeable:SetOnReadyFn(e)
    self.onready = e
end

function Rechargeable:RecalculateRate()
    if self.owner ~= nil then
        self.cooldownrate = 1 + self.owner.components.buffable:GetBuffData("cooldown_mult")
        if self.updatetask ~= nil then
            self.inst.replica.inventoryitem:SetChargeTime(self:GetRechargeTime())
        end
    end
end

function Rechargeable:FinishRecharge()
    if self.updatetask ~= nil then
        self.updatetask:Cancel()
        self.updatetask = nil
    end
    self.isready = true
    if self.inst.components.aoetargeting then
        self.inst.components.aoetargeting:SetEnabled(true)
    end
    if self.onready then
        self.onready(self.inst)
    end
    self.pickup = false
    self.recharge = 255
    self.inst:PushEvent("rechargechange", { percent = self.recharge and self.recharge / 180, overtime = false })
end

function Rechargeable:Update()
    self.recharge = self.recharge + 180 * FRAMES / (self.rechargetime * (self.pickup and 1 or self.cooldownrate))
    if self.recharge >= 180 then
        self:FinishRecharge()
    end
end

function Rechargeable:StartRecharge()
    self.isready = false
    if self.inst.components.aoetargeting then
        self.inst.components.aoetargeting:SetEnabled(false)
    end
    self.rechargetime = self.pickup and 1 or self.maxrechargetime
    self.recharge = 0
    self:RecalculateRate()
    self.inst:DoTaskInTime(0, function()
        self.inst.replica.inventoryitem:SetChargeTime(self:GetRechargeTime())
        self.inst:PushEvent("rechargechange", { percent = self.recharge and self.recharge / 180, overtime = false })
        self.updatetask = self.inst:DoPeriodicTask(FRAMES, function()
            self:Update()
        end)
    end)
end

function Rechargeable:GetPercent()
    return self.recharge and self.recharge / 180, false
end

function Rechargeable:GetRechargeTime()
    return self.pickup and 1 or self.maxrechargetime * self.cooldownrate
end

function Rechargeable:GetDebugString()
    return string.format("recharge: %2.2f, rechargetime: %2.2f, cooldownrate: %2.2f", self.recharge, self:GetRechargeTime(), self.cooldownrate)
end

return Rechargeable