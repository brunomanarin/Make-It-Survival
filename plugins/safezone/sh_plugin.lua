local PLUGIN = PLUGIN
local playerMeta = FindMetaTable("Player")

PLUGIN.name = "Safezone"
PLUGIN.author = "Black Tea (NS 1.0), Neon (NS 1.1)"
PLUGIN.desc = "Bad Air just like Metro. DrunkyBlur by Spy."
PLUGIN.safeZone = PLUGIN.safeZone or {}
PLUGIN.safeList = {} -- No Leave/Join/CharChange shit.

if !nut.plugin.list["_oldplugins-fix"] then
	print("[Bad Air Plugin] _oldplugins-fix Plugin is not found!")
	print("Download from GitHub: https://github.com/tltneon/nsplugins\n")
	return
end

PLUGIN.thinkTime = 1


-- to mod filter health amount, go to mask item file.

if (SERVER) then
	function PLUGIN:LoadData()
		self.safeZone = self:getData() or {}
	end

	function PLUGIN:SaveData()
		self:setData(self.safeZone)
	end


	function PLUGIN:DoPlayerDeath( client )
		self.safeList[client:SteamID()][client:getChar():getID()] = 0
		netstream.Start(client, "syncSafeZone", self.safeList[client:SteamID()][client:getChar():getID()])
	end

	function PLUGIN:PlayerLoadedChar(client)
		self.safeList[client:SteamID()] = self.safeList[client:SteamID()] or {}
		self.safeList[client:SteamID()][client:getChar():getID()] = self.safeList[client:SteamID()][client:getChar():getID()] or 0
		netstream.Start(client, "syncSafeZone", self.safeList[client:SteamID()][client:getChar():getID()])
	end

	local thinktime = RealTime()
	function PLUGIN:Think()
		if (thinktime < RealTime()) then
			thinktime = RealTime() + self.thinkTime

			for k, client in pairs(player.GetAll()) do
				local pos = client:GetPos() + client:OBBCenter() -- preventing fuckering around.
				if (!client:getChar()) then
					continue
				end
			
				for _, vec in pairs(self.safeZone) do
					if (!vec[1] or !vec[2]) then 
						continue 
					end
					if (pos:WithinAABox(vec[1], vec[2])) then
						client:GodEnable()
						self.safeList[client:SteamID()] = self.safeList[client:SteamID()] or {}
						self.safeList[client:SteamID()][client:getChar():getID()] = self.safeList[client:SteamID()][client:getChar():getID()] or 0
						netstream.Start(client, "syncSafeZone", self.safeList[client:SteamID()][client:getChar():getID()])
					else
						client:GodDisable()
						netstream.Start(client, "safezoneOut", false)
					end
				end
			end
		end
	end
else
	local badair = 0
	surface.CreateFont( "TheDefaultSettings", {
		font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 30,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})
	netstream.Hook("syncSafeZone", function(data)
		badair = data
		hook.Add( "HUDPaint", "my_hook_identifier", function()
	
			surface.SetFont( "TheDefaultSettings" )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( 50, (ScrH()-50) ) 
			surface.DrawText( "You are in the safezone." )
			
		end )
	end)

	netstream.Hook("safezoneOut", function(data)
		hook.Remove( "HUDPaint", "my_hook_identifier" )	
	end)


	PLUGIN.deltaBlur = SCHEMA.deltaBlur or 0
end

local function vecabs( v1, v2 )
	local fv1, fv2 = Vector( 0, 0, 0 ), Vector(0, 0, 0)

	for i = 1,3 do
		if v1[i] > v2[i] then
			fv1[i] = v2[i]
			fv2[i] = v1[i]
		else
			fv1[i] = v1[i]
			fv2[i] = v2[i]
		end
	end

	return fv1, fv2
end

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		if (!client:getNetVar("safeZoneMin")) then
			client:setNetVar("safeZoneMin", client:GetPos())
			nut.util.Notify( "Run the command again at a different position to set a maximum point.", client )
		else
			local vector1, vector2 = vecabs( client:getNetVar("safeZoneMin"),  client:GetPos() )
			table.insert(PLUGIN.safeZone, {vector1, vector2})
			PLUGIN:SaveData()
			client:setNetVar("safeZoneMin", nil)

			nut.util.Notify("Added new bad-air area.", client)
		end
	end
}, "safezoneadd")

nut.command.Register({
	adminOnly = true,
	onRun = function(client, arguments)
		local pos = client:GetPos() + client:OBBCenter()

		for k, vec in pairs(PLUGIN.safeZone) do
			if (pos:WithinAABox(vec[1], vec[2])) then
				table.remove(PLUGIN.safeZone, k)
				PLUGIN:SaveData()
				nut.util.Notify("You've removed bad-air area.", client)
				return
			end
		end

		print('Debug-Dead Zones')
		PrintTable(PLUGIN.safeZone)
		nut.util.Notify("To remove bad-air area, You have to be in bad-air area.", client)
	end
}, "safezoneremove")