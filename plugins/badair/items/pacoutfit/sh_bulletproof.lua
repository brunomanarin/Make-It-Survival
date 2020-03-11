ITEM.name = "Olive Armor"
ITEM.model = Model("models/warz/olivearmor.mdl")
ITEM.width = 3
ITEM.height = 3
ITEM.desc = "An armor to make you survive while being shot at."
ITEM.outfitCategory = "vest"
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(1.487, 99.991, 2.327),
					["Position"] = Vector(-2.435242, -1.481812, -48.753571),
					["UniqueID"] = "3058013970",
					["Size"] = 0.9,
					["Model"] = "models/warz/olivearmor.mdl",
					["Bone"] = "chest",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "3058013970",
			["EditorExpand"] = true,
		},
	},
}




		
ITEM.durability = 3

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

hook.Add("EntityTakeDamage", "BulletArmor", function(target, dmginfo)
	if (SERVER) then
		if(target:IsPlayer() and isItemEquiped(target:getChar():getInv():hasItem("bulletproof")) ) then
			setArmor(target, dmginfo, target:getChar():getInv():hasItem("bulletproof"), 0.)
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

