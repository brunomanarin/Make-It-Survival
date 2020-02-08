AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
self:SetModel("models/custom_models/sterling/ahshop_dirt.mdl")
self:PhysicsInit(SOLID_VPHYSICS)
self:SetMoveType(MOVETYPE_VPHYSICS)
self:SetSolid(SOLID_VPHYSICS)
self:SetUseType(SIMPLE_USE,3)
local p = self:GetPhysicsObject()
if p:IsValid() then
	p:Wake()
end
self.isGrowingSomething = false
self.timer = CurTime()
self.planta = nil
self.cooldown = 5
self.thereIsPlant = false
end

sound.Add( {
	name = "take_money",
	channel = CHAN_STATIC,
	volume = 0.1,
	level = 80,
	pitch = {95, 110},
	sound = "npc/env_headcrabcanister/hiss.wav"
} )

function ENT:StartTouch(ent)
	if(self.planta == nil) then
		if ent:GetClass() == "sementedetomate" and self.isGrowingSomething == false then
			self.planta = ents.Create("tomate")
			self.isGrowingSomething = true
			self.cooldown = 10
			ent:Remove()
		end
	end


end

function ENT:Think()
	if self.thereIsPlant then self:SetColor(Color(255,255,255))
	else self:SetColor(Color(100,100,100))
	end

	if self.isGrowingSomething  then
		if CurTime()>self.timer+10 then
			self.timer = CurTime()
			self.isGrowingSomething = false
			self.planta:SetPos(self:GetPos() + Vector(0,0,0) )
			self.planta:Spawn()
			self.thereIsPlant = true
		end
	end
	if self.thereIsPlant then
		if CurTime()>self.timer+60 then
			self.timer = CurTime()
			if(self.cooldown>0) then
				self.cooldown = self.cooldown - 1
			end
			if(self.cooldown == 0) then
				self.isGrowingSomething = false
				if(planta != nil) then
					self.planta:Remove();
				end
				self.planta = nil
				self.thereIsPlant = false
			end
		end
	end
end