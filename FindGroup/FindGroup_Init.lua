FGL={}
FGL.db={}
FGL.func={}
FGL.db.FGC={}
FGL.Interface = {}
FGL.SPACE_NAME= "FindGroup: link"
FGL.SPACE_VERSION = "3.0"
FGL.SPACE_BUILD = "3038"
FGL.Interface.Frame = FindGroupFrame
FGL.CharName, _ = UnitName("player")
FGL.RealmName, _ = GetRealmName()
FGL.ChannelName = "FindGroupChannel"
function FGL.func:IsLoad() return 1 end
function FGL.func:Version() return SPACE_VERSION end
_G[FGL.SPACE_NAME] = {}


--[[--------------------START DEFAULT PARAMETRS------------------]]--

FGL.db.defparam={
["findlistvalues"]={true,true,true,true},		-- bool false or true
["findpatches"]={true,true,true,true,true},		-- bool false or true
["createpatches"]={true,true,true,true,true},	-- bool false or true
["alarmpatches"]={true,true,true,true,true},	-- bool false or true
["needs"]={true,true,true},					-- bool false or true
["arena"]={true,true},					-- bool false or true
["alarmlist"]={},							-- serious table
["msgforparty"]="пати", 			-- string max=80 symbols
["timeleft"]=60, 			-- seconds 15, 30, 45, 60, 75, 90
["framealpha"]=100, 		-- alpha percent 20 to 100
["framealphaback"]=100,		-- alpha percent 0 to 100
["framealphafon"]=0, 		-- alpha percent 0 to 100
["framescale"]=100, 		-- alpha percent 80 to 150
["linefadesec"]=2, 			-- alpha percent 0.5 to 5
["alarminst"]=1, 			-- table 1 to max of table
["defbackground"]=1,		-- table 1 to max of table
["alarmsound"]=23, 			-- table 1 to max of table
["alarmir"]=1, 				-- table 1 to max of table
["instsplitestatus"]=1,		-- table 1 to max of table
["checksplite"]=2,			-- table 1 to max of table
["specmode"]=1,				-- table 1 to max of table
["showstatus"]=1, 			-- trigger 1 or 0
["configstatus"]=0, 		-- trigger 1 or 0
["faststatus"]=0, 			-- trigger 1 or 0
["pinstatus"]=0, 			-- trigger 1 or 0
["raidcdstatus"]=1, 		-- trigger 1 or 0
["changebackdrop"]=1,		-- trigger 1 or 0
["closefindstatus"]=1, 		-- trigger 1 or 0
["iconstatus"]=0, 			-- trigger 1 or 0
["channelyellstatus"]=1, 	-- trigger 1 or 0
["channelguildstatus"]=1, 	-- trigger 1 or 0
["channelfilterstatus"]=1, 	-- trigger 1 or 0
["alarmstatus"]=0,			-- trigger 1 or 0
["raidfindstatus"]=1,		-- trigger 1 or 0
["classfindstatus"]=1,		-- trigger 1 or 0
["minimapiconshow"]=1,		-- trigger 1 or 0
["minimapiconfree"]=0,		-- trigger 1 or 0
["checklider"]=1,			-- trigger 1 or 0
["checkfull"]=1,			-- trigger 1 or 0
["checkid"]=0,				-- trigger 1 or 0
["alarmcd"]=0,				-- trigger 1 or 0
["showivk"]=0,				-- trigger 1 or 0
}

--[[--------------------END DEFAULT PARAMETRS------------------]]--

-----------------------------------------------------------------------------------------------------------------------------


FGL.db.difficulties={
{name="5", 			print="", 		maxplayers=5, 		heroic=0, 		balance={1,1,3}}, 	-- 1. 5об
{name="5 гер", 		print="", 		maxplayers=5, 		heroic=1,		balance={1,1,3}}, 	-- 2. 5гер
{name="10", 		print=" 10", 	maxplayers=10, 		heroic=0,		balance={2,3,5}},	-- 3. 10об
{name="10 гер", 	print=" 10", 	maxplayers=10, 		heroic=1,		balance={2,3,5}}, 	-- 4. 10гер
{name="25", 		print=" 25", 	maxplayers=25, 		heroic=0,		balance={2,5,18}}, 	-- 5. 25об
{name="25 гер",		print=" 25", 	maxplayers=25, 		heroic=1,		balance={2,5,18}}, 	-- 6. 25гер
{name="20", 		print=" 20",	maxplayers=20, 		heroic=0,		balance={2,4,14}},	-- 7. 20
{name="40", 		print=" 40",	maxplayers=40, 		heroic=0,		balance={3,7,30}},	-- 8. 40
{name="", 			print="",		maxplayers=40, 		heroic=0,		balance={0,0,0}},	-- 9. Неизвестно
}

FGL.db.add_difficulties={
{name="норм.", 	difficulties="13578"},
{name="гер.", 	difficulties="246"},
{name="все 10", difficulties="34"},
{name="все 25", difficulties="56"},
{name="любой", 	difficulties="12345678"}
}

FGL.db.patches={
{name="Wrath of the Lick King",		abbreviation="WotLK",	point="wotlk"},
{name="The Burning Crusade", 		abbreviation="TBC",	point="tbc"},
{name="Classic", 			abbreviation="Classic",	point="classic"},
{name="Сезонные ивенты", 		abbreviation="Events",	point="events"},
{name="PvP / Арена", 			abbreviation="PVP",	point="pvp"},
}

-----------------------------------------------------------------------------------------------------------------------------------

