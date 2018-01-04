#!/bin/bash
if [ $# != 3 ]
then
	echo "usage: bash delete_zone.bash tenantId, zoneId, name"
	exit 1
fi
tenantId=$1
zoneId=$2
host=127.0.0.1
curl -X GET \
  "http://$host:5353/dns?Version=2017-12-12&Action=DeleteHostedZone&HostedZoneId=$zoneId&ForceDelete=true" \
  -H "X-Product-Id: $tenantId" \
  -H "X-Request-Id: $tenantId"
echo -e "\n"

# select tenant_id,zone_id,name from dns_domain_zone where name like "perf%"