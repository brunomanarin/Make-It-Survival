ITEM.name = "Máscara de Gás"
ITEM.model = Model("models/tnb/items/aphelion/gasmask.mdl")
ITEM.width = 2
ITEM.height = 2
ITEM.desc = "Uma máscara que te protege do corona."
ITEM.outfitCategory = "mask"
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(88.677, -13.225, 27.727),
					["Position"] = Vector(-0.637207, -1.833221, -0.034576),
					["UniqueID"] = "3069222848",
					["Model"] = "models/tnb/items/aphelion/gasmask.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "3069222848",
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
			client:ConCommand("say /me pega a máscara de gás e, com as mãos apoiadas no filtro, coloca-a em seu rosto.")
			client:EmitSound("breath_in")
		end
	end
end)

ITEM:hook("EquipUn", function(item)
	if (SERVER) then
		local client = item.player
		client:ConCommand("say /me apoia o rosto com as mãos e puxa a máscara, retirando-a.")
		client:StopSound("breath_in")
	end
end)

ITEM:hook("drop", function(item)
	if (SERVER) then
		local client = item.player
		client:ConCommand("say /me retira uma máscara e deixa-a cair no chão.")
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


ITEM.functions.CheckFilter = { -- don't ask why I put _ before 'filter'.
	text = "Check Filter",
	menuOnly = true,
	tip = "Toggle this device.",
	icon = "icon16/weather_sun.png",
	onRun = function(item)
		if (SERVER) then
			local filter = item:getData("filter") or 0 -- mod this to change filter time.

			if filter == 0 then
				nut.util.Notify("The filter is expired.", client)
			else
				nut.util.Notify("The filter's health is " .. filter .. "." , client)
			end
			return false
		end
	end
}

ITEM.functions.Filter = { -- don't ask why I put _ before 'filter'.
	text = "Change Filter",
	menuOnly = true,
	tip = "Toggle this device.",
	icon = "icon16/weather_sun.png",
	onRun = function(item)
		if (SERVER) then
			local client = item.player
			if client:HasItem("filter") then
				local id = client:HasItem("filter"):getID()
				--local newData = table.Copy(data)
				-- Default Think time : 1 seconds
				-- It survives 300 thinks
				-- 300 * 1 seconds = 300 seconds.
				--newData.Filter = 300 -- mod this to change filter time.
				client:UpdateInv(item.uniqueID, 1, {filter = 300}, true)
				client:UpdateInv(id, -1)

				client:EmitSound("HL1/fvox/hiss.wav")
				nut.util.Notify("You changed the mask's filter.", client)
				return true
			else
				nut.util.Notify("You don't have any filter to change.", client)
			end
			return false
		end
	end
}