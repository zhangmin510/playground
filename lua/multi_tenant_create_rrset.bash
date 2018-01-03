if [ $# != 3 ]
then
	echo "usage: bash script [threads] [connections] [duration]"
	exit 1
fi
#wrk -t $1 -c $2 -d $3  'http://10.187.3.165:5353/dns?Version=2017-12-12&Action=CreateHostedZone' -s delete_zone.lua 
wrk -t $1 -c $2 -d $3  'http://127.0.0.1:5353/dns?Version=2017-12-12&Action=CreateResourceRecordSet' -s create_rrset.lua
