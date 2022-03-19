GLOBAL.setmetatable(env,{__index = function(t, k)return GLOBAL.rawget(GLOBAL, k) end})
local containers = require "containers"
local params = containers.params
local bank = {
	"bonenail1",
	"bonenail2",
	"bonenail3",
	"bonenail4",
	"bonenail5",
}
params.bonenail1 = {
    widget = {
        slotpos = {},
        animbank = "",
        animbuild = "",
        pos = Vector3(320, -350, 0),
        side_align_tip = 160
    },
    type = "pack",
    acceptsstacks = false,
	openlimit = 1,
}
function params.bonenail1.itemtestfn(container, item, slot)
    if item:HasTag("badge") then
		return true
    end
end

for x = 0, 1 do
	table.insert(params.bonenail1.widget.slotpos, Vector3(75 * x - 75, 0, 0))
end

params.bonenail2 = {
    widget = {
        slotpos = {},
        animbank = "",
        animbuild = "",
        pos = Vector3(300, -350, 0),
        side_align_tip = 160
    },
    type = "pack",
    acceptsstacks = false,
	openlimit = 1,
}
function params.bonenail2.itemtestfn(container, item, slot)
    if item:HasTag("badge") then
        return true
    end
end

for x = 0, 2 do
	table.insert(params.bonenail2.widget.slotpos, Vector3(75 * x - 75, 0, 0))
end

params.bonenail3 = {
    widget = {
        slotpos = {},
        animbank = "",
        animbuild = "",
        pos = Vector3(275, -350, 0),
        side_align_tip = 160
    },
    type = "pack",
    acceptsstacks = false,
	openlimit = 1,
}
function params.bonenail3.itemtestfn(container, item, slot)
    if item:HasTag("badge") then
        return true
    end
end
for x = 0, 3 do
	table.insert(params.bonenail3.widget.slotpos, Vector3(75 * x - 75, 0, 0))
end

params.bonenail4 = {
    widget = {
        slotpos = {},
        animbank = "",
        animbuild = "",
        pos = Vector3(275, -300, 0),
        side_align_tip = 160
    },
    type = "pack",
    acceptsstacks = false,
	openlimit = 1,
}
function params.bonenail4.itemtestfn(container, item, slot)
    if item:HasTag("badge") then
        return true
    end
end
for y = 0,1 do
    for x = 0, 3 do
        table.insert(params.bonenail4.widget.slotpos, Vector3(75 * x - 75, 75 * y - 75, 0))
    end
end

params.bonenail5 = {
    widget = {
        slotpos = {},
		--ui_chester_shadow_3x4
        animbank = "",
        animbuild = "",
        pos = Vector3(275, -300, 0),
        side_align_tip = 160
    },
    type = "pack",
    acceptsstacks = false,
	openlimit = 1,
}
function params.bonenail5.itemtestfn(container, item, slot)
    if item:HasTag("badge") then
        return true
    end
end
for y = 0, 1 do
    for x = 0, 3 do
        table.insert(params.bonenail5.widget.slotpos, Vector3(75 * x - 75, 75 * y - 75, 0))
    end
end

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local prefab = {
	"bonenail1",
	"bonenail2",
	"bonenail3",
	"bonenail4",
	"bonenail5",
}
for k,v in ipairs(prefab) do
	AddPrefabPostInit(v,function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			inst:DoTaskInTime(0, function()
				if inst.replica then
					if inst.replica.container then
						inst.replica.container:WidgetSetup(v)
					end
				end
			end)
			return inst
		end
		if GLOBAL.TheWorld.ismastersim then
			if not inst.components.container then
				inst:AddComponent("container")
				inst.components.container:WidgetSetup(v)
			end
		end
	end)
end