PLUGIN.name = "Business Tab Restriction"
PLUGIN.desc = "Allows to restrict the business tab in the F1 menu to administrators and superadministrators."
PLUGIN.author = "PMX"

-- Adds a configuration option to the configurations tab.
nut.config.add("RestrictBusiness", false, "Restrict the business tab to administrators and superadministrators", nil, {
	category = "Administration"
	})

-- Checks if the player is an admin or above. If not, doesnt allow them to open the business menu.
hook.Add("CreateMenuButtons", "nutBusiness", function(tabs)
		if (!nut.config.get("RestrictBusiness")) then
			tabs["business"] = function(panel)
				if (hook.Run("BuildBusinessMenu", panel)) then
					panel:Add("nutBusiness")
				end
			end
		else
			if (LocalPlayer():IsAdmin()) then
				tabs["business"] = function(panel)
					if (hook.Run("BuildBusinessMenu", panel)) then
						panel:Add("nutBusiness")
					end
				end
				
			else return end
		end		
end)