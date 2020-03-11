AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")




sound.Add( {
	name = "charge_water_pump",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = {95, 110},
	sound = "physics/metal/paintcan_impact_hard3.wav"
} )

function ENT:Initialize()
	self:SetModel("models/nseven/coolingtank01.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE,3)
	local p = self:GetPhysicsObject()
	self.timer = CurTime()
	self.waterPump = 0
	if p:IsValid() then
		p:Wake()
	end

end

-- function ENT:Think()
-- 	if CurTime()>self.timer+self.con then
-- 		self.con = self.con + 5 
-- 		self.timer = CurTime()
-- 		if(self.grow<1.5) then
-- 			self.grow = self.grow + 0.25
-- 			self:SetColor(Color(0,255,0))
-- 		else
-- 			self:SetColor(Color(255,255,255))
-- 			self.mature = true
-- 			self.tomatoCount = 5
-- 		end
-- 		if(self.con>100) then
-- 			self:Remove()
-- 		end
-- 		self:SetModelScale(self.grow, 5)
-- 	end
-- end


function ENT:Use(player_activator, player_caller)
	self.waterPump = self.waterPump + 1
	self:EmitSound("charge_water_pump")
	if(self.waterPump == 50) then
		nut.item.spawn("waterbottle", self:GetPos() + Vector(20,0,50))
		self.waterPump = 0
	end

end