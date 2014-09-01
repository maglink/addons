local root = "Interface\\AddOns\\FindGroup\\textures\\backgrounds\\"

local my_add_table = {
	{"Крепость Нерубиана",    		"UI-LFG-BACKGROUND-Nerubian.tga"},
	{"Черный Храм",				"UI-LFG-BACKGROUND-blacktemplecitadel.tga"},
	{"Резервуар Темного Клыка",		"UI-LFG-BACKGROUND-Coilfangreservoir.tga"},
	{"Сильвана",         			"UI-LFG-BACKGROUND-Silvana.tga"},
	{"Обитель Демонов",			"UI-LFG-BACKGROUND-demonshouse.tga"},
	{"Монастырь Алого Ордена",     		"UI-LFG-BACKGROUND-Scarlet.tga"},
	{"Прибрежная Деревушка",		"UI-LFG-BACKGROUND-Vilage.tga"},
	{"Пропасть",      			"UI-LFG-BACKGROUND-Pit.tga"},
	{"Разрушенный город",    		"UI-LFG-BACKGROUND-RuinedCity.tga"},
	{"Цитадель Адского пламени",		"UI-LFG-BACKGROUND-HellfireCitadelBack.tga"},
	{"Лесная Глушь",    			"UI-LFG-BACKGROUND-Enviroment.tga"},
	{"Подземелье",				"UI-LFG-BACKGROUND-Dungeon.tga"},
	{"Пещера",				"UI-LFG-BACKGROUND-Cave.tga"},
	{"Запределье",   			"UI-LFG-BACKGROUND-planet.tga"},
	{"Гилнеас",   				"UI-LFG-BACKGROUND-Houses.tga"},
	{"Король Лич",    			"UI-LFG-BACKGROUND-Artas.tga"},
	{"Бронзобород",      			"UI-LFG-BACKGROUND-Bronzebeard.tga"},
	{"Неуязвимый",         			"UI-LFG-BACKGROUND-Invinсible.tga"},
	{"Кельтас",   				"UI-LFG-BACKGROUND-Kaelthas.tga"},
	{"КелТузад",      			"UI-LFG-BACKGROUND-KelTuzad.tga"},
	{"Неутомимый чернокнижник",		"UI-LFG-BACKGROUND-Warlock.tga"},
	{"КельТалас",				"UI-LFG-BACKGROUND-KelTalas.tga"},
	{"Эльфийские Окрестности",		"UI-LFG-BACKGROUND-Teldrasil.tga"},
	{"Открытия Врат АнКиража",		"UI-LFG-BACKGROUND-Gatesofanqiraj.tga"},
	{"Зиккураты плети",    			"UI-LFG-BACKGROUND-Ziggurat.tga"},
	{"Восстание нежити",      		"UI-LFG-BACKGROUND-Undeads.tga"},
	{"Ошугун",      			"UI-LFG-BACKGROUND-Oshugun.tga"},
	{"Темница душ",      			"UI-LFG-BACKGROUND-SoulPrison.tga"},
	{"Покои Лорда Ребрада",         	"UI-LFG-BACKGROUND-deadlands.tga"},
	{"Лес Хрустальной Песни",		"UI-LFG-BACKGROUND-CrystalWood.tga"},
	{"Пеплоуст",        			"UI-LFG-BACKGROUND-Draenei.tga"},
	{"Оплот Акеруса",     			"UI-LFG-BACKGROUND-EbonHold.tga"},
	{"Хижина Кулуака",       		"UI-LFG-BACKGROUND-Kuluak.tga"},
	{"Подгород",      			"UI-LFG-BACKGROUND-Lordaeron.tga"},
	{"Возмездие",        			"UI-LFG-BACKGROUND-Retribution.tga"},
	{"Топи Шолозара",        		"UI-LFG-BACKGROUND-Sholozar.tga"},
	{"Залы Ульдуара",			"UI-LFG-BACKGROUND-UlduarHalls.tga"},
	{"Остров Кровавой Дымки",		"UI-LFG-BACKGROUND-Bloodmystisle.tga"},
	{"Цитадель Ледяной Короны",		"UI-LFG-BACKGROUND-ICC.tga"},
	{"Азжол-Неруб",				"UI-LFG-BACKGROUND-Dungeonnerubian.tga"},
	{"Руины Аукиндона",			"UI-LFG-BACKGROUND-Auchindon.tga"},
	{"Череп на стене",       		"UI-LFG-BACKGROUND-Skullwall.tga"},
	{"Знамя Орды",         			"UI-LFG-BACKGROUND-HordeFlag.tga"},
	{"Екзодар",				"UI-LFG-BACKGROUND-Exodar.tga"},
	{"Тайны Гномов",			"UI-LFG-BACKGROUND-Gnomssecrets.tga"},
	{"Троль",				"UI-LFG-BACKGROUND-Troll.tga"},

}

function FindGroup_AddBackgrounds()
	local my_table = {}
	for i=1, #my_add_table do
		if not my_add_table[i][2]:find(root) then
			my_add_table[i][2] = root..my_add_table[i][2]
		end
		tinsert(my_table, my_add_table[i])
	end
	return my_table
end