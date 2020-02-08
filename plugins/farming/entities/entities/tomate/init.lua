AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")




sound.Add( {
	name = "pickup_food",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = {95, 110},
	sound = "items/battery_pickup.wav"
} )

function ENT:Initialize()
	self:SetModel("models/oldbill/tomatoplant.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE,3)
	self:SetModelScale(0, 0)
	local p = self:GetPhysicsObject()
	self.timer = CurTime()
	self.grow = 0
	self.con = 0
	self.mature = false
	self.tomatoCount = 0
	if p:IsValid() then
		p:Wake()
	end

end

function ENT:Think()
	if CurTime()>self.timer+self.con then
		self.con = self.con + 5 
		self.timer = CurTime()
		if(self.grow<1.5) then
			self.grow = self.grow + 0.25
			self:SetColor(Color(0,255,0))
		else
			self:SetColor(Color(255,255,255))
			self.mature = true
			self.tomatoCount = 5
		end
		if(self.con>100) then
			self:Remove()
		end
		self:SetModelScale(self.grow, 5)
	end
end


function ENT:Use(player_activator, player_caller)
	if(self.tomatoCount>0) then
		nut.item.spawn("tomato", self:GetPos() + Vector(20,0,50))
		self.tomatoCount = self.tomatoCount - 1
		self:SetColor(Color(self.tomatoCount*50,self.tomatoCount*50,0))
	end
	if(self.mature and self.tomatoCount == 0) then
		self:Remove()
		self.mature = false
		self.con = 0
	end
end