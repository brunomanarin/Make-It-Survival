ITEM.name = "Coringa Mask"
ITEM.model = Model("models/props_bank/crossover/dallas_mask_nostraps.mdl")
ITEM.width = 2
ITEM.height = 2
ITEM.desc = "Uma máscara que te torna incel."
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(180.0, 30.0, 90.0),
					["Position"] = Vector(4.732845, -0.580246, -0.164444),
					["UniqueID"] = "180821026",
					["Model"] = "models/props_bank/crossover/dallas_mask_nostraps.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "180821026",
			["EditorExpand"] = true,
		},
	},
}


verifyItem = function(item)
	local char = item.player:getChar()
	local items = char:getInv():getItems()
	
	for k, v in pairs(items) do
		if (v.id != item.id) then
			local itemTable = nut.item.instances[v.id]
			if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:getData("equip")) then
				item.player:notify("FALSE")
				return false
			end
		end
	end
	return true
end

sound.Add( {
	name = "breath_in",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 80,
	pitch = {95, 110},
	sound = "player/breathe1.wav"
} )

ITEM:hook("Equip", function(item)
	if (SERVER) then
		local client = item.player
        if(verifyItem(item)) then
            client:SetName("Joker")
			client:ConCommand("say /me pega mascara do coringa e percebe que vivemos numa sociedade.")
			client:EmitSound("breath_in")
		end
	end
end)

ITEM:hook("EquipUn", function(item)
	if (SERVER) then
        local client = item.player
        item.player:notify("Não é possivel sair da sociedade.")
        return false
		--client:ConCommand("say /me apoia o rosto com as mãos e puxa a máscara, retirando-a.")
		--client:StopSound("breath_in")
	end
end)

ITEM:hook("drop", function(item)
	if (SERVER) then
        local client = item.player
        item:remove()
        client:Ignite(3, 1)
        client:ConCommand("say /me retira a mascara do coringa e ela desaparece como poeira.")
        client:EmitSound("des_wind2")
		client:StopSound("breath_in")
	end
end)



ITEM.functions = ITEM.functions or {}

--ITEM.functions.JackOLantern =  { 
--text = "Say jackolantern",
--menuOnly = true,
--tip = "Use this command.",
--icon = "icon16/sound.png",
--onRun = function(item)
	--if (SERVER) then
		--item.player:ConCommand("say jackolantern")
	--end
	--return false
--end
--}