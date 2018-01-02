-- example HTTP POST script which demonstrates setting the
-- HTTP method, body, and adding a header

local time  = os.time() local id = 1
local count = 1


-- dns resolv finished, thread generated
function setup(thread)
	-- set thread variables
	thread:set("id", id)
	id = id + 1

	f = io.open("zone_tenant.txt")
	local zones = {}
	local tenants = {}
	for line in f:lines() do
       		-- print(line)
        	_,_, zone, tenant = string.find(line, "(.+)%c(.+)")
       		print(zone, tenant)
		table.insert(zones, zone)
		table.insert(tenants, tenant)

	end
	thread:set("zones", zones)
	thread:set("tenants", tenants)
end

-- invoke before each request
function init(args)
	print(string.format("thread %d created", id))
end

function request()
	-- print("count " .. count)
	-- print(zones[count])
	-- print(tenants[count])
	if count > #zones then
		count = 1
	end
	local prefix = "/dns?Version=2017-12-12&Action=DeleteHostedZone"
	local zone = string.format("&HostedZoneId=%s&ForceDelete=true", zones[count])
	local path = prefix .. zone
	local headers = {}
	headers["Content-Type"] = "application/json"
	headers["X-Product-Id"] = tenants[count]

	count = count + 1

	print(path)	
	dump(headers)

	return wrk.format(nil, path, headers)
end

function response(status, headers, body)
	-- dump(wrk)
	-- print(status)
	if status ~= 200 then
		io.write(status .. "\n")
		io.write(body .. "\n")
		-- wrk.thread:stop()
	end
end	

function dump(t)
	for k,v in pairs(t) do
		print(k,v)
	end
end
