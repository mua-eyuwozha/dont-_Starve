local Leave = Class(function(self, inst)
	--调用者
    self.inst = inst
	--等级
	self.level = 1
	--最大等级
	self.maxlevel = 50
	--初始化经验值
	self.exp = 0
	--升级所需经验
	self.exptotal = 200
	--限制等级
	self.blocklevel = 6
	--解锁条件
	self.lock = 1
	--注入指数，多次给予物品累计
	self.injection = 1
	--跳出循环
	self.jumpout = 0
	--初始化攻击力
	self.damage = 0
	--实际攻击力
	self.dmg = 0
	--移速
	self.runspeed = 0
	self.inst:AddTag("level")
end)

--更新等级效果
local function applyupgrades(self)
    self.level = math.min(self.level, self.maxlevel)
	self.dmg = self.damage + self.level - 1
	if self.inst:HasTag("weapon") and self.inst then
		self.inst.components.weapon:SetDamage(self.dmg)
		self.inst.components.equippable.walkspeedmult = math.min(self.level * 0.01 + 1,1.5)
	end
	self.inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
end

--设置最大等级,升级所需经验,阻断等级,攻击力
function Leave:SetMaxlevel(damage,exptotal,blocklevel,maxlevel)
	if damage then
		self.damage = damage
	elseif exptotal then
		self.exptotal = exptotal
	elseif blocklevel then
		self.blocklevel = blocklevel
	elseif maxlevel then
		self.maxlevel = maxlevel
	end
	applyupgrades(self)
end

--获取信息
function Leave:GetLevel(inst,data)
	inst.levels = {
		level = self.level,
		maxlevel = self.maxlevel,
		exps = self.exp,
		exptotal = self.exptotal,
		blocklevel = self.blocklevel,
		lock = self.lock,
		injection = self.injection,
		dmg = self.dmg,
		userid = self.userid,
		--runspeed = self.runspeed,
	}
	if inst and inst:HasTag("awaken") then
		local id = inst.GUID
		table.insert(awakeniddb,id)
		table.insert(awakenuserdb,inst.levels.userid)
		leveldb[id] = inst.levels
	end
	if inst and inst:HasTag("dark") then
		table.insert(darkuserdb,inst.levels.userid)
	end
	return inst.levels
end

function Leave:GiveUserid(id)
	self.userid = id
	self.inst.components.level:OnSave()
	self.inst.components.level:GetLevel(self.inst)
end

--一键升级
function Leave:CommandLevel(number)
	self.level = self.level + number
	applyupgrades(self)
	self.inst.components.level:OnSave()
	self.inst.components.level:GetLevel(self.inst)
end

--[[
function Leave:Builder_OnBuilt(inst,builder)
	inst:ListenForEvent("builditem", function(inst,data)
		table.insert(awakenuserdb,data.builder.userid)
	end)
end
--]]

