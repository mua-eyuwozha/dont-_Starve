local Buffable = Class(function(self, inst)
    self.inst = inst
    self.data = {}
    self.buffs = {}
end)
function Buffable:AddBuff(c, d)
    if self.buffs[c] ~= nil then
        self:RemoveBuff(c)
    end
    self.buffs[c] = {}
    for k, v in pairs(d) do
        if not self.data[k] then
            self.data[k] = {}
        end
        self.data[k][c] = v
        table.insert(self.buffs[c], k)
    end
end
function Buffable:GetBuffData(e)
    local f = 0
    if self:HasBuffData(e) then
        for k, v in pairs(self.data[e]) do
            f = f + v
        end
    end
    return f
end
function Buffable:HasBuff(c)
    return self.buffs[c] ~= nil
end
function Buffable:HasBuffData(c)
    return self.data[c] ~= nil
end
function Buffable:RemoveBuff(c)
    for i, e in pairs(self.buffs[c]) do
        self.data[e][c] = nil
        if GetTableSize(self.data[e]) < 1 then
            self.data[e] = nil
        end
    end
    self.buffs[c] = nil
end
return Buffable