local function fn(colour)
    return colour[1] or 0, colour[2] or 0, colour[3] or 0, 0
end
local ColourFader = Class(function(self, inst)
    self.inst = inst
    self.current_colour = { 0, 0, 0, 0 }
    self.target_colour = { 0, 0, 0, 0 }
    self.callback = nil
    self.time = nil
    self.timepassed = 0
end)
function ColourFader:EndFade()
    self.inst:StopUpdatingComponent(self)
    self.current_colour = self.target_colour
    self.inst.AnimState:SetAddColour(fn(self.target_colour))
    self.time = nil
    if self.callback then
        self.callback(self.inst)
    end
end
function ColourFader:StartFade(colour, times, back)
    self.callback = back
    self.target_colour = colour
    self.time = times
    self.timepassed = 0
    if self.time > 0 then
        self.inst:StartUpdatingComponent(self)
    else
        self:EndFade()
    end
end
function ColourFader:SetCurrentFade(colour)
    self.current_colour = colour
end
function ColourFader:OnUpdate(times)
    self.timepassed = self.timepassed + times
    local timenum = self.timepassed / self.time
    if timenum > 1 then
        timenum = 1
    end 
    local colour = {}
    for i = 1, 3 do
        table.insert(colour, Lerp(self.current_colour[i], self.target_colour[i], timenum))
    end 
    self.inst.AnimState:SetAddColour(fn(colour))
    if self.timepassed >= self.time then
        self:EndFade()
    end
end
return ColourFader