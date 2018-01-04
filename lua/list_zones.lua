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

wrk.headers["X-Product-Id"] = '1e94259bc0024a87966fa8aa82077e75'
