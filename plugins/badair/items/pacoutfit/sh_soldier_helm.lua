ITEM.name = "Helmet"
ITEM.model = Model("models/equipmentpack/usgearhelmet.mdl")
ITEM.width = 3
ITEM.height = 3
ITEM.desc = "A Mask that protects you from the bad air area."
ITEM.outfitCategory = "hat"
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(-0.387,102.885,-91.063),
					["Position"] = Vector(3.902191, -2.750885, 0.495300),
					["UniqueID"] = "2325881199",
					["Size"] = 1,
					["Model"] = "models/equipmentpack/usgearhelmet.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "271825943",
			["EditorExpand"] = true,
		},
	},
}
ITEM.durability = 10
ITEM.isEquipped = false

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

ITEM.functions = ITEM.functions or {}

hook.Add("EntityTakeDamage", "helmproof", function(target, dmginfo)
	if (SERVER) then
		if(target:IsPlayer() and isItemEquiped(target:getChar():getInv():hasItem("soldier_helm")) ) then
			setArmor(target, dmginfo, target:getChar():getInv():hasItem("soldier_helm"), 0.2)
		end
	end
end)

ITEM:hook("Equip", function(item)
	if (SERVER) then
		local client = item.player
		if(verifyItem(item)) then
			client:SetArmor(100)
			client:EmitSound("items/ammopickup.wav")
		end
	end
end)

