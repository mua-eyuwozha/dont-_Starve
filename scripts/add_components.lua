local insts = {
	"hivehat",
	"trident",
	"trinket_31",
	"trinket_30",
	"trinket_29",
	"trinket_28",
	"trinket_16",
	"trinket_15",
	"lavae_cocoon",
	"alterguardianhat",
}
for k,v in pairs(insts) do
	AddPrefabPostInit(v,function(inst)
		if inst and not inst.components.tradable then
			inst:AddComponent("tradable")
		end
	end)
end