FGL.db.instances={

---------------------PVE----------------------

{	name="Цит. Лед. Короны", 
 	namecreatepartyraid="В ЦЛК",
	abbreviationrus="ЦЛК",
	abbreviationeng="ЦЛК",
	difficulties="3456",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-IcecrownCitadel", 
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-IcecrownCitadel", 
	achieve={
	[3]={4527, 4528, 4529, 4530, 4531, 4532, 4534, 4535, 4536, 4537, 4538, 4539, 4577, 4578, 4579, 4580, 4581, 4582, 4601, 4602}, 
	[4]={4583, 4628, 4629, 4630, 4631, 4636}, 
	[5]={4597, 4603, 4604, 4605, 4606, 4607, 4608, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622},
	[6]={4576, 4584, 4632, 4633, 4634, 4635, 4637}}, 
	search={criteria={{"лич"}, "на лича", "цкл ", "цлк", "clk", "ребра ", "ребро ", "ребры ", "цитадель", "цетадель", "цит. лед.", "срлк", "саур", "леди ", " леди","валю", "вали", "вальки ", "вальку ", "чумк", "гнил", "тухл", "синдр"}
}},
{	name="Склеп Аркавона", 
 	namecreatepartyraid="В Склеп",
	abbreviationrus="СА",
	abbreviationeng="Склеп",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-VaultOfArchavon",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-VaultOfArchavon", 
	achieve={
	[3]={1722, 3136, 3836, 4016, 4585}, 
	[5]={1721, 3137, 3837, 4017, 4586}},
	search={criteria={"склеп", "чклеп", "торавон", {"в са"}, "арку", {"арка"}, {"са "}}
}},
{	name="Ульдуар", 
 	namecreatepartyraid="В Ульду",
	abbreviationrus="УЛД",
	abbreviationeng="Ульду",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Ulduar",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-UlduarRaidHeroic", 
	achieve={
	[3]={2886, 2888, 2890, 2892, 2894, 2903, 2905, 2907, 2909, 2911, 2913, 2914, 2915, 2919, 2923, 2925, 2927, 2930, 2931, 2933, 2934, 2937, 2939, 2940, 2941, 2945, 2947, 2951, 2953, 2955, 2957, 2959, 2961, 2963, 2967, 2969, 2971, 2973, 2975, 2977, 2979, 2980, 2985, 3006, 3076, 2982, 2989, 2996, 3003, 3004, 3008, 3009, 3012, 3014, 3015, 3036, 3056, 3058, 3097, 3138, 3141, 3157, 3158, 3159, 3176, 3177, 3178, 3179, 3180, 3181, 3182, 3316 }, 
	[5]={2887, 2889, 2891, 2893, 2895, 2904, 2906, 2908, 2910, 2912, 2916, 2917, 2918, 2921, 2924, 2926, 2928, 2929, 2932, 2935, 2936, 2938, 2942, 2943, 2944, 2946, 2948, 2952, 2954, 2956, 2958, 2960, 2962, 2965, 2968, 2970, 2972, 2974, 2976, 2978, 2981, 2983, 2984, 2995, 2997, 3002, 3005, 3007, 3010, 3011, 3013, 3016, 3017, 3037, 3057, 3059, 3077, 3098, 3117, 3118, 3161, 3162, 3163, 3164, 3184, 3185, 3183, 3186, 3187, 3188, 3189, 3237, 3259}},
	search={criteria={"ульду", {"ульда"}, {"сру"}, "робот", "игнис", "острокрыл", "алгалон", {"йог",  "сарон"}, {"ёг",  "сарон"}},
}},
{	name="Наксрамас", 
 	namecreatepartyraid="В Накс",
	abbreviationrus="НКС",
	abbreviationeng="Накс.",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Naxxramas",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-NAXXRAMAS", 
	achieve={
	[3]={562, 564, 566, 568, 572, 574, 576, 578, 1856, 1858, 1996, 1997, 2146, 2176, 2178, 2180, 2182, 2184, 2187}, 
	[5]={563, 565, 567, 569, 573, 575, 577, 579, 1857, 1859, 2139, 2140, 2147, 2177, 2179, 2181, 2183, 2185, 2186}},
	search={criteria={"накс", "ласкут", "лоскут", "чумно", "разуви"}
}},
{	name="Логово Ониксии", 
 	namecreatepartyraid="На Оню",
	abbreviationrus="ЛО",
	abbreviationeng="Ониксия",
	cutVeng="true",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-OnyxiaEncounter",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-Onyxia", 
	achieve={
	[3]={4396, 4402, 4403, 4404}, 
	[5]={4397, 4405, 4406, 4407}},
	search={criteria={{"оня"}, "на оньку", " оню", "оникс", {"логово", "они"}, {"лог.", "они"}}
}},
{	name="Око Вечности", 
 	namecreatepartyraid="На Малигоса",
	abbreviationrus="ОВ",
	abbreviationeng="Малигос",
	cutVeng="true",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Malygos",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Malygos", 
	achieve={
	[3]={622, 1869, 1874, 2148}, 
	[5]={623, 1870, 1875, 2149}},
	search={criteria={"малигос", "око вечности"}
}},
{	name="Обс. Святилище", 
 	namecreatepartyraid="В ОС",
	abbreviationrus="ОС",
	abbreviationeng="ОС",
	difficulties="35",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-ChamberOfAspects",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-ChamberOfAspects", 
	achieve={
	[3]={624, 1876, 2047, 2049, 2050, 2051}, 
	[5]={625, 1877, 2048, 2052, 2053, 2054}},
	search={criteria={" ос ", " ос2", " ос1", "обс. свят", "сарт", {"обсид", "свят"}, {"обсид", "светилищ"}, {"ос"}}
}},
{	name="Руб. Святилище", 
 	namecreatepartyraid="В РС",
	abbreviationrus="РС",
	abbreviationeng="РС",
	difficulties="3456",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-RubySanctum",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-RubySanctum", 
	achieve={
	[3]={4817, 4818}, 
	[4]={4817, 4818}, 
	[5]={4815, 4816},
	[6]={4817, 4818}}, 
	search={criteria={" рс", "руб. свят", {"рубин", "свят"}, {"рубин", "светилищ"}, {"рс"}}
}},
{	name="Исп. Крестоносца", 
 	namecreatepartyraid="В ИК",
	abbreviationrus="ИК",
	abbreviationeng="ИК",
	difficulties="3456",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-ArgentRaid",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-ArgentRaid", 
	achieve={
	[3]={3797, 3798, 3799, 3917, 3936, 3996, 3800}, 
	[4]={3808, 3809, 3810, 3918, 4080}, 
	[5]={3813, 3814, 3815, 3816, 3916, 3937, 3997},
	[6]={3812, 3817, 3818, 3819, 4079, 4156}},
	search={criteria={"в ик", "ик10", "ик25", "ивк10", "ивк25", "в ивк", " ик ", " ивк ", "исп. крест", "валькир ", "джаракс", "с чемпионов", {"испытание", "крестоносца"}, {"исп", "вел", "крестон"}, {"ик"}, {"ивк"}}
}},
{	name="Исп.Вел.Крестоносца",
 	namecreatepartyraid="В ИВК",
	abbreviationrus="ИВК",
	abbreviationeng="ИВК",
	dontprintheroic = 1,
	difficulties="3456",
	patch="undef",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-ArgentRaid",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-ArgentRaid", 
	search={criteria={}
}},
{	name="Исп. Чемпиона", 
 	namecreatepartyraid="В ИЧ",
	abbreviationrus="ИЧ",
	abbreviationeng="ИЧ",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-ArgentDungeon",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-ArgentDungeon", 
	achieve={[1]={3778}, [2]={4297, 3804, 3802, 3803}},
	search={criteria={" ич", "исп. чемп", {"испытание", "чемпиона"}, {"ич"}}
}},
{	name="Чертоги Камня", 
 	namecreatepartyraid="В ЧК",
	abbreviationrus="ЧК",
	abbreviationeng="ЧК",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-HallsofStone",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-HallsofStone", 
	achieve={[1]={485}, [2]={496, 1866, 2155, 2154}},
	search={criteria={" чк", {"чертоги", "камня"}, {"чк"}}
}},
{	name="Чертоги Молний", 
 	namecreatepartyraid="В ЧМ",
	abbreviationrus="ЧМ",
	abbreviationeng="ЧМ",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-HallsofLightning",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-HallsofLightning", 
	achieve={[1]={486}, [2]={497, 2042, 1834, 1867}},
	search={criteria={" чм ", {"чертоги", "молний"}, {"чм"}}
}},
{	name="Ам. Крепость", 
 	namecreatepartyraid="В АМК",
	abbreviationrus="АМК",
	abbreviationeng="АМК",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-TheVioletHold",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-TheVioletHold", 
	achieve={[1]={483}, [2]={494, 1865, 1816, 2041, 2153}},
	search={criteria={" амк", "аметисов", "ам. креп"}
}},
{	name="Яма Сарона", 
 	namecreatepartyraid="В Яму",
	abbreviationrus="ЯС",
	abbreviationeng="Яму",
 	cutVname="true",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-PitofSaron", 
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-PitofSaron", 
	achieve={[1]={4517}, [2]={4525, 4524, 4520}},
	search={criteria={"яма", "яму", "рукоят", "на ика"}
}},
{	name="Кузня Душ", 
 	namecreatepartyraid="В Кузню",
	abbreviationrus="КД",
	abbreviationeng="Кузню",
 	cutVname="true",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-TheForgeofSouls",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-TheForgeofSouls", 
	achieve={[1]={4516}, [2]={4519, 4523, 4522}},
	search={criteria={"кузня", "кузню", "кузни"}
}},
{	name="Залы Отражений", 
 	namecreatepartyraid="В Залы",
	abbreviationrus="ЗО",
	abbreviationeng="Залы",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-HallsofReflection",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-HallsofReflection", 
	achieve={[1]={4518}, [2]={44526, 4521}},
	search={criteria={"в залы", "v zali", {"залы"}}
}},
{	name="Нексус", 
 	namecreatepartyraid="В Нексус",
	abbreviationrus="НС",
	abbreviationeng="Нексус",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-TheNexus",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-TheNexus", 
	achieve={[1]={478}, [2]={490, 2037, 2150, 2036}},
	search={criteria={"нексус"}
}},
{	name="Окулус", 
 	namecreatepartyraid="В Окулус",
	abbreviationrus="ОК",
	abbreviationeng="Окулус",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-TheOculus",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-TheOculus", 
	achieve={[1]={487}, [2]={498, 2044, 2045, 2046, 1871, 1868}},
	search={criteria={"окулус", "окулос"}
}},
{	name="Азжол-Неруб", 
 	namecreatepartyraid="В Азжол",
	abbreviationrus="АН",
	abbreviationeng="Азжол",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-AzjolNerub",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-AzjolNerub", 
	achieve={[1]={480}, [2]={491, 1296, 1860, 1297}},
	search={criteria={"азжол", "неруб ", "ажол "}
}},
{	name="Ан'Кахет", 
 	namecreatepartyraid="В Анкахет",
	abbreviationrus="АК",
	abbreviationeng="Ан'Кахет",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Ahnkalet",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Ahnkalet", 
	achieve={[1]={481}, [2]={492, 2038, 2056, 1862}},
	search={criteria={"кахет"}
}},
{	name="Верш. Утгард", 
 	namecreatepartyraid="В в.Утгард",
	abbreviationrus="ВУ",
	abbreviationeng="Вер. Утгард",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-UtgardePinnacle",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-UtgardePinnacle", 
	achieve={[1]={488}, [2]={499, 2043, 1873, 2156, 2157}},
	search={criteria={"скади", "имирон", "верш. утга", {"вир", "утга"}, {"вер", "утга"}, {"сини", "протодра"}, "да здравствует король"}
}},
{	name="Крепость Утгард", 
 	namecreatepartyraid="В к.Утгард",
	abbreviationrus="КУ",
	abbreviationeng="Кр. Утгард",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Utgarde",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Utgarde", 
	achieve={[1]={477}, [2]={489, 1919}},
	search={criteria={"крепость утг", "кр. утга"}
}},
{	name="Креп. Драк'Тарон", 
 	namecreatepartyraid="В Драктарон",
	abbreviationrus="КДТ",
	abbreviationeng="Драк'Тарон",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-DrakTharon", 
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-DrakTharon", 
	achieve={[1]={482}, [2]={493, 2039, 2151, 2057}},
	search={criteria={"драктар", {"драк", "тарон"}}
}},
{	name="Оч. Стратхольма", 
 	namecreatepartyraid="В Страты",
	abbreviationrus="ОС",
	abbreviationeng="Оч. Страт.",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-OldStrathome",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-OldStratholme", 
	achieve={[1]={479}, [2]={500, 1817, 1872}},
	search={criteria={{"очищ", "страт"}, "страты", "оч. страт", "стратихольмы", "стратхольмы"}
}},
{	name="Гундрак", 
 	namecreatepartyraid="В Гундрак",
	abbreviationrus="ГК",
	abbreviationeng="Гундрак",
	difficulties="12",
	patch="wotlk",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Gundrak",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Gundrak", 
	achieve={[1]={484}, [2]={495, 2040, 2058, 1864, 2152}},
	search={criteria={"гундр"}
}},
{	name="Зул'Аман", 
 	namecreatepartyraid="В ЗА",
	abbreviationrus="ЗА",
	abbreviationeng="ЗА",
	difficulties="3",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-ZulAman",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-ZULAMAN", 
	achieve={[3]={691}},
	search={criteria={"v za", "в за ", "за палачем", {"на зул", "джина"}, {"зул", "аман"}}

}},
{	name="Каражан", 
 	namecreatepartyraid="В Каражан",
	abbreviationrus="КРЖ",
	abbreviationeng="Каражан",
	difficulties="3",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Karazhan",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-KARAZHAN", 
	achieve={[3]={690}},
	search={criteria={"в кару", "v karu", "каражан", "на малчезара", "за мангустом", {"за", "поводья", "огненного", "боевого", "коня"}}
}},
{  
	name="Крепость Бурь", 
 	namecreatepartyraid="В ТК",
	abbreviationrus="КБ",
	abbreviationeng="ТК",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-TempestKeep",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-TEMPESTKEEP", 
	achieve={[5]={696}},
	search={criteria={"v tk", "в тк", "в кб", " кб ", " tk ",  "за феней", "за феникc", {"пепел", "ал", "ара"}, {"крепость", "бурь"}, {"tk"}, {"тк"}, {"кб"}}
}},
{	name="Лог. Груула", 
 	namecreatepartyraid="На Груула",
	abbreviationrus="ЛГ",
	abbreviationeng="Груул",
	cutVeng="true",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-GruulsLair",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-GRUULSLAIR", 
	achieve={[5]={692}},
	search={criteria={ "груул",  "на грул", "лог. груу", {"логово", "грул"}}
}},
{	name="Вершина Хиджала", 
 	namecreatepartyraid="В Хиджал",
	abbreviationrus="ВХ",
	abbreviationeng="Хиджал",
	cutVname="true",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-HyjalPast",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-HYJALPAST", 
	achieve={[5]={695}},
	search={criteria={"на арчи", "на архимонда", "хиджал"}
}},
{	name="Солнечный Колодец", 
 	namecreatepartyraid="В Санвел",
	abbreviationrus="СК",
	abbreviationeng="Санвелл",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Sunwell",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-SUNWELL", 
	achieve={[5]={698}},
	search={criteria={"санвел", "за торидалом", "на киля", "плато солнечного колодца", {"кил", "джеден"}, {"солне", "колод"}, {"кел", "джеден"}, "санвел", "sunwel", "sunvel"}
}},
{	name="Змеиное Святилище", 
 	namecreatepartyraid="В ССК",
	abbreviationrus="ЗС",
	abbreviationeng="ССК",
	difficulties="5",
	patch="tbc",
	achieve={[5]={694}},
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-CoilFang",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-SERPENTSHRINECAVERN", 
	search={criteria={"в подводку", "на вайш", "в сск", {"змеиное", "святилище"}}
}},
{	name="Лог. Магтеридона", 
 	namecreatepartyraid="На Магтеридона",
	abbreviationrus="ЛМ",
	abbreviationeng="Магтеридон",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-HellfireCitadelRaid",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-HELLFIRECITADELRAID", 
	search={criteria={{"логово", "магтеридона"}, "магтеридон", "лог. магтер"}
}},
{	name="Черный Храм", 
 	namecreatepartyraid="В БТ",
	abbreviationrus="ЧХ",
	abbreviationeng="БТ",
	difficulties="5",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-BlackTemple",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-BLACKTEMPLE", 
	search={criteria={"v bt", "в бт", "в чх", " чх ", " bt ", " бт ", "на иллидана", "на илидана", "за азинотками", {"черн", "храм"}, {"чёрн", "храм"}, {"бт"}, {"чх"}, {"bt"}}
}},
{	name="Аук. гробницы", 
 	namecreatepartyraid="В АГ",
	abbreviationrus="АГ",
	abbreviationeng="АГ",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Auchindoun",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-AUCHINDOUN", 
	achieve={[1]={666}, [2]={672}},
	search={criteria={"в аг", "в аукенай", "маладаар", "аук. гроб", {"аукенайск", "гробн"}, {"аукенайск", "грабн"}}
}},
{	name="Гробницы Маны", 
 	namecreatepartyraid="В Гроб. маны",
	abbreviationrus="ГМ",
	abbreviationeng="ГМ",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Auchindoun",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-AUCHINDOUN", 
	achieve={[1]={651}, [2]={671}},
	search={criteria={"в аг", "шаффар", "шафар", {"гробниц", "маны"}, {"грабниц", "маны"}}
}},
{	name="Сетекк. залы", 
 	namecreatepartyraid="В Сеттек",
	abbreviationrus="СЗ",
	abbreviationeng="Сетекк",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Auchindoun",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-AUCHINDOUN", 
	achieve={[1]={653}, [2]={674}},
	search={criteria={"в сетекк", "за вороном", "анзу", "айкис", {"за", "владыки", "воронов"}, {"сетек", "залы"}}
}},
{	name="Темный лабиринт", 
 	namecreatepartyraid="В Лабиринт",
	abbreviationrus="ТЛ",
	abbreviationeng="Лабиринт",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Auchindoun",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-AUCHINDOUN", 
	achieve={[1]={654}, [2]={675}},
	search={criteria={"в лабиринт", "в тл", "v tl", "бормотун", {"темный", "лабиринт"}}
}},
{	name="Аркатрац", 
 	namecreatepartyraid="В Аркатрац",
	abbreviationrus="АТ",
	abbreviationeng="Аркатрац",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-TempestKeep",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-TEMPESTKEEP", 
	achieve={[1]={660}, [2]={681}},
	search={criteria={"в аркатр", "скайрис", "аркатрац"}
}},
{	name="Ботаника", 
 	namecreatepartyraid="В Ботанику",
	abbreviationrus="БН",
	abbreviationeng="Ботаника",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-TempestKeep",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-TEMPESTKEEP", 
	achieve={[1]={659}, [2]={680}},
	search={criteria={"v botu", "в боту", "в ботанику", "узлодрев", "ботаник"}
}},
{	name="Механар", 
 	namecreatepartyraid="В Механар",
	abbreviationrus="МХ",
	abbreviationeng="Механар",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-TempestKeep",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-TEMPESTKEEP", 
	achieve={[1]={658}, [2]={679}},
	search={criteria={"в мех", "паталеон", "вычислител", "механар"}
}},
{	name="Стар. Хилсбрад", 
 	namecreatepartyraid="В Хилсбрад",
	abbreviationrus="СХ",
	abbreviationeng="Хилсбрад",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-CavernsOfTime",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-CAVERNSOFTIME", 
	achieve={[1]={652}, [2]={673}},
	search={criteria={"в спх", "на охотника вечности", "хилсбрад", "дарнх", "стар. хилс"}
}},
{	name="Черные топи", 
 	namecreatepartyraid="В Топи",
	abbreviationrus="ЧТ",
	abbreviationeng="Топи",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-CavernsOfTime",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-CAVERNSOFTIME", 
	achieve={[1]={655}, [2]={676}},
	search={criteria={"эонус", "в чт ", "в топи", {"черн", "топи"}, {"чёрн", "топи"}, {"открытие", "темного", "портала"}}
}},
{	name="Баст. Ад. Пламени", 
 	namecreatepartyraid="В Бастионы",
	abbreviationrus="БАП",
	abbreviationeng="Бастионы",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-HELLFIRECITADEL",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-HELLFIRECITADEL", 
	achieve={[1]={647}, [2]={667}},
	search={criteria={"в бастионы", "в бап", "в бп", "на омора", "назан", "вазруден", "баст. ад. пла", {"бастионы", "адского", "пламени"}}
}},
{	name="Кузня Крови", 
 	namecreatepartyraid="В Кузню(70)",
	abbreviationrus="КК",
	abbreviationeng="Кузня(70)",
	cutVname="true",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-HELLFIRECITADEL",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-HELLFIRECITADEL", 
	achieve={[1]={648}, [2]={668}},
	search={criteria={"в кк", "келидан", "кузню70", "кузню(70)", {"кузн", "крови"}}
}},
{	name="Разрушенные залы", 
 	namecreatepartyraid="В Залы(70)",
	abbreviationrus="РЗ",
	abbreviationeng="Залы(70)",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-HELLFIRECITADEL",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-HELLFIRECITADEL", 
	achieve={[1]={657}, [2]={678}},
	search={criteria={"в рз", "залы70", "залы(70)", "раз. залы", "р. залы", "залы 70", "залы (70)", "раз.залы", "р.залы", "каргат", "острорук", {"разруш", "залы"}}
}},
{	name="Терраса Магистров", 
 	namecreatepartyraid="В Терассу",
	abbreviationrus="ТМ",
	abbreviationeng="ТМ",
	cutVname="true",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-MagistersTerrace",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-MAGISTERSTERRACE", 
	achieve={[1]={661}, [2]={682}},
	search={criteria={"v tm", "в тм", "в терас", {"за", "белый", "крылобег"}, {"за", "птенец", "феникса"}, {"за", "син", "дорай"}, {"тер", "магистр"}, {"тм"}}
}},
{	name="Нижетопь", 
 	namecreatepartyraid="В Нижетопь",
	abbreviationrus="НТ",
	abbreviationeng="Нижетопь",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-CoilFang",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-COILFANG", 
	achieve={[1]={650}, [2]={670}},
	search={criteria={"в нт", {"черн", "охотниц"}, {"чёрн", "охотниц"}, "нижетопь"}
}},
{ 	name="Пар. подземелье", 
 	namecreatepartyraid="В Паровое",
 	abbreviationrus="ПРП",
 	abbreviationeng="Паровое",
 	difficulties="12",
	 patch="tbc",
 	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-CoilFang",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-COILFANG", 
	achieve={[1]={656}, [2]={677}},
 	search={criteria={"в паровое", "калитреш", "пар. подз", "в пар подзем", {"паров", "подзем"}, {"парав", "подзем"}}
}},
{	name="Узилище", 
 	namecreatepartyraid="В Узилище",
	abbreviationrus="УЗ",
	abbreviationeng="Узилище",
	difficulties="12",
	patch="tbc",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-CoilFang",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-COILFANG", 
	achieve={[1]={649}, [2]={669}},
	search={criteria={"в узи", "зыбун", "узилище"}
}},
{	name="Зул'Гуруб", 
 	namecreatepartyraid="В ЗГ",
	abbreviationrus="ЗГ",
	abbreviationeng="ЗГ",
	difficulties="7",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-ZulGurub",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-ZULGURUB", 
	achieve={[7]={688}},
	search={criteria={"v zg", "в зг", "хаккар", "хакар", "за тигром", "за ящером", "за раптором", {"зул", "гуруб"}, {"зг"}, {"zg"}}
}},
{	name="Руины Ан'Киража", 
 	namecreatepartyraid="В АК20",
	abbreviationrus="РА",
	abbreviationeng="AK20",
	difficulties="7",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-AQRuins",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-AQRUINS", 
	achieve={[7]={689}},
	search={criteria={"в ак20", "в руины", "оссириан", {"руины", "ан", "киража"}, {"ак20"}}
}},
{	name="Храм Ан'Киража", 
 	namecreatepartyraid="В АК40",
	abbreviationrus="ХА",
	abbreviationeng="AK40",
	difficulties="8",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-AQTemple",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-AQTEMPLE", 
	achieve={[8]={687}},
	search={criteria={"в ак40", "в анкираж", "в кираж", "в храм", "на ктун", {"храм", "ан", "киража"}, {"потому", "что", "он", "красный"}, {"к", "тун"}, {"ак40"}}
}},
{	name="Лог. Крыла Тьмы", 
 	namecreatepartyraid="В БВЛ",
	abbreviationrus="ЛКТ",
	abbreviationeng="БВЛ",
	difficulties="8",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-BlackwingLair",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-BLACKWINGLAIR", 
	achieve={[8]={685}},
	search={criteria={"в лкт", "в бвл", "лог. крыла", "на нефариан", {"логов", "крыла", "тьмы"}, {"бвл"}, {"лкт"}}
}},
{	name="Огненные Недра", 
 	namecreatepartyraid="В Недра",
	abbreviationrus="ОН",
	abbreviationeng="МК",
	difficulties="8",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-MoltenCore",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-MOLTENCORE", 
	achieve={[8]={686}},
	search={criteria={"v mc", "в мк", "в он ", " mc ", " мк ", "на рагнароса", "на гарра", "геддон", {"огн", "недра"}, {"за", "наручники", "искателя", "ветра"}, {"за", "око", "сульфураса"}, {"он40"}, {"mc"}, {"мк"}}
}},
{	name="Гномреган", 
 	namecreatepartyraid="В Гномреган",
	abbreviationrus="ГРН",
	abbreviationeng="Реган",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Gnomeregan",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-GNOMEREGAN", 
	achieve={[1]={634}},
	search={criteria={"в реган ", "на термоштеп", "гномереган", "гномиреган", "гномреган"}
}},
{	name="Ульдаман", 
 	namecreatepartyraid="В Ульдаман",
	abbreviationrus="УЛН",
	abbreviationeng="Ульдаман",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Uldaman",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-ULDAMAN", 
	achieve={[1]={638}},
	search={criteria={"ульдам", "аркедас"}
}},
{	name="Тюрьма Штормграда", 
 	namecreatepartyraid="В Тюрьму",
	abbreviationrus="ТШ",
	abbreviationeng="Тюрьма",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-StormwindStockades",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-STORMWINDSTOCKADES", 
	achieve={[1]={633}},
	search={criteria={"в тюрьму", "в тш", "базил", "тюрьма"}
}},
{	name="Стратхольм", 
 	namecreatepartyraid="В Страты(60)",
	abbreviationrus="СМ",
	abbreviationeng="Страты(60)",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Stratholme",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-STRATHOLME", 
	achieve={[1]={646}},
	search={criteria={"в стратхольм", "на ривендера", "балназ", {"за", "поводья", "коня", "смерти"}, {"стратхольм"}, {"страт", "60"}, {"страт", "стары"} }
}},
{	name="Пик Черной Горы", 
 	namecreatepartyraid="В БРС",
	abbreviationrus="ПЧГ",
	abbreviationeng="БРС",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-BlackrockSpire",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-BLACKROCKSPIRE", 
	achieve={[1]={643, 1307, 2188}},
	search={criteria={"пик черной го","в пчг", "в брс", "в вчг", "в нчг", "в вччг", "в нччг", "змейталак", "драккисат", "дракисат", {"часть", "черной", "гор"}, {"часть", "чёрной", "гор"}}
}},
{	name="Глуб. Черной Горы", 
 	namecreatepartyraid="В БРД",
	abbreviationrus="ГЧГ",
	abbreviationeng="БРД",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-BlackrockDepths",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-BLACKROCKDEPTHS", 
	achieve={[1]={642}},
	search={criteria={"глуб. черной го", "в брд", "в гчг", "дагран", "тауриссан", "таурисан", {"глубины", "черной", "горы"}}
}},
{	name="Некроситет",
 	namecreatepartyraid="В Некро",
	abbreviationrus="НТ",
	abbreviationeng="Некро",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Scholomance",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-SCHOLOMANCE", 
	achieve={[1]={645}},
	search={criteria={"в некро", "в шоло", "гандлинг", {"рас", "ледяной", "шепот"}, {"некроситет"}}
}},
{	name="Марадон", 
 	namecreatepartyraid="В Марадон",
	abbreviationrus="МН",
	abbreviationeng="Мара",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Maraudon",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-MARAUDON", 
	achieve={[1]={640}},
	search={criteria={"в мару", "в мара", "терадрас", "марадон", "мародон"}
}},
{	name="Мертвые копи", 
 	namecreatepartyraid="В Копи",
	abbreviationrus="МК",
	abbreviationeng="Копи",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Deadmines",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-DEADMINES", 
	achieve={[1]={628}},
	search={criteria={"в копи", "эдвин", "клиф", {"мертвые", "копи"}}
}},
{	name="Пещеры Стенаний", 
 	namecreatepartyraid="В Пещеры",
	abbreviationrus="ПС",
	abbreviationeng="Пещеры",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-WailingCaverns",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-WAILINGCAVERNS", 
	achieve={[1]={630}},
	search={criteria={"в пещеры", "мутанус", {"пещер", "стенан"}}
}},
{	name="Огненная Пропасть", 
 	namecreatepartyraid="Под Огри",
	abbreviationrus="ОП",
	abbreviationeng="Под огри",
	cutVname="true",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-RagefireChasm",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-RagefireChasm", 
	achieve={[1]={629}},
	search={criteria={"под огри", "в оп ", "в пропасть", "в пропость", {"огнен", "проп"}}
}},
{	name="Непроглядная Пучина", 
 	namecreatepartyraid="В Пучину",
	abbreviationrus="НП",
	abbreviationeng="Пучина",
 	cutVname="true",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-BlackfathomDeeps",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-BLACKFATHOMDEEPS", 
	achieve={[1]={632}},
	search={criteria={"в нп", "в пучину", {"аку", "май"}, {"непр", "пучина"}}
}},
{	name="Креп. Темн. Клыка", 
 	namecreatepartyraid="В КТК",
	abbreviationrus="КТК",
	abbreviationeng="КТК",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-ShadowFangKeep",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-SHADOWFANGKEEP", 
	achieve={[1]={631}},
	search={criteria={"в ктк", "аругал", "креп. темн. кл", {"крепость", "темного", "клыка"}, {"ктк"}}
}},
{	name="Зул'Фаррак", 
 	namecreatepartyraid="В ЗулФарак",
	abbreviationrus="ЗФ",
	abbreviationeng="Фаррак",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-ZulFarak",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-ZULFARAK", 
	achieve={[1]={639}},
	search={criteria={"в зф", "в фарак", "в фаррак", {"зул", "фаррак"}, {"зул", "фарак"}}
}},
{	name="Забытый Город", 
 	namecreatepartyraid="В Маул",
	abbreviationrus="ЗБГ",
	abbreviationeng="Маул",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-DireMaul",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-DIREMAUL", 
	achieve={[1]={644}},
	search={criteria={"в маул", "в город", {"зобытый", "город"}, "алззин", "на гордок", {"гордок"}, {"забытый", "город"}, {"зобытый", "город"}, {"бессмер", "тер"}, {"dire", "maul"}}
}},
{	name="Затонувший храм", 
 	namecreatepartyraid="В Зат. Храм",
	abbreviationrus="ЗХ",
	abbreviationeng="Зат. Храм",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-SunkenTemple",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-SUNKENTEMPLE", 
	achieve={[1]={641}},
	search={criteria={"в зх", "зат. храм", "эраникус", {"затонувш", "храм"}}
}},
{	name="Мон. Ал. Ордена", 
 	namecreatepartyraid="В МАО",
	abbreviationrus="МАО",
	abbreviationeng="МАО",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-ScarletMonastery",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-SCARLETMONASTERY", 
	achieve={[1]={637}},
	search={criteria={"в собор", "в библиотеку", "мон. ал. орд", "в кладбище", "в оружейн", "талнос", "доан", "ирод", "могрейн", "инквизитор", {"монаст", "ал", "орден"}, {"моност", "ал", "орден"}, {"мао"}}
}},
{	name="Курганы Иглошкурых", 
 	namecreatepartyraid="В Курганы",
	abbreviationrus="КИ",
	abbreviationeng="Курганы",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-RazorfenDowns",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-RAZORFENDOWNS", 
	achieve={[1]={639}},
	search={criteria={"в курганы", "в ки ", "хладов", {"курганы", "иглошкурых"}, {"ки"}}
}},
{	name="Лабиринты Иглошкурых", 
 	namecreatepartyraid="В Лабиринты",
	abbreviationrus="ЛИ",
	abbreviationeng="Лабиринты",
	difficulties="1",
	patch="classic",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-RazorfenKraul",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGICON-RAZORFENKRAUL", 
	achieve={[1]={635}},
	search={criteria={"в ли ", "в лабиринты", "остробок", {"лабиринты", "иглошкурых"}, {"ли"}}
}}, 
{ 	name="Огненный солнцеворот", 
 	namecreatepartyraid="На Ахуна",
	abbreviationrus="ОС",
	abbreviationeng="Ахун",
 	cutVname="true",
	cutVeng="true",
	difficulties="1",
	patch="events",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Summer",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Summer", 
	achieve={[1]={263}},
	search={criteria={"за косой", "ахун", "ахуан",  "аухун", "аухан", "ахаун", {"огнен", "солнце"}}
}},
{ 	name="Хмельный Фестиваль", 
 	namecreatepartyraid="На Худовара",
	abbreviationrus="ХФ",
	abbreviationeng="Худовар",
 	cutVname="true",
	cutVeng="true",
	difficulties="1",
	patch="events",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Brew",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Brew", 
	achieve={[1]={295, 3496}},
	search={criteria={"худовар", "худавар", "худой", "на худо", "за кодо", "за бараном", {"утром", "дрож"}, {"хмел", "фестив"}}
}},
{ 	name="Тыквовин", 
 	namecreatepartyraid="На Всадника",
	abbreviationabbreviationrus="ТВ",
	abbreviationeng="Всадник",
 	cutVname="true",
	cutVeng="true",
	difficulties="1",
	patch="events",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Halloween",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Halloween", 
	achieve={[1]={255, 980}},
	search={criteria={"всадник", "конем", "канем", "конём", "тыквовин", "канём", {"поводья", "всадника"}}
}},
{ 	name="Любовная лихорадка", 
 	namecreatepartyraid="На Хамеля",
	abbreviationrus="ЛЛ",
	abbreviationeng="Хамель",
 	cutVname="true",
	cutVeng="true",
	difficulties="1",
	patch="events",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Love",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Love", 
	achieve={[1]={4624, 4627}},
	search={criteria={"аптекар", "хаммел", "хамеля", "хамелю", "хамель", "ракет", {"любов", "лихорад"}, "химик", "химичес", "королевскую хим", "лабораторию"}
}},
{ 	name="Арена 2х2", 
 	namecreatepartyraid="В двойку",
	abbreviationrus="2х2",
	abbreviationeng="2х2",
	difficulties="9",
	patch="pvp",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Arena1",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Arena1", 
	search={criteria={
		" 2х2", " 2x2", "2х2 ", "2x2 ",
		"2vs2", "2на2", "2на 2","2 на2","2 на 2",
		"в двойку", " нап ", " напа ", "в 2хку",
		"рег 2е", "в 2е", "к 2е",
		"тиму 2c", "тиму 2с",
		"тима 2c", "тима 2с",
		"рег 2c", "в 2c", "к 2c",
		"рег 2с", "в 2с", "к 2с",
		"рег 2c", "в 2c", "к 2c",
		"рег c2", "в c2", "к c2",
		"рег с2", "в с2", "к с2",
	}
}},
{ 	name="Арена 3х3", 
 	namecreatepartyraid="В тройку",
	abbreviationrus="3х3",
	abbreviationeng="3х3",
	difficulties="9",
	patch="pvp",
 	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Arena2",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Arena2", 
	search={criteria={ "3х3 ",  "3x3 ", " 3х3",  " 3x3",
	"3vs3", "3на3", "3на 3","3 на3","3 на 3", "в тройку", "в 3хку",
		"тиму 3c", "тиму 3с",
		"тима 3c", "тима 3с",
		"рег 3е", "в 3е", "к 3е",
		"рег 3с", "в 3с", "к 3с",
		"рег 3c", "в 3c", "к 3c",
		"рег c3", "в c3", "к c3",
		"рег с3", "в с3", "к с3",
	}
}},
{ 	name="Арена 5х5", 
 	namecreatepartyraid="В пятёрку",
	abbreviationrus="5х5",
	abbreviationeng="5х5",
	difficulties="9",
	patch="pvp",
 	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Arena3",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-Arena3", 
	search={criteria={ "5х5 ", "5x5 "," 5х5", " 5x5", 
	"5vs5", "5на5", "5 на 5","в пятёрку", "в 5хку",
		"тиму 5c", "тиму 5с",
		"тима 5c", "тима 5с",
		"рег 5е", "в 5е", "к 5е",
		"рег 5с", "в 5с", "к 5с",
		"рег 5c", "в 5c", "к 5c",
		"рег c5", "в c5", "к c5",
		"рег с5", "в с5", "к с5",
	}
}},
{ 	name="Поле боя", 
 	namecreatepartyraid="На бг",
	abbreviationrus="БГ",
	abbreviationeng="батлграунд",
	difficulties="9",
	patch="pvp",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Battleground",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-IsleOfConquest", 
	search={criteria={"собираю на бг", "собираю бг", "на бг нид", "на бг нуж"}
}},
{ 	name="Озеро Ледяных Оков", 
 	namecreatepartyraid="На ОЛО",
	abbreviationrus="ОЛО",
	abbreviationeng="Оз. Лед. Оков",
	difficulties="9",
	patch="pvp",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-VaultOfArchavon",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-VaultOfArchavon", 
	search={criteria={ "оло началось","оло идет", "оло идёт","на оло ", "собираю на оло", "оло осталось", "оло через"}
}},
{	name="Случ. Подземелье", 
 	namecreatepartyraid="В ПП",
	abbreviationrus="ПП",
	abbreviationeng="Рандом",
	difficulties="12",
	patch="random",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-RANDOMDUNGEON",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-RANDOMDUNGEON", 
	achieve={[2]={4478, 4477, 4476}},
	search={criteria={{"ргер"}, " ргер","р гер", "рендом", "случ. подз", "рендомгер", "рендомпп", 
	"рандом", "рандомгер", "рандомпп", "рпп", "пп ", "случайку", 
	"рандом героик", "рендом героик", "в рг", "ппг"}
}},
{  name="Ущелье Песни Войны",
	namecreatepartyraid="Ущелье",
	abbreviationrus="Ущелье",
	abbreviationeng="Ущелье",
	difficulties="9",
	patch="notice",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Warsong",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-OLDDALARAN",
	search={criteria={"ущелье песни войны"}
}},
{  name="Низина Арати",
	namecreatepartyraid="Арати",
	abbreviationrus="Арати",
	abbreviationeng="Арати",
	difficulties="9",
	patch="notice",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Arathi",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-OLDDALARAN",
	search={criteria={"низина арати"}
}},
{  name="Альтеракская долина",
	namecreatepartyraid="Альтерак",
	abbreviationrus="Альтерак",
	abbreviationeng="Альтерак",
	difficulties="9",
	patch="notice",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Alterac",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-OLDDALARAN",
	search={criteria={"альтеракская долина"}
}},
{  name="Око бури",
	namecreatepartyraid="Око",
	abbreviationrus="Око",
	abbreviationeng="Око",
	difficulties="9",
	patch="notice",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Storm",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-OLDDALARAN",
	search={criteria={"око бури"}
}},
{  name="Берег древних",
	namecreatepartyraid="Берег",
	abbreviationrus="Берег",
	abbreviationeng="Берег",
	difficulties="9",
	patch="notice",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Antients",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-OLDDALARAN",
	search={criteria={"берег древних"}
}},
{  name="Остров завоеваний",
	namecreatepartyraid="Остров",
	abbreviationrus="Остров",
	abbreviationeng="Остров",
	difficulties="9",
	patch="notice",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-Island",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-OLDDALARAN",
	search={criteria={"остров завоеваний"}
}},
{ 	name="Другое", 
 	namecreatepartyraid="",
	abbreviationrus="",
	abbreviationeng="",
	difficulties="9",
	patch="other",
	picture="Interface\\AddOns\\FindGroup\\textures\\instances\\UI-LFG-BACKGROUND-OLDDALARAN",
	icon="Interface\\AddOns\\FindGroup\\textures\\preview\\LFGIcon-OLDDALARAN", 
	search={criteria={}
}},
}



