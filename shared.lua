GM.Name = "LifeRP"
GM.Author = "HeadArrow Studios"
GM.Email = "info@headarrow.com"
GM.Website = "liferp.headarrow.com"

DeriveGamemode( "sandbox" )

function GM:Initialize()
	self.BaseClass.Initialize(self)
end

function GM:PlayerNoClip(ply)
	return ply:IsSuperAdmin()
end