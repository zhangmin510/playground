#!/bin/bash
if [ $# != 2 ]
then
	echo "usage: bash delete_zone.bash tenantId, rrsetId"
	exit 1
fi
tenantId=$1
rrsetId=$2
host=127.0.0.1
curl -X GET \
  "http://$host:5353/dns?Version=2017-12-12&Action=DeleteResourceRecordSet&ResourceRecordSetId=$rrsetId" \
  -H "X-Product-Id: $tenantId" \
  -H "X-Request-Id: $tenantId"

echo -e "\n"

# select zone.tenant_id,rrset.set_id
# from dns_resource_record_set as rrset 
# left join dns_domain_zone as zone 
# on rrset.zone_id = zone.zone_id 
# where rrset.name like "%perf%" and rrset.type != 'SOA' and rrset.type != 'NS'


# select comment, set_id from dns_resource_record_set where name like "%perf%" and type != 'SOA' and type != 'NS'