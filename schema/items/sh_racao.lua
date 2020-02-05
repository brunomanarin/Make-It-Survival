ITEM.name = "Ração"
ITEM.desc = "Um pacote com pedaços de uma carne desconhecida dentro."
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.healthRestore = 30
ITEM.category = "consumables"
ITEM.restore = 33
ITEM.functions.Comer = {
	icon = "icon16/add.png",
	sound = "npc/barnacle/barnacle_crunch2.wav",
	onRun = function(item)
		item.player:SetHealth(math.min(item.player:Health() + item.restore, 100))
		item.player:setLocalVar("stm", math.min(item.player:getLocalVar("stm", 100) + item.restore, 100))
	end
}