FGL.db.add_instances={
{name="Групповой", difficulties="12"},
{name="Рейдовый", difficulties="345678"},
{name="Любой", difficulties="12345678"},
{name="С достижением", difficulties="12345678"},
{name="Все анонсы", difficulties="9"},
}

FGL.db.roles={
	heal={
		label="хил",
		search={
			criteria={"хил", " hil", "hil ", "heal", "холик", "лекар"},
			exception={"хил есть", "хилы есть", "пахилю", "похилю", "хильну", "я хил", "пати хилу", "хилы фул", "прохилю"}
		}
	},
	attack={
		label="дд",
		search={
			criteria={"дд", "спд", "мили", "dd", "spd", "дамагер", "домагер", "domager", "damager", "боец", "бойц"},
			exception={"пойду", "задамажу", "я дд", "я рдд", "дд фул", "заддшу", "поддшу", "проддшу"}
		}
	},
	tank={
		label="танк",
		search={
			criteria={" mt", "need ot", "tank", "танк", " такн ", "мт", "нужен от ", "нид от "},
			exception={"мт есть", "танк есть", "танки есть", "от есть", "танкану", "я танк", "пати танку", "танки фул", "протанчу"}
		}
	},
	all={
		label="все",
		search={
			criteria={	"нид все", "нужны все", "все нужны", "все нид", "нидвсе", 
				"need vse", "vse need", "nid vse", "vse nid", "все в ", "vse v ", "неед все",
				"ктонибудь", "1 тело"
			},
			exception={}
		}
	},
} 

