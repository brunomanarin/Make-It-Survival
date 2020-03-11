ENT.Type = "anim"
ENT.PrintName = "Fireplace"
ENT.Author = "Lemano"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "NutScript"
ENT.RenderGroup = RENDERGROUP_BOTH

if (SERVER) then
	function ENT:Initialize()
        self:SetModel("models/warz/items/woodshield_unbuilt.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local physicsObject = self:GetPhysicsObject()
		if ( IsValid(physicsObject) ) then
			physicsObject:Wake()
		end
    end
    

    local isOnFire = false

    function ENT:Use(activator)
        if(!isOnFire) then
            self:Ignite(120, 1)
            activator:ConCommand("say /me retira uma máscara e deixa-a cair no chão.")
            isOnFire = true
        else
            self:Extinguish()
            isOnFire = false
        end
	end
else


	function ENT:Initialize()
	end
	
	function ENT:Draw()
		self:DrawModel()
	end
    end
	function ENT:OnRemove()
end