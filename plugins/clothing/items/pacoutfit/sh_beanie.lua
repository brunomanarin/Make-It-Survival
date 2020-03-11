ITEM.name = "Beanie"
ITEM.model = Model("models/tnb/items/aphelion/beanie.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "A hat to cover your head from cold and fear."
ITEM.outfitCategory = "bodygroup_face"
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["BodyGroupName"] = "headgear",
					["ClassName"] = "bodygroup",
					["ModelIndex"]	=	"3",
					["UniqueID"] = "2644154509",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "2644154509",
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
			client:ConCommand("say /me leva as mãos a cabeça, colocando uma touca .")
			client:EmitSound("clothes_on")
		end
	end
end)

ITEM:hook("EquipUn", function(item)
	if (SERVER) then
		local client = item.player
		client:ConCommand("say /me leva as mãos até atrás de sua cabeça e retira a touca.")
		client:StopSound("clothes_on")
	end
end)

ITEM:hook("drop", function(item)
	if (SERVER) then
		local client = item.player
		client:ConCommand("say /me retira uma touca e deixa-a cair no chão.")
		client:StopSound("clothes_on")
	end
end)

ITEM.functions = ITEM.functions or {}