FGL.db.classfindtable = {
["DEATHKNIGHT"]={
				{},
				{"дк"},
				{},
				},
["ROGUE"]={
				{},
				{"рог"},
				{},
				},
["HUNTER"]={
				{},
				{"хант"},
				{},
				},
["MAGE"]={
				{},
				{"маг"},
				{},
				},
["WARRIOR"]={
				{},
				{"вар"},
				{"пвар", {"прото", "вар"}},
				},
["WARLOCK"]={
				{},
				{"лок","афли","демо","дестр"},
				{},
				},		
["DRUID"]={
				{"рдру","дерево","бревно","палено", {"ресто", "дру", 5}},
				{"дру","кошка","сова","мункин","совух"},
				{"мишк"},
				},
["PALADIN"]={
				{"хпал","hpal", {"холи", "пал"}},
				{"пал","ретри"},
				{"ппал", "ppal", {"прото", "пал"}},
				},
["PRIEST"]={
				{"хприст","дц", {"прист", "холи"}},
				{"прист","шп","шприст", {"шадоу", "прист", 5}},
				{},
				},
["SHAMAN"]={
				{"ршам", {"ресто", "шам", 5}},
				{"шам","элем","энх"},
				{},
				},			
}

FGL.db.submsgs = {
	"{ромб}",
	"{звезда}",
	"{круг}",
	"{череп}",
	"{крест}",
	"{треугольник}",
	"{полумесяц}",
	"{квадрат}",
	"{Ромб}",
	"{Звезда}",
	"{Круг}",
	"{Череп}",
	"{Крест}",
	"{Треугольник}",
	"{Полумесяц}",
	"{Квадрат}",
	"{РОМБ}",
	"{ЗВЕЗДА}",
	"{КРУГ}",
	"{ЧЕРЕП}",
	"{КРЕСТ}",
	"{ТРЕУГОЛЬНИК}",
	"{ПОЛУМЕСЯЦ}",
	"{КВАДРАТ}",
	"__",
	"**",
	"-".."-",
	"!!!",
	"!!",
}

FGL.db.exceptions={
	"тиму",
	"2x2",
	"3x3",
	"5x5",
	"2х2",
	"3х3",
	"5х5",
	"2на2",
	"3на3",
	"5на5",
	"кому нуж",
	"кому нид",
	"пойду",
	"пайду",
	"схожу",
	" ги",
	"вгиль",
	"гильдии",
	"гильдее",
	"есть пати",
	"рецами",
	"продам",
	"продаю",
	"куплю",
	"обменяю",
	"кому там над",
	"кому там нуж",
	"кто там соб",
	"нид кому?",
	"фул уже",
	"хочешь узнать",	
	"походы",
	"походов",
	"поня",
	"покупа",
	"работаю",
	"своди",
	"искал",
	"зачем регать",
	"в цлк выдавал",
	"в цлк выдаёт",
	"я спд",
	"я дд",
	"я рдд",
	"я мдд",
	--"репу",
	--"репы",
}

