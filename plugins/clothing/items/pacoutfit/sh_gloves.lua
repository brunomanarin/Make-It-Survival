ITEM.name = "Luva"
ITEM.model = Model("models/tnb/items/aphelion/gloves.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "Luvas para proteger suas mãos do frio."
ITEM.outfitCategory = "bodygroup_hands"
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["BodyGroupName"] = "hands",
					["ClassName"] = "bodygroup",
					["ModelIndex"]	=	"1",
					["UniqueID"] = "782424386",
					["EditorExpand"] = true,
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "782424386",
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
			client:ConCommand("say /me põe a luva em suas mãos, a lã macia aquece suas palmas.")
			client:EmitSound("clothes_on")
		end
	end
end)

ITEM:hook("EquipUn", function(item)
	if (SERVER) then
		local client = item.player
		client:ConCommand("say /me puxa as luvas de suas mãos, retirando-as.")
		client:StopSound("clothes_on")
	end
end)

ITEM:hook("drop", function(item)
	if (SERVER) then
		local client = item.player
		client:ConCommand("say /me retira um par de luvas e deixa-as cair no chão.")
		client:StopSound("clothes_on")
	end
end)

ITEM.functions = ITEM.functions or {}
