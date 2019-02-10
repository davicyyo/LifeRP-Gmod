if SERVER then

	local net = {"meta:getClient","liferp.getJob"}

	for _,n in pairs(net) do
		util.AddNetworkString(n)
	end

	net.Receive("meta:getClient",function()
		local ply = net.ReadEntity()
		local var = net.ReadString()
		local db = net.ReadString()

		return ply:getClient(var,db)
	end)

	net.Receive("liferp.getJob",function()
		local name = net.ReadString()
		local var = net.ReadString()

		return liferp.getJob(name,var)
	end)

end