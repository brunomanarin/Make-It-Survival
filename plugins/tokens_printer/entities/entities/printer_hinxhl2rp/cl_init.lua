include("shared.lua")

surface.CreateFont( "fonte", {
	font = "Arial",
	extended = false,
	size = 70,
	weight = 240,
	blursize = 0.2,
	scanlines = 10,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = true,
	outline = true,
} )


function ENT:Draw()
	self:DrawModel()
	local angle = self:GetAngles()
	angle:RotateAroundAxis(self:GetAngles():Right(), 270)
	angle:RotateAroundAxis(self:GetAngles():Forward(), 90)
	angle:RotateAroundAxis(self:GetAngles():Up(), 0)
	
	cam.Start3D2D( self:GetPos() + self:GetForward()*20 - self:GetRight()*40 + self:GetUp()*40, angle, 0.1 )
		draw.RoundedBox(5, -550, -550, 250, 250, Color(120,120,120))
		draw.SimpleText(self:GetTokens() ,"fonte",-425, -425, Color(255,255,255, 255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Tokens" ,"fonte",-425, -525, Color(120,255,255, 255),TEXT_ALIGN_CENTER)
	
	cam.End3D2D()
end