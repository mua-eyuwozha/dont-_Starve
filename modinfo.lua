name = "戒网中心"  --mod的名字
description = "制作一些增加游戏可玩性的装备，暂时处于测试阶段。\n欢迎各位在体验mod后，加群反馈bug。\n群号：1014131726。\n本mod会持续更新，敬请期待。\n注：本mod禁止以任何形式在steam和wegame平台上转载，所有图片、动画禁止抄袭搬运。\n本mod也希望招揽码师一位，如果有兴趣的小伙伴可以加群联系我。"   --mod介绍
author = "代码:mua尔虞我诈	画师:小猫Giovanni"  --作者
version = "1.0"  --版本号
forumthread = ""  --网址，暂且留空
api_version = 10  --mod的API版本，联机目前固定为10

dst_compatible = true  --用于判断是否和饥荒联机版兼容，兼容true，不兼容false
dont_starve_compatible = false
reign_of_giants_compatible =  false  --9,10行用于判定是否和饥荒单机版兼容，兼容true，不兼容false
all_clients_require_mod = true  --是否需要拥有本mod才可以进入服务器，是true，否false。默认情况需要设置为true才可以。
--要求所有客户端都下载此Mod。当有需要发送给客户端的自定义数据时，此项为true。所谓自定义数据有两类，
--一是自定义动画和图片，二是自定义的网络变量。

icon_atlas = "modicon.xml"
icon = "modicon.tex"  --确定mod图标文件

server_filter_tags = {
"item",
"character",
}  --服务器确定mod标签，character是人物，item是物品，pet是宠物
-- 服务器过滤标签，会在其他人使用标签筛选功能时起作用，标签可以写英文也可以写中文，可以添加多个标签。
local keys = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V",
	"W","X","Y","Z","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","LAlt","RAlt","LCtrl","RCtrl",
	"LShift","RShift","Tab","Capslock","Space","Minus","Equals","Backspace","Insert","Home","Delete","End",
	"Pageup","Pagedown","Print","Scrollock","Pause","Period","Slash","Semicolon","Leftbracket","Rightbracket",
	"Backslash","Up","Down"
}
local keylist = {}
local string = ""
for i = 1, #keys do
    keylist[i] = {description = keys[i], data = "KEY_"..string.upper(keys[i])}
end

configuration_options = -- 设置选项，可以在Mod选择界面对Mod的一些参数进行选择。这些参数可以在modmain里用GetModConfigData方法读取
{-- 这个表中的每一个元素都是一行选项
    { -- 一个选项用一张表括起来
        name = "AWAKEN_PF", -- 选项的标识，对应GetModConfigData的第一个参数
        label = "契约胜利之剑制造", -- 选项的名称
        hover = "开启后可制造契约胜利之剑", -- 提示说明，当鼠标移动到label上时会自动弹出
        options = -- 选项内容，每个元素代表一个选项值
        {
            {description = "开", data = true}, -- dscripttion是显示在设置面板上的值，data是实际对应的取值
            {description = "关", data = false},
        },
        default = true, -- 选项的默认值，在选项面板点击Reset时，会把该选项的值设置为默认值
    },
	{
		name = "DARK_PF",
		label = "契约胜利之剑:黑暗制造",
		hover = "开启后可制造契约胜利之剑:黑暗",
		options =
		{
			{description = "开启(默认)", data = true},
			{description = "关闭", data = false},
		},
		default = true,
	},
	{
		name = "QUAKE_PF",
		label = "雷神之锤制造",
		hover = "开启后可制造雷神之锤",
		options =
		{
			{description = "开启(默认)", data = true},
			{description = "关闭", data = false},
		},
		default = true,
	},
	{
		name = "DURON_PF",
		label = "毒龙裁决制造",
		hover = "开启后可制造毒龙裁决",
		options =
		{
			{description = "开启(默认)", data = true},
			{description = "关闭", data = false},
		},
		default = true,
	},
	{
		name = "BONENAIL1_PF",
		label = "旧骨钉制造",
		hover = "开启后可制造旧骨钉",
		options =
		{
			{description = "开启(默认)", data = true},
			{description = "关闭", data = false},
		},
		default = true,
	},
	{
		name = "TOOL_PF",
		label = "贝爷的小刀制造",
		hover = "开启后可制造贝爷的小刀",
		options =
		{
			{description = "开启(默认)", data = true},
			{description = "关闭", data = false},
		},
		default = true,
	},
	--契约胜利之剑
	{
		name = "AWAKEN_DAMAGE",
		label = "契约胜利之剑攻击力",
		hover = "默认值为最低伤害",
		options =
		{
			{description = "40(默认)", data = 40},
			{description = "50", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
		},
		default = 40,
	},
	--契约胜利之剑:黑暗
	{
		name = "DARK_DAMAGE",
		label = "契约胜利之剑:黑暗攻击力",
		hover = "默认值为最低伤害",
		options =
		{
			{description = "60(默认)", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
		},
		default = 60,
	},
	--雷神之锤
	{
		name = "QUAKE_DAMAGE",
		label = "雷神之锤攻击力",
		hover = "默认值为最低伤害",
		options =
		{
			{description = "70(默认)", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
			{description = "110", data = 110},
		},
		default = 70,
	},
	--毒龙裁决
	{
		name = "DURON_DAMAGE",
		label = "毒龙裁决攻击力",
		hover = "默认值为最低伤害",
		options =
		{
			{description = "50(默认)", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
		},
		default = 50,
	},
	--旧骨钉
	{
		name = "BONENAIL1_DAMAGE",
		label = "旧骨钉攻击力",
		hover = "默认值为最低伤害",
		options =
		{
			{description = "15(默认)", data = 15},
			{description = "20", data = 20},
			{description = "25", data = 25},
			{description = "30", data = 30},
			{description = "35", data = 35},
		},
		default = 15,
	},
	{
		name = "HOLLOW_KNIGHT_CLOAK_DASH_KEY",
		label = "冲刺技能",
		hover = "默认值为最低伤害",
		options = keylist,
		default = "KEY_"..string.upper(keys[39]),
	},
}

