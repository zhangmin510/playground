local cjson = require "cjson"

local data = {}

function dump(o)
	for k,v in pairs(o) do
		print(k,v)
	end
end

function setup(thread)
	thread:set("data", {})
end

function init(args)
	print("init")
	dump(args)
end

function request()
	local headers = {};
	headers["x-product-id"] = "1e94259bc0024a87966fa8aa82077e75"
	return wrk.format(nil, nil, headers)
end

function response(status, headers, body)
	if status == 200 then
		resp = cjson.decode(body)
		-- print("requestId: " .. resp.RequestId);
		-- data = thread:get("data")	
		table.insert(data, resp.RequestId)
		-- local f = io.open("rrset_ids", "a")
		-- f:write(resp.RequestId .. "\n")
		-- f:close()
		dump(data)
	end

end	

function done(summary, latency, requests)
	print("done")
	dump(data)
end