FGL.db.fp_exceptions={
	inst={
		"рс",
		"цлк",
		"цкл",
		"склеп",
		"ргер",
		"рэйд",
		"рейд",
		"пати",
		"группу",
		"подченили",
		"подчинили",
		"падчинили",
		"падченили",
		"починили",
		"поченили",
		"паченили",
		"пачинили",
	},
	itype={
		"ищю",
		"ичу",
		"ишю",
		"ищут",
		"ищют",
		"ишут",
		"ищет",
		"ишет",
		"ищу",
		"ишу",
		"ищит",
		"Худовара не",
	},
}

FGL.db.heroic={
"г",
"гер",
"г ",
" гер",
"гер ",
" г ",
"ргер",
"гирои",
"герои",
"хиро",
"хм",
"за драко",
"за маунтом",
"за флаем",
"ивк",
"вел.",
"великого",
"ппг",
}

FGL.db.normal={
"",
"об",
"н ",
"н ",
"нор ",
" об",
"об ",
"норма ",
"нормал ",
}

FGL.db.createtexts={
	full={
		start="В инст %s",
		cut="%s",
		need=" нужны:%s.",
		need1=" нужны%s.",
		need3=" нужен%s.",
		pm="Писать в пм: %s.",
		ddspd="дамагер",
	},
	splite={
		start="В %s",
		start2="На %s",
		cut="%s",
		need=" нид%s",
		pm="(в пм: %s)",
		spd="спд",
		dd="дд",
		rdd="рдд",
		ddspd="дд/спд",
	},
	random={
		name="Случ. Подземелье",
		start="В %s",
	},
}

FGL.db.iconclasses={
	tank={
		"warrior",
		"deathknight",
		"paladin",
		"druid",
	},
	heal={
		"paladin",
		"shaman",
		"priest",
		"druid",
	},
	dd={
		"warrior",
		"deathknight",
		"paladin",
		"shaman",
		"hunter",
		"mage",
		"rogue",
		"warlock",
		"priest",
		"druid",
	},
}

FGL.db.classesprint={
	["TANK"]={
		"вар",
		"дк",
		"пал",
		"дру",
	},
	["HEAL"]={
		"пал",
		"шам",
		"прист",
		"дру",
	},
	["DD"]={
		"вар",
		"дк",
		"пал",
		"шам",
		"хант",
		"маг",
		"рог",
		"лок",
		"прист",
		"дру",
	},
}

FGL.db.classesprint2={
	["TANK"]={
		"warrior",
		"deathknight",
		"paladin",
		"druid",
	},
	["HEAL"]={
		"paladin",
		"shaman",
		"priest",
		"druid",
	},
	["DD"]={
		"warrior",
		"deathknight",
		"paladin",
		"shaman",
		"hunter",
		"mage",
		"rogue",
		"warlock",
		"priest",
		"druid",
	},
}

FGL.db.classesgroup={
		1,
		1,
		1,
		3,
		4,
		2,
		1,
		2,
		2,
		3,
}


FGL.db.classroles={
 --association={
 --{tank}, {heal}, {dd}
 --}
 ["WARRIOR"]={
  originaltrees={"Оружие", "Неистовство", "Защита"},
  abbreviation={"армс", "фурик", "протовар"},
  association={{0,0,1},{0,0,0},{1,1,0}},
  icons={"Ability_Rogue_Eviscerate","Ability_Warrior_InnerRage","Ability_Warrior_DefensiveStance"},
 },
 ["DEATHKNIGHT"]={
  originaltrees={"Кровь", "Холод", "Нечестивость"},
  abbreviation={"бдк", "фдк", "адк"}, -- (мино предлагает адк фдк бдк)
  association={{1,1,1},{0,0,0},{1,1,1}},
  icons={"Spell_Shadow_BloodBoil","Spell_Frost_FrostNova","Spell_Shadow_ShadeTrueSight"},
 },  
 ["PALADIN"]={
  originaltrees={"Свет", "Защита", "Воздаяние"},
  abbreviation={"хпал", "ппал", "рпал"},
  association={{0,1,0},{1,0,0},{0,0,1}},
  icons={"Spell_Holy_HolyBolt","SPELL_HOLY_DEVOTIONAURA","Spell_Holy_AuraOfLight"},
 },
 ["SHAMAN"]={
  originaltrees={"Стихии", "Совершенствование", "Исцеление"},
  abbreviation={"элем", "энх", "ршам"},
  association={{0,0,0},{0,0,1},{1,1,0}},
  icons={"Spell_Nature_Lightning","Spell_Nature_LightningShield","Spell_Nature_MagicImmunity"},
 },
 ["HUNTER"]={
  originaltrees={"Чувство зверя", "Стрельба", "Выживание"},
  abbreviation={"бм", "Мм", "сурв"},
  association={{0,0,0},{0,0,0},{1,1,1}},
  icons={"Ability_Hunter_BeastTaming","Ability_Marksmanship","Ability_Hunter_SwiftStrike"},
 },    
 ["MAGE"]={
  originaltrees={"Тайная магия", "Огонь", "Лед"},
  abbreviation={"аркан", "файермаг", "фростмаг"},
  association={{0,0,0},{0,0,0},{1,1,1}},
  icons={"Spell_Holy_MagicalSentry","Spell_Fire_FireBolt02","Spell_Frost_FrostBolt02"},
 },   
 ["ROGUE"]={
  originaltrees={"Ликвидация", "Бой", "Скрытность"},
  abbreviation={"мутик", "комбат", "шд"}, -- (мино предлагает ШД)
  association={{0,0,0},{0,0,0},{1,1,1}},
  icons={"Ability_Rogue_Eviscerate","Ability_BackStab","Ability_Ambush"},
 },
 ["WARLOCK"]={
  originaltrees={"Колдовство", "Демонология", "Разрушение"},
  abbreviation={"алок", "демон", "дестрик"},
  association={{0,0,0},{0,0,0},{1,1,1}},
  icons={"Spell_Shadow_DeathCoil","Spell_Shadow_Metamorphosis","Spell_Shadow_RainOfFire"},
 },
 ["PRIEST"]={
  originaltrees={"Послушание", "Свет", "Тьма"},
  abbreviation={"дц", "хприст", "шп"},
  association={{0,0,0},{1,1,0},{1,0,1}},
  icons={"Spell_Holy_WordFortitude","Spell_Holy_HolyBolt","Spell_Shadow_ShadowWordPain"},
 },
 ["DRUID"]={
  originaltrees={"Баланс", "Сила зверя", "Исцеление"},
  abbreviation={"сова", "ферал", "рдру"},
  association={{0,1,0},{0,0,1},{1,1,0}},
  icons={"Spell_Nature_StarFall","Ability_Racial_BearForm","Spell_Nature_HealingTouch"},
 },
}


FGL.db.instnames_mods={
	"Полное название",
	"Сокращение",
	"Написать вручную",
}

FGL.db.specnames_mods={
	"Аббревиатурное",
	"Написать вручную",
}

FGL.db.instnames_modstt={
	"Используется стандартное название.",
	"Используется абревиатурное сокращение.",
	"Напишите удобное для вас название подземелья, рейда и прочего.",
}

FGL.db.specnames_modstt={
	"Используется абревиатурное сокращение.",
	"Напишите удобное для вас название.",
}

-- допускается верхний регистр

FGL.db.achievements = {
	{criteria={"за ачив", "на ачив", "за достиж", "на достиж"}},
	{ 	--Слава рейдеру Ульдуара 10
		id=2957,
		checkdiff="34",
		criteria={"СРУ", "сру 10"}
	},
	{ 	--Слава рейдеру Ульдуара 25
		id=2958,
		checkdiff="56",
		criteria={"СРУ", "сру 25"}
	},
	{ 	--Слава рейдеру Ледяной Короны 10
		id=4602,
		checkdiff="34",
		criteria={"СРЛК", "срлк"}
	},
	{ 	--Слава рейдеру Ледяной Короны 25
		id=4603,
		checkdiff="56",
		criteria={"СРЛК", "срлк"}
	},
}

FGL.db.quests = {
	{criteria={"за кв", "по кв", "кв есть", " кв "}},
}

FGL.db.reps = {
	{criteria={"репа ", " репа", " репу", "репу ", " репо", "репо ", "репы"}},
}

FGL.db.arenas = {
	{criteria={"рег ", "рега", " го ", " рег"}},
	{criteria={" нап ", "нид нап", " напа"}}
}

_G[FGL.SPACE_NAME].Flags = {1, 2, 4}

FGL.db.id_criteria={
	"ид",
	"id",
	"айди",
	"кд",
	"cd",
}

FGL.db.defbackgroundfiles={{"Пусто",    ""},}

FGL.db.soundfiles={
	{"Simon Bell",   		"Sound\\Spells\\SimonGame_Visual_GameTick.wav"},
	{"Rubber Ducky", 		"Sound\\Doodad\\Goblin_Lottery_Open01.wav"},
	{"Cartoon FX", 		"Sound\\Doodad\\Goblin_Lottery_Open03.wav"},
	{"Explosion",		"Sound\\Doodad\\Hellfire_Raid_FX_Explosion05.wav"},
	{"Shing!", 		"Sound\\Doodad\\PortcullisActive_Closed.wav"},
	{"Wham!", 		"Sound\\Doodad\\PVP_Lordaeron_Door_Open.wav"},
	{"War Drums", 		"Sound\\Event Sounds\\Event_wardrum_ogre.wav"},
	{"Cheer", 			"Sound\\Event Sounds\\OgreEventCheerUnique.wav"},
	{"Humm", 		"Sound\\Spells\\SimonGame_Visual_GameStart.wav"},
	{"Short Circuit", 		"Sound\\Spells\\SimonGame_Visual_BadPress.wav"},
	{"Fel Portal", 		"Sound\\Spells\\Sunwell_Fel_PortalStand.wav"},
	{"Fel Nova", 		"Sound\\Spells\\SeepingGaseous_Fel_Nova.wav"},
	{"Sonic Horn", 		"Sound\\Spells\\SonicHornCast.wav"},
	{"Throw Impact", 		"Sound\\Spells\\Warrior_Heroic_Throw_Impact2.wav"},
	{"Overload Effect", 		"Sound\\Spells\\Ulduar_IronConcil_OverloadEffect.wav"},
	{"You Will Die!", 		"Sound\\Creature\\CThun\\CThunYouWillDIe.wav"},
	{"Spawn", 		"Sound\\Events\\UD_DiscoBallSpawn.wav"},
	{"Horn", 			"Sound\\Events\\scourge_horn.wav"},
	{"Denied", 		"Sound\\Interface\\LFG_Denied.wav"},
	{"Dungeon Ready", 	"Sound\\Interface\\LFG_DungeonReady.wav"},
	{"Rewards", 		"Sound\\Interface\\LFG_Rewards.wav"},
	{"Role Check", 		"Sound\\Interface\\LFG_RoleCheck.wav"},
	{"Player Invite", 		"Sound\\Interface\\PlayerInviteA.wav"},
	{"Ready Check",		"Sound\\Interface\\ReadyCheck.wav"},
	{"Alarm Clock 1", 		"Sound\\Interface\\AlarmClockWarning1.wav"},
	{"Alarm Clock 2", 		"Sound\\Interface\\AlarmClockWarning2.wav"},
	{"Alarm Clock 3", 		"Sound\\Interface\\AlarmClockWarning3.wav"},
}

FGL.db.FindList={
"Подземелий",
"Подземелий (гер.)",
"Рейдов",
"Рейдов (гер.)",
}

FGL.db.msgforsaves = "Привет! В %s %s по кд (ID %d) пойдешь?"
FGL.db.msgforsaves_notinvite = "Привет! В %s %s по кд (ID %d) собирает [%s]. Если пойдешь, то пиши ему!"
FGL.db.msgforprint = "%s %s ID-%s: "

