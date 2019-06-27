#!/bin/bash

snipe_api_key="GET API KEY FROM SNIPEIT"

server="http://snipeit.com/api/v1/"

#get all computers from OCS
pcs=$(curl -s http://ocs.com/ocsapi/v1/computers/listID |sed 's/\\"/"/g'|sed 's/^"//g;s/"$//g'|python -m json.tool |jq -r .[].ID)

#Loop through all PCs in OSC database and pull their serial # and MAC address

for i in $pcs;
do

#Get asset serial #
asset_sn=$(curl -s http://ocs.com/ocsapi/v1/computer/$i/bios |sed 's/\\"/"/g'|sed 's/^"//g;s/"$//g'|python -m json.tool |jq -r .[].bios[].SSN);

#Get asset MAC address
mac_addr=$(curl -s http://ocs.com/ocsapi/v1/computer/$i/networks |sed 's/\\"/"/g'|sed 's/^"//g;s/"$//g'|python -m json.tool |jq -r .[].networks[1].MACADDR);

#Get asset ID from SnipeIT by serial #
snipe_id=$(curl -s http://snipeit.com/api/v1/hardware/byserial/$asset_sn -H "Authorization: Bearer $snipe_api_key" -H "Content-Type: application/json"|python -m json.tool |jq '.rows[0].id');


#Update SnipeIT MAC Address custom field based on the asset ID
res=$(curl -s -d '{"_snipeit_mac_address_1":"'$mac_addr'"}' -H "Content-Type: application/json" -H "Authorization: Bearer $snipe_api_key" -H "accept: application/json" -X PUT http://snipeit.com/api/v1/hardware/$snipe_id);

echo $res

done

exit