local exp = {
	--鹿鸭
	[0] = function(self,target)
		if target:HasTag("moose") then
			self.exp = self.exp + 50
			self.jumpout = 1
		end
	end,
	--蚁狮
	[1] = function(self,target)
		if target:HasTag("antlion") then
			self.exp = self.exp + 50
			self.jumpout = 1
		end
	end,
	--熊大
	[2] = function(self,target)
		if target:HasTag("bearger") then
			self.exp = self.exp + 50
			self.jumpout = 1
		end
	end,
	--巨鹿
	[3] = function(self,target)
		if target:HasTag("deerclops") then
			self.exp = self.exp + 50
			self.jumpout = 1
		end
	end,
	--龙蝇
	[4] = function(self,target)
		if target:HasTag("dragonfly") then
			self.exp = self.exp + 100
			self.jumpout = 1
		end
	end,
	--邪天翁
	[5] = function(self,target)
		if target:HasTag("malbatross") then
			self.exp = self.exp + 50
			self.jumpout = 1
		end
	end,
	--蜂后
	[6] = function(self,target)
		if target:HasTag("bee")  and target:HasTag("epic") and target:HasTag("largecreature")then
			self.exp = self.exp + 100
			self.jumpout = 1
		end
	end,
	--狂暴克劳斯S
	[7] = function(self,target)
		if target:HasTag("deergemresistance") and target:HasTag("epic") and target.nohelpers then
			self.level = self.level + 2
			self.exptotal = self.exptotal + 1000
			applyupgrades(self)
			self.jumpout = 1
		end
	end,
	--克劳斯S
	[8] = function(self,target)
		if target:HasTag("deergemresistance") and target:HasTag("epic") and target.unchained then
			self.exp = self.exp + 80
			self.jumpout = 1
		end
	end,
	--帝王蟹S
	[9] = function(self,target)
		if target:HasTag("crabking") then
			self.exp = self.exp + 100
			self.jumpout = 1
		end
	end,
	--巨型毒蟾蜍
	[10] = function(self,target)
		if target:HasTag("toadstool") and target.dark then
			self.exp = self.exp + 150
			self.jumpout = 1
		end
	end,
	--毒蟾蜍
	[11] = function(self,target)
		if target:HasTag("toadstool") then
			self.exp = self.exp + 80
			self.jumpout = 1
		end
	end,
	--远古守卫者
	[12] = function(self,target)
		if target:HasTag("minotaur") then
			self.exp = self.exp + 50
			self.jumpout = 1
		end
	end,
	--远古影织者S
	[13] = function(self,target)
		if target:HasTag("stalker") and target.components.commander then
			self.exp = self.exp + 100
			self.jumpout = 1
		end
	end,
	--复活的骨架
	[14] = function(self,target)
		if target:HasTag("stalker") then
			self.exp = self.exp + 5
			self.jumpout = 1
		end
	end,
	--暗影三基佬
	[15] = function(self,target)
		if target:HasTag("shadowchesspiece") and target.level and target.level == 3 then
			self.exp = self.exp + 60
			self.jumpout = 1
		end
	end,
	--恐怖猎物,兔人也属于这类,暂时注释
	-- [15] = function(self,target)
		-- if target:HasTag("scarytoprey") then
			-- self.exp = self.exp + 30
			-- self.jumpout = 1
		-- end
	-- end,
	--EPIC怪物经验
	[16] = function(self,target)
		if target:HasTag("epic") then
			self.exp = self.exp + 50
			self.jumpout = 1
		end
	end,
	--大型生物
	[17] = function(self,target)
		if target:HasTag("largecreature") then
			self.exp = self.exp + 10
			self.jumpout = 1
		end
	end,
	--影怪,蠕虫
	[18] = function(self,target)
		if target:HasTag("nightmarecreature") or target:HasTag("worm") or target:HasTag("chess")then
			self.exp = self.exp + 5
			self.jumpout = 1
		end
	end,
	--怪物
	[19] = function(self,target)
		if target:HasTag("monster") then
			self.exp = self.exp + 0.1
			self.jumpout = 1
		end
	end,
}

--更新注入指数
function Leave:BreachInjection()
	self.injection = self.injection + 1
	self.inst.components.level:GetLevel(self.inst)
	self.inst.components.level:OnSave()
end

--已获取突破材料,更新限制等级上线
function Leave:BreachLevel()
	if self.blocklevel < self.maxlevel then
		if self.lock == 4 then
			self.lock = self.lock + 1
			self.blocklevel = self.maxlevel
			self.inst.components.level:GetLevel(self.inst)
			self.inst.components.level:OnSave()
			return
		end
		self.lock = self.lock + 1
		self.blocklevel = self.blocklevel + 10
		self.inst.components.level:GetLevel(self.inst)
		self.inst.components.level:OnSave()
	end
end

--获取经验：推荐使用在OnAttack函数中
function Leave:GetExp(attacker,target)
	if target.components.health:IsDead() and self.level < self.maxlevel then
		if self.level < self.blocklevel then
			for k,v in ipairs(exp) do
				v(self,target)
				if self.exp >= self.exptotal then
					self.level = self.level + 1
					self.exptotal = self.exptotal + 500
					applyupgrades(self)
					self.inst.components.level:OnSave()
				end
				self.inst.components.level:GetLevel(self.inst)
				attacker.components.talker:Say("当前经验:" .. self.exp .. "\r\n等级:"..self.level.."\r\n伤害:"..self.dmg)
				if self.jumpout == 1 then
					self.jumpout = 0
					return
				end
			end
		else
			attacker.components.talker:Say("请先突破!\r\n当前经验:" .. self.exp .. "\r\n等级:"..self.level.."\r\n伤害:"..self.dmg)
		end
	end
end



--保存信息
function Leave:OnSave(data)
	--all_function.onsave(data)
	return
	{
		loadlevel = self.level,
		loadmaxlevel = self.maxlevel,
		loadexp = self.exp,
		loadexptotal = self.exptotal,
		loadblocklevel = self.blocklevel,
		loadlock = self.lock,
		loadinjection = self.injection,
		loaddamage = self.dmg,
		loadrunspeed = self.runspeed,
		loaduserid = self.userid,
	}
end

--加载信息
function Leave:OnLoad(data)
	if data then
		local inst = self.inst
		self.level = data.loadlevel
		self.maxlevel = data.loadmaxlevel
		self.exp = data.loadexp
		self.exptotal = data.loadexptotal
		self.lock = data.loadlock
		self.injection = data.loadinjection
        self.dmg = data.loaddamage
		self.runspeed = data.loadrunspeed
		self.userid = data.loaduserid
		--inst.net_level_hr:set(self.level)
		
		applyupgrades(self)
		self.inst.components.level:GetLevel(inst)
    end
end


return Leave