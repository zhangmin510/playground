#!/bin/bash
if [ $# != 2 ]
then
	echo "usage: bash delete_zone.bash tenantId, zoneId"
	exit 1
fi
tenantId=$1
zoneId=$2
curl -X GET \
  "http://10.187.3.165:5353/dns?Version=2017-12-12&Action=DeleteHostedZone&HostedZoneId=$zoneId&ForceDelete=true" \
  -H "X-Product-Id: $tenantId" \
  -H "X-Request-Id: $tenantId"
