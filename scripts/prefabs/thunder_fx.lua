local fxassets =
{
    Asset("ANIM", "anim/thunder_fx.zip"),
}
local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst:AddTag("FX")
    inst.entity:SetCanSleep(false)
    
    inst.AnimState:SetBank("thunder_fx")
    inst.AnimState:SetBuild("thunder_fx")	
	inst.AnimState:PlayAnimation("loop",true)
	inst.AnimState:SetScale(1, 1)
    inst.AnimState:SetFinalOffset(0)
    --inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( 998)
    inst.AnimState:SetSortOrder(999)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
	-- inst:ListenForEvent("animqueueover", function(inst,data)
		-- inst:DoTaskInTime(0.5,inst.Remove)
	-- end)
    return inst
end

return Prefab("thunder_fx", fxfn, fxassets)
