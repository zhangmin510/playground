-- example HTTP POST script which demonstrates setting the
-- HTTP method, body, and adding a header

local time  = os.time()
local count = 1

-- dns resolv finished, thread generated
function setup(thread)
	-- set thread variables
	thread:set("id", count)
	count = count + 1
end

-- invoke before each request
function init(args)
	print(string.format("thread %d created", id))
end

function request()
	local prefix = "/dns?Version=2017-12-12&Action=CreateHostedZone"
	local zone = string.format("&Name=perf-%s-%d-%d.name&Comment=PerfTest&IsPrivateZone=true", time, id, count)
	local path = prefix .. zone
	local headers = {}
	headers["Content-Type"] = "application/json"
	headers["X-Product-Id"] = string.format("perf-tenant-%s-%d-%d", time, id, count)

	count = count + 1

	-- print(path)	
	-- dump(headers)

	return wrk.format(nil, path, headers)
end

function response(status, headers, body)
	-- dump(wrk)
	-- print(status)
	if status ~= 200 then
		io.write(status .. "\n")
		io.write(body .. "\n")
		wrk.thread:stop()
	end
end	

function dump(t)
	for k,v in pairs(t) do
		print(k,v)
	end
end
