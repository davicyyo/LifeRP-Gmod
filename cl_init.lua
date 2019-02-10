include( "shared.lua" )

files = {"network","hud","scoreboard","keys","functions","tick"}

local files = file.Find( "gamemodes/liferp/gamemode/liferp/*", "GAME" )

for _,file in pairs(files) do
	include("liferp/"..file)
end