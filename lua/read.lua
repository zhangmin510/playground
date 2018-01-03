
function read_from_file(file)
	f = io.open(file)
	local tenants = {}
	local zones = {}
	for line in f:lines() do
		-- print(line)
		_,_, tenant, zone = string.find(line, "(.+)%c(.+)")
		print(tenant, zone)
		table.insert(tenants, tenant)
		table.insert(zones, zone)
	end
	return tenants, zones
end
