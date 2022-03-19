local STRINGS = GLOBAL.STRINGS -- 预设置，不管modmain中有没有相同的预设置，这里都是一个独立的模块环境。
local TUNING = GLOBAL.TUNING

STRINGS.NAMES.AWAKEN = "契约胜利之剑"  --名字
STRINGS.RECIPE_DESC.AWAKEN = "亚瑟王的传说道具"  --在制造栏的介绍
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AWAKEN = "英雄永不腐朽"  --人物检查物品时的对话

STRINGS.NAMES.DARK = "契约胜利之剑:黑暗"
STRINGS.RECIPE_DESC.DARK = "亚瑟王的传说黑暗道具"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DARK = "英雄正在腐化"

STRINGS.NAMES.QUAKE = "雷神之锤"
STRINGS.RECIPE_DESC.QUAKE = "雷神索尔降临于世"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.QUAKE = "正义永远主持着正义"

STRINGS.NAMES.DURON = "毒龙裁决"
STRINGS.RECIPE_DESC.DURON = "你是否以为世界只有正义？"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DURON = "巫毒腐蚀大地"

STRINGS.NAMES.BONENAIL1 = "旧骨钉"
STRINGS.RECIPE_DESC.BONENAIL1 = "圣巢的传统武器"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BONENAIL1 = "它的刀刃因老化和磨损变钝了"

STRINGS.NAMES.BONENAIL2 = "锋利骨钉"
STRINGS.RECIPE_DESC.BONENAIL2 = "圣巢的传统武器"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BONENAIL2 = "恢复到了致命形态"

STRINGS.NAMES.BONENAIL3 = "开槽骨钉"
STRINGS.RECIPE_DESC.BONENAIL3 = "圣巢的裂槽武器"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BONENAIL3 = "刀刃极其平衡"

STRINGS.NAMES.BONENAIL4 = "螺纹骨钉"
STRINGS.RECIPE_DESC.BONENAIL4 = "圣巢的强大武器"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BONENAIL4 = "精制程度超越所有其他武器"

STRINGS.NAMES.BONENAIL5 = "纯粹骨钉"
STRINGS.RECIPE_DESC.BONENAIL5 = "圣巢的终极武器"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BONENAIL5 = "这枚古老的骨钉展现出它的真实形态"

STRINGS.NAMES.STEEL = "陨铁"
STRINGS.RECIPE_DESC.STEEL = "锻造而成的精致材料"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STEEL = "矮人精品"

STRINGS.NAMES.TOOL = "万能工具"
STRINGS.RECIPE_DESC.TOOL = "偷懒必备佳品"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TOOL = "简直离谱"

local function GetKeyFromConfig(config)
    local key = GetModConfigData(config)
    return key and (type(key) == "number" and key or GLOBAL[key])
end

TUNING.AWAKEN_PF = GetModConfigData("AWAKEN_PF") -- 开启契约胜利之剑制造
TUNING.AWAKEN_DAMAGE = GetModConfigData("AWAKEN_DAMAGE") -- 契约胜利之剑伤害
TUNING.DARK_PF = GetModConfigData("DARK_PF")
TUNING.DARK_DAMAGE = GetModConfigData("DARK_DAMAGE")
TUNING.QUAKE_PF = GetModConfigData("QUAKE_PF")
TUNING.QUAKE_DAMAGE = GetModConfigData("QUAKE_DAMAGE")
TUNING.DURON_PF = GetModConfigData("DURON_PF")
TUNING.DURON_DAMAGE = GetModConfigData("DURON_DAMAGE")
TUNING.BONENAIL1_PF = GetModConfigData("BONENAIL1_PF")
TUNING.BONENAIL1_DAMAGE = GetModConfigData("BONENAIL1_DAMAGE")
TUNING.TOOL_PF = GetModConfigData("TOOL_PF") -- 开启贝爷的小刀制造
TUNING.HOLLOW_KNIGHT_CLOAK_DASH_KEY = GetKeyFromConfig("HOLLOW_KNIGHT_CLOAK_DASH_KEY")