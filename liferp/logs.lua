if !SERVER then return end

if not file.Exists("liferp","DATA") then file.CreateDir("liferp") end
if not file.Exists("liferp/logs","DATA") then file.CreateDir("liferp/logs") end


local logs = {}
function logAdd(str)
	if not str then return end

	local original = "[LIFERP] ("..os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )") "..str

	table.insert(log,original)
end

function GM:ShutDown()
	
	local time = os.date( "%d/%m/%Y" , os.time() )

	local num = 0
	local exists = false
	local function checkFiles()
		if file.Exists("liferp/logs/"..time..".txt","DATA") then
			exists = true
		else
			if file.Exists("liferp/logs/"..time..num..".txt","DATA") then
				exists = true
				num = num + 1
				checkFiles()
			else
				if exists then
					file.Write("liferp/logs/"..time..num..".txt",table.concat(log,"\n"))
				else
					file.Write("liferp/logs/"..time..".txt",table.concat(log,"\n"))
				end
			end
		end
	end

	checkFiles()
end