#!/bin/bash
if [ $# -lt 2 ]
then
	echo "usage: bash script [host] [action] [threads] [connections] [duration]"
	echo "support actions : list_zones, create_zone, create_rrset"
	exit 1
fi

host=$1
action=$2
t=$3
c=$4
d=$5

HOST=127.0.0.1
if [ "x$host" != "x" ]
then
	HOST=$host
fi

case $action in
	list_zones)
		echo "list zones"
		wrk -t $t -c $c -d $d  "http://$HOST:5353/dns?Version=2017-12-12&Action=ListHostedZones" -s list_zones.lua
		;;
	create_zone)
		echo "create zone"
		wrk -t $t -c $c -d $d  "http://$HOST:5353/dns?Version=2017-12-12&Action=CreateHostedZone" -s create_zone.lua
		;;
	create_rrset)
		echo "create rrset"
		wrk -t $t -c $c -d $d  "http://$HOST:5353/dns?Version=2017-12-12&Action=CreateResourceRecordSet" -s create_rrset.lua
		;;
	*)
		echo "invalid action"
		;;
esac
