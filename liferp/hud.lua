if CLIENT then

	function LifeRPHUD()

		hook.Add( "HUDPaint", "HUDLifeRPPaint", function()
		surface.SetDrawColor( 0, 0, 0, 128 )
		surface.DrawRect( 50, 50, 128, 128 )
		end )

	end

	hook.Add("liferpHUD","buildHUD",LifeRPHUD)

	function LifeRPMOTD()
		hook.Add( "HUDPaint", "HUDLifeRPPaint", function()
		surface.SetDrawColor( 0, 0, 0, 128 )
		surface.DrawRect( 50, 50, 128, 128 )
		end )
	end

	hook.Add("liferpMOTD","buildMOTD",liferpMOTD)

	function LifeRPTAB()
		hook.Add( "HUDPaint", "HUDLifeRPPaint", function()
		surface.SetDrawColor( 0, 0, 0, 128 )
		surface.DrawRect( 50, 50, 128, 128 )
		end )
	end

	hook.Add("liferpTAB","buildTAB",LifeRPTAB)

end