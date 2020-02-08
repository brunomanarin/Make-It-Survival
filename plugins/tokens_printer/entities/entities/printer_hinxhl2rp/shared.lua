ENT.Spawnable = true
ENT.Category = "Lemano's Printer"
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Token Printer Machine"


function ENT:SetupDataTables()

	self:NetworkVar("Int",1 ,"Tokens")

end