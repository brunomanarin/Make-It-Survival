ITEM.name = "Garrafa de água"
ITEM.model = "models/props_junk/garbage_plasticbottle003a.mdl"
ITEM.desc = "Garrafa de água, conteúdo: 1L."
ITEM.price = 20
ITEM.permit = "misc"

ITEM.functions.Comer = { 
	text = "Comer o tomate",
	menuOnly = true,
	tip = "Comer o tomate.",
	icon = "icon16/cup_go.png",
	onRun = function(item)
		local client = item.player
		if(client:Health() < client:GetMaxHealth()) then
			client:SetHealth(client:Health()+10)
			client:Say("/me pega o suculento tomate e leva-o a boca, devorando ferozmente.")
			client:EmitSound("pickup_food")
		else
			client:Say("Já estou cheio.")
			return false
		end
	end
}
