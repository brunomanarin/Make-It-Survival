AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local con = 5

function ENT:Initialize()
self:SetModel("models/props_lab/servers.mdl")
self:PhysicsInit(SOLID_VPHYSICS)
self:SetMoveType(MOVETYPE_VPHYSICS)
self:SetSolid(SOLID_VPHYSICS)
self.timer = CurTime()

local pp = self:GetPhysicsObject()
if pp:IsValid() then
	pp:Wake()
end

end

local cooldown = 0;

sound.Add( {
	name = "printing",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 80,
	pitch = {95, 110},
	sound = "ambient/machines/combine_terminal_idle4.wav"
} )

sound.Add( {
	name = "take_money",
	channel = CHAN_STATIC,
	volume = 0.1,
	level = 80,
	pitch = {95, 110},
	sound = "npc/env_headcrabcanister/hiss.wav"
} )


function ENT:Think()

	if CurTime() > self.timer + con then
		self.timer = CurTime()
		if (cooldown > 0) then
			cooldown = cooldown - 1
		end
		if(cooldown == 0) then
			self:EmitSound("printing")
			self:StopSound("take_money")
		end
		if(self:GetTokens()>500) then
			self:Ignite(60,10)
			local explosion = ents.Create( "env_explosion" )
			explosion:SetPos(self:GetPos())
			explosion:Spawn() --this actually spawns the explosion
			explosion:SetKeyValue( "iMagnitude", "30" ) -- the magnitude
			explosion:Fire( "Explode", 0, 0 )
		else
			self:SetTokens(self:GetTokens() + 3)
		end

	end

end

function ENT:Use(player_activator, player_caller)
	if(cooldown == 0  && self:GetTokens()<500) then
		local dinheiro = self:GetTokens()
		self:SetTokens(0)
		cooldown = 10
		player_caller:getChar():giveMoney(dinheiro)
		self:EmitSound("take_money")
		player_caller:Say("/me estende sua mão até a máquina, coletando os Tokens.")
	else
		self:SetTokens(0)
		self:Extinguish()
	end
end

function ENT:OnRemove()
	self:StopSound("printing")
	self:StopSound("take_money")
end