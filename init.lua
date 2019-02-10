AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


	if not file.Exists("liferp/config/","DATA") then file.CreateDir("liferp/config") end

	local files = file.Find( "gamemodes/liferp/gamemode/liferp/*", "GAME" )
	MsgC( Color( 255, 0, 0 ), "-----------------------------------------------------------------\n" )
	MsgC( Color( 255, 0, 0 ), "[LIFERP]",Color( 255, 255, 255 ), " Load Modules\n" )
	MsgC( Color( 255, 0, 0 ), "-----------------------------------------------------------------\n" )
	MsgC( Color( 255, 255, 255 ), "\n")
	for _,file in pairs(files) do
		MsgC( Color( 255, 0, 0 ), "File: ",Color( 255, 255, 255 ), file.."\n" )
		AddCSLuaFile("liferp/" .. file)
		include("liferp/" .. file)
	end
	MsgC( Color( 255, 255, 255 ), "\n")
	MsgC( Color( 255, 0, 0 ), "-----------------------------------------------------------------\n" )