ITEM.name = "Rookie Rebel Shirt"
ITEM.model = Model("models/tnb/items/aphelion/shirt_rebel1.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "This one is for all you recruits out there."
ITEM.outfitCategory = "bodygroup_torso"
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["BodyGroupName"] = "torso",
					["ClassName"] = "bodygroup",
					["ModelIndex"]	=	"14",
					["UniqueID"] = "3775022902",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "3775022902",
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
				item.player:notify("You already have an equiped item")
				return false
			end
		end
	end
	return true
end

sound.Add( {
	name = "clothes_on",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 80,
	pitch = {95, 110},
	sound = "physics/cardboard/cardboard_box_break3.wav"
} )

ITEM:hook("Equip", function(item)
	if (SERVER) then
		local client = item.player
		if(verifyItem(item)) then
			client:ConCommand("say /me coloca a vestimenta rebelde, ajustando o colete em seu corpo.")
			client:EmitSound("clothes_on")
		end
	end
end)

ITEM:hook("EquipUn", function(item)
	if (SERVER) then
		local client = item.player
		client:ConCommand("say /me retira a vestimenta rebelde, dobrando com colete com as mãos.")
		client:StopSound("clothes_on")
	end
end)

ITEM:hook("drop", function(item)
	if (SERVER) then
		local client = item.player
		client:ConCommand("say /me retira uma vestimenta rebelde e deixa-a cair no chão.")
		client:StopSound("clothes_on")
	end
end)

ITEM.functions = ITEM.functions or {}