FGL.db.tooltips={
["FindGroupOptionsViewFindFrameCheckButton1"] = {"ANCHOR_TOPLEFT", "Отображать иконки всех ролей", 
	"Выбрав эту функцию, вы будете видеть ВСЕ иконки ролей которые нужны в группе/рейде. При этом сам поиск будет производится всё также по заданой вами категории."
	},
["FindGroupOptionsViewFindFrameCheckButton2"] = {"ANCHOR_TOPLEFT", "Отображать фон инста", 
	"Уберите этот флажок, если не желаете видеть картинки, которые появляются при подводе курсора к названию инста."
	},
["FindGroupOptionsViewFindFrameCheckButton3"] = {"ANCHOR_TOPLEFT", "Отображать инсты с КД", 
	"Когда отмечена эта опция, инсты с КД не скрываются и окрашиваются в серый(неактивный) цвет."
	},
["FindGroupOptionsViewFindFrameCheckButton4"] = {"ANCHOR_TOPLEFT", "Отображать сокращения",
	"Показывать сокращенные названия инстов в окне поиска."
	},
["FindGroupOptionsFrameResetButton"] = {"ANCHOR_TOPLEFT", "По умолчанию",
	"Эта кнопка устанавливает все значения на стандартные."
	},
["FindGroupOptionsViewFindFrameCheckButtonRaidFind"] = {"ANCHOR_TOPLEFT", "Отображать свои сообщения",
	"Сканировать собственные сообщения и сообщения участников рейда/группы."
	},
["FindGroupOptionsViewFindFrameCheckButtonClassFind"] = {"ANCHOR_TOPLEFT", "Отображать чужие классы",
	"Отображать сообщения в которых ваш класс предположительно не нужен."
	},
["FindGroupOptionsViewFindFrameCheckButtonShowIVK"] = {"ANCHOR_TOPLEFT", "Использовать ИВК",
	"Использование общепринятого сокращения для ИК 10/25 героик в виде ИВК"
	},
["FindGroupOptionsCreateViewFrameCheckButtonShowIVK"] = {"ANCHOR_TOPLEFT", "Использовать ИВК",
	"Использование общепринятого сокращения для ИК 10/25 героик в виде ИВК"
	},
["FindGroupOptionsFindFrameCheckButtonFilter"] = {"ANCHOR_TOPLEFT", "Фильтр сообщений",
	"Не отображать в чате сообщения, попавшие в окно поиска."
	},
["FindGroupOptionsFindFrameCheckButtonCloseFind"] = {"ANCHOR_TOPLEFT", "Фоновый Режим",
	"Аддон будет работать и искать сообщения даже если закрыт."
	},
["FindGroupOptionsInterfaceFrameCheckButton1"] = {"ANCHOR_TOPLEFT", "Показывать подсказки",
	"Показывать вот такие подсказки на кнопки и прочие элементы аддона."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonSplite"] = {"ANCHOR_TOPLEFT", "Сокращать текст сбора",
	"Сокращать предложение по сбору в общепринятный жаргонный вид."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonLider"] = {"ANCHOR_TOPLEFT", "Писать ник рейд лидера",
	"Дописывать ник лидера рейда, если вы не лидер и не помошник."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonFull"] = {"ANCHOR_TOPLEFT", "Автостоп",
	"Когда рейд/группа набрало колличество игроков заданной сложности инста то в чат посылается сообщение, что группа/рейд набраны. При этом сбор останавливается."
	},
["FindGroupOptionsCreateRuleFrameCheckButtonId"] = {"ANCHOR_TOPLEFT", "ID подземелий",
	"В тексте сбора к названию подземелия будет подписываться номер сохранения, если такой есть."
	},
["FindGroupOptionsMinimapIconFrameCheckButtonShow"] = {"ANCHOR_TOPLEFT", "Отображать кнопку у миникарты",
	"Показывать миникнопку у миникарты дающую быстрый доступ к функциям аддона."
	},
["FindGroupOptionsMinimapIconFrameCheckButtonFree"] = {"ANCHOR_TOPLEFT", "Свободное перемещение",
	"Кнопка будет откреплена от миникарты для свободного перемещения."
	},
["FindGroupOptionsAlarmFrameCheckButtonAlarmCD"] = {"ANCHOR_TOPLEFT", "Оповещать только без КД",
	"Оповещение будет игнорировать подземелья с ID."
	},






["FindGroupFrameAlarmButton"] = {"ANCHOR_TOPRIGHT", "Оповещение",
	"Когда в таблице поиска появляется новая запись, аддон может оповестить вас о ней."
	},
["FindGroupFrameCreateButton1"] = {"ANCHOR_TOPRIGHT", "Окно сбора",
	"Нажмите для перехода в режим сбора группы/рейда."
	},
["FindGroupFrameCreateButton3"] = {"ANCHOR_TOPRIGHT", "Окно сбора",
	"Нажмите для перехода в режим сбора группы/рейда. \r\r|cffffff88(Нажмите правой кнопкой чтобы остановить сбор)"
	},
["FindGroupFrameCreateButton2"] = {"ANCHOR_TOPRIGHT", "Окно поиска",
	"Нажмите для перехода в режим поиска рейда/группы."
	},
["FindGroupFrameCCDButton"] = {"ANCHOR_TOPRIGHT", "Сохраненные подземелья",
	"Список игроков и сохраненных подземелий."
	},
["FindGroupFrameConfigButton1"] = {"ANCHOR_TOPRIGHT", "Вспомогательная панель поиска",
	"Панель помогающая настроить окно поиска под личные параметры."
	},
["FindGroupFrameConfigButton2"] = {"ANCHOR_TOPRIGHT", "Вспомогательная панель сбора",
	"Панель помогающая настроить окно сбора под личные параметры."
	},
["FindGroupFrameConfigFrameButton"] = {"ANCHOR_TOPRIGHT", "Настройки",
	"Настройки всех параметров аддона."
	},
["FindGroupFramePinButton"] = {"ANCHOR_TOPRIGHT", "Блокировка",
	"Блокирование окна от перетаскиваний."
	},
["FindGroupFrameInfoButton"] = {"ANCHOR_TOPRIGHT", "Инфо",
	"Информация по этому аддону."
	},
["FindGroupFrameCloseButton"] = {"ANCHOR_TOPRIGHT", "Закрыть",
	"Нажмите для закрытия окна."
	},
["FindGroupConfigFrameHNeedsButton"] = {"ANCHOR_TOPRIGHT", "Роли",
	"Выберите роли для которых будет производится поиск."
	},
["FindGroupConfigFrameHTextButton"] = {"ANCHOR_TOPRIGHT", "Текст отправляемый игроку",
	"пати"
	},
["FindGroupConfigFrameHOtherButton"] = {"ANCHOR_TOPRIGHT", "Оповещение",
	"Создайте свой список для оповещения."
	},
["FindGroupShadowClearButton"] = {"ANCHOR_TOPRIGHT", "Очистить",
	"Очистить весь список оповещений."
	},
["FindGroupShadowAddButton"] = {"ANCHOR_TOPRIGHT", "Добавить",
	"Добавить еще один критерий в список оповещений."
	},
["FindGroupConfigFrameHActButton"] = {"ANCHOR_TOPRIGHT", "Продолжительность собщений",
	"Продолжительность собщений игроков в окне поиска. (регулируется левой и правой кнопкой мыши)"
	},
["FindGroupConfigFrameHChannelsButton"] = {"ANCHOR_TOPRIGHT", "Каналы",
	"Выберите каналы в которые будет отслылаться сообщение сбора."
	},
["FindGroupShowTextClearButton"] = {"ANCHOR_TOPRIGHT", "Стереть",
	"Очистка дополнительного текста сбора."
	},
["FindGroupConfigFrameHSaveButton"] = {"ANCHOR_TOPRIGHT", "Список сохраненных сборов",
	"Окно в котором вы можете загрузить сохраненный сбор."
	},
["FindGroupFrameMiniSaveButton"] = {"ANCHOR_TOPRIGHT", "Сохранить",
	"Нажмите для сохранения ролей классов и прочей информации как новый вариант параметров."
	},
["FindGroupFrameMiniInsButton"] = {"ANCHOR_TOPRIGHT", "Применить",
	"Вставить настройки в текущий вариант параметров."
	},	
["FindGroupFrameMiniClearButton"] = {"ANCHOR_TOPRIGHT", "Очистить",
	"Отвязать режим от текущего варианта параметров"
	},
["FindGroupFrameMiniCancelButton"] = {"ANCHOR_TOPRIGHT", "Отмена",
	"Отменить последнии манипуляции над вариантом параметров."
	},
["FindGroupSaveListFrameClearButton"] = {"ANCHOR_TOPRIGHT", "Очистить",
	"Очистить список сохранений."
	},
["FindGroupFrameCalculate"] = {"ANCHOR_TOPRIGHT", "Автоподбор",
	"Помогает в окне сбора автоподсчитать роли исходя из спеков вблизи стоящих членов группы/рейда."
	},
["FindGroupSavesFrameSendButton"] = {"ANCHOR_TOPRIGHT", "Рассылка сообщений",
	"Все игроки, которые в сети, будут уведомлены о наборе по кд в данное подземелье."
	},
["FindGroupSavesFramePrintButton"] = {"ANCHOR_TOPRIGHT", "Распечатать список",
	"Текущий список игроков будет отправлен в чат-рейд или группу."
	},
["FindGroupSavesFrameCloseButton"] = {"ANCHOR_TOPRIGHT", "Закрыть",
	"Нажмите для закрытия окна."
	},
["FindGroupSavesFrameBackButton"] = {"ANCHOR_TOPRIGHT", "Назад",
	"Нажмите для возврата в предыдущее окно."
	},

["SavesPlus"] = {"ANCHOR_TOPRIGHT", "Пригласить",
	"Пригласить в группу."
	},
["SavesSend"] = {"ANCHOR_TOPRIGHT", "Шепнуть игроку",
	"Игроку отправится текст:\n"
	},


["FindGroupFrameMinimapButton"] = 		{"ANCHOR_TOPRIGHT", "FindGroup: Link", ""},
["FindGroupFrameFindLineTextToolTip"] = 		{"ANCHOR_TOPRIGHT", "Отправить запрос", ""},
["FindGroupFrameFindLineHeal"] = 			{"ANCHOR_TOPRIGHT", "Лечение", ""},
["FindGroupFrameFindLineTank"] = 			{"ANCHOR_TOPRIGHT", "Защита", ""},
["FindGroupFrameFindLineDD"] = 			{"ANCHOR_TOPRIGHT", "Атака", ""},
["FindGroupFrameFindLineHead"] = 			{"ANCHOR_TOPRIGHT", "Героическая сложность", ""},
}

FGL.db.shadow={
	{
		texts={
			"Критерии фильтра для возможности:",
			"Принять",
		},
		widgets={
			"FindGroupShadowCheckButton1",
			"FindGroupShadowCheckButton2",
			"FindGroupShadowCheckButton3",
			"FindGroupShadowCheckText1",
			"FindGroupShadowCheckText2",
			"FindGroupShadowCheckText3",
			"FindGroupShadowCheckButton4",
			"FindGroupShadowCheckButton5",
			"FindGroupShadowCheckText4",
			"FindGroupShadowCheckText5",
			"FindGroupShadowArenaFind",
			"FindGroupShadowArenaReg",
			"FindGroupShadowTank",
			"FindGroupShadowDD",
			"FindGroupShadowHeal"
		}
	},
	{
		texts={
			"Редактор шаблона сообщений:",
			"Принять",
		},
		widgets={
			"FindGroupShadowEdit",
			"FindGroupShadowEditBox",
			"FindGroupShadowPanel1",
			"FindGroupShadowFastButton",
		}
	},
	{
		texts={
			"Оповещение:",
			"Принять",
		},
		widgets={
			"FindGroupShadowTitleInst",
			"FindGroupShadowTitleIR",
			"FindGroupShadowComboBox1",
			"FindGroupShadowComboBox3",
			
			"FindGroupShadowScrollFrame",
			"FindGroupShadowPanelFrame",
			"FindGroupShadowAddButton",
			"FindGroupShadowClearButton",
		}
	},
	{
		texts={
			"",
			"Отправить",
		},
		widgets={
			"FindGroupShadowEditBox2",
			"FindGroupShadowPanel2",
		}
	},
	{
		texts={
			"",
			"Отправить",
		},
		widgets={
			"FindGroupShadowEditBox2",
			"FindGroupShadowPanel2",
		}
	},
	--[[
	{
		texts={
			"Редактирование классов",
			"Принять",
		},
		widgets={
			"FindGroupClasses",
		}
	},
	]]


}

FGL.db.wigets={

configframe="FindGroupConfigFrameH",
configbuttons={
"FindGroupConfigFrameHActButton",
"FindGroupConfigFrameHTextButton",
"FindGroupConfigFrameHNeedsButton",
"FindGroupConfigFrameHOtherButton",
"FindGroupConfigFrameHChannelsButton",
"FindGroupConfigFrameHSaveButton",
},

mainwigets2={
"FindGroupFrameSlider",
"FindGroupFrameSliderButtonUp",
"FindGroupFrameSliderButtonDown",
{"FindGroupFrameFindLine"},
},

mainwigets1={
"FindGroupConfigFrameHActButton",
"FindGroupConfigFrameHTextButton",
"FindGroupConfigFrameHNeedsButton",
"FindGroupConfigFrameHOtherButton",
"FindGroupTooltip",
--{"FindGroupFrameFindLine"},
},

createwigets={
"FindGroupConfigFrameHChannelsButton",
"FindGroupConfigFrameHSaveButton",
"FindGroupConfigFrameHSecFrame",


"FindGroupFrameTitleInst",
"FindGroupFrameTitleIR",
"FindGroupFrameTime",

"FindGroupFrameComboBox1",
"FindGroupFrameComboBox3",
"FindGroupFrameSec",
"FindGroupFramePanel3",

"FindGroupFrameTriggerButton",
"FindGroupFrameTankh",
"FindGroupFrameHealh",
"FindGroupFrameDDh",
"FindGroupFrameTank",
"FindGroupFrameHeal",
"FindGroupFrameDD",
"FindGroupFrameEditTank",
"FindGroupFrameEditHeal",
"FindGroupFrameEditDD",
"FindGroupFramePanelHeal",
"FindGroupFramePanelTank",
"FindGroupFramePanelDD",
"FindGroupFrameDTank",
"FindGroupFrameUTank",
"FindGroupFrameDHeal",
"FindGroupFrameUHeal",
"FindGroupFrameDDD",
"FindGroupFrameUDD",

"FindGroupFrameMiniSaveButton",
"FindGroupFrameMiniInsButton",
"FindGroupFrameMiniClearButton",
"FindGroupFrameMiniCancelButton",

"FindGroupFrameCalculate",
"FindGroupFrameSliderTankHeal",
"FindGroupFrameSliderHealDD",
},

stringwigets={
"FindGroupFrameFindLine",
},

stringwigets2={
{"FindGroupFrameFindLine"},
},

optionframes={
"Find",
"ViewFind",
"Alarm",
"CreateRule",
"CreateView",
"Interface",
"MinimapIcon",
},

}


