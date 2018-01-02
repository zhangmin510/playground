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
function init()
	print(string.format("thread %d created", id))
end

function delay()
	return 0
end

function request()
	count = count + 1
	wrk.method = "POST"
	wrk.headers["Content-Type"] = "application/json"
	wrk.headers["X-Product-Id"] = "1e94259bc0024a87966fa8aa82077e75"
	wrk.body = string.format('{"Name": "s-%s-t%d-%d.zhangmin-vpc.name.", "Type": "A", "TTL": 300, "Policy": "simple", "Comment": "test", "ResourceRecords": ["127.0.0.1"]}', time, id, count);
	-- io.write(wrk.body .. "\n")
	return wrk.format(wrk.method, nil, wrk.headers, wrk.body)
end

function response(status, headers, body)
	if status ~= 200 then
		io.write(status .. "\n")
		io.write(body .. "\n")
		wrk.thread:stop()
	end
end	


