local G = GLOBAL
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
GLOBAL.leveldb = {}
GLOBAL.awakeniddb = {}
GLOBAL.awakenuserdb = {}
GLOBAL.darkuserdb = {}
-- local require = G.require -- 可以使用require，默认从scripts文件夹下开始找
-- local Ingredient = G.Ingredient
-- local RECIPETABS = G.RECIPETABS -- 制作栏相关
-- local TECH = G.TECH -- 科技相关
-- local STRINGS = G.STRINGS -- 物品描述的预设置
-- local ACTIONS = G.ACTIONS -- 动作相关预制变量
-- local ActionHandler = G.ActionHandler -- 动作相关的预制变量


modimport("scripts/all_function")
modimport("scripts/knight_function")
modimport("scripts/prefab_desc") -- 导入其它代码文件，路径从Mod根目录开始
modimport("scripts/sg_atk") -- 导入动作
modimport("scripts/xg_fx")
modimport("scripts/add_components")
modimport("scripts/command")
modimport("scripts/xg_containers")
PrefabFiles = {
"weapons",
"material",
"tool",
"thunder_fx",
}  --添加预制物文件

Assets = {
	Asset("IMAGE", "images/eyuwozha.tex" ),
    Asset("ATLAS", "images/eyuwozha.xml" ),
	
	Asset("IMAGE", "images/inventoryimages/icon_awaken.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_awaken.xml"),
	
	Asset("IMAGE", "images/inventoryimages/steel.tex" ),
	Asset("ATLAS", "images/inventoryimages/steel.xml"),
	
	Asset("IMAGE", "images/inventoryimages/green_son.tex" ),
	Asset("ATLAS", "images/inventoryimages/green_son.xml"),
	
	Asset("IMAGE", "images/inventoryimages/rapidcoagulation.tex" ),
	Asset("ATLAS", "images/inventoryimages/rapidcoagulation.xml"),
	
	Asset("IMAGE", "images/inventoryimages/luminousuterus.tex" ),
	Asset("ATLAS", "images/inventoryimages/luminousuterus.xml"),
	
	Asset("IMAGE", "images/inventoryimages/trematodenest.tex" ),
	Asset("ATLAS", "images/inventoryimages/trematodenest.xml"),
	
	Asset("IMAGE", "images/inventoryimages/fragile_heart.tex" ),
	Asset("ATLAS", "images/inventoryimages/fragile_heart.xml"),
	
	Asset("IMAGE", "images/inventoryimages/strong_heart.tex" ),
	Asset("ATLAS", "images/inventoryimages/strong_heart.xml"),
	
	Asset("IMAGE", "images/inventoryimages/fragile_greedy.tex" ),
	Asset("ATLAS", "images/inventoryimages/fragile_greedy.xml"),
	
	Asset("IMAGE", "images/inventoryimages/strong_greedy.tex" ),
	Asset("ATLAS", "images/inventoryimages/strong_greedy.xml"),
	
	Asset("IMAGE", "images/inventoryimages/fragile_damage.tex" ),
	Asset("ATLAS", "images/inventoryimages/fragile_damage.xml"),
	
	Asset("IMAGE", "images/inventoryimages/strong_damage.tex" ),
	Asset("ATLAS", "images/inventoryimages/strong_damage.xml"),
	
	Asset("IMAGE", "images/inventoryimages/icon_tool.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_tool.xml"),
	
	Asset("IMAGE", "images/inventoryimages/icon_dark.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_dark.xml"),
	
	Asset("IMAGE", "images/inventoryimages/icon_quake.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_quake.xml"),
	
	Asset("IMAGE", "images/inventoryimages/icon_duron.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_duron.xml"),
	
	Asset("IMAGE", "images/inventoryimages/icon_bonenail1.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_bonenail1.xml"),
	
	Asset("IMAGE", "images/inventoryimages/icon_bonenail2.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_bonenail2.xml"),
	
	Asset("IMAGE", "images/inventoryimages/icon_bonenail3.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_bonenail3.xml"),
	
	Asset("IMAGE", "images/inventoryimages/icon_bonenail4.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_bonenail4.xml"),
	
	Asset("IMAGE", "images/inventoryimages/icon_bonenail5.tex" ),
	Asset("ATLAS", "images/inventoryimages/icon_bonenail5.xml"),
	
}  --载入资源