FGL.db.nummsgsmax=0
FGL.db.boxshowstatus=0
FGL.db.enterline=0
FGL.db.framemove=0
FGL.db.createstatus=0
FGL.db.mtooltipstatus = 0

FGL.db.lastmsg={}
FGL.db.tooltippoints={}
FGL.db.needs={}
FGL.db.arena={}
FGL.db.findlistvalues={}
FGL.db.findpatches={}
FGL.db.createpatches={}
FGL.db.alarmpatches={}
FGL.db.alarmlist={}

FGL.db.findinstnamelist={}
FGL.db.createinstnamelist={}

--[[
FGL.db.msgTEXT
FGL.db.msgTEXT2
FGL.db.includeaddon
FGL.db.timeleft
FGL.db.msgforparty
FGL.db.global_sender
FGL.db.framealpha
FGL.db.alarminst
FGL.db.alarmir
FGL.db.alarmsound
FGL.db.defbackground
FGL.db.framealphaback
FGL.db.framealphafon
FGL.db.framescale
FGL.db.linefadesec

FGL.db.configstatus
FGL.db.changebackdrop
FGL.db.showstatus
FGL.db.faststatus
FGL.db.pinstatus
FGL.db.raidcdstatus
FGL.db.iconstatus
FGL.db.closefindstatus
FGL.db.channelyellstatus
FGL.db.channelguildstatus
FGL.db.tooltipsstatus
FGL.db.alarmstatus
FGL.db.raidfindstatus
FGL.db.instsplitestatus
]]--



----------------------------------------------------------------------- Init---------------------------------------------

function FindGroup_LoadConfig()
		if FindGroup_AddBackgrounds then
			FGL.db.defbackgroundfiles=FindGroup_AddBackgrounds()
		end
		FindGroupFrameSlider:Disable()
		FindGroupFrameSlider:Hide()
		FindGroupFrameSliderButtonUp:Hide()
		FindGroupFrameSliderButtonDown:Hide()
		
for i=1, #FGL.db.wigets.optionframes do
getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[i].."Frame"):Hide()
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[i]):UnlockHighlight()
end

	if not FindGroupCharVars then FindGroupCharVars = {} end -- fresh DB
	if not FindGroupCharVars.usingtime then FindGroupCharVars.usingtime = 0 end
	if not(type(FindGroupCharVars.lowversion) == 'table') or not FindGroupCharVars.lowversion then FindGroupCharVars.lowversion = {} end
	
	local x, y  = FindGroupCharVars.X, FindGroupCharVars.Y
	if not x or not y then
		FindGroupFrame:ClearAllPoints()
		FindGroupFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", UIParent:GetWidth()/2 - FindGroupFrame:GetWidth()/2, - UIParent:GetHeight()/2 + FindGroupFrame:GetHeight()/2)
		FindGroup_SaveAnchors()
	else
		FindGroupFrame:ClearAllPoints()
		FindGroupFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)

	end
		FindGroupFrame:SetWidth(280)
		FindGroupFrame:SetHeight(126)
		
	if not(type(FindGroupCharVars.NEEDS) == 'table') or not FindGroupCharVars.NEEDS then FindGroupCharVars.NEEDS=FGL.db.defparam["needs"] end
	for h=1,3 do FGL.db.needs[h] = FindGroupCharVars.NEEDS[h] end
	if not(type(FindGroupCharVars.arena) == 'table') or not FindGroupCharVars.arena then FindGroupCharVars.arena=FGL.db.defparam["arena"] end
	for h=1,2 do FGL.db.arena[h] = FindGroupCharVars.arena[h] end
	
	if not(type(FindGroupCharVars.findlistvalues) == 'table') or not FindGroupCharVars.findlistvalues then FindGroupCharVars.findlistvalues=FGL.db.defparam["findlistvalues"] end
	for h=1,#FindGroupCharVars.findlistvalues do FGL.db.findlistvalues[h] = FindGroupCharVars.findlistvalues[h] end

	if not(type(FindGroupCharVars.findpatches) == 'table') or not FindGroupCharVars.findpatches then FindGroupCharVars.findpatches=FGL.db.defparam["findpatches"] end
	for h=1, #FGL.db.defparam["findpatches"] do if not(FindGroupCharVars.findpatches[h]) then FindGroupCharVars.findpatches[h] = FGL.db.defparam["findpatches"][h] end end
	for h=1, #FindGroupCharVars.findpatches do FGL.db.findpatches[h] = FindGroupCharVars.findpatches[h] end

	if not(type(FindGroupCharVars.createpatches) == 'table') or not FindGroupCharVars.createpatches then FindGroupCharVars.createpatches=FGL.db.defparam["createpatches"] end
	for h=1, #FGL.db.defparam["createpatches"] do if not(FindGroupCharVars.createpatches[h]) then FindGroupCharVars.createpatches[h] = FGL.db.defparam["createpatches"][h] end end
	for h=1, #FindGroupCharVars.createpatches do FGL.db.createpatches[h] = FindGroupCharVars.createpatches[h] end

	if not(type(FindGroupCharVars.alarmpatches) == 'table') or not FindGroupCharVars.alarmpatches then FindGroupCharVars.alarmpatches=FGL.db.defparam["alarmpatches"] end
	for h=1, #FGL.db.defparam["alarmpatches"] do if not(FindGroupCharVars.alarmpatches[h]) then FindGroupCharVars.alarmpatches[h] = FGL.db.defparam["alarmpatches"][h] end end
	for h=1, #FindGroupCharVars.alarmpatches do FGL.db.alarmpatches[h] = FindGroupCharVars.alarmpatches[h] end

	if not(type(FindGroupCharVars.ALARMLIST) == 'table') or not FindGroupCharVars.ALARMLIST then FindGroupCharVars.ALARMLIST=FGL.db.defparam["alarmlist"] end
	for h=1, #FindGroupCharVars.ALARMLIST do FGL.db.alarmlist[h] = FindGroupCharVars.ALARMLIST[h] end
	
	if not(FindGroupCharVars.enterinstnamelist) then
		FindGroupCharVars.enterinstnamelist = 1
		FindGroupCharVars.findinstnamelist={}
		FindGroupCharVars.createinstnamelist={}
	end

	if not(FindGroupCharVars.newbuild==FGL.SPACE_BUILD) then
		FindGroupCharVars.newbuild=FGL.SPACE_BUILD
		FindGroupCharVars.o_chsum = FGL.db.chsum
		if FindGroupCharVars.DEFBACKGROUND then
			FindGroupCharVars.DEFBACKGROUND = FGL.db.defparam["defbackground"]
		end
	end
	
	if FindGroupCharVars.o_chsum then
		if FindGroupCharVars.o_chsum ~= FGL.db.chsum then
			FindGroupDB.getback=1
		end
	end
	
	if not(type(FindGroupCharVars.findTinstnamelist) == 'table') or not FindGroupCharVars.findTinstnamelist then 
		FindGroupCharVars.findTinstnamelist={}
	end

	if not(type(FindGroupCharVars.createTinstnamelist) == 'table') or not FindGroupCharVars.createTinstnamelist then 
		FindGroupCharVars.createTinstnamelist={}
	end	
	
	if not(type(FindGroupCharVars.createspecnamelist) == 'table') or not FindGroupCharVars.createspecnamelist then 
		FindGroupCharVars.createspecnamelist={}
		FGL.db.createspecnamelist={}
		for i=1, #FGL.db.iconclasses.dd do
			local class = string.upper(FGL.db.iconclasses.dd[i])
			FindGroupCharVars.createspecnamelist[class]={}
			FGL.db.createspecnamelist[class]={}
			for j=1, 3 do
				FindGroupCharVars.createspecnamelist[class][j] = FGL.db.classroles[class].abbreviation[j]
				FGL.db.createspecnamelist[class][j] = FGL.db.classroles[class].abbreviation[j]
			end
		end	
	else
		FGL.db.createspecnamelist={}
		for i=1, #FGL.db.iconclasses.dd do
			local class = string.upper(FGL.db.iconclasses.dd[i])
			FGL.db.createspecnamelist[class]={}
			for j=1, 3 do
				FGL.db.createspecnamelist[class][j] = FindGroupCharVars.createspecnamelist[class][j]
			end
		end	
	end

	FGL.db.findTinstnamelist = {}	
	FGL.db.createTinstnamelist = {}
		
	for h=1, #FGL.db.instances do
		local i_name = FGL.db.instances[h].name
		
		if not(FindGroupCharVars.findTinstnamelist[i_name]) then
			FindGroupCharVars.findTinstnamelist[i_name] = FGL.db.instances[h].abbreviationeng
		end
		FGL.db.findTinstnamelist[i_name] = FindGroupCharVars.findTinstnamelist[i_name]
		
		if not(FindGroupCharVars.createTinstnamelist[i_name]) then
			FindGroupCharVars.createTinstnamelist[i_name] = FGL.db.instances[h].namecreatepartyraid
		end
		FGL.db.createTinstnamelist[i_name] = FindGroupCharVars.createTinstnamelist[i_name]
	end
	
	

	FGL.db.msgforparty = FindGroupCharVars.MSGFORPARTY
		if not FGL.db.msgforparty then FGL.db.msgforparty = FGL.db.defparam["msgforparty"] end
		FindGroupCharVars.MSGFORPARTY = FGL.db.msgforparty
		FindGroupShadowEditBox:SetText(FGL.db.msgforparty)

	FGL.db.showstatus = FindGroupCharVars.SHOWSTATUS
		if FGL.db.showstatus == nil then FGL.db.showstatus = FGL.db.defparam["showstatus"] end
		if FGL.db.showstatus == 1 then FindGroup_ShowWindow() end

	FGL.db.configstatus = FindGroupCharVars.CONFIGSTATUS
		if FGL.db.configstatus == nil then FGL.db.configstatus = FGL.db.defparam["configstatus"] end
		if FGL.db.configstatus == 1 then FGL.db.configstatus = 0 else FGL.db.configstatus = 1 end
		FindGroup_ConfigButton()

 	FGL.db.timeleft = FindGroupCharVars.TIMELEFT
		if not FGL.db.timeleft then FGL.db.timeleft = FGL.db.defparam["timeleft"] - 15 else FGL.db.timeleft = FGL.db.timeleft - 15 end
		FindGroup_ActButton(nil,"LeftButton")

 	FGL.db.faststatus = FindGroupCharVars.FASTSTATUS
		if FGL.db.faststatus == nil then FGL.db.faststatus = FGL.db.defparam["faststatus"] end
		if FGL.db.faststatus == 1 then FGL.db.faststatus = 0 else FGL.db.faststatus = 1 end
		FindGroup_FastButton()

	FGL.db.pinstatus = FindGroupCharVars.PINSTATUS
		if FGL.db.pinstatus == nil then FGL.db.pinstatus = FGL.db.defparam["pinstatus"] end
		if FGL.db.pinstatus == 1 then FGL.db.pinstatus = 0 else FGL.db.pinstatus = 1 end
		FindGroup_PinButton()

	FGL.db.alarmstatus = FindGroupCharVars.ALARMSTATUS
		if FGL.db.alarmstatus == nil then FGL.db.alarmstatus = FGL.db.defparam["alarmstatus"] end
		if FGL.db.alarmstatus == 1 then FGL.db.alarmstatus = 0 else FGL.db.alarmstatus = 1 end
		FindGroup_AlarmButton()

	FGL.db.raidcdstatus = FindGroupCharVars.RAIDCDSTATUS
		if FGL.db.raidcdstatus == nil then FGL.db.raidcdstatus = FGL.db.defparam["raidcdstatus"] end
		FindGroupCharVars.RAIDCDSTATUS = FGL.db.raidcdstatus

	FGL.db.changebackdrop = FindGroupCharVars.changebackdrop
		if FGL.db.changebackdrop == nil then FGL.db.changebackdrop = FGL.db.defparam["changebackdrop"] end
		FindGroupCharVars.changebackdrop = FGL.db.changebackdrop

	FGL.db.closefindstatus = FindGroupCharVars.CLOSEFINDSTATUS
		if FGL.db.closefindstatus == nil then FGL.db.closefindstatus = FGL.db.defparam["closefindstatus"] end
		FindGroupCharVars.CLOSEFINDSTATUS = FGL.db.closefindstatus

	FGL.db.iconstatus = FindGroupCharVars.ICONSTATUS
		if FGL.db.iconstatus == nil then FGL.db.iconstatus = FGL.db.defparam["iconstatus"] end
		FindGroupCharVars.ICONSTATUS = FGL.db.iconstatus

	FGL.db.channelyellstatus = FindGroupCharVars.CHANNELYELLSTATUS
		if FGL.db.channelyellstatus == nil then FGL.db.channelyellstatus = FGL.db.defparam["channelyellstatus"] end
		FindGroupCharVars.CHANNELYELLSTATUS = FGL.db.channelyellstatus

	FGL.db.channelguildstatus = FindGroupCharVars.CHANNELGUILDSTATUS
		if FGL.db.channelguildstatus == nil then FGL.db.channelguildstatus = FGL.db.defparam["channelguildstatus"] end
		FindGroupCharVars.CHANNELGUILDSTATUS = FGL.db.channelguildstatus

	FGL.db.channelfilterstatus = FindGroupCharVars.CHANNELFILTERSTATUS
		if FGL.db.channelfilterstatus == nil then FGL.db.channelfilterstatus = FGL.db.defparam["channelfilterstatus"] end
		FindGroupCharVars.CHANNELFILTERSTATUS = FGL.db.channelfilterstatus		
		
	FGL.db.tooltipsstatus = FindGroupCharVars.TOOLTIPSSTATUS
		if FGL.db.tooltipsstatus == nil then FGL.db.tooltipsstatus = FGL.db.defparam["tooltipsstatus"] end
		FindGroupCharVars.TOOLTIPSSTATUS = FGL.db.tooltipsstatus

	FGL.db.framealpha = FindGroupCharVars.FRAMEALPHA
		if FGL.db.framealpha == nil then FGL.db.framealpha = FGL.db.defparam["framealpha"] end
		FindGroupOptionsInterfaceFrameSlider:SetValue(FGL.db.framealpha)
		FindGroupCharVars.FRAMEALPHA = FGL.db.framealpha

	FGL.db.framealphaback = FindGroupCharVars.FRAMEALPHABACK
		if FGL.db.framealphaback == nil then	FGL.db.framealphaback = FGL.db.defparam["framealphaback"] end
		FindGroupOptionsInterfaceFrameSliderBack:SetValue(FGL.db.framealphaback)
		FindGroupCharVars.FRAMEALPHABACK = FGL.db.framealphaback

	FGL.db.framealphafon = FindGroupCharVars.FRAMEALPHAFON
		if FGL.db.framealphafon == nil then FGL.db.framealphafon = FGL.db.defparam["framealphafon"] end
		FindGroupOptionsInterfaceFrameSliderFon:SetValue(FGL.db.framealphafon)
		FindGroupCharVars.FRAMEALPHAFON = FGL.db.framealphafon

	FGL.db.framescale = FindGroupCharVars.FRAMESCALE
		if FGL.db.framescale == nil then FGL.db.framescale = FGL.db.defparam["framescale"] end
		FindGroupOptionsInterfaceFrameSliderScale:SetValue(FGL.db.framescale)
		FindGroup_ScaleUpdate()
		FindGroupCharVars.FRAMESCALE = FGL.db.framescale

	FGL.db.linefadesec = FindGroupCharVars.LINEFADESEC
		if FGL.db.linefadesec == nil then FGL.db.linefadesec = FGL.db.defparam["linefadesec"] end
		FindGroupOptionsViewFindFrameSliderFade:SetValue(FGL.db.linefadesec)
		FindGroup_FadeUpdate()
		FindGroupCharVars.LINEFADESEC = FGL.db.linefadesec

	FGL.db.alarminst = FindGroupCharVars.ALARMINST
		if FGL.db.alarminst == nil then FGL.db.alarminst = FGL.db.defparam["alarminst"] end
		FindGroupCharVars.ALARMINST = FGL.db.alarminst

	FGL.db.alarmsound = FindGroupCharVars.ALARMSOUND
		if FGL.db.alarmsound == nil then FGL.db.alarmsound = FGL.db.defparam["alarmsound"] end
		FindGroupCharVars.ALARMSOUND = FGL.db.alarmsound

	FGL.db.alarmcd = FindGroupCharVars.ALARMCD
		if FGL.db.alarmcd == nil then FGL.db.alarmcd = FGL.db.defparam["alarmcd"] end
		FindGroupCharVars.ALARMCD = FGL.db.alarmcd
		
	FGL.db.raidfindstatus = FindGroupCharVars.RAIDFINDSTATUS
		if FGL.db.raidfindstatus == nil then FGL.db.raidfindstatus = FGL.db.defparam["raidfindstatus"] end
		FindGroupCharVars.RAIDFINDSTATUS = FGL.db.raidfindstatus

	FGL.db.classfindstatus = FindGroupCharVars.CLASSFINDSTATUS
		if FGL.db.classfindstatus == nil then FGL.db.classfindstatus = FGL.db.defparam["classfindstatus"] end
		FindGroupCharVars.CLASSFINDSTATUS = FGL.db.classfindstatus
		
	FGL.db.instsplitestatus = FindGroupCharVars.instsplitestatus
		if FGL.db.instsplitestatus == nil or FGL.db.instsplitestatus == 0 then FGL.db.instsplitestatus = FGL.db.defparam["instsplitestatus"] end
		FindGroupCharVars.instsplitestatus = FGL.db.instsplitestatus

	FGL.db.defbackground = FindGroupCharVars.DEFBACKGROUND
		if FGL.db.defbackground == nil then FGL.db.defbackground = FGL.db.defparam["defbackground"] end
		FindGroupCharVars.DEFBACKGROUND = FGL.db.defbackground
		FindGroup_SetBackGround()

	FGL.db.alarmir = FindGroupCharVars.ALARMIR
		if FGL.db.alarmir == nil then FGL.db.alarmir = FGL.db.defparam["alarmir"] end
		FindGroupCharVars.ALARMIR = FGL.db.alarmir	

	FGL.db.minimapiconshow = FindGroupCharVars.MINIMAPICONSHOW
		if FGL.db.minimapiconshow == nil then FGL.db.minimapiconshow = FGL.db.defparam["minimapiconshow"] end
		FindGroupCharVars.MINIMAPICONSHOW = FGL.db.minimapiconshow

	FGL.db.minimapiconfree = FindGroupCharVars.MINIMAPICONFREE
		if FGL.db.minimapiconfree == nil then FGL.db.minimapiconfree = FGL.db.defparam["minimapiconfree"] end
		FindGroupCharVars.MINIMAPICONFREE = FGL.db.minimapiconfree
		
	FGL.db.showivk = FindGroupCharVars.SHOWIVK
		if FGL.db.showivk == nil then FGL.db.showivk = FGL.db.defparam["showivk"] end
		FindGroupCharVars.SHOWIVK = FGL.db.showivk

	FGL.db.configindex = FindGroupCharVars.CONFIGINDEX
		if FGL.db.configindex == nil then FGL.db.configindex = 1 end
		FindGroupCharVars.CONFIGINDEX = FGL.db.configindex
		getglobal("FindGroupOptions"..FGL.db.wigets.optionframes[FGL.db.configindex].."Frame"):Show()
		getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[FGL.db.configindex]):SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")
		getglobal("FindGroupOptionsFrameButton"..FGL.db.wigets.optionframes[FGL.db.configindex]):LockHighlight()
		
	if FindGroupCharVars.DEFBACKGROUND>#FGL.db.defbackgroundfiles then
		FindGroupCharVars.DEFBACKGROUND = FGL.db.defparam["defbackground"]
	end
	
	local flag=true
	for h=1,3 do 
		if not FGL.db.needs[h] then flag = false end
	end
	if flag then
		FindGroupOptionsViewFindFrameCheckButton1:Disable()
		FGL.db.iconstatus = 1
		FindGroupCharVars.ICONSTATUS = FGL.db.iconstatus
	else
		FindGroupOptionsViewFindFrameCheckButton1:Enable()
		FGL.db.iconstatus = 1
		FindGroupCharVars.ICONSTATUS = FGL.db.iconstatus
	end
	if FGL.db.configstatus == 1 then
		FindGroup_ShowConfigPanel()
	end
