AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
self:SetModel("models/custom_models/sterling/ahshop_package_seeds_02.mdl")
self:PhysicsInit(SOLID_VPHYSICS)
self:SetMoveType(MOVETYPE_VPHYSICS)
self:SetSolid(SOLID_VPHYSICS)
self:SetUseType(SIMPLE_USE,3)
local p = self:GetPhysicsObject()
if p:IsValid() then
	p:Wake()
end

end