--AddMinimapAtlas("images/inventoryimages/icon_awaken.xml") -- 在地图添加可视图标


RECIPETABS.EYUWOZHA = {str = "EYUWOZHA", sort = 19, icon = "eyuwozha.tex", icon_atlas = "images/eyuwozha.xml"}--制造栏图标
--local EYUWOZHA = AddRecipeTab("EYUWOZHA", 798, "images/hud/EYUWOZHA.xml", "EYUWOZHA.tex")第二种制作栏图标的方法

local steel=AddRecipe("steel", -- 添加配方的api
	{Ingredient("goose_feather",1),Ingredient("moonrocknugget",1)},
	RECIPETABS.EYUWOZHA,  TECH.SCIENCE_TWO,
	nil, nil, nil, nil, nil,
	"images/inventoryimages/steel.xml",
	"steel.tex"
)
if TUNING.TOOL_PF then
	local tool=AddRecipe("tool",
		{Ingredient("multitool_axe_pickaxe",8),Ingredient("glommerfuel",20),Ingredient("glommerwings",5)},
		RECIPETABS.EYUWOZHA,  TECH.SCIENCE_TWO,
		nil, nil, nil, nil, nil,
		"images/inventoryimages/icon_tool.xml",
		"icon_tool.tex"
	)
end
if TUNING.AWAKEN_PF then
	local awaken=AddRecipe("awaken",  --添加物品的配方
		{Ingredient("steel", 50,"images/inventoryimages/steel.xml"),
		Ingredient("rocks", 500),Ingredient("shadowheart", 1)},  --材料
		RECIPETABS.EYUWOZHA,  TECH.SCIENCE_TWO,  --制作栏和解锁的科技（这里是eyuwozha，需要科学二本）
		--具体可查看/scripts/constants.lua
		nil, nil, nil, nil, nil,  --是否有placer  是否有放置的间隔  科技锁  制作的数量（改成2就可以一次做两个） 需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
		"images/inventoryimages/icon_awaken.xml",  --配方的贴图（跟物品栏使用同一个贴图）
		"icon_awaken.tex"
	)
end
if TUNING.DARK_PF then
	local dark=AddRecipe("dark", 
		{Ingredient("steel", 50,"images/inventoryimages/steel.xml"),
		Ingredient("rocks", 500),Ingredient("walrus_tusk", 3)},
		RECIPETABS.EYUWOZHA,  TECH.SCIENCE_TWO, 
		nil, nil, nil, nil, nil, 
		"images/inventoryimages/icon_dark.xml",
		"icon_dark.tex"
	)
end
if TUNING.QUAKE_PF then
	local quake=AddRecipe("quake", 
		{Ingredient("steel", 50,"images/inventoryimages/steel.xml"),
		Ingredient("rocks", 500),Ingredient("glommerfuel", 3)}, 
		RECIPETABS.EYUWOZHA,  TECH.SCIENCE_TWO, 
		nil, nil, nil, nil, nil,
		"images/inventoryimages/icon_quake.xml",
		"icon_quake.tex"
	)
end

if TUNING.DURON_PF then
	local duron=AddRecipe("duron", 
		{Ingredient("steel", 50,"images/inventoryimages/steel.xml"),
		Ingredient("rocks", 500),Ingredient("glommerfuel", 3)},
		RECIPETABS.EYUWOZHA,  TECH.SCIENCE_TWO,  
		nil, nil, nil, nil, nil, 
		"images/inventoryimages/icon_duron.xml", 
		"icon_duron.tex"
	)
end

if TUNING.BONENAIL1_PF then
	local bonenail1=AddRecipe("bonenail1", 
		{Ingredient("steel", 50,"images/inventoryimages/steel.xml"),
		Ingredient("rocks", 500),Ingredient("glommerfuel", 3)},
		RECIPETABS.EYUWOZHA,  TECH.SCIENCE_TWO,  
		nil, nil, nil, nil, nil, 
		"images/inventoryimages/icon_bonenail1.xml", 
		"icon_bonenail1.tex"
	)
end


















