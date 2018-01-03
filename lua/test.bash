#!/bin/bash
if [ $# != 3 ]
then
	echo "usage: bash test [threads] [connections] [duration]"
	exit 1
fi
wrk -t $1 -c $2 -d $3  'http://127.0.0.1:5353/dns?Version=2017-12-12&Action=ListHostedZones' -s test.lua
