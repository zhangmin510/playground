local cjson = require ("cjson")
local time = os.time()
local count = 1
-- all threads data table, save thread data to this table
local threads_data = {}
-- all server address table
local addrs = nil

-- helper function
function dump(o)
	for k,v in pairs(o) do
		print(k,v)
	end
end

-- helper function
function read_from_file(file)
	local f = io.open(file)
	local tenants = {}
	local zones = {}
	for line in f:lines() do
		-- print(line)
		_,_, tenant, zone = string.find(line, "(.+)%c(.+)")
		-- print(tenant, zone)
		table.insert(tenants, tenant)
		table.insert(zones, zone)
	end
	return tenants, zones
end


function setup(thread)
	print("setup-start")
	thread:set("id", count)
	table.insert(threads_data, thread)

	count = count + 1
	local tenants, zones = read_from_file("tenant_zone.txt")
	-- dump(tenants)
	-- dump(zones)

	-- choose addr
	if not addrs then
		addrs = wrk.lookup(wrk.host, wrk.port or 'http')
		dump(addrs)
		for i = #addrs, 1, -1 do
			-- check connectivity
			if not wrk.connect(addrs[i]) then
				table.remove(addrs, i)
			end
		end
	end
	-- thread server addr
	-- thread.addr = addrs[math.random(#addrs)]
	thread.addr = addrs[math.random(#addrs)]
	print("setup-end")
end

function init(args)
	print("init-start")
	-- init thread data
	requests = 0
	responses = 0
	tdata = {}

	dump(args)
	local msg = "thread %d created, addr %s"
	print(msg:format(id, wrk.thread.addr))

	-- pipelining
	local r = {}
	r[1] = wrk.format(nil, "/1")
	r[2] = wrk.format(nil, "/2")
	-- pipelining request
	req = table.concat(r)

	print("init-end")
end

function delay()
	print("delay-start")
	print("delay-end")
	-- add 0-10ms delay before each request
	-- return math.random(0,10)
	return 0
end

function request()
	print("request-start")
	-- count requests
	requests = requests + 1
	print("thread " .. id .. " count " .. count)
	count = count + 1
	local headers = {};
	headers["x-product-id"] = "1e94259bc0024a87966fa8aa82077e75"
	print("request-end")
	-- return pipelining request
	-- return req
	return wrk.format(nil, nil, headers)
end

function response(status, headers, body)
	print("response-start")
	-- count responses
	responses = responses + 1
	table.insert(tdata, status)
	if status ~= 200 then
		io.write(status)
		io.write(body)
		-- resp = cjson.decode(body)
		-- print("requestId: " .. resp.RequestId);
		-- data = thread:get("data")
		-- table.insert(data, resp.RequestId)
		-- local f = io.open("rrset_ids", "a")
		-- f:write(resp.RequestId .. "\n")
		-- f:close()
		-- dump(data)

		-- stop thread
		-- wrk.thread:stop()
	end
	print("response-end")
end

function done(summary, latency, requests)
	print("done-start")
	-- dump all thread data
	for index, thread in ipairs(threads_data) do
		local id        = thread:get("id")
		local requests  = thread:get("requests")
		local responses = thread:get("responses")
		local tdata = thread:get("tdata")
		print(#tdata)
		local msg = "thread %d made %d requests and got %d responses"
		print(msg:format(id, requests, responses))
	end
	-- custom report
	io.write("------------------------------\n")
	for _, p in pairs({ 50, 90, 99, 99.999 }) do
	   n = latency:percentile(p)
	   io.write(string.format("%g%%,%d\n", p, n))
	end
	print("done-end")
end



