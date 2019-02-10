local meta = FindMetaTable("Player")
local liferp = {}

if SERVER then

	local db = sql.TableExists("liferp")

	if !db then
		sql.Query( "CREATE TABLE liferp( steamid TEXT,id TEXT,name TEXT,money FLOAT,sex TEXT,job TEXT,model TEXT,skin INTEGER)" )
	end

	function meta:newClient(id,name,money,sex,job,model,skin)

		if !self:IsPlayer() then return end

		local function beginDB()
			
			steamid = self:SteamID() or nil

			if not id or id == "id" then
				id = self:SteamID64() or nil
			end

			if not name or name == "name" then
				name = self:Nick() or nil
			end

			if not money or money == "money" then
				money = LifeRP.InitialMoney or nil
			end

			if not sex or sex == "sex" then
				sex = "Male"
			end

			if not job or job == "job" then
				job = LifeRP.InitialJob or nil
			end

			if not model or model == "model" then
				model = LifeRP.DefaultModel or nil
			end

			if not skin or skin == "skin" then
				skin = 1
			end

			newRecord()

		end

		local function newRecord()
			sql.Query( "INSERT INTO liferp(steamid,id,name,money,sex,job,model,skin) VALUES( '"..steamid.."','"..id.."','"..name.."','"..money.."','"..sex.."','"..job.."','"..model.."','"..skin.."' ) FROM DUAL WHERE NOT EXISTS (SELECT steamid FROM liferp WHERE steamid='"..steamid.."');" )
			logAdd("New Client created into liferp, steamid="..steamid.." id="..id.." name="..name.." money="..money.." sex="..sex.." job="..job.." model="..model.." skin="..skin)
		end

		beginDB()

		return

	end

	function meta:getClient(var,db)
		if !self:IsPlayer() then return end
		if not var then return end
		if not db then db = "liferp" end

		local $SQL = sql.Query("SELECT "..var.." FROM "..db.." WHERE steamid = '"..self:SteamID().."'")

		return $SQL

	end

	function meta:setClient(var,value,db)
		if !self:IsPlayer() then return end
		if not var then return end
		if not value then return end
		if not db then db = "liferp" end

		sql.Query("UPDATE "..db.." SET "..var.."='"..value.."' WHERE steamid='"..self:SteamID().."'")
		logAdd("Set client into "..db.." database "..var.."="..value.." to "..self:SteamID())

		return

	end

	function liferp.newJob(name,health,armor,salary,model,description,weapon,access,vote,max,spawn,type)
		
		if not name then return end

		if not health or health == "health" then
			health = LifeRP.InitialHealth or 100
		end

		if not armor or armor == "armor" then
			health = LifeRP.InitialArmor or 0
		end

		if not salary or salary == "salary" then
			salary = LifeRP.InitialSalary or 0
		end

		if not model or model == "model" then
			model = LifeRP.DefaultModel or nil
		end

		if not description or description == "description" then
			description = LifeRP.DefaultDescription or nil
		end

		if not weapon or weapon == "weapon" then
			weapon = LifeRP.DefaultWeapon or nil
		end

		if not access or access == "access" then
			access = false
		end

		if not vote or vote == "vote" then
			vote = false
		end

		if not max or max == "max" then
			max = 0
		end

		if not spawn or spawn == "spawn" then
			spawn = LifeRP.SpawnPosition or Vector(0,0,0)
		end

		if not type or type == "type" then
			type = "citizen"
		end

		local newJob = {name=name,health=health,armor=armor,salary=salary,model=model,description=description,weapon=weapon,access=access,vote=vote,max=max,spawn=spawn,type=type}
		local _newJob = table.ToString(newJob,NewJob.."["..name.."]",true)


		if not file.Exists("liferp/config/jobs","DATA") then file.CreateDir("liferp/config/jobs") end

		file.Write("liferp/config/jobs/"..name..".txt",_newJob)

		logAdd("Job Created: "..name)

	end

	function liferp.setJob(name,var,value)
		
		if not name or not var or not value then return end

		local getJob = file.Read("liferp/config/jobs/"..name..".txt","DATA")
		local _getJob = string.ToTable(getJob)

		for key,_ in pairs(_getJob) do
			if tostring(key) == var then
				_getJob.key = value
			end
		end

		local saveJob = table.ToString(_getJob,NewJob.."["..name.."]",true)

		if not file.Exists("liferp/config/jobs","DATA") then file.CreateDir("liferp/config/jobs") end

		file.Write("liferp/config/jobs"..string.lower(name)..".txt",saveJob)

		logAdd("Job Edited: "..var.."="..value.." to "..name)

	end

	function liferp.getJob(name,var)
		
		if not name or not var then return end

		local getJob = file.Read("liferp/config/jobs/"..string.lower(name)..".txt","DATA")
		local _getJob = string.ToTable(getJob)

		for key,value in pairs(_getJob) do
			if tostring(key) == var then
				return value
			end
		end

	end

	function meta:becomeTo(job)
		if not job then return end

		self:setClient("job",job)

		local getJob = file.Read("liferp/config/jobs/"..string.lower(job)..".txt","DATA")
		local j = string.ToTable(getJob)

		if not table.HasValue(string.lower(j.access),string.lower(self:GetUserGroup())) then liferp.Notify("You don't have permissions for become to "..job) return end

		local count = 0
		if max != 0 then
			for _,players in pairs(player.GetAll()) do
				if string.lower(players:getClient("job")) == string.lower(job) then
					count = count + 1
				end
			end

			if count >= max then liferp.Notify("This job is full") return end

		end

		self:SetHealth(j.health)
		self:SetArmor(j.armor)
		self:SetModel(table.Random(j.model))
		self:SetPos(j.spawn)

		for _,swep in pairs(j.weapon) do
			self:Give(swep)
		end


	end

else

	function meta:getClient(var,db)
		if !self:IsPlayer() then return end

		if not var then return end
		if not db then db = "liferp" end

		net.Start("meta:getClient")
		net.WriteEntity(self)
		net.WriteString(var)
		net.WriteString(db)
		net.SendToServer()

		return

	end

	function liferp.getJob(name,var)
		
		if not name or not var then return end

		net.Start("liferp.getJob")
		net.WriteString(name)
		net.WriteString(var)
		net.SendToServer()

	end


end