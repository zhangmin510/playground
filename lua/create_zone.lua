local time  = os.time()
local count = 0
local addrs = nil


-- dns resolv finished, thread generated
function setup(thread)
	-- set thread variables, thread id
	thread:set("id", count)
	count = count + 1

	-- choose random server addr
	if not addrs then
		addrs = wrk.lookup(wrk.host, wrk.port or '5353')
		for i = #addrs, 1, -1 do
			-- check connectivity
			if not wrk.connect(addrs[i]) then
				table.remove(addrs, i)
			end
		end
	end
	-- set thread server addr
	thread.addr = addrs[math.random(#addrs)]

end

-- invoke before each request
function init(args)
	local msg = "thread %d created, addr %s"
	print(msg:format(id, wrk.thread.addr))
end

function request()
	count = count + 1
	local prefix = "/dns?Version=2017-12-12&Action=CreateHostedZone"
	local zone = string.format("&Name=perf-%s-%d-%d.name&Comment=PerfTest&IsPrivateZone=true", time, id, count)
	local path = prefix .. zone
	local headers = {}
	headers["Content-Type"] = "application/json"
	headers["X-Product-Id"] = string.format("perf-tenant-%s-%d-%d", time, id, count)
	-- headers["X-Product-Id"] = '1e94259bc0024a87966fa8aa82077e75'

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
