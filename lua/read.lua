

f = io.open("zone_tenant.txt")

for line in f:lines() do
	-- print(line)
	_,_, zone, tenant = string.find(line, "(.+)%c(.+)")
	print(zone, tenant)
end
