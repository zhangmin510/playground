local cjson = require "cjson"

local data = {}

function dump(o)
	for k,v in pairs(o) do
		print(k,v)
	end
end

function setup(thread)
	print("setup-start")
	thread:set("data", {})
	print("setup-start")
end

function init(args)
	print("init-start")
	dump(args)
	print("init-end")
end

function request()
	print("request-start")
	local headers = {};
	headers["x-product-id"] = "1e94259bc0024a87966fa8aa82077e75"
	print("request-end")
	return wrk.format(nil, nil, headers)
end

function response(status, headers, body)
	print("response-start")
	if status == 200 then
		resp = cjson.decode(body)
		-- print("requestId: " .. resp.RequestId);
		-- data = thread:get("data")	
		table.insert(data, resp.RequestId)
		-- local f = io.open("rrset_ids", "a")
		-- f:write(resp.RequestId .. "\n")
		-- f:close()
		dump(data)
	print("response-end")
	end

end	

function done(summary, latency, requests)
	print("done-start")
	dump(data)
	print("done-end")
end



