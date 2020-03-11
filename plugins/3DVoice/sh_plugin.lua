PLUGIN.name = "3D Voice Proximity"
PLUGIN.author = "Chachi"
PLUGIN.desc = "Adds 3D Voice. Voices cannot be heard through walls or props, and props can be whitelisted to allow voices to be heard through them."

-- Made with <3 from Chachi
-- https://steamcommunity.com/id/chachijuarez

-- debug clientside rendering
nut.util.include("cl_debug.lua")
nut.util.include("sh_propwhitelists.lua")

nut.config.add("3DVoiceEnabled", true, "Enable 3D Voice System?", nil, {category = "3DVoice"})
nut.config.add("3DVoiceRadius", 325, "Maximum Distance a player can be heard from.", nil, {data = {min = 50, max = 500}, category = "3DVoice"})
nut.config.add("3DVoiceRefreshRate", 2, "Amount of seconds between checks to if the players voice should be heard. > 3 or 4 may be too much, < 2 can cause lag.", nil, {form = "Float",data = {min = 0.5, max = 10}, category = "3DVoice"})
nut.config.add("3DVoiceDebugMode", false, "Enable 3D Voice System Debug", nil, {category = "3DVoice"})

local voicedata = {}
voicedata.radius = nut.config.get("3DVoiceRadius")*nut.config.get("3DVoiceRadius") -- Number outputted will be obsenely large because im using DistToSqr, which is better optimized than distance.
voicedata.refreshrate = nut.config.get("3DVoiceRefreshRate") 

voicedata.cache = CurTime() -- internal, dont change this nerd.
voicedata.CanHearCache = false -- internal, dont change this either, nerd.

-- Core Voice Check ( Its ugly but it works, okay? ;< ) 
function PLUGIN:PlayerCanHearPlayersVoice( lis, tlk )

	if (nut.config.get("3DVoiceEnabled")) then

		if ( (CurTime()-voicedata.cache > voicedata.refreshrate) and (lis != tlk) ) then
			voicedata.cache = CurTime()	

			voicedata.radius = nut.config.get("3DVoiceRadius")*nut.config.get("3DVoiceRadius")
			voicedata.refreshrate = nut.config.get("3DVoiceRefreshRate") 
			
			if ( tlk:GetPos():DistToSqr(lis:GetPos()) <= voicedata.radius ) then
				
				local tr = util.TraceLine( {
					start = tlk:EyePos(),
					endpos = lis:EyePos(),
					filter = player.GetAll()
				} )

				if (!tr.Hit or table.HasValue( WhitelistedProps , tr.Entity:GetModel() ) ) then
					voicedata.CanHearCache = true
				else
					voicedata.CanHearCache = false
				end
			
			else
				voicedata.CanHearCache = false
			end
		
		end
	
		if (voicedata.CanHearCache) then return true else return false end

	end
		
end
