-- example HTTP POST script which demonstrates setting the
-- HTTP method, body, and adding a header
-- local cjson = require "cjson"
local time  = os.time()
local count = 1


function read_from_file(file)
	f = io.open(file)
	local tenants = {}
	local zones = {}
	local names = {}
	for line in f:lines() do
		-- print(line)
		_,_, tenant, zone, name = string.find(line, "(.+)%c(.+)%c(.+)")
		-- print(tenant, zone, name)
		table.insert(tenants, tenant)
		table.insert(zones, zone)
		table.insert(names, name)
	end
	return tenants, zones, names
end


-- dns resolv finished, thread generated
function setup(thread)
	-- set thread variables
	thread:set("id", count)
	count = count + 1
end

-- invoke before each request
function init()
	-- thread data
	tenants, zones, names = read_from_file("tenant_zone.txt")
	print(string.format("thread %d created", id))
end

function delay()
	return 0
end

function request()
	count = count + 1
	if count > #zones then
		count = 1
	end
	-- print(tenants[count] .. zones[count])
	-- local zone_id = "LHcVX41sj1iPF8Uz"
	-- local tenant_id = "1e94259bc0024a87966fa8aa82077e75"
	local path = string.format("/dns?Version=2017-12-12&Action=CreateResourceRecordSet&HostedZoneId=%s", zones[count])
	local method = "POST"
	local headers = {}
	headers["Content-Type"] = "application/json"
	headers["X-Product-Id"] = tenants[count] 
	-- simple policy
	-- local body = string.format('{"Name": "s-%s-t%d-%d.%s", "Type": "A", "TTL": 300, "Policy": "simple", "Comment": "test", "ResourceRecords": ["127.0.0.1"]}', time, id, count, names[count]);
	local body = string.format('{"Name": "s-%s-t%d-%d.%s", "Type": "A", "TTL": 300, "Policy": "weight", "Weight": 10, "Comment": "%s", "ResourceRecords": ["127.0.0.1"]}', time, id, count, names[count], tenants[count]);
	-- io.write(body .. "\n")
	return wrk.format(method, path, headers, body)
end

-- function response(status, headers, body)
-- 	if status ~= 200 then
-- 		io.write(status .. "\n")
-- 		io.write(body .. "\n")
-- 		wrk.thread:stop()
-- 	else 
-- 		-- rrset = cjson.decode(body)
-- 		-- local id = rrset.ResourceRecordSet.ResourceRecordSetId;
-- 		-- print(id)
-- 		-- table.insert(ids, id)
-- 	end
-- end	

function done(summary, latency, requests)

end