end

local FindGroup_ResetAllConfig = function()
FindGroup_CreateOff()
FGL.db.createstatus = 1
FindGroup_CreateButton()

local buff = FindGroupCharVars.FGS
local buff2 = FindGroupCharVars.usingtime
local buff3 = FindGroupCharVars.usrflags
local buff4 = FindGroupCharVars.firstrun
local buff5 = FindGroupCharVars.lowversion[FGL.SPACE_VERSION]

FindGroupCharVars = {}

FindGroupCharVars.FGS = buff
FindGroupCharVars.usingtime = buff2
FindGroupCharVars.usrflags = buff3
FindGroupCharVars.firstrun = buff4
	if not(type(FindGroupCharVars.lowversion) == 'table') or not FindGroupCharVars.lowversion then FindGroupCharVars.lowversion = {} end
FindGroupCharVars.lowversion[FGL.SPACE_VERSION] = buff5
FindGroupCharVars.FGC =nil

FindGroup_LoadConfig()
FindGroup_CloseInfo()

FindGroupOptionsFrame:Hide()
FindGroupShadow:Hide()
FindGroupChannel:Hide()
FindGroupShowText:Hide()
FindGroupTooltip:Hide()
GameTooltip:Hide()
FindGroupConfigFrameH:Hide()
FindGroupFrame:Show()


FGC_OnLoad()

FindGroupSaves_OnLoad()
FindGroup_ShowMinimapIcon()
FindGroupOptionsFrame:ClearAllPoints()
FindGroupOptionsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
FindGroupChannel:ClearAllPoints()
FindGroupChannel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
FindGroupShowText:ClearAllPoints()
FindGroupShowText:SetPoint("BOTTOMLEFT", FindGroupFrame, "TOPLEFT", 0, 2)
end

local FINDGROUP_CONFIRM_CLEAR_CONFIG = "Вы действительно хотите привести все настройки к стандартным?"
_G.StaticPopupDialogs["FINDGROUP_CONFIRM_CLEAR_CONFIG"] = {
	text = FINDGROUP_CONFIRM_CLEAR_CONFIG,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FindGroup_ResetAllConfig()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
}

function FindGroup_OnLoad()

---- new save mode
if type(FindGroupDB) ~= 'table' then
	FindGroupDB = {}
end
	if type(FindGroupDB[FGL.RealmName]) ~= 'table' then
		FindGroupDB[FGL.RealmName] = {}
	end
		if type(FindGroupDB[FGL.RealmName][FGL.CharName]) ~= 'table' then
			FindGroupDB[FGL.RealmName][FGL.CharName] = {}
		end
FindGroupCharVars = FindGroupDB[FGL.RealmName][FGL.CharName]
---
	FindGroup_LoadConfig()

	-- slash command
	SLASH_FindGroup1 = "/FindGroup";
	SLASH_FindGroup2 = "/fg";  
	SlashCmdList["FindGroup"] = function (msg)
		if getglobal(FGL.SPACE_NAME).SlashCmdList(msg) 
		then return end
		if msg == "show" or msg == "open" then
			FindGroup_ShowWindow()
		elseif msg == "hide" or msg == "close" then
			FindGroup_HideWindow()
		elseif msg == "reset" then
			StaticPopup_Show("FINDGROUP_CONFIRM_CLEAR_CONFIG")
		elseif msg:find("conf") then
			FindGroup_ShowOptions()
		elseif msg == "toggle" then
			if FGL.db.showstatus == 1 then
			FindGroup_HideWindow()
			else
			FindGroup_ShowWindow()
			end
		else
			FindGroup_ShowWindow()
		end
	end
	FGL.db.includeaddon = 1
	FindGroup_LoadMinimapIcon()
	FindGroup_ScrollChanged(FindGroupFrameSlider:GetValue())
	FindGroupFrame:EnableMouseWheel(true)
	FindGroupFrame:SetScript("OnMouseWheel", function(self, delta)
	if FindGroupFrameSlider:IsEnabled() then
		FindGroupFrameSlider:SetValue(FindGroupFrameSlider:GetValue()-delta) end
	end)
	FindGroup_ShowText1()
	if FindGroupCharVars.lowversion[FGL.SPACE_VERSION] then
		FindGroupInfoVesr:Show()
	end